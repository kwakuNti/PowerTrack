<?php
require '../vendor/autoload.php';
require '../bootstrap.php';

$router = new AltoRouter();

$router->map('GET', '/users', 'UserController@getUsers', 'get_users');
$router->map('POST', '/users', 'UserController@createUser', 'create_user');

$match = $router->match();

if ($match && is_callable($match['target'])) {
    call_user_func_array($match['target'], $match['params']);
} else {
    header($_SERVER["SERVER_PROTOCOL"] . ' 404 Not Found');
}
