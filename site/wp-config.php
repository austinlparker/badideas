<?php
/** Browser-side WordPress configuration. Loaded by real WordPress core. */
define('DB_NAME', 'wordpress');
define('DB_USER', 'root');
define('DB_PASSWORD', '');
define('DB_HOST', 'localhost');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');
$table_prefix = 'wp_';
define('WP_DEBUG', true);
define('WP_DEBUG_DISPLAY', true);
define('WP_ENVIRONMENT_TYPE', 'local');
$browser_scheme = $_SERVER['REQUEST_SCHEME'] ?? 'http';
$browser_host = $_SERVER['HTTP_HOST'] ?? 'localhost';
$browser_script = $_SERVER['SCRIPT_NAME'] ?? '/index.php';
$browser_base_path = rtrim(str_replace('\\', '/', dirname($browser_script)), '/.');
$browser_home = $browser_scheme . '://' . $browser_host . $browser_base_path;
define('WP_HOME', $browser_home);
define('WP_SITEURL', $browser_home . '/wordpress');
define('WP_CONTENT_DIR', '/wp-content');
define('WP_CONTENT_URL', $browser_home . '/wp-content');
define('WP_PLUGIN_DIR', WP_CONTENT_DIR . '/plugins');
define('WP_PLUGIN_URL', WP_CONTENT_URL . '/plugins');
define('DISABLE_WP_CRON', true);
define('AUTOMATIC_UPDATER_DISABLED', true);
define('FS_METHOD', 'direct');
define('AUTH_KEY',         'browser-side wordpress auth key');
define('SECURE_AUTH_KEY',  'browser-side wordpress secure auth key');
define('LOGGED_IN_KEY',    'browser-side wordpress logged in key');
define('NONCE_KEY',        'browser-side wordpress nonce key');
define('AUTH_SALT',        'browser-side wordpress auth salt');
define('SECURE_AUTH_SALT', 'browser-side wordpress secure auth salt');
define('LOGGED_IN_SALT',   'browser-side wordpress logged in salt');
define('NONCE_SALT',       'browser-side wordpress nonce salt');
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/wordpress/');
}
require_once ABSPATH . 'wp-settings.php';

// There is no HTTP response for WordPress to redirect: PHP renders into the
// current browser document, whose origin and project path already determine
// the canonical URL.
remove_action('template_redirect', 'redirect_canonical');
