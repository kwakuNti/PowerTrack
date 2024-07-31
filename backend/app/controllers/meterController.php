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
            $stmt = $this->pdo->prepare("SELECT * FROM meters WHERE user_id = :user_id AND is_deleted = 0");
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

// MeterController.php

public function softDeleteMeter($meter_id) {
    try {
        $stmt = $this->pdo->prepare('UPDATE meters SET is_deleted = 1 WHERE meter_id = :meter_id');
        $stmt->bindParam(':meter_id', $meter_id, PDO::PARAM_INT);
        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            return ['status' => 'success', 'message' => 'Meter marked as deleted'];
        } else {
            return ['status' => 'error', 'message' => 'Meter not found'];
        }
    } catch (PDOException $e) {
        return ['status' => 'error', 'message' => 'Error marking meter as deleted: ' . $e->getMessage()];
    }
}

}
