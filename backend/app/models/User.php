<?php
require_once __DIR__ . '/model.php';

/// Class to represent the Users database
class User extends Model
{
    protected $table = 'users';
    protected $otherTable = 'tokens';

    // Create single user
    public function createUser($first_name, $last_name, $email, $password)
    {
        $password_hash = password_hash($password, PASSWORD_DEFAULT);
        $data = [
            'first_name' => $first_name,
            'last_name' => $last_name,
            'email' => $email,
            'password' => $password_hash,
        ];

        return $this->insert($data);
    }

    // Find a user by their email address
    public function findByEmail($email)
    {
        $result = $this->find("email", $email);
        return $result;
    }

    // Fetch all users in the system with a specific set of column details (attributes)
    public function fetchAll()
    {
        $sql = "SELECT user_id, first_name, last_name, profile_image
                FROM {$this->table}";

        $stmt = $this->pdo->query($sql);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Find a user by their id
    public function findProfileById($id)
    {
        $sql = "SELECT userId,username, firstname, lastname, profile_Image, email FROM " . $this->table . " WHERE user_id = :id";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['id' => $id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Update user profile image
    public function updateProfileImage($id, $imagePath){
        $sql = "UPDATE {$this->table} SET profile_Image = :profile_Image WHERE user_id = :id";
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute(['profile_Image' => $imagePath, 'id' => $id]);
    }

    // Store the user's login token in the database
    public function storeToken($id, $token){
        $sql = "INSERT INTO {$this->otherTable} (user_id, token) VALUES (:id, :token)
            ON DUPLICATE KEY UPDATE
            token = VALUES(token)";
        
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['id' => $id, 'token' => $token]);
    }

    // Setup the user's profile with bio and username
    public function updateProfile($id, $username, $bio, $gender){
        $sql = "UPDATE {$this->table} SET bio = :bio WHERE user_id = :id";
    
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute([
                    'id' => $id,
                    'username' => $username,
                ]);
    }

    // update password
    public function resetPassword($email, $newPassword)
    {
        $password_hash = password_hash($newPassword, PASSWORD_DEFAULT);
        $sql = "UPDATE {$this->table} SET password = :password WHERE email = :email";
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute(['password' => $password_hash, 'email' => $email]);
    }

    public function changePassword($user_id, $oldPassword, $newPassword)
    {
        $user = $this->findById($user_id);
        
        if ($user && password_verify($oldPassword, $user['password'])) {
            $password_hash = password_hash($newPassword, PASSWORD_DEFAULT);
            $sql = "UPDATE {$this->table} SET password = :password WHERE user_id = :user_id";
            $stmt = $this->pdo->prepare($sql);
            return $stmt->execute(['password' => $password_hash, 'user_id' => $user_id]);
        } else {
            return false; // Invalid current password
        }
    }
    
    public function findById($user_id)
    {
        $sql = "SELECT * FROM {$this->table} WHERE user_id = :user_id";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['user_id' => $user_id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    
}
?>
