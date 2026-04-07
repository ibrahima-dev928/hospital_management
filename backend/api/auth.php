<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';
include_once '../models/User.php';

$database = new Database();
$db = $database->getConnection();
$user = new User($db);

$data = json_decode(file_get_contents("php://input"));

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_GET['action'])) {
        switch($_GET['action']) {
            case 'login':
                if (!empty($data->email) && !empty($data->password)) {
                    $user->email = $data->email;
                    $user->password = $data->password;
                    
                    $userData = $user->login();
                    if ($userData) {
                        // Générer un token simple (en production, utilisez JWT)
                        $token = bin2hex(random_bytes(16));
                        // Stockez le token quelque part (table user_tokens) pour validation
                        echo json_encode([
                            "success" => true,
                            "message" => "Login successful",
                            "user" => [
                                "id" => $userData['id'],
                                "name" => $userData['name'],
                                "email" => $userData['email'],
                                "phone" => $userData['phone'],
                                "user_type" => $userData['user_type'],
                                "wallet_balance" => $userData['wallet_balance']
                            ],
                            "token" => $token
                        ]);
                    } else {
                        http_response_code(401);
                        echo json_encode(["success" => false, "message" => "Invalid credentials"]);
                    }
                }
                break;
                
            case 'register':
                if (!empty($data->name) && !empty($data->email) && !empty($data->password)) {
                    $user->name = $data->name;
                    $user->email = $data->email;
                    $user->password = $data->password;
                    $user->phone = $data->phone ?? '';
                    $user->user_type = $data->user_type ?? 'patient';
                    
                    $userId = $user->create();
                    if ($userId) {
                        echo json_encode([
                            "success" => true,
                            "message" => "User created successfully",
                            "user_id" => $userId
                        ]);
                    } else {
                        http_response_code(500);
                        echo json_encode(["success" => false, "message" => "Unable to create user"]);
                    }
                }
                break;
        }
    }
}
?>