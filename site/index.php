<?php
/**
 * Real WordPress front controller, executed by PHP-WASM in the browser.
 *
 * The loader preloads official WordPress core into /wordpress and this file
 * simply hands control to WordPress' own index.php. Database calls are handled
 * by a wp-content/db.php drop-in that bridges WordPress' wpdb API to the
 * browser-side MySQL 5.7 embedded server.
 */
chdir('/wordpress');
require '/wordpress/index.php';
