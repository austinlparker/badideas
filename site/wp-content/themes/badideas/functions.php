<?php
/** Theme setup for the browser-hosted WordPress site. */
add_action('wp_enqueue_scripts', function () {
    wp_enqueue_style(
        'badideas-style',
        get_stylesheet_uri(),
        array(),
        wp_get_theme()->get('Version')
    );
});
