<?php
require_once 'config/jwt.php';

class AuthMiddleware {
    public static function authenticate() {
        $headers = getallheaders();
        if(!isset($headers['Authorization'])) {
            http_response_code(401);
            echo json_encode(['success' => false, 'message' => 'No token provided']);
            exit;
        }

        $authHeader = $headers['Authorization'];
        $token = str_replace('Bearer ', '', $authHeader);
        $payload = JWT::decode($token);

        if(!$payload) {
            http_response_code(401);
            echo json_encode(['success' => false, 'message' => 'Invalid token']);
            exit;
        }

        return $payload; // contient user_id, email, user_type
    }
}
?>