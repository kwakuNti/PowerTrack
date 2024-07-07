<?php
namespace App\Controllers;

use App\Models\User;

class UserController {
    public function getUsers() {
        // Fetch users from the database
        $users = User::getAll();
        echo json_encode($users);
    }

    public function createUser() {
        // Get POST data
        $data = json_decode(file_get_contents('php://input'), true);

        // Create new user
        $user = new User($data);
        $user->save();

        echo json_encode(['message' => 'User created successfully']);
    }
}
