<?php
/**
 * WordPress database drop-in for browser-side MySQL-WASM.
 *
 * WordPress core still runs normally; this replaces only the transport layer
 * that would otherwise require mysqli/PDO sockets unavailable in php-wasm.
 */
class Wasm_WPDB extends wpdb {
    private $window;
    private $wasm_insert_id = 0;

    public function __construct($dbuser, $dbpassword, $dbname, $dbhost) {
        $this->window = new Vrzno;
        parent::__construct($dbuser, $dbpassword, $dbname, $dbhost);
    }

    public function db_connect($allow_bail = true) {
        $this->dbh = true;
        $this->ready = true;
        $this->has_connected = true;
        $this->set_charset($this->dbh);
        $this->select($this->dbname, $this->dbh);
        return true;
    }

    public function select($db, $dbh = null) {
        $this->_wasm_query('USE `' . str_replace('`', '``', $db) . '`');
        return true;
    }

    public function set_charset($dbh, $charset = null, $collate = null) {
        return true;
    }

    public function check_connection($allow_bail = true) {
        return true;
    }

    public function close() {
        return true;
    }


    public function db_server_info() {
        return '5.7.44-wasm';
    }

    public function db_version() {
        return '5.7.44';
    }

    public function has_cap($db_cap) {
        if (in_array(strtolower($db_cap), array('collation', 'group_concat', 'subqueries', 'set_charset', 'utf8mb4', 'utf8mb4_520', 'identifier_placeholders'), true)) {
            return true;
        }
        return parent::has_cap($db_cap);
    }

    public function get_charset_collate() {
        return 'DEFAULT CHARSET=utf8mb4';
    }

    public function _real_escape($data) {
        return str_replace(array('\\', "'", "\0", "\n", "\r", "\x1a"), array('\\\\', "\\'", '\\0', '\\n', '\\r', '\\Z'), (string) $data);
    }

    public function query($query) {
        if (!$this->ready) {
            $this->check_current_query = true;
            return false;
        }

        $query = apply_filters('query', $query);
        if (!$query) {
            return false;
        }

        $this->flush();
        $this->func_call = '$db->query("' . esc_sql($query) . '")';
        $this->last_query = $query;
        $this->timer_start();
        $result = $this->_wasm_query($query);
        $this->num_queries++;

        if (isset($result['error'])) {
            $this->last_error = $result['error'];
            return false;
        }

        $this->last_error = '';
        $this->last_result = array();
        $this->col_info = array();
        $this->num_rows = 0;
        $this->rows_affected = isset($result['affected_rows']) ? (int) $result['affected_rows'] : 0;

        if (!empty($result['columns'])) {
            foreach ($result['columns'] as $name) {
                $field = new stdClass;
                $field->name = $name;
                $this->col_info[] = $field;
            }
            foreach ($result['rows'] as $row) {
                $object = new stdClass;
                foreach ($row as $i => $value) {
                    $object->{$result['columns'][$i]} = $value;
                }
                $this->last_result[] = $object;
            }
            $this->num_rows = count($this->last_result);
            return $this->num_rows;
        }

        if (preg_match('/^\s*(insert|replace)\s/i', $query)) {
            $id_result = $this->_wasm_query('SELECT LAST_INSERT_ID() AS insert_id');
            if (empty($id_result['error']) && isset($id_result['rows'][0][0])) {
                $this->insert_id = (int) $id_result['rows'][0][0];
                $this->wasm_insert_id = $this->insert_id;
            }
        }

        return $this->rows_affected;
    }

    private function _wasm_query($sql) {
        $raw = $this->window->mysqlQuery($sql);
        $result = json_decode($raw, true);
        if (!is_array($result)) {
            return array('error' => 'mysql_wasm_query returned non-JSON');
        }
        return $result;
    }
}

$wpdb = new Wasm_WPDB(DB_USER, DB_PASSWORD, DB_NAME, DB_HOST);
