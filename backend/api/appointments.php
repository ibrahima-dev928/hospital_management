<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';
include_once '../models/Appointment.php';
include_once '../models/User.php';

// Récupération du token depuis l'en-tête Authorization
$headers = apache_request_headers();
$token = isset($headers['Authorization']) ? str_replace('Bearer ', '', $headers['Authorization']) : null;

if (!$token) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Unauthorized"]);
    exit;
}

// Ici vous devriez valider le token (en production)
// Pour l'exemple, on suppose que le token est valide et on extrait l'user_id

$database = new Database();
$db = $database->getConnection();
$appointment = new Appointment($db);

$data = json_decode(file_get_contents("php://input"));

// On suppose que l'utilisateur est authentifié, on récupère son id depuis le token
// Pour simplifier, on passe l'user_id en paramètre ou dans le corps
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : ($data->user_id ?? null);

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if ($user_id) {
        $stmt = $appointment->getForPatient($user_id);
        $appointments = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $row['id'] = (int)$row['id'];
            $row['patient_id'] = (int)$row['patient_id'];
            $row['doctor_id'] = (int)$row['doctor_id'];
            $row['fee'] = (float)$row['fee'];
            $appointments[] = $row;
        }
        echo json_encode(["success" => true, "data" => $appointments]);
    } else {
        http_response_code(400);
        echo json_encode(["success" => false, "message" => "Missing user_id"]);
    }
}
elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_GET['action']) && $_GET['action'] == 'create') {
        if (!empty($data->doctor_id) && !empty($data->appointment_date) && !empty($data->patient_id)) {
            $appointment->patient_id = $data->patient_id;
            $appointment->doctor_id = $data->doctor_id;
            $appointment->appointment_date = $data->appointment_date;
            $appointment->status = 'upcoming';
            $appointment->notes = $data->notes ?? null;
            $appointment->fee = $data->fee ?? 0;

            $id = $appointment->create();
            if ($id) {
                echo json_encode(["success" => true, "message" => "Appointment created", "appointment_id" => $id]);
            } else {
                http_response_code(500);
                echo json_encode(["success" => false, "message" => "Unable to create appointment"]);
            }
        } else {
            http_response_code(400);
            echo json_encode(["success" => false, "message" => "Missing required fields"]);
        }
    }
}
elseif ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    if (isset($_GET['action']) && $_GET['action'] == 'cancel') {
        if (!empty($data->appointment_id)) {
            if ($appointment->cancel($data->appointment_id)) {
                echo json_encode(["success" => true, "message" => "Appointment cancelled"]);
            } else {
                http_response_code(500);
                echo json_encode(["success" => false, "message" => "Unable to cancel appointment"]);
            }
        } else {
            http_response_code(400);
            echo json_encode(["success" => false, "message" => "Missing appointment_id"]);
        }
    }
}
?>