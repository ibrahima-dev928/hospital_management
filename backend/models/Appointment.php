<?php
class Appointment {
    private $conn;
    private $table_name = "appointments";

    public $id;
    public $patient_id;
    public $doctor_id;
    public $appointment_date;
    public $status;
    public $notes;
    public $meeting_link;
    public $fee;

    public function __construct($db) {
        $this->conn = $db;
    }

    public function getForPatient($patient_id) {
        $query = "SELECT a.*, 
                         d.name as doctor_name, d.specialization 
                  FROM " . $this->table_name . " a
                  JOIN users d ON a.doctor_id = d.id
                  WHERE a.patient_id = :patient_id
                  ORDER BY a.appointment_date DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':patient_id', $patient_id);
        $stmt->execute();
        return $stmt;
    }

    public function create() {
        $query = "INSERT INTO " . $this->table_name . "
                SET patient_id=:patient_id, doctor_id=:doctor_id, 
                    appointment_date=:appointment_date, status=:status, 
                    notes=:notes, fee=:fee";
        $stmt = $this->conn->prepare($query);

        $stmt->bindParam(':patient_id', $this->patient_id);
        $stmt->bindParam(':doctor_id', $this->doctor_id);
        $stmt->bindParam(':appointment_date', $this->appointment_date);
        $stmt->bindParam(':status', $this->status);
        $stmt->bindParam(':notes', $this->notes);
        $stmt->bindParam(':fee', $this->fee);

        if ($stmt->execute()) {
            return $this->conn->lastInsertId();
        }
        return false;
    }

    public function cancel($id) {
        $query = "UPDATE " . $this->table_name . " SET status='cancelled' WHERE id=:id";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':id', $id);
        return $stmt->execute();
    }
}
?>