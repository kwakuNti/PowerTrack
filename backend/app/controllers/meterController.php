<?php
class MeterController {
    private $pdo;

    public function __construct($pdo) {
        $this->pdo = $pdo;
    }

    public function createMeter($data) {
        try {
            $stmt = $this->pdo->prepare("
                INSERT INTO meters (
                    user_id, 
                    meter_number, 
                    location, 
                    meter_name, 
                    customer_name, 
                    customer_number
                ) VALUES (
                    :user_id, 
                    :meter_number, 
                    :location, 
                    :meter_name, 
                    :customer_name, 
                    :customer_number
                )
            ");
            $stmt->bindParam(':user_id', $data['user_id']);
            $stmt->bindParam(':meter_number', $data['meter_number']);
            $stmt->bindParam(':location', $data['location']);
            $stmt->bindParam(':meter_name', $data['meter_name']);
            $stmt->bindParam(':customer_name', $data['customer_name']);
            $stmt->bindParam(':customer_number', $data['customer_number']);

            if ($stmt->execute()) {
                return ['status' => 'success', 'message' => 'Meter created successfully'];
            } else {
                return ['status' => 'error', 'message' => 'Failed to create meter'];
            }
        } catch (PDOException $e) {
            return ['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()];
        }
    }

    public function getMetersByUserId($userId) {
        try {
            $stmt = $this->pdo->prepare("SELECT * FROM meters WHERE user_id = :user_id");
            $stmt->bindParam(':user_id', $userId);
            $stmt->execute();
            $meters = $stmt->fetchAll(PDO::FETCH_ASSOC);

            if (empty($meters)) {
                return ['status' => 'error', 'message' => 'No meters found for the specified user ID'];
            }

            return $meters;
        } catch (PDOException $e) {
            return ['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()];
        }
    }
}
