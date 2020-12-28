<?php
// getConfig.php to get the configuration of a Kirby site
// Usage: php getConfig.php DOCROOT
// Example: php getConfig.php '/srv/www/vhost/kirby-test/htdocs'

$kirbyBootstrap = $argv[1] . '/kirby/bootstrap.php';
if ( ! file_exists($kirbyBootstrap) ) {
  echo json_encode('');
  exit;
}

require $kirbyBootstrap;

$kirby = new Kirby([ 'roots' => [ 'index' => $argv[1] ] ]);

$myKirby = array(
  'languages' => $kirby->languages()->toArray(),
  'options'   => $kirby->options(),
  'plugins'   => $kirby->plugins(),
  'roles'     => $kirby->roles()->toArray(),
  'roots'     => $kirby->roots()->toArray(),
  'routes'    => $kirby->routes(),
  'site'      => $kirby->site()->toArray(),
  'urls'      => $kirby->urls()->toArray(),
  'users'     => $kirby->users()->toArray(),
  'version'   => $kirby->version(),
);

echo json_encode($myKirby);

/*
 * Other solution provided by texnixe in https://forum.getkirby.com/t/get-info-about-a-kirby-website/20533
 * but the __debugInfo is missing info about roles, users, plugins and routes.

 $debugInfo = $kirby->__debugInfo();

//var_dump($debugInfo);

$debugInfo = array_map(function($info) {
    if ( is_object( $info ) && method_exists( $info, 'toArray' ) ) {
      return $info->toArray();
    }
    return $info;
}, $debugInfo);

echo json_encode($debugInfo);
*/
?>
