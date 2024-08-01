<?php

require_once __DIR__ . '/../models/Maintenance.php';

class MaintenanceRequestController
{
    protected $maintenanceRequestModel;

    public function __construct($pdo)
    {
        $this->maintenanceRequestModel = new MaintenanceRequest($pdo);
    }

    public function createRequest($data)
    {
        try {
            $this->maintenanceRequestModel->createRequest(
                $data['meter_id'],
                $data['user_id'],
                $data['description']
            );
            return ['success' => true];
        } catch (PDOException $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    public function updateRequestStatus($request_id, $status)
    {
        try {
            $this->maintenanceRequestModel->updateRequestStatus($request_id, $status);
            return ['success' => true];
        } catch (PDOException $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    public function getRequestsByUserId($user_id)
    {
        try {
            $requests = $this->maintenanceRequestModel->fetchRequestsByUserId($user_id);
            return ['success' => true, 'data' => $requests];
        } catch (Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    public function getAllRequests()
    {
        try {
            $requests = $this->maintenanceRequestModel->fetchAllRequests();
            return ['success' => true, 'data' => $requests];
        } catch (Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }
}
?>
