<?php

// header('Access-Control-Allow-Origin: ' . $_SERVER['HTTP_ORIGIN']);
header('Access-Control-Allow-Methods: GET, PUT, POST, DELETE, PATCH, OPTIONS');
header('Access-Control-Max-Age: 1000');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
header('content-Type: application/json');


require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/app/controllers/Usercontroller.php';
require_once __DIR__ . '/app/controllers/ForgetPasswordController.php';
require_once __DIR__ . '/app/middleware/validationMiddleware.php';
require_once __DIR__ . '/app/controllers/changePasswordController.php';


use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable(__DIR__);
$dotenv->load();

$router = new AltoRouter();
$router->setBasePath('/PowerTrack/backend');

// create database and pdo
$database = new Database();
$pdo = $database->getPdo();

$userController = new UserController($pdo);
$forgetPasswordController = new ForgetPasswordController($pdo);
$changePasswordController = new ChangePasswordController($pdo);

// Routes
// Below I will define all the different end points that the user can send requests to

// Cater for user account creation
$router->map('POST', '/users', function () use ($userController) {

    $data = json_decode(file_get_contents('php://input'), true);

    // validate data
    ValidationMiddleWare::handle($data, [
        'first_name' => 'string',
        'last_name' => 'string',
        'email' => 'email',
        'password' => 'password',
        'confirm_password' => 'confirm_password',
    ]);

    echo json_encode($userController->createUser($data));
});

// Cater for user login
$router->map('POST', '/users/login', function () use ($userController) {

    $data = json_decode(file_get_contents('php://input'), true);

    // validate data
    ValidationMiddleWare::handle($data, [
        'email' => 'string',
        'password' => 'password',
    ]);

    echo json_encode($userController->login($data));
});

// Catering for fetching user details by user_id
$router->map('GET', '/users/[*:user_id]', function ($user_id) use ($userController) {
    ValidationMiddleWare::handle(['user_id' => $user_id], ['user_id' => 'integer']);
    echo json_encode($userController->getUserById($user_id));
});

// Cater for fetching all users
$router->map('GET', '/users', function () use ($userController) {

    echo json_encode($userController->getAllUsers());
});

// Cater for user creating thier profile
$router->map('POST', '/profile', function () use ($userController) {

    $data = json_decode(file_get_contents('php://input'), true);

    //validate data
    ValidationMiddleWare::handle($data, [
        'user_id' => 'integer',
        'username' => 'string',
        'gender' => 'string',
        'bio' => 'string'
    ]);

    echo json_encode(
        $userController->createProfile(
            $data['user_id'], $data['username'], 
            $data['gender'], $data['bio']
        )
    );
});



// Catering for fetching the matches of a user
$router->map('POST', '/upload/[*:user_id]', function ($user_id) use ($userController) {

    $file = $_FILES['profile_image'];
    
    ValidationMiddleWare::handle(["user_id" => $user_id], ["user_id" => "integer"]);
    ValidationMiddleWare::handleImage($file);
    
    echo json_encode($userController->uploadProfileImage($user_id));
});

// catering for a user forgetting and reseting their password
$router->map('POST', '/users/reset_password', function () use ($forgetPasswordController) {
    $data = json_decode(file_get_contents('php://input'), true);
    ValidationMiddleWare::handle($data, ['email' => 'email']);
    echo json_encode($forgetPasswordController->resetPassword($data));
});


$router->map('POST', '/users/change_password', function () use ($changePasswordController) {
    $data = json_decode(file_get_contents('php://input'), true);
    ValidationMiddleWare::handle($data, [
        'user_id' => 'integer',
        'oldPassword' => 'string',
        'newPassword' => 'string',
        'confirmPassword' => 'string'
    ]);
    echo json_encode($changePasswordController->changePassword($data));
});




$match = $router->match();

if ($match && is_callable($match['target'])) {
    call_user_func_array($match['target'], $match['params']);
} else {
    http_response_code(404);
    echo json_encode(['status' => 'error', 'message' => 'Route not found']);
}
