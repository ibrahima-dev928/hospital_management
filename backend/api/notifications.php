<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';
include_once '../middleware/auth.php';

$userData = authenticate();

$request_method = $_SERVER["REQUEST_METHOD"];
$data = json_decode(file_get_contents("php://input"));

if ($request_method == 'POST') {
    if (isset($_GET['action']) && $_GET['action'] == 'register-token') {
        // Enregistrer le token FCM pour l'utilisateur
        if (!empty($data->fcm_token)) {
            $database = new Database();
            $db = $database->getConnection();
            $query = "UPDATE users SET fcm_token = :fcm_token WHERE id = :id";
            $stmt = $db->prepare($query);
            $stmt->bindParam(':fcm_token', $data->fcm_token);
            $stmt->bindParam(':id', $userData['id']);
            if ($stmt->execute()) {
                echo json_encode(['success' => true, 'message' => 'Token registered']);
            } else {
                http_response_code(500);
                echo json_encode(['success' => false, 'message' => 'Failed to register token']);
            }
        } else {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'fcm_token required']);
        }
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>