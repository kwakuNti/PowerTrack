<?php

class MeterUsageController
{
    private $meterUsage;

    public function __construct($pdo)
    {
        $this->meterUsage = new MeterUsage($pdo);
    }

    // Add a new usage record
    public function addUsage()
    {
        $data = json_decode(file_get_contents('php://input'), true);

        // Validate data
        ValidationMiddleWare::handle($data, [
            'meter_id' => 'integer',
            'user_id' => 'integer',
            'usage_date' => 'string', // Format should be validated
            'usage_amount' => 'decimal'
        ]);

        $response = $this->meterUsage->addUsage($data);
        echo json_encode($response);
    }

    // Retrieve usage data by meter ID
    public function getUsageByMeterId($meter_id)
    {
        if (!is_numeric($meter_id)) {
            $this->sendResponse(['status' => 'error', 'message' => 'Invalid meter ID']);
            return;
        }

        $response = $this->meterUsage->getUsageByMeterId($meter_id);
        $this->sendResponse($response);
    }

    // Helper function to send JSON responses
    private function sendResponse($data)
    {
        header('Content-Type: application/json');
        echo json_encode($data);
    }
}
