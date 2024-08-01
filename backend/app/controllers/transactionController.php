<?php

require_once __DIR__ . '/../models/Transaction.php';
require_once __DIR__ . '/../models/MeterUsage.php';

class TransactionController
{
    private $transaction;
    private $meterUsage;

    public function __construct($pdo)
    {
        $this->transaction = new Transaction($pdo);
        $this->meterUsage = new MeterUsage($pdo);
    }

    // Handle creating a transaction
    public function createTransaction($data)
    {
        $response = $this->transaction->createTransaction($data);

        if ($response['status'] === 'success') {
            // Calculate kWh and add usage record
            $kWh = $data['amount'] * 0.110; // Example conversion factor
            $this->meterUsage->addUsage([
                'meter_id' => $data['meter_id'],
                'user_id' => $data['user_id'],
                'usage_date' => date('Y-m-d'),
                'usage_amount' => $kWh
            ]);
        }

        return $response;
    }

    // Handle retrieving transactions by user ID
    public function getTransactionsByUserId($user_id)
    {
        return $this->transaction->getTransactionsByUserId($user_id);
    }
}
?>
