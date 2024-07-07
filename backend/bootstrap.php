<?php
require 'vendor/autoload.php';

use Dotenv\Dotenv;
use App\Models\User;

// Load environment variables from .env file
$dotenv = Dotenv::createImmutable(__DIR__);
$dotenv->load();

// Set up database connection
$pdo = new PDO('mysql:host=' . $_ENV['DB_HOST'] . ';dbname=' . $_ENV['DB_NAME'], $_ENV['DB_USER'], $_ENV['DB_PASS']);
User::setDatabase($pdo);
