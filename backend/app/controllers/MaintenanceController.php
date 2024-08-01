<?php

require_once __DIR__ . '/../models/Maintenance.php';

class MaintenanceController
{
    private $maintenanceModel;

    public function __construct($pdo)
    {
        $this->maintenanceModel = new Maintenance($pdo);
    }

    public function createMaintenanceRequest($data)
    {
        return $this->maintenanceModel->create($data);
    }

    public function getMaintenanceRequestById($id)
    {
        return $this->maintenanceModel->find($id);
    }

    public function getAllMaintenanceRequests()
    {
        return $this->maintenanceModel->all();
    }

    public function updateMaintenanceRequest($id, $data)
    {
        return $this->maintenanceModel->update($id, $data);
    }

    public function deleteMaintenanceRequest($id)
    {
        return $this->maintenanceModel->delete('id', $id);
    }
}
