# badideas

a home for projects that are bad ideas

## the dream website

> "That's my dream website. PHP executed in the client via WASM, connecting to
> a WASM MySQL server. Pulls a prebuilt DB dump from github.io. Time to first
> contentful paint measured in minutes."

It is built. More importantly, this version says precisely what it is doing.

### Is it really PHP + MySQL in WebAssembly?

Yes, with one important noun made explicit:

- PHP 8.4 runs in the browser through
  [php-wasm](https://github.com/seanmorris/php-wasm).
- Oracle MySQL 5.7.44's actual C/C++ **embedded server library** (`libmysqld`)
  is compiled with Emscripten and runs in the browser as WebAssembly.
- The tables are real MyISAM tables stored in Emscripten's in-memory
  filesystem. `CREATE TABLE`, `INSERT`, `UPDATE`, joins, and `SELECT
  VERSION()` are handled by MySQL code.
- PHP queries that database synchronously through php-wasm's `vrzno`
  JavaScript bridge.

It is not a TCP MySQL daemon. `libmysqld` is MySQL's in-process server API, so
there is no MySQL wire protocol, listening socket, or fake network layer. That
is both smaller and a more honest fit for a browser tab: the database server
engine is real MySQL, while the connection is an embedded connection.

### What happens when you visit

1. The browser loads the Emscripten module containing MySQL 5.7.44's embedded
   server and boots it with InnoDB disabled. Embedded MySQL has no TCP listener,
   external authentication handshake, replication, or event scheduler.
   MyISAM data files live under `/mysql/data` in the module's memory filesystem.
2. The browser fetches `dump.sql` and replays the dump into MySQL one statement
   at a time.
3. It downloads and starts the PHP interpreter.
4. It fetches `index.php` as plain text and executes it in that interpreter.
5. PHP performs real queries and a real hit-counter `UPDATE`, then renders the
   guestbook. Signing it performs a real `INSERT`.
6. Everything disappears with the tab because persistence would make this
   dangerously close to a reasonable architecture.

There is no application backend. Each visitor gets an isolated PHP runtime,
MySQL server engine, and database in their own browser.

### Layout

| path | job |
|---|---|
| `site/index.html` | boots MySQL, imports the dump, boots PHP, and runs the page |
| `site/index.php` | the guestbook, executed by PHP in the browser |
| `site/dump.sql` | generated MySQL dump loaded at startup |
| `mysql-wasm/` | reproducible MySQL/OpenSSL/Emscripten build and compatibility patches |
| `tools/generate_dump.py` | regenerates the checked-in dump |
| `tools/vendor-php-wasm.sh` | vendors the PHP interpreter into `site/` |
| `tools/serve.py` | local server with the headers required by Wasm pthreads |
| `.github/workflows/pages.yml` | builds and deploys the site to GitHub Pages |

### PHP → MySQL, without a socket

php-wasm's `vrzno` extension lets PHP invoke JavaScript synchronously. The
Emscripten wrapper exposes `mysql_wasm_query()`, and the loader publishes it as
`window.mysqlQuery()`:

```php
$window = new Vrzno;
$res = json_decode($window->mysqlQuery(
    'SELECT VERSION(), hits FROM hit_counter'
), true);
```

The wrapper uses MySQL's C client API with
`MYSQL_OPT_USE_EMBEDDED_CONNECTION`; query results cross the bridge as JSON.

### Building locally

The MySQL build is pinned to MySQL 5.7.44, OpenSSL 1.1.1w, and Emscripten
3.1.64. It needs Docker, `curl`, and `git`; PHP vendoring also needs Node.js.
The first MySQL build downloads source archives and compiles a substantial
amount of C/C++, so it is intentionally cached under `.cache/`.

```bash
./mysql-wasm/build.sh
./tools/vendor-php-wasm.sh
./tools/serve.py
# open http://127.0.0.1:8000 and go make coffee
```

Do not use `python3 -m http.server`: WebAssembly pthreads require the
`Cross-Origin-Opener-Policy` and `Cross-Origin-Embedder-Policy` headers sent by
`tools/serve.py`. GitHub Pages cannot configure those headers, so the deployed
site uses `coi-serviceworker.js` and performs a one-time bootstrap reload.

Useful build overrides are `MYSQL_WASM_CACHE`, `JOBS`, and `MYSQL_JOBS`.
`MYSQL_JOBS` defaults to 1 because old MySQL GIS sources can exhaust the memory
of a small Docker VM when several Clang processes run at once.

### Source and licensing

The build verifies the official MySQL source archive's SHA-256 and the exact
OpenSSL Git commit, uses a digest-pinned Emscripten image, and applies the small
patches in `mysql-wasm/patches/`. The generated site includes the MySQL and
OpenSSL license files next to the WebAssembly module. MySQL 5.7 Community
Server is GPLv2; see those files and the upstream source distributions for the
full terms.

### Deploying

Enable GitHub Pages with **Settings → Pages → Source: GitHub Actions**. A push
to `main` rebuilds the pinned MySQL module, vendors PHP, verifies the dump, and
deploys `site/`.
