<?php
require_once __DIR__ . '/model.php';

class MaintenanceRequest extends Model
{
    protected $table = 'maintenance_requests';

    public function createRequest($meter_id, $user_id, $description)
    {
        $data = [
            'meter_id' => $meter_id,
            'user_id' => $user_id,
            'description' => $description,
        ];
        return $this->insert($data);
    }

    public function updateRequestStatus($request_id, $status)
    {
        $sql = "UPDATE {$this->table} SET status = :status WHERE request_id = :request_id";
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute(['status' => $status, 'request_id' => $request_id]);
    }

    public function fetchRequestsByUserId($user_id)
    {
        $sql = "SELECT * FROM {$this->table} WHERE user_id = :user_id ORDER BY request_date DESC";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['user_id' => $user_id]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function fetchAllRequests()
    {
        $sql = "SELECT * FROM {$this->table} ORDER BY request_date DESC";
        $stmt = $this->pdo->query($sql);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
?>
