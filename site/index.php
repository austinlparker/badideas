<?php
/**
 * index.php
 *
 * This file is served to your browser as plain text, then executed BY your
 * browser, inside a PHP interpreter compiled to WebAssembly. It connects to
 * MySQL's embedded server library, also running inside your browser. If you are
 * reading this via View Source: yes, really. No, we won't apologize.
 */

error_reporting(E_ALL);
date_default_timezone_set('UTC');

// The interpreter outlives the page render (signing the guestbook re-runs
// this whole script in the same PHP instance), hence the redeclare guards.
if (!class_exists('WasmMysqlConnection')) {

/**
 * The world's worst database driver. Speaks to libmysqld compiled to WASM
 * through the vrzno PHP<->JS bridge, one synchronous JSON call at a time.
 * mysqli walked so this could crawl.
 */
class WasmMysqlConnection
{
    private $window;

    public function __construct($host, $user, $pass, $dbname)
    {
        // $host, $user and $pass are accepted for emotional support only.
        $this->window = new Vrzno;
        $this->query("USE $dbname");
    }

    public function query($sql)
    {
        $raw = $this->window->mysqlQuery($sql);
        $res = json_decode($raw, true);
        if (!is_array($res)) {
            die('<b>Fatal error:</b> the database returned something that was not even JSON.');
        }
        if (isset($res['error'])) {
            die('<b>MySQL error:</b> ' . htmlspecialchars($res['error'])
                . ' <i>(and there is no server admin to email, because there is no server)</i>');
        }
        return $res;
    }

    public function queryAll($sql)
    {
        $res = $this->query($sql);
        $cols = isset($res['columns']) ? $res['columns'] : array();
        $out = array();
        if (isset($res['rows'])) {
            foreach ($res['rows'] as $row) {
                $assoc = array();
                foreach ($row as $i => $v) {
                    $assoc[$cols[$i]] = $v;
                }
                $out[] = $assoc;
            }
        }
        return $out;
    }

    public function queryOne($sql)
    {
        $rows = $this->queryAll($sql);
        return count($rows) ? $rows[0] : null;
    }

    public function queryValue($sql)
    {
        $row = $this->queryOne($sql);
        return $row === null ? null : reset($row);
    }
}

function h($s)
{
    return htmlspecialchars((string) $s, ENT_QUOTES);
}

} // end redeclare guard

// Traditional credentials, traditionally ignored.
$db = new WasmMysqlConnection('localhost', 'root', 'hunter2', 'badideas');

// Load site config the way nature intended: one query per setting.
$config = array();
foreach ($db->queryAll('SELECT name, value FROM site_config') as $row) {
    $config[$row['name']] = $row['value'];
}

// You visited, therefore we UPDATE. A real write query against a real
// database that exists only in your RAM.
$db->query('UPDATE hit_counter SET hits = hits + 1 WHERE id = 1');
$hits = $db->queryValue('SELECT hits FROM hit_counter WHERE id = 1');

$posts       = $db->queryAll('SELECT title, body, created_at FROM posts ORDER BY created_at DESC');
$guestCount  = $db->queryValue('SELECT COUNT(*) FROM guestbook');
$guests      = $db->queryAll('SELECT name, message, created_at FROM guestbook ORDER BY created_at DESC, id DESC LIMIT 12');
$mysqlVer    = $db->queryValue('SELECT VERSION()');

$window  = new Vrzno;
$elapsed = $window->__elapsedSeconds();
if (!$elapsed) {
    $elapsed = 'several hundred';
}
?>
<div align="center">
<table width="780" border="2" cellpadding="8" cellspacing="0" bgcolor="#FFFFCC" style="border-style:ridge; font-family: Verdana, Geneva, sans-serif; font-size: 13px;">
<tr><td bgcolor="#000080" align="center">
  <font color="#FFFF00" size="6" face="Comic Sans MS, cursive"><b><?php echo h($config['site_title']); ?></b></font><br>
  <font color="#00FFFF" size="2"><i><?php echo h($config['tagline']); ?></i></font>
</td></tr>

<tr><td bgcolor="#FF00FF" align="center">
  <marquee scrollamount="6"><font color="#FFFF00" size="3"><b><?php echo h($config['marquee']); ?></b></font></marquee>
</td></tr>

<tr><td align="center" bgcolor="#CCCCFF">
  <font size="2">You are visitor number</font><br>
  <font face="Courier New, monospace" size="5" color="#008000" style="background:#000000; padding: 2px 6px; letter-spacing: 4px;"><b><?php echo str_pad((string) $hits, 8, '0', STR_PAD_LEFT); ?></b></font><br>
  <font size="1" color="#666666">(this counter is stored in a MySQL database in your browser's memory,<br>so you are also visitor number 1, forever, every time)</font>
</td></tr>

<tr><td>
  <font face="Comic Sans MS, cursive" size="4" color="#800000"><b>&#9733; LATEST NEWS &#9733;</b></font>
  <?php foreach ($posts as $post): ?>
    <p>
      <font color="#000080" size="3"><b><?php echo h($post['title']); ?></b></font>
      <font size="1" color="#666666">&mdash; posted <?php echo h($post['created_at']); ?></font><br>
      <font size="2"><?php echo h($post['body']); ?></font>
    </p>
    <hr size="1" noshade>
  <?php endforeach; ?>
</td></tr>

<tr><td bgcolor="#CCFFCC">
  <font face="Comic Sans MS, cursive" size="4" color="#006600"><b>&#9998; GUESTBOOK</b></font>
  <font size="2">(<?php echo (int) $guestCount; ?> entries, showing 12)</font>
  <?php foreach ($guests as $g): ?>
    <p style="margin: 6px 0;">
      <font size="2" color="#000080"><b><?php echo h($g['name']); ?></b></font>
      <font size="1" color="#666666"><?php echo h($g['created_at']); ?></font><br>
      <font size="2"><?php echo h($g['message']); ?></font>
    </p>
  <?php endforeach; ?>
  <form onsubmit="return window.__signGuestbook(this);" style="margin-top: 10px; border-top: 1px dashed #006600; padding-top: 8px;">
    <font size="2"><b>Sign the guestbook!</b> (INSERTs into a real MySQL table that evaporates when you close this tab)</font><br>
    <input type="text" name="name" placeholder="ur name" size="20" maxlength="100">
    <input type="text" name="message" placeholder="ur message" size="50" maxlength="500">
    <input type="submit" value="Sign!">
    <font size="1" color="#666666">&larr; submitting re-runs the entire PHP script. server-side rendering, client-side.</font>
  </form>
</td></tr>

<tr><td bgcolor="#000000" align="center">
  <font color="#00FF00" size="1" face="Courier New, monospace">
    Page generated in <?php echo h($elapsed); ?> seconds
    &mdash; PHP/<?php echo PHP_VERSION; ?> (WASM) &mdash; MySQL <?php echo h($mysqlVer); ?> (also WASM, somehow)<br>
    <?php echo count($guests) + count($posts) + count($config) + 4; ?>+ queries executed over a JavaScript bridge, each one a small apology<br>
    webmaster: <?php echo h($config['webmaster_email']); ?> &mdash; best viewed in any browser you are willing to sacrifice<br>
    &copy; 2003&ndash;<?php echo date('Y'); ?> &mdash; no rights reserved, no server involved
  </font>
</td></tr>
</table>
<font size="1" color="#999999" face="Verdana"><i>There is no backend. You are the backend.</i></font>
</div>
