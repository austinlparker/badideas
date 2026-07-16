<!doctype html>
<html <?php language_attributes(); ?>>
<head>
<meta charset="<?php bloginfo('charset'); ?>">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><?php bloginfo('name'); ?> &#8212; real WordPress in a browser</title>
<?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
<div class="wrap">
<header class="site-header"><h1><?php bloginfo('name'); ?></h1><p><?php bloginfo('description'); ?></p></header>
<div class="notice">This is real WordPress core, loaded from a cached SQL dump and talking to MySQL-WASM through a db.php drop-in.</div>
<main class="content"><section>
<?php if (have_posts()) : while (have_posts()) : the_post(); ?>
<article <?php post_class('post'); ?> id="post-<?php the_ID(); ?>">
<h2><?php the_title(); ?></h2>
<p class="meta">Posted <?php echo esc_html(get_the_date('Y-m-d H:i:s')); ?> by <?php the_author(); ?> &mdash; <?php comments_number('0 comments', '1 comment', '% comments'); ?></p>
<div><?php the_content(); ?></div>
</article>
<?php endwhile; else : ?><p>No posts. Even the database gave up.</p><?php endif; ?>
</section><aside class="sidebar"><h2>Recent Comments</h2>
<?php foreach (get_comments(array('number' => 12, 'status' => 'approve')) as $comment) : ?>
<div class="comment"><b><?php echo esc_html($comment->comment_author); ?></b><br><small><?php echo esc_html($comment->comment_date); ?></small><div><?php echo esc_html($comment->comment_content); ?></div></div>
<?php endforeach; ?>
<h3>Leave a comment</h3><p>The form below writes through WordPress' comment API, into MySQL in this tab.</p>
<?php if (have_posts()) { rewind_posts(); the_post(); comment_form(array('title_reply' => '', 'comment_notes_before' => '', 'comment_notes_after' => '')); } ?>
</aside></main><footer class="footer" style="padding:1rem;background:#f7f7f7;">Powered by WordPress <?php bloginfo('version'); ?>, PHP/<?php echo PHP_VERSION; ?> WASM, and a database with nowhere else to be.</footer>
</div><?php wp_footer(); ?></body></html>
