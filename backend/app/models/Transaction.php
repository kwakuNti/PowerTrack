<?php

class Transaction
{
    private $pdo;

    public function __construct($pdo)
    {
        $this->pdo = $pdo;
    }

    // Create a new transaction
    public function createTransaction($data)
    {
        $sql = "INSERT INTO transactions (user_id, meter_id, amount, payment_method, transaction_status) 
                VALUES (:user_id, :meter_id, :amount, :payment_method, :transaction_status)";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([
            ':user_id' => $data['user_id'],
            ':meter_id' => $data['meter_id'],
            ':amount' => $data['amount'],
            ':payment_method' => $data['payment_method'],
            ':transaction_status' => $data['transaction_status']
        ]);

        return ['status' => 'success', 'message' => 'Transaction recorded successfully'];
    }

    // Retrieve transactions by user ID
    public function getTransactionsByUserId($user_id)
    {
        $sql = "SELECT * FROM transactions WHERE user_id = :user_id";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([':user_id' => $user_id]);
        $transactions = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if ($transactions) {
            return ['status' => 'success', 'data' => $transactions];
        } else {
            return ['status' => 'error', 'message' => 'No transactions found'];
        }
    }
}
?>
