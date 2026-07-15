-- MySQL dump 10.13  Distrib 5.7.44, for wasm32-unknown-unknown (browser tab)
--
-- Host: localhost    Database: badideas
-- ------------------------------------------------------
-- Server version	5.7.44
-- Warning: this dump is executed by a client, into an embedded server, in a client. There is no remote server.

CREATE DATABASE badideas;
USE badideas;

--
-- Table structure for table `site_config`
--
CREATE TABLE site_config (name VARCHAR(64) PRIMARY KEY, value TEXT NOT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;
INSERT INTO site_config VALUES ('site_title', 'austin''s BAD IDEAS zone');
INSERT INTO site_config VALUES ('tagline', 'PHP + MySQL + your browser''s RAM: pick three');
INSERT INTO site_config VALUES ('marquee', 'WELCOME to the ONLY website where the LAMP stack runs entirely inside the L... wait');
INSERT INTO site_config VALUES ('webmaster_email', 'webmaster@localhost (literally)');

--
-- Table structure for table `hit_counter`
--
CREATE TABLE hit_counter (id INT PRIMARY KEY, hits BIGINT NOT NULL) ENGINE=MyISAM;
INSERT INTO hit_counter VALUES (1, 1336);

--
-- Table structure for table `posts`
--
CREATE TABLE posts (id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(255) NOT NULL, body TEXT NOT NULL, created_at DATETIME NOT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;
INSERT INTO posts (title, body, created_at) VALUES ('Announcing: This Website', 'This site is a PHP application. The PHP runs in your browser via WebAssembly. It connects to Oracle MySQL 5.7''s embedded server library, which also runs in your browser via WebAssembly. The data you are reading was replayed from a SQL dump fetched over HTTP, one statement at a time, before anything was allowed to appear on screen. There is no backend. There has never been a backend. You are the backend.', '2026-07-15 01:23:00');
INSERT INTO posts (title, body, created_at) VALUES ('Why We Measure Time To First Contentful Paint In Minutes', 'Seconds are for cowards. When this page finally paints, you feel something. Modern web performance culture optimizes for the absence of experience -- the page is simply there, unearned. We have restored the anticipation. The progress is in the developer console, where all honest progress lives.', '2026-07-14 02:23:00');
INSERT INTO posts (title, body, created_at) VALUES ('Architecture Deep Dive', 'Your browser downloads Oracle MySQL 5.7''s embedded C/C++ server compiled with Emscripten, boots it, replays a mysqldump file into it, then downloads a PHP interpreter compiled to WASM, runs index.php, and PHP queries MySQL through a JavaScript bridge one synchronous call at a time. Every layer of this was avoidable. That is what makes it art.', '2026-07-13 03:23:00');
INSERT INTO posts (title, body, created_at) VALUES ('FAQ', 'Q: Why? A: The request was clear. Q: Is it fast? A: The hit counter increments in O(1). Q: Does it scale? A: Every visitor brings their own database server, so yes -- infinitely. This is the most horizontally scaled MySQL deployment in history. Q: Is my guestbook entry saved? A: It is saved to a database that ceases to exist when you close the tab. Like a sandcastle. Q: Can I use this in production? A: You are in production right now.', '2026-07-12 04:23:00');
INSERT INTO posts (title, body, created_at) VALUES ('Performance Update', 'We profiled the site. The flame graph is just one very wide bar. We considered a loading spinner but rejected it: a spinner implies apology, and we regret nothing. We did add HTTP caching headers, which GitHub Pages provides for free, so the second visit is merely slow.', '2026-07-11 05:23:00');

--
-- Table structure for table `guestbook`
--
CREATE TABLE guestbook (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(128) NOT NULL, message TEXT NOT NULL, created_at DATETIME NOT NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;
INSERT INTO guestbook (name, message, created_at) VALUES ('ICQ_Angel_Xx', 'best viewed at 800x600 in a browser with 16GB of RAM', '2026-06-01 00:00:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NapsterTheGreat', 'TTFB was great, shame about the other letters', '2026-06-24 13:53:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('QuakeWizard', 'how did you get the counter to work?? plz email me the cgi', '2026-06-19 02:46:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AOLRulez', 'how did you get the counter to work?? plz email me the cgi', '2026-06-14 15:39:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AngelfireMaster', 'TTFB was great, shame about the other letters', '2026-06-09 04:32:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('BuddyWizard', 'First!!!1', '2026-06-04 17:25:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Sk8erKid', 'how did you get the counter to work?? plz email me the cgi', '2026-06-27 06:18:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ICQJunkie', 'your site crashed netscape but in a good way', '2026-06-22 19:11:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ModemKid', 'signed the guestbook, now sign mine!!', '2026-06-17 08:04:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Y2KKid', 'this page loaded faster than my dial-up, and my dial-up is broken', '2026-06-12 21:57:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ModemBoi_99', 'TTFB was great, shame about the other letters', '2026-06-07 10:50:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Buddy_Angel_Xx', 'waited 4 minutes for first paint. the paint was worth it', '2026-06-02 23:43:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ModemTheGreat', 'cool site! check out my site at geocities dot com slash modemthegreat', '2026-06-25 12:36:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('JavaOnFire', 'waited 4 minutes for first paint. the paint was worth it', '2026-06-20 01:29:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('xX_DarkHacker', 'TTFB was great, shame about the other letters', '2026-06-15 14:22:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('xX_Dark_Angel_Xx', 'the hit counter incremented, so the database writes work. incredible', '2026-06-10 03:15:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('WebMasterFan', 'TTFB was great, shame about the other letters', '2026-06-05 16:08:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AOL2000', 'TTFB was great, shame about the other letters', '2026-06-28 05:01:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Y2KRider', 'an entire MySQL server engine in WebAssembly? in this economy?', '2026-06-23 18:54:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('xX_Dark_2003', 'TTFB was great, shame about the other letters', '2026-06-18 07:47:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('QuakeX', 'best viewed at 800x600 in a browser with 16GB of RAM', '2026-06-13 20:40:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Quake_Angel_Xx', 'you should add a splash page so it loads slower', '2026-06-08 09:33:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('CyberDudeTheGreat', 'still faster than our Jira instance', '2026-06-03 22:26:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NetSurferRider', 'First!!!1', '2026-06-26 11:19:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('WebMasterMaster', 'your site crashed netscape but in a good way', '2026-06-21 00:12:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NapsterRider', 'does this site work on WAP? asking for my Nokia', '2026-06-16 13:05:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('your ISP', 'we noticed unusual download activity. it was this page.', '2026-06-11 02:58:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NetSurfer_2003', 'the hit counter incremented, so the database writes work. incredible', '2026-06-06 15:51:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('CounterZilla', 'my computer fan turned on and I knew the database was starting', '2026-06-01 04:44:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Rasmus', 'I said PHP would run anywhere. this is not what I meant. it counts though.', '2026-06-24 17:37:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Flash4life', 'an entire MySQL server engine in WebAssembly? in this economy?', '2026-06-19 06:30:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('PentiumMaster', 'best viewed at 800x600 in a browser with 16GB of RAM', '2026-06-14 19:23:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Winamp4life', 'an entire MySQL server engine in WebAssembly? in this economy?', '2026-06-09 08:16:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NapsterZilla', 'you should add a splash page so it loads slower', '2026-06-04 21:09:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Java_2003', 'Lighthouse gave this site a score and then filed a restraining order', '2026-06-27 10:02:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('CounterWizard', 'I have been waiting for this page to load since breakfast. Worth it.', '2026-06-22 23:55:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('TrillianRulez', 'First!!!1', '2026-06-17 12:48:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('CounterMaster', 'I viewed source and I am calling the police', '2026-06-12 01:41:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ICQDawg', 'how did you get the counter to work?? plz email me the cgi', '2026-06-07 14:34:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('WebMasterJunkie', 'waited 4 minutes for first paint. the paint was worth it', '2026-06-02 03:27:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Sk8erHacker', 'TTFB was great, shame about the other letters', '2026-06-25 16:20:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('xX_DarkJunkie', 'this page loaded faster than my dial-up, and my dial-up is broken', '2026-06-20 05:13:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Sk8erX', 'the hit counter incremented, so the database writes work. incredible', '2026-06-15 18:06:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('BuddyWizard', 'the hit counter incremented, so the database writes work. incredible', '2026-06-10 07:59:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NetSurferTheGreat', 'TTFB was great, shame about the other letters', '2026-06-05 20:52:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ICQLord', 'does this site work on WAP? asking for my Nokia', '2026-06-28 09:45:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Pentium_Angel_Xx', 'my computer fan turned on and I knew the database was starting', '2026-06-23 22:38:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Quake_2003', 'signed the guestbook, now sign mine!!', '2026-06-18 11:31:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('TrillianDawg', 'this page loaded faster than my dial-up, and my dial-up is broken', '2026-06-13 00:24:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('xX_DarkBoi_99', 'best viewed at 800x600 in a browser with 16GB of RAM', '2026-06-08 13:17:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NetSurferWizard', 'an entire MySQL server engine in WebAssembly? in this economy?', '2026-06-03 02:10:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('PentiumX', 'Lighthouse gave this site a score and then filed a restraining order', '2026-06-26 15:03:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AngelfireDawg', 'greetings from the year 2003, we finally got here', '2026-06-21 04:56:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AngelfireBoi_99', 'PHP in the browser?? what will they think of next, CSS?', '2026-06-16 17:49:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('FlashTheGreat', 'greetings from the year 2003, we finally got here', '2026-06-11 06:42:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Geo4life', 'does this site work on WAP? asking for my Nokia', '2026-06-06 19:35:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Sk8erRider', 'how did you get the counter to work?? plz email me the cgi', '2026-06-01 08:28:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('TrillianRider', 'signed the guestbook, now sign mine!!', '2026-06-24 21:21:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AOL2000', 'waited 4 minutes for first paint. the paint was worth it', '2026-06-19 10:14:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Java2000', 'an entire MySQL server engine in WebAssembly? in this economy?', '2026-06-14 23:07:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('mobile user on 3G', 'I will let you know how the site is when it finishes loading. reply expected 2027.', '2026-06-09 12:00:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('TrillianRider', 'the hit counter incremented, so the database writes work. incredible', '2026-06-04 01:53:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Counter4life', 'an entire MySQL server engine in WebAssembly? in this economy?', '2026-06-27 14:46:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AOLOnFire', 'signed the guestbook, now sign mine!!', '2026-06-22 03:39:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NapsterJr', 'I viewed source and I am calling the police', '2026-06-17 16:32:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('FlashHacker', 'waited 4 minutes for first paint. the paint was worth it', '2026-06-12 05:25:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ICQOnFire', 'TTFB was great, shame about the other letters', '2026-06-07 18:18:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NapsterMaster', 'the hit counter incremented, so the database writes work. incredible', '2026-06-02 07:11:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('QuakeTheGreat', 'does this site work on WAP? asking for my Nokia', '2026-06-25 20:04:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('JavaMaster', 'you should add a splash page so it loads slower', '2026-06-20 09:57:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('WebMasterMaster', 'greetings from the year 2003, we finally got here', '2026-06-15 22:50:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Buddy4life', 'best viewed at 800x600 in a browser with 16GB of RAM', '2026-06-10 11:43:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Angelfire_Angel_Xx', 'how did you get the counter to work?? plz email me the cgi', '2026-06-05 00:36:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('xX_Dark_Angel_Xx', 'you should add a splash page so it loads slower', '2026-06-28 13:29:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('a Lighthouse auditor', 'Performance: 0. Accessibility: surprisingly fine. Best Practices: no.', '2026-06-23 02:22:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('FlashDawg', 'still faster than our Jira instance', '2026-06-18 15:15:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Quake4life', 'I viewed source and I am calling the police', '2026-06-13 04:08:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('WebMasterDawg', 'waited 4 minutes for first paint. the paint was worth it', '2026-06-08 17:01:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('PentiumX', 'this page loaded faster than my dial-up, and my dial-up is broken', '2026-06-03 06:54:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('WinampZilla', 'the hit counter incremented, so the database writes work. incredible', '2026-06-26 19:47:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('the CDN', 'you did not use me. bold. everything shipped from github.io raw.', '2026-06-21 08:40:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Pentium_2003', 'PHP in the browser?? what will they think of next, CSS?', '2026-06-16 21:33:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Y2KWizard', 'best viewed at 800x600 in a browser with 16GB of RAM', '2026-06-11 10:26:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('JavaFan', 'your site crashed netscape but in a good way', '2026-06-06 23:19:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('TrillianZilla', 'TTFB was great, shame about the other letters', '2026-06-01 12:12:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AOLHacker', 'best viewed at 800x600 in a browser with 16GB of RAM', '2026-06-24 01:05:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NapsterFan', 'does this site work on WAP? asking for my Nokia', '2026-06-19 14:58:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('BuddyFan', 'you should add a splash page so it loads slower', '2026-06-14 03:51:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NetSurferWizard', 'your site crashed netscape but in a good way', '2026-06-09 16:44:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Sk8erJunkie', 'waited 4 minutes for first paint. the paint was worth it', '2026-06-04 05:37:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Pentium4life', 'my computer fan turned on and I knew the database was starting', '2026-06-27 18:30:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AOLJunkie', 'you should add a splash page so it loads slower', '2026-06-22 07:23:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('JavaFan', 'Lighthouse gave this site a score and then filed a restraining order', '2026-06-17 20:16:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Y2KZilla', 'signed the guestbook, now sign mine!!', '2026-06-12 09:09:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Sk8erLord', 'I viewed source and I am calling the police', '2026-06-07 22:02:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Tim', 'the whole web platform is right there and you built this. respect.', '2026-06-02 11:55:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('GeoBoi_99', 'best viewed at 800x600 in a browser with 16GB of RAM', '2026-06-25 00:48:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Buddy4life', 'still faster than our Jira instance', '2026-06-20 13:41:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('xX_DarkWizard', 'greetings from the year 2003, we finally got here', '2026-06-15 02:34:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('GeoBoi_99', 'First!!!1', '2026-06-10 15:27:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AOLZilla', 'I have been waiting for this page to load since breakfast. Worth it.', '2026-06-05 04:20:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NetSurferX', 'I have been waiting for this page to load since breakfast. Worth it.', '2026-06-28 17:13:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('JavaFan', 'waited 4 minutes for first paint. the paint was worth it', '2026-06-23 06:06:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ModemBoi_99', 'you should add a splash page so it loads slower', '2026-06-18 19:59:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NetSurferWizard', 'still faster than our Jira instance', '2026-06-13 08:52:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Y2KX', 'you should add a splash page so it loads slower', '2026-06-08 21:45:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('TrillianJr', 'you should add a splash page so it loads slower', '2026-06-03 10:38:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('the MySQL server', 'I live in your browser tab now. please do not close it, that is my house.', '2026-06-26 23:31:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('FlashLord', 'the hit counter incremented, so the database writes work. incredible', '2026-06-21 12:24:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AOLDawg', 'waited 4 minutes for first paint. the paint was worth it', '2026-06-16 01:17:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AngelfireRider', 'still faster than our Jira instance', '2026-06-11 14:10:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Sk8er2000', 'this page loaded faster than my dial-up, and my dial-up is broken', '2026-06-06 03:03:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NapsterDawg', 'best viewed at 800x600 in a browser with 16GB of RAM', '2026-06-01 16:56:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('xX_DarkOnFire', 'TTFB was great, shame about the other letters', '2026-06-24 05:49:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('CounterMaster', 'my computer fan turned on and I knew the database was starting', '2026-06-19 18:42:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('WebMasterOnFire', 'an entire MySQL server engine in WebAssembly? in this economy?', '2026-06-14 07:35:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Y2KWizard', 'still faster than our Jira instance', '2026-06-09 20:28:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('GeoKid', 'does this site work on WAP? asking for my Nokia', '2026-06-04 09:21:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ICQOnFire', 'waited 4 minutes for first paint. the paint was worth it', '2026-06-27 22:14:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Y2KKid', 'does this site work on WAP? asking for my Nokia', '2026-06-22 11:07:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('BuddyZilla', 'cool site! check out my site at geocities dot com slash buddyzilla', '2026-06-17 00:00:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NetSurfer2000', 'this page loaded faster than my dial-up, and my dial-up is broken', '2026-06-12 13:53:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('PentiumX', 'PHP in the browser?? what will they think of next, CSS?', '2026-06-07 02:46:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('WebMasterKid', 'cool site! check out my site at geocities dot com slash webmasterkid', '2026-06-02 15:39:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('JavaLord', 'your site crashed netscape but in a good way', '2026-06-25 04:32:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('PentiumTheGreat', 'PHP in the browser?? what will they think of next, CSS?', '2026-06-20 17:25:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AOLDawg', 'PHP in the browser?? what will they think of next, CSS?', '2026-06-15 06:18:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('JavaRulez', 'does this site work on WAP? asking for my Nokia', '2026-06-10 19:11:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('xX_DarkMaster', 'best viewed at 800x600 in a browser with 16GB of RAM', '2026-06-05 08:04:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('CounterJr', 'PHP in the browser?? what will they think of next, CSS?', '2026-06-28 21:57:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('BuddyJr', 'this page loaded faster than my dial-up, and my dial-up is broken', '2026-06-23 10:50:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ModemBoi_99', 'signed the guestbook, now sign mine!!', '2026-06-18 23:43:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Y2K_Angel_Xx', 'you should add a splash page so it loads slower', '2026-06-13 12:36:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('xX_DarkKid', 'Lighthouse gave this site a score and then filed a restraining order', '2026-06-08 01:29:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('xX_DarkDawg', 'still faster than our Jira instance', '2026-06-03 14:22:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('the garbage collector', 'I have seen things you people would not believe.', '2026-06-26 03:15:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AOLBoi_99', 'your site crashed netscape but in a good way', '2026-06-21 16:08:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ModemFan', 'cool site! check out my site at geocities dot com slash modemfan', '2026-06-16 05:01:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('FlashWizard', 'cool site! check out my site at geocities dot com slash flashwizard', '2026-06-11 18:54:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('FlashX', 'my computer fan turned on and I knew the database was starting', '2026-06-06 07:47:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ModemBoi_99', 'I viewed source and I am calling the police', '2026-06-01 20:40:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('FlashMaster', 'your site crashed netscape but in a good way', '2026-06-24 09:33:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('WebMaster4life', 'PHP in the browser?? what will they think of next, CSS?', '2026-06-19 22:26:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Flash4life', 'the hit counter incremented, so the database writes work. incredible', '2026-06-14 11:19:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Sk8er_2003', 'your site crashed netscape but in a good way', '2026-06-09 00:12:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ModemZilla', 'you should add a splash page so it loads slower', '2026-06-04 13:05:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Trillian2000', 'cool site! check out my site at geocities dot com slash trillian2000', '2026-06-27 02:58:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('JavaZilla', 'PHP in the browser?? what will they think of next, CSS?', '2026-06-22 15:51:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Buddy2000', 'how did you get the counter to work?? plz email me the cgi', '2026-06-17 04:44:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('FlashRulez', 'TTFB was great, shame about the other letters', '2026-06-12 17:37:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NetSurfer2000', 'this page loaded faster than my dial-up, and my dial-up is broken', '2026-06-07 06:30:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Geo4life', 'I have been waiting for this page to load since breakfast. Worth it.', '2026-06-02 19:23:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('GeoMaster', 'waited 4 minutes for first paint. the paint was worth it', '2026-06-25 08:16:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Buddy4life', 'you should add a splash page so it loads slower', '2026-06-20 21:09:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Y2KJr', 'you should add a splash page so it loads slower', '2026-06-15 10:02:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('PentiumFan', 'I viewed source and I am calling the police', '2026-06-10 23:55:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('WinampTheGreat', 'TTFB was great, shame about the other letters', '2026-06-05 12:48:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('PentiumTheGreat', 'does this site work on WAP? asking for my Nokia', '2026-06-28 01:41:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Geo_Angel_Xx', 'does this site work on WAP? asking for my Nokia', '2026-06-23 14:34:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ModemTheGreat', 'does this site work on WAP? asking for my Nokia', '2026-06-18 03:27:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('WebMasterLord', 'cool site! check out my site at geocities dot com slash webmasterlord', '2026-06-13 16:20:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('CounterBoi_99', 'the hit counter incremented, so the database writes work. incredible', '2026-06-08 05:13:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ICQHacker', 'Lighthouse gave this site a score and then filed a restraining order', '2026-06-03 18:06:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('JavaDawg', 'the hit counter incremented, so the database writes work. incredible', '2026-06-26 07:59:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Y2K4life', 'I have been waiting for this page to load since breakfast. Worth it.', '2026-06-21 20:52:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('CounterTheGreat', 'how did you get the counter to work?? plz email me the cgi', '2026-06-16 09:45:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ModemRulez', 'signed the guestbook, now sign mine!!', '2026-06-11 22:38:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Modem2000', 'I viewed source and I am calling the police', '2026-06-06 11:31:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AngelfireDawg', 'signed the guestbook, now sign mine!!', '2026-06-01 00:24:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('PentiumRulez', 'this page loaded faster than my dial-up, and my dial-up is broken', '2026-06-24 13:17:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NetSurferMaster', 'signed the guestbook, now sign mine!!', '2026-06-19 02:10:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('BuddyZilla', 'your site crashed netscape but in a good way', '2026-06-14 15:03:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('GeoZilla', 'I have been waiting for this page to load since breakfast. Worth it.', '2026-06-09 04:56:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('QuakeBoi_99', 'I have been waiting for this page to load since breakfast. Worth it.', '2026-06-04 17:49:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NetSurferHacker', 'does this site work on WAP? asking for my Nokia', '2026-06-27 06:42:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Sk8erLord', 'Lighthouse gave this site a score and then filed a restraining order', '2026-06-22 19:35:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AOLRider', 'you should add a splash page so it loads slower', '2026-06-17 08:28:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AOLLord', 'this page loaded faster than my dial-up, and my dial-up is broken', '2026-06-12 21:21:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NetSurferFan', 'my computer fan turned on and I knew the database was starting', '2026-06-07 10:14:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('GeoLord', 'does this site work on WAP? asking for my Nokia', '2026-06-02 23:07:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('CounterZilla', 'greetings from the year 2003, we finally got here', '2026-06-25 12:00:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Y2KX', 'signed the guestbook, now sign mine!!', '2026-06-20 01:53:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('FlashJunkie', 'I have been waiting for this page to load since breakfast. Worth it.', '2026-06-15 14:46:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('GeoZilla', 'I have been waiting for this page to load since breakfast. Worth it.', '2026-06-10 03:39:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Pentium2000', 'TTFB was great, shame about the other letters', '2026-06-05 16:32:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NapsterX', 'does this site work on WAP? asking for my Nokia', '2026-06-28 05:25:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ModemJr', 'your site crashed netscape but in a good way', '2026-06-23 18:18:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AngelfireBoi_99', 'the hit counter incremented, so the database writes work. incredible', '2026-06-18 07:11:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('GeoWizard', 'an entire MySQL server engine in WebAssembly? in this economy?', '2026-06-13 20:04:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('AOL4life', 'this page loaded faster than my dial-up, and my dial-up is broken', '2026-06-08 09:57:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NetSurfer4life', 'I viewed source and I am calling the police', '2026-06-03 22:50:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('NapsterBoi_99', 'does this site work on WAP? asking for my Nokia', '2026-06-26 11:43:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Winamp4life', 'does this site work on WAP? asking for my Nokia', '2026-06-21 00:36:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('CounterJr', 'this page loaded faster than my dial-up, and my dial-up is broken', '2026-06-16 13:29:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('ICQFan', 'an entire MySQL server engine in WebAssembly? in this economy?', '2026-06-11 02:22:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('PentiumOnFire', 'I have been waiting for this page to load since breakfast. Worth it.', '2026-06-06 15:15:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Y2KJunkie', 'your site crashed netscape but in a good way', '2026-06-01 04:08:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Geo4life', 'still faster than our Jira instance', '2026-06-24 17:01:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('GeoX', 'you should add a splash page so it loads slower', '2026-06-19 06:54:00');
INSERT INTO guestbook (name, message, created_at) VALUES ('Y2K_Angel_Xx', 'waited 4 minutes for first paint. the paint was worth it', '2026-06-14 19:47:00');

-- Dump completed on 2026-07-15  4:04:04
