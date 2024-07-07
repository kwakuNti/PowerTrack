<?php
namespace App\Models;

use PDO;

class User {
    private static $db;

    public static function setDatabase($database) {
        self::$db = $database;
    }

    public static function getAll() {
        $stmt = self::$db->query("SELECT * FROM users");
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function __construct($data) {
        $this->name = $data['name'];
        $this->email = $data['email'];
    }

    public function save() {
        // Insert user data into the database
        $stmt = self::$db->prepare("INSERT INTO users (name, email) VALUES (:name, :email)");
        $stmt->execute([':name' => $this->name, ':email' => $this->email]);
    }
}
