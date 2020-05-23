<?php
// createUser.php to create a kirby panel admin user
// Usage: php createUser.php DOCROOT EMAIL NAME LANG PASSWORD
// Example: php createUser.php '/srv/www/vhost/kirby-test/htdocs' 'uwe@imap.cc' 'Uwe Gehring' 'en' 'secret'

require $argv[1] . '/kirby/bootstrap.php';

$kirby = new Kirby([ 'roots' => [ 'index' => $argv[1] ] ]);

// authenticate as almighty
$kirby->impersonate('kirby');

// create new K3 user account
$kirby->users()->create(['role' => 'admin','email' => $argv[2],'name' => $argv[3],'language' => $argv[4],'password' => $argv[5]]);

?>
