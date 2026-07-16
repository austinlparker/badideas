#!/usr/bin/env python3
"""Generates site/dump.sql, the prebuilt WordPress database this website boots from.

The output imitates mysqldump because the browser deserves authenticity.
Statements are kept one-per-line (no `;` followed by a newline inside string
literals) because the client-side replayer splits on exactly that. This is a
contract between two files that should never have existed.
"""
import os
import random

random.seed(0x0BAD1DEA)

OUT = os.path.join(os.path.dirname(__file__), "..", "site", "dump.sql")

FIRST = ["xX_Dark", "Sk8er", "WebMaster", "CyberDude", "NetSurfer", "Angelfire",
         "Geo", "Napster", "Winamp", "Trillian", "ICQ", "Modem", "Y2K", "Buddy",
         "AOL", "Pentium", "Quake", "Counter", "Flash", "Java"]
LAST = ["_Angel_Xx", "Boi_99", "2000", "4life", "Fan", "Kid", "Lord", "Wizard",
        "Junkie", "Rider", "Master", "Hacker", "Dawg", "Zilla", "X", "_2003",
        "OnFire", "Rulez", "TheGreat", "Jr"]

MESSAGES = [
    "cool blog! check out my site at geocities dot com slash {name}",
    "First!!!1",
    "how did you get WordPress to work without a server?? plz email me the plugin",
    "this page loaded faster than my dial-up, and my dial-up is broken",
    "I have been waiting for this page to load since breakfast. Worth it.",
    "your blog crashed netscape but in a good way",
    "PHP in the browser?? what will they think of next, CSS?",
    "signed the comments, now sign mine!!",
    "greetings from the year 2003, we finally got here",
    "my computer fan turned on and I knew wpdb was starting",
    "still faster than our Jira instance",
    "an entire WordPress database in WebAssembly? in this economy?",
    "waited 4 minutes for first paint. the paint was worth it",
    "does this blog work on WAP? asking for my Nokia",
    "I viewed source and I am calling the police",
    "the comment count incremented, so database writes work. incredible",
    "best viewed at 800x600 in a browser with 16GB of RAM",
    "TTFB was great, shame about the other letters",
    "you should add a splash page so it loads slower",
    "Lighthouse gave this site a score and then filed a restraining order",
]

HANDCRAFTED = [
    ("Matt", "I said democratize publishing. I did not specify which process owns mysqld."),
    ("your ISP", "we noticed unusual download activity. it was this page."),
    ("a Lighthouse auditor", "Performance: 0. Accessibility: surprisingly fine. Best Practices: no."),
    ("the MySQL server", "I live in your browser tab now. please do not close it, that is my house."),
    ("Rasmus", "I said PHP would run anywhere. this is not what I meant. it counts though."),
    ("the garbage collector", "I have seen things you people would not believe."),
    ("mobile user on 3G", "I will let you know how the blog is when it finishes loading. reply expected 2027."),
    ("the CDN", "you did not use me. bold. everything shipped from github.io raw."),
]

POSTS = [
    ("Hello world, from browser-side WordPress",
     "Welcome to WordPress. This is not the famous five-minute install: it is the famous five-minute page load. The PHP interpreter, MySQL 5.7 embedded server, wp_posts table, and theme rendering all happen inside your browser tab."),
    ("Choosing a WordPress for MySQL 5.7.44",
     "The database engine here is Oracle MySQL 5.7.44 compiled to WebAssembly. WordPress still supports the MySQL 5.x family, so this dump uses ordinary MyISAM WordPress tables and avoids modern server-side conveniences like a server."),
    ("The cached database is the install wizard",
     "There is no wp-admin setup screen because setup already happened in site/dump.sql. The browser fetches a cached dump, replays it into libmysqld, and then PHP renders a blog from wp_options, wp_posts, and wp_comments."),
    ("Plugins we are proud not to support",
     "Object cache? The object is cache. Cron? Time has no meaning inside this tab. XML-RPC? Please do not give this architecture a remote procedure call surface."),
    ("Performance Update",
     "We profiled WordPress-in-the-browser. The flame graph is now several very wide bars wearing a trench coat. The second visit is faster only because the browser cache has accepted its fate."),
]


