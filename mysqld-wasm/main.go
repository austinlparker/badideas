//go:build js && wasm

// mysqld-wasm: a MySQL-compatible database server compiled to WebAssembly,
// running entirely in the browser tab. This is a load-bearing component of
// a website whose performance budget is "eventually".
package main

import (
	"context"
	"encoding/json"
	"fmt"
	"syscall/js"
	"time"

	sqle "github.com/dolthub/go-mysql-server"
	"github.com/dolthub/go-mysql-server/memory"
	"github.com/dolthub/go-mysql-server/sql"
	"github.com/dolthub/go-mysql-server/sql/types"
)

type queryResult struct {
	Columns []string        `json:"columns,omitempty"`
	Rows    [][]interface{} `json:"rows,omitempty"`
	Error   string          `json:"error,omitempty"`
}

func jsonify(v interface{}) interface{} {
	switch t := v.(type) {
	case nil:
		return nil
	case bool, string, float32, float64,
		int, int8, int16, int32, int64,
		uint, uint8, uint16, uint32, uint64:
		return t
	case []byte:
		return string(t)
	case time.Time:
		return t.Format("2006-01-02 15:04:05")
	case types.OkResult:
		return map[string]interface{}{
			"affectedRows": t.RowsAffected,
			"insertId":     t.InsertID,
		}
	default:
		return fmt.Sprintf("%v", t)
	}
}

func main() {
	pro := memory.NewDBProvider()
	engine := sqle.NewDefault(pro)

	baseSession := memory.NewSession(sql.NewBaseSession(), pro)
	ctx := sql.NewContext(context.Background(), sql.WithSession(baseSession))

	runQuery := func(query string) string {
		res := queryResult{}
		schema, iter, _, err := engine.Query(ctx, query)
		if err != nil {
			res.Error = err.Error()
		} else {
			for _, col := range schema {
				res.Columns = append(res.Columns, col.Name)
			}
			for {
				row, err := iter.Next(ctx)
				if err != nil {
					// io.EOF marks the end of the result set; anything else
					// is a genuine mid-iteration failure worth reporting.
					if err.Error() != "EOF" {
						res.Error = err.Error()
					}
					break
				}
				out := make([]interface{}, len(row))
				for i, v := range row {
					out[i] = jsonify(v)
				}
				res.Rows = append(res.Rows, out)
			}
			iter.Close(ctx)
		}
		b, jerr := json.Marshal(res)
		if jerr != nil {
			b, _ = json.Marshal(queryResult{Error: jerr.Error()})
		}
		return string(b)
	}

	js.Global().Set("mysqlQuery", js.FuncOf(func(this js.Value, args []js.Value) any {
		if len(args) < 1 {
			return `{"error":"mysqlQuery requires a SQL string"}`
		}
		return runQuery(args[0].String())
	}))

	js.Global().Set("mysqldReady", js.ValueOf(true))
	fmt.Println("mysqld-wasm: MySQL-compatible server listening on nothing, port nowhere")

	// Block forever; the server must keep "running" for the lifetime of the tab.
	select {}
}
