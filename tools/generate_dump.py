#!/usr/bin/env python3
"""Generates site/dump.sql, the "prebuilt database dump" this website boots from.

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
    "cool site! check out my site at geocities dot com slash {name}",
    "First!!!1",
    "how did you get the counter to work?? plz email me the cgi",
    "this page loaded faster than my dial-up, and my dial-up is broken",
    "I have been waiting for this page to load since breakfast. Worth it.",
    "your site crashed netscape but in a good way",
    "PHP in the browser?? what will they think of next, CSS?",
    "signed the guestbook, now sign mine!!",
    "greetings from the year 2003, we finally got here",
    "my computer fan turned on and I knew the database was starting",
    "still faster than our Jira instance",
    "an entire MySQL server engine in WebAssembly? in this economy?",
    "waited 4 minutes for first paint. the paint was worth it",
    "does this site work on WAP? asking for my Nokia",
    "I viewed source and I am calling the police",
    "the hit counter incremented, so the database writes work. incredible",
    "best viewed at 800x600 in a browser with 16GB of RAM",
    "TTFB was great, shame about the other letters",
    "you should add a splash page so it loads slower",
    "Lighthouse gave this site a score and then filed a restraining order",
]

HANDCRAFTED = [
    ("Tim", "the whole web platform is right there and you built this. respect."),
    ("your ISP", "we noticed unusual download activity. it was this page."),
    ("a Lighthouse auditor", "Performance: 0. Accessibility: surprisingly fine. Best Practices: no."),
    ("the MySQL server", "I live in your browser tab now. please do not close it, that is my house."),
    ("Rasmus", "I said PHP would run anywhere. this is not what I meant. it counts though."),
    ("the garbage collector", "I have seen things you people would not believe."),
    ("mobile user on 3G", "I will let you know how the site is when it finishes loading. reply expected 2027."),
    ("the CDN", "you did not use me. bold. everything shipped from github.io raw."),
]

POSTS = [
    ("Announcing: This Website",
     "This site is a PHP application. The PHP runs in your browser via WebAssembly. "
     "It connects to Oracle MySQL 5.7's embedded server library, which also runs in your browser via WebAssembly. "
     "The data you are reading was replayed from a SQL dump fetched over HTTP, one statement at a time, "
     "before anything was allowed to appear on screen. There is no backend. There has never been a backend. "
     "You are the backend."),
    ("Why We Measure Time To First Contentful Paint In Minutes",
     "Seconds are for cowards. When this page finally paints, you feel something. "
     "Modern web performance culture optimizes for the absence of experience -- the page is simply there, "
     "unearned. We have restored the anticipation. The progress is in the developer console, "
     "where all honest progress lives."),
    ("Architecture Deep Dive",
     "Your browser downloads Oracle MySQL 5.7's embedded C/C++ server compiled with Emscripten, boots it, replays a mysqldump file into it, "
     "then downloads a PHP interpreter compiled to WASM, runs index.php, and PHP queries MySQL through a "
     "JavaScript bridge one synchronous call at a time. Every layer of this was avoidable. That is what makes it art."),
    ("FAQ",
     "Q: Why? A: The request was clear. Q: Is it fast? A: The hit counter increments in O(1). "
     "Q: Does it scale? A: Every visitor brings their own database server, so yes -- infinitely. "
     "This is the most horizontally scaled MySQL deployment in history. "
     "Q: Is my guestbook entry saved? A: It is saved to a database that ceases to exist when you close the tab. "
     "Like a sandcastle. Q: Can I use this in production? A: You are in production right now."),
    ("Performance Update",
     "We profiled the site. The flame graph is just one very wide bar. "
     "We considered a loading spinner but rejected it: a spinner implies apology, and we regret nothing. "
     "We did add HTTP caching headers, which GitHub Pages provides for free, so the second visit is merely slow."),
]


def esc(s: str) -> str:
    return s.replace("\\", "\\\\").replace("'", "''")


def main() -> None:
    lines = []
    w = lines.append

    w("-- MySQL dump 10.13  Distrib 5.7.44, for wasm32-unknown-unknown (browser tab)")
    w("--")
    w("-- Host: localhost    Database: badideas")
    w("-- ------------------------------------------------------")
    w("-- Server version\t5.7.44")
    w("-- Warning: this dump is executed by a client, into an embedded server, in a client. There is no remote server.")
    w("")
    w("CREATE DATABASE badideas;")
    w("USE badideas;")
    w("")
    w("--")
    w("-- Table structure for table `site_config`")
    w("--")
    w("CREATE TABLE site_config (name VARCHAR(64) PRIMARY KEY, value TEXT NOT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")
    w("INSERT INTO site_config VALUES ('site_title', 'austin''s BAD IDEAS zone');")
    w("INSERT INTO site_config VALUES ('tagline', 'PHP + MySQL + your browser''s RAM: pick three');")
    w("INSERT INTO site_config VALUES ('marquee', 'WELCOME to the ONLY website where the LAMP stack runs entirely inside the L... wait');")
    w("INSERT INTO site_config VALUES ('webmaster_email', 'webmaster@localhost (literally)');")
    w("")
    w("--")
    w("-- Table structure for table `hit_counter`")
    w("--")
    w("CREATE TABLE hit_counter (id INT PRIMARY KEY, hits BIGINT NOT NULL) ENGINE=MyISAM;")
    w("INSERT INTO hit_counter VALUES (1, 1336);")
    w("")
    w("--")
    w("-- Table structure for table `posts`")
    w("--")
    w("CREATE TABLE posts (id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(255) NOT NULL, body TEXT NOT NULL, created_at DATETIME NOT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")
    for i, (title, body) in enumerate(POSTS):
        w(f"INSERT INTO posts (title, body, created_at) VALUES ('{esc(title)}', '{esc(body)}', '2026-07-{15 - i:02d} 0{i + 1}:23:00');")
    w("")
    w("--")
    w("-- Table structure for table `guestbook`")
    w("--")
    w("CREATE TABLE guestbook (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(128) NOT NULL, message TEXT NOT NULL, created_at DATETIME NOT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;")

    entries = []
    for name, msg in HANDCRAFTED:
        entries.append((name, msg))
    for i in range(192):
        name = random.choice(FIRST) + random.choice(LAST)
        msg = random.choice(MESSAGES).format(name=name.lower())
        entries.append((name, msg))
    random.shuffle(entries)

    # One INSERT per row. A multi-row INSERT would be efficient, and efficiency
    # is against the spirit of this project.
    for i, (name, msg) in enumerate(entries):
        day = 1 + (i * 7919) % 28
        hh, mm = (i * 37) % 24, (i * 53) % 60
        w(f"INSERT INTO guestbook (name, message, created_at) VALUES ('{esc(name)}', '{esc(msg)}', '2026-06-{day:02d} {hh:02d}:{mm:02d}:00');")

    w("")
    w("-- Dump completed on 2026-07-15  4:04:04")
    w("")

    with open(OUT, "w") as f:
        f.write("\n".join(lines))
    print(f"wrote {OUT}: {len(lines)} lines, {len(entries)} guestbook rows")


if __name__ == "__main__":
    main()
