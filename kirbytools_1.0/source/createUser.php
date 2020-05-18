<?php

require $argv[1] . '/kirby/bootstrap.php';

$kirby = new Kirby([ 'roots' => [ 'index' => $argv[1] ] ]);

// authenticate as almighty
$kirby->impersonate('kirby');

// create new K3 user account
$kirby->users()->create(['role' => 'admin','email' => $argv[2],'name' => $argv[3],'language' => $argv[4],'password' => $argv[5]]);

?>
