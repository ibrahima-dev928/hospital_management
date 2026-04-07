<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';
include_once '../models/User.php';

$database = new Database();
$db = $database->getConnection();
$user = new User($db);

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $user->getDoctors();
    $doctors = [];
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $row['id'] = (int)$row['id'];
        $row['experience'] = (int)$row['experience'];
        $row['rating'] = (float)$row['rating'];
        $doctors[] = $row;
    }
    echo json_encode(["success" => true, "data" => $doctors]);
}
?>