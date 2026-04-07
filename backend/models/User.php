<?php
class User {
    private $conn;
    private $table_name = "users";

    public $id;
    public $name;
    public $email;
    public $password;
    public $phone;
    public $profile_image;
    public $user_type;
    public $specialization;
    public $experience;
    public $rating;
    public $wallet_balance;

    public function __construct($db) {
        $this->conn = $db;
    }

    public function login() {
        $query = "SELECT * FROM " . $this->table_name . " WHERE email = :email";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':email', $this->email);
        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            if (password_verify($this->password, $row['password'])) {
                return $row;
            }
        }
        return false;
    }

    public function create() {
        $query = "INSERT INTO " . $this->table_name . "
                SET name=:name, email=:email, password=:password, 
                    phone=:phone, user_type=:user_type";
        $stmt = $this->conn->prepare($query);

        $this->password = password_hash($this->password, PASSWORD_DEFAULT);

        $stmt->bindParam(':name', $this->name);
        $stmt->bindParam(':email', $this->email);
        $stmt->bindParam(':password', $this->password);
        $stmt->bindParam(':phone', $this->phone);
        $stmt->bindParam(':user_type', $this->user_type);

        if ($stmt->execute()) {
            return $this->conn->lastInsertId();
        }
        return false;
    }

    public function getDoctors() {
        $query = "SELECT id, name, email, phone, specialization, experience, rating FROM " . $this->table_name . " WHERE user_type = 'doctor'";
        $stmt = $this->conn->prepare($query);
        $stmt->execute();
        return $stmt;
    }

    public function getById($id) {
        $query = "SELECT id, name, email, phone, profile_image, user_type, specialization, experience, rating, wallet_balance FROM " . $this->table_name . " WHERE id = :id";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $id);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
}
?>