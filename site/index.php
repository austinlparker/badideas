<?php
/**
 * Real WordPress front controller, executed by PHP-WASM in the browser.
 *
 * The loader preloads official WordPress core into /wordpress and this file
 * simply hands control to WordPress' own index.php. Database calls are handled
 * by a wp-content/db.php drop-in that bridges WordPress' wpdb API to the
 * browser-side MySQL 5.7 embedded server.
 */
$_SERVER += array(
    'PHP_SELF' => '/index.php',
    'SCRIPT_NAME' => '/index.php',
    'SCRIPT_FILENAME' => '/index.php',
    'REQUEST_URI' => '/',
    'REQUEST_METHOD' => 'GET',
    'QUERY_STRING' => '',
    'HTTP_HOST' => 'localhost',
    'SERVER_NAME' => 'localhost',
    'SERVER_PORT' => '80',
    'REQUEST_SCHEME' => 'http',
    'HTTPS' => 'off',
    'REMOTE_ADDR' => '127.0.0.1',
    'HTTP_USER_AGENT' => 'badideas browser WordPress',
);
chdir('/wordpress');
require '/wordpress/index.php';
