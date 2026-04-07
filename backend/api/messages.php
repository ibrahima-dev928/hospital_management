<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';
include_once '../models/Message.php';
include_once '../models/User.php';

$headers = apache_request_headers();
$token = isset($headers['Authorization']) ? str_replace('Bearer ', '', $headers['Authorization']) : null;

if (!$token) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Unauthorized"]);
    exit;
}

$database = new Database();
$db = $database->getConnection();
$message = new Message($db);
$userModel = new User($db);

$user_id = $_GET['user_id'] ?? null;

if (!$user_id) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Missing user_id"]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['conversations'])) {
        // Récupérer les conversations
        $stmt = $message->getConversations($user_id);
        $conversations = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $other_user_id = $row['other_user_id'];
            $userInfo = $userModel->getById($other_user_id);
            // Récupérer le dernier message
            $lastMsgStmt = $message->getMessages($user_id, $other_user_id);
            $lastMsg = null;
            while ($msg = $lastMsgStmt->fetch(PDO::FETCH_ASSOC)) {
                $lastMsg = $msg;
            }
            $conversations[] = [
                'other_user_id' => $other_user_id,
                'other_user_name' => $userInfo['name'],
                'other_user_specialty' => $userInfo['specialization'] ?? '',
                'last_message' => $lastMsg,
                'unread_count' => (int)$row['unread_count']
            ];
        }
        echo json_encode(["success" => true, "data" => $conversations]);
    }
    elseif (isset($_GET['other_user_id'])) {
        $other_user_id = $_GET['other_user_id'];
        $stmt = $message->getMessages($user_id, $other_user_id);
        $messages = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $row['id'] = (int)$row['id'];
            $row['is_read'] = (bool)$row['is_read'];
            $messages[] = $row;
        }
        // Marquer comme lus
        $message->markAsRead($user_id, $other_user_id);
        echo json_encode(["success" => true, "data" => $messages]);
    }
}
elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    if (!empty($data->receiver_id) && !empty($data->message)) {
        $message->sender_id = $user_id;
        $message->receiver_id = $data->receiver_id;
        $message->message = $data->message;
        if ($message->send()) {
            // Récupérer les noms pour la réponse
            $sender = $userModel->getById($user_id);
            $receiver = $userModel->getById($data->receiver_id);
            echo json_encode([
                "success" => true,
                "message" => "Message sent",
                "data" => [
                    "id" => $message->id,
                    "sender_id" => $user_id,
                    "sender_name" => $sender['name'],
                    "receiver_id" => $data->receiver_id,
                    "receiver_name" => $receiver['name'],
                    "message" => $data->message,
                    "created_at" => date('Y-m-d H:i:s'),
                    "is_read" => false
                ]
            ]);
        } else {
            http_response_code(500);
            echo json_encode(["success" => false, "message" => "Unable to send message"]);
        }
    } else {
        http_response_code(400);
        echo json_encode(["success" => false, "message" => "Missing required fields"]);
    }
}
?>