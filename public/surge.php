<?php
use App\Utils\Tools;
use App\Services\Config;
use App\Models\User;
use App\Models\Node;

//  PUBLIC_PATH
define('PUBLIC_PATH', __DIR__);

// Bootstrap
require PUBLIC_PATH.'/../bootstrap.php';

if ( $_GET['node'] != (int)$_GET['node'] ) {
	echo "nonode";
} else if ( $_GET['uid'] != (int)$_GET['uid'] ) {
	echo "nouser";
	die();
} else if ( 64 !== strlen( $_GET['token'] ) ) {
	echo "notoken" . strlen( $_GET['token'] );
	die();
}
$user = User::find( (int)$_GET['uid'] );
if ( $user === null || $user->surgetoken !== $_GET['token'] ) {
	echo "wronguserortoken";
	die();
}

$node = Node::find( (int)$_GET['node'] );
if ( $node === null ) {
	echo "nonode";
	die();
}
echo Tools::getSurgeConf( $node->server, $user->port, $node->method, $user->passwd, Config::get( "surgeSSModule" ) );
