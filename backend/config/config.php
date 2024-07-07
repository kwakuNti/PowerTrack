<?php
use App\Models\User;

$pdo = new PDO('mysql:host=localhost;dbname=testdb', 'username', 'password');
User::setDatabase($pdo);
