<?php

class MeterUsage
{
    private $pdo;

    public function __construct($pdo)
    {
        $this->pdo = $pdo;
    }

    // Add a new meter usage record
    public function addUsage($data)
    {
        $sql = "INSERT INTO meter_usage (meter_id, user_id, usage_date, usage_amount) 
                VALUES (:meter_id, :user_id, :usage_date, :usage_amount)";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([
            ':meter_id' => $data['meter_id'],
            ':user_id' => $data['user_id'],
            ':usage_date' => $data['usage_date'],
            ':usage_amount' => $data['usage_amount']
        ]);

        return ['status' => 'success', 'message' => 'Usage record added successfully'];
    }

    // Retrieve usage data by meter ID
    public function getUsageByMeterId($meter_id)
    {
        $sql = "SELECT * FROM meter_usage WHERE meter_id = :meter_id";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([':meter_id' => $meter_id]);
        $usage = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if ($usage) {
            return ['status' => 'success', 'data' => $usage];
        } else {
            return ['status' => 'error', 'message' => 'No usage data found'];
        }
    }
}
?>
