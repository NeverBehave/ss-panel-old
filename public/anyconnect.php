<?php
use App\Utils\Tools;
use App\Services\Config;
use App\Models\User;
use App\Models\Node;

//  PUBLIC_PATH
define('PUBLIC_PATH', __DIR__);

// Bootstrap
require PUBLIC_PATH.'/../bootstrap/app.php';

$key = Config::get( "apikey" );
if ( php_sapi_name() !== 'cli' && $_GET['key'] !== $key ) {
	die();
}

$group = "gfwlist";
$users = User::where( "ac_enable", "=", 1 )->get();
foreach ( $users as $user ) {
	$salt = uniqid( "$5$", true );
	$hash = crypt( $user->ac_passwd, $salt );
	echo "{$user->ac_user_name}:{$group}:{$hash}\n";
}