def esc(s: str) -> str:
    return s.replace("\\", "\\\\").replace("'", "''")


def main() -> None:
    lines = []
    w = lines.append

    w("-- MySQL dump 10.13  Distrib 5.7.44, for wasm32-unknown-unknown (browser tab)")
    w("--")
    w("-- Host: localhost    Database: wordpress")
    w("-- ------------------------------------------------------")
    w("-- Server version\t5.7.44")
    w("-- Warning: this dump is executed by WordPress, into an embedded server, in a client. There is no remote server.")
    w("")
    w("CREATE DATABASE wordpress;")
    w("USE wordpress;")
    w("")
    w("CREATE TABLE wp_options (option_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, option_name VARCHAR(191) NOT NULL DEFAULT '', option_value LONGTEXT NOT NULL, autoload VARCHAR(20) NOT NULL DEFAULT 'yes', UNIQUE KEY option_name (option_name)) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")
    options = {
        'siteurl': './wordpress', 'home': '.', 'blogname': "Austin's Real Browser WordPress",
        'blogdescription': 'Actual WordPress core, except the server is you',
        'template': 'badideas', 'stylesheet': 'badideas', 'current_theme': 'Bad Ideas Browser WordPress',
        'admin_email': 'webmaster@localhost', 'initial_db_version': '60421', 'db_version': '60421',
        'wp_user_roles': 'a:0:{}', 'comment_moderation': '0', 'comments_notify': '0',
        'moderation_notify': '0', 'permalink_structure': '', 'rewrite_rules': '', 'show_on_front': 'posts',
        'posts_per_page': '10', 'default_ping_status': 'closed', 'default_comment_status': 'open',
        'active_plugins': 'a:0:{}', 'stylesheet_root': '/wp-content/themes', 'template_root': '/wp-content/themes',
    }
    for k, v in options.items():
        w(f"INSERT INTO wp_options (option_name, option_value, autoload) VALUES ('{esc(k)}', '{esc(v)}', 'yes');")
    w("")
    w("CREATE TABLE wp_commentmeta (meta_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, comment_id BIGINT UNSIGNED NOT NULL DEFAULT 0, meta_key VARCHAR(255) DEFAULT NULL, meta_value LONGTEXT, KEY comment_id (comment_id), KEY meta_key (meta_key(191))) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")
    w("CREATE TABLE wp_links (link_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, link_url VARCHAR(255) NOT NULL DEFAULT '', link_name VARCHAR(255) NOT NULL DEFAULT '', link_image VARCHAR(255) NOT NULL DEFAULT '', link_target VARCHAR(25) NOT NULL DEFAULT '', link_description VARCHAR(255) NOT NULL DEFAULT '', link_visible VARCHAR(20) NOT NULL DEFAULT 'Y', link_owner BIGINT UNSIGNED NOT NULL DEFAULT 1, link_rating INT NOT NULL DEFAULT 0, link_updated DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00', link_rel VARCHAR(255) NOT NULL DEFAULT '', link_notes MEDIUMTEXT NOT NULL, link_rss VARCHAR(255) NOT NULL DEFAULT '') ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")
    w("CREATE TABLE wp_postmeta (meta_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, post_id BIGINT UNSIGNED NOT NULL DEFAULT 0, meta_key VARCHAR(255) DEFAULT NULL, meta_value LONGTEXT, KEY post_id (post_id), KEY meta_key (meta_key(191))) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")
    w("CREATE TABLE wp_terms (term_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(200) NOT NULL DEFAULT '', slug VARCHAR(200) NOT NULL DEFAULT '', term_group BIGINT NOT NULL DEFAULT 0, KEY slug (slug(191)), KEY name (name(191))) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")
    w("INSERT INTO wp_terms (term_id, name, slug, term_group) VALUES (1, 'Uncategorized', 'uncategorized', 0);")
    w("CREATE TABLE wp_term_taxonomy (term_taxonomy_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, term_id BIGINT UNSIGNED NOT NULL DEFAULT 0, taxonomy VARCHAR(32) NOT NULL DEFAULT '', description LONGTEXT NOT NULL, parent BIGINT UNSIGNED NOT NULL DEFAULT 0, count BIGINT NOT NULL DEFAULT 0, UNIQUE KEY term_id_taxonomy (term_id,taxonomy), KEY taxonomy (taxonomy)) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")
    w("INSERT INTO wp_term_taxonomy (term_taxonomy_id, term_id, taxonomy, description, parent, count) VALUES (1, 1, 'category', '', 0, 5);")
    w("CREATE TABLE wp_term_relationships (object_id BIGINT UNSIGNED NOT NULL DEFAULT 0, term_taxonomy_id BIGINT UNSIGNED NOT NULL DEFAULT 0, term_order INT NOT NULL DEFAULT 0, PRIMARY KEY (object_id,term_taxonomy_id), KEY term_taxonomy_id (term_taxonomy_id)) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")
    w("CREATE TABLE wp_termmeta (meta_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, term_id BIGINT UNSIGNED NOT NULL DEFAULT 0, meta_key VARCHAR(255) DEFAULT NULL, meta_value LONGTEXT, KEY term_id (term_id), KEY meta_key (meta_key(191))) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")
    w("CREATE TABLE wp_usermeta (umeta_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, user_id BIGINT UNSIGNED NOT NULL DEFAULT 0, meta_key VARCHAR(255) DEFAULT NULL, meta_value LONGTEXT, KEY user_id (user_id), KEY meta_key (meta_key(191))) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")
    w("")
    w("CREATE TABLE wp_users (ID BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, user_login VARCHAR(60) NOT NULL DEFAULT '', user_pass VARCHAR(255) NOT NULL DEFAULT '', user_nicename VARCHAR(50) NOT NULL DEFAULT '', user_email VARCHAR(100) NOT NULL DEFAULT '', user_url VARCHAR(100) NOT NULL DEFAULT '', user_registered DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00', user_activation_key VARCHAR(255) NOT NULL DEFAULT '', user_status INT NOT NULL DEFAULT 0, display_name VARCHAR(250) NOT NULL DEFAULT '') ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")
    w("INSERT INTO wp_users (user_login, user_pass, user_nicename, user_email, user_url, user_registered, display_name) VALUES ('admin', '$P$BrowserSideHashThatAuthenticatesNobody', 'admin', 'webmaster@localhost', '.', '2026-07-16 00:00:00', 'admin');")
    w("INSERT INTO wp_usermeta (user_id, meta_key, meta_value) VALUES (1, 'wp_capabilities', 'a:1:{s:13:\"administrator\";b:1;}');")
    w("INSERT INTO wp_usermeta (user_id, meta_key, meta_value) VALUES (1, 'wp_user_level', '10');")
    w("")
    w("CREATE TABLE wp_posts (ID BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, post_author BIGINT UNSIGNED NOT NULL DEFAULT 0, post_date DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00', post_date_gmt DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00', post_content LONGTEXT NOT NULL, post_title TEXT NOT NULL, post_excerpt TEXT NOT NULL, post_status VARCHAR(20) NOT NULL DEFAULT 'publish', comment_status VARCHAR(20) NOT NULL DEFAULT 'open', ping_status VARCHAR(20) NOT NULL DEFAULT 'open', post_password VARCHAR(255) NOT NULL DEFAULT '', post_name VARCHAR(200) NOT NULL DEFAULT '', to_ping TEXT NOT NULL, pinged TEXT NOT NULL, post_modified DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00', post_modified_gmt DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00', post_content_filtered LONGTEXT NOT NULL, post_parent BIGINT UNSIGNED NOT NULL DEFAULT 0, guid VARCHAR(255) NOT NULL DEFAULT '', menu_order INT NOT NULL DEFAULT 0, post_type VARCHAR(20) NOT NULL DEFAULT 'post', post_mime_type VARCHAR(100) NOT NULL DEFAULT '', comment_count BIGINT NOT NULL DEFAULT 0, KEY type_status_date (post_type,post_status,post_date,ID)) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")
    for i, (title, body) in enumerate(POSTS, 1):
        date = f"2026-07-{16 - i:02d} 0{i}:23:00"
        slug = title.lower().replace(' ', '-').replace(',', '').replace(':', '').replace('.', '')[:190]
        w(f"INSERT INTO wp_term_relationships (object_id, term_taxonomy_id, term_order) VALUES ({i}, 1, 0);")
        w(f"INSERT INTO wp_posts (post_author, post_date, post_date_gmt, post_content, post_title, post_status, comment_status, post_name, post_modified, post_modified_gmt, guid, post_type, comment_count) VALUES (1, '{date}', '{date}', '{esc(body)}', '{esc(title)}', 'publish', 'open', '{esc(slug)}', '{date}', '{date}', './?p={i}', 'post', 0);")
    w("")
    w("CREATE TABLE wp_comments (comment_ID BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, comment_post_ID BIGINT UNSIGNED NOT NULL DEFAULT 0, comment_author TINYTEXT NOT NULL, comment_author_email VARCHAR(100) NOT NULL DEFAULT '', comment_author_url VARCHAR(200) NOT NULL DEFAULT '', comment_author_IP VARCHAR(100) NOT NULL DEFAULT '', comment_date DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00', comment_date_gmt DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00', comment_content TEXT NOT NULL, comment_karma INT NOT NULL DEFAULT 0, comment_approved VARCHAR(20) NOT NULL DEFAULT '1', comment_agent VARCHAR(255) NOT NULL DEFAULT '', comment_type VARCHAR(20) NOT NULL DEFAULT 'comment', comment_parent BIGINT UNSIGNED NOT NULL DEFAULT 0, user_id BIGINT UNSIGNED NOT NULL DEFAULT 0, KEY comment_post_ID (comment_post_ID)) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")
    entries = HANDCRAFTED[:]
    for _ in range(192):
        name = random.choice(FIRST) + random.choice(LAST)
        entries.append((name, random.choice(MESSAGES).format(name=name.lower())))
    random.shuffle(entries)
    for i, (name, msg) in enumerate(entries):
        post_id = 1 + (i % len(POSTS))
        day = 1 + (i * 7919) % 28
        hh, mm = (i * 37) % 24, (i * 53) % 60
        w(f"INSERT INTO wp_comments (comment_post_ID, comment_author, comment_date, comment_date_gmt, comment_content, comment_approved, comment_agent) VALUES ({post_id}, '{esc(name)}', '2026-06-{day:02d} {hh:02d}:{mm:02d}:00', '2026-06-{day:02d} {hh:02d}:{mm:02d}:00', '{esc(msg)}', '1', 'WordPress/6.8.3; MySQL-WASM');")
    for post_id in range(1, len(POSTS) + 1):
        count = sum(1 for i in range(len(entries)) if 1 + (i % len(POSTS)) == post_id)
        w(f"UPDATE wp_posts SET comment_count = {count} WHERE ID = {post_id};")
    w("")
    w("-- Dump completed on 2026-07-16  04:04:04")
    w("")
    with open(OUT, "w") as f:
        f.write("\n".join(lines))
    print(f"wrote {OUT}: {len(lines)} lines, {len(entries)} comments")

if __name__ == "__main__":
    main()
