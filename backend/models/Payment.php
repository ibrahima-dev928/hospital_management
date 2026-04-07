<?php
class Payment {
    private $conn;
    private $table_name = "payments";

    public $id;
    public $user_id;
    public $appointment_id;
    public $amount;
    public $status;
    public $stripe_payment_intent_id;
    public $created_at;

    public function __construct($db) {
        $this->conn = $db;
    }

    public function create() {
        $query = "INSERT INTO " . $this->table_name . "
                SET user_id=:user_id, appointment_id=:appointment_id, amount=:amount,
                    status=:status, stripe_payment_intent_id=:stripe_payment_intent_id";
        $stmt = $this->conn->prepare($query);
        $this->user_id = htmlspecialchars(strip_tags($this->user_id));
        $this->appointment_id = htmlspecialchars(strip_tags($this->appointment_id));
        $this->amount = htmlspecialchars(strip_tags($this->amount));
        $this->status = htmlspecialchars(strip_tags($this->status));
        $this->stripe_payment_intent_id = htmlspecialchars(strip_tags($this->stripe_payment_intent_id));
        $stmt->bindParam(':user_id', $this->user_id);
        $stmt->bindParam(':appointment_id', $this->appointment_id);
        $stmt->bindParam(':amount', $this->amount);
        $stmt->bindParam(':status', $this->status);
        $stmt->bindParam(':stripe_payment_intent_id', $this->stripe_payment_intent_id);
        return $stmt->execute();
    }

    public function getByUser($user_id) {
        $query = "SELECT * FROM " . $this->table_name . " WHERE user_id = :user_id ORDER BY created_at DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':user_id', $user_id);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
?>