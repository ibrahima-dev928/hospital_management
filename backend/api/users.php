<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, PUT");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';
include_once '../models/User.php';
include_once '../middleware/auth.php';

$userData = authenticate();
$database = new Database();
$db = $database->getConnection();
$user = new User($db);

$request_method = $_SERVER["REQUEST_METHOD"];

if ($request_method == 'GET') {
    if (isset($_GET['id'])) {
        // Profil d'un utilisateur spécifique
        $profile = $user->getById($_GET['id']);
        if ($profile) {
            echo json_encode(['success' => true, 'data' => $profile]);
        } else {
            http_response_code(404);
            echo json_encode(['success' => false, 'message' => 'User not found']);
        }
    } elseif (isset($_GET['doctors'])) {
        // Liste des docteurs
        $doctors = $user->getDoctors();
        echo json_encode(['success' => true, 'data' => $doctors]);
    } else {
        // Mon profil
        $profile = $user->getById($userData['id']);
        echo json_encode(['success' => true, 'data' => $profile]);
    }
} elseif ($request_method == 'PUT') {
    // Mettre à jour mon profil
    $data = json_decode(file_get_contents("php://input"), true);
    if ($user->updateProfile($userData['id'], $data)) {
        echo json_encode(['success' => true, 'message' => 'Profile updated']);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Update failed']);
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>