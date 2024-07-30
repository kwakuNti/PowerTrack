<?php

class MeterController {
    private $pdo;

    public function __construct($pdo) {
        $this->pdo = $pdo;
    }

    public function createMeter($data) {
        $stmt = $this->pdo->prepare("INSERT INTO meters (user_id, meter_number, location) VALUES (:user_id, :meter_number, :location)");
        $stmt->bindParam(':user_id', $data['user_id']);
        $stmt->bindParam(':meter_number', $data['meter_number']);
        $stmt->bindParam(':location', $data['location']);

        if ($stmt->execute()) {
            return ['status' => 'success', 'message' => 'Meter created successfully'];
        } else {
            return ['status' => 'error', 'message' => 'Failed to create meter'];
        }
    }

    public function getMetersByUserId($userId) {
        $stmt = $this->pdo->prepare("SELECT * FROM meters WHERE user_id = :user_id");
        $stmt->bindParam(':user_id', $userId);
        $stmt->execute();
        $meters = $stmt->fetchAll(PDO::FETCH_ASSOC);

        return $meters;
    }
}
