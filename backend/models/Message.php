<?php
class Message {
    private $conn;
    private $table_name = "messages";

    public $id;
    public $sender_id;
    public $receiver_id;
    public $message;
    public $is_read;
    public $created_at;

    public function __construct($db) {
        $this->conn = $db;
    }

    public function getConversations($user_id) {
        // Récupère les dernières conversations groupées par interlocuteur
        $query = "SELECT 
                    IF(sender_id = :user_id, receiver_id, sender_id) as other_user_id,
                    MAX(created_at) as last_time,
                    SUM(CASE WHEN receiver_id = :user_id AND is_read = 0 THEN 1 ELSE 0 END) as unread_count
                  FROM messages
                  WHERE sender_id = :user_id OR receiver_id = :user_id
                  GROUP BY other_user_id
                  ORDER BY last_time DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':user_id', $user_id);
        $stmt->execute();
        return $stmt;
    }

    public function getMessages($user_id, $other_user_id) {
        $query = "SELECT m.*, 
                         sender.name as sender_name, receiver.name as receiver_name
                  FROM messages m
                  JOIN users sender ON m.sender_id = sender.id
                  JOIN users receiver ON m.receiver_id = receiver.id
                  WHERE (m.sender_id = :user_id AND m.receiver_id = :other_id)
                     OR (m.sender_id = :other_id AND m.receiver_id = :user_id)
                  ORDER BY m.created_at ASC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':user_id', $user_id);
        $stmt->bindParam(':other_id', $other_user_id);
        $stmt->execute();
        return $stmt;
    }

    public function send() {
        $query = "INSERT INTO " . $this->table_name . "
                SET sender_id=:sender_id, receiver_id=:receiver_id, message=:message, is_read=0";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':sender_id', $this->sender_id);
        $stmt->bindParam(':receiver_id', $this->receiver_id);
        $stmt->bindParam(':message', $this->message);
        if ($stmt->execute()) {
            $this->id = $this->conn->lastInsertId();
            return true;
        }
        return false;
    }

    public function markAsRead($user_id, $other_user_id) {
        $query = "UPDATE messages SET is_read=1 
                  WHERE receiver_id = :user_id AND sender_id = :other_id AND is_read=0";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':user_id', $user_id);
        $stmt->bindParam(':other_id', $other_user_id);
        return $stmt->execute();
    }
}
?>