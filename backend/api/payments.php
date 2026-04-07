<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once '../vendor/autoload.php'; // pour Stripe

include_once '../config/database.php';
include_once '../models/Payment.php';
include_once '../models/User.php';
include_once '../middleware/auth.php';

$userData = authenticate();

\Stripe\Stripe::setApiKey('sk_test_YOUR_STRIPE_SECRET_KEY'); // À remplacer

$database = new Database();
$db = $database->getConnection();
$paymentModel = new Payment($db);
$userModel = new User($db);

$request_method = $_SERVER["REQUEST_METHOD"];
$data = json_decode(file_get_contents("php://input"));

if ($request_method == 'POST') {
    if (isset($_GET['action']) && $_GET['action'] == 'create-intent') {
        // Créer un PaymentIntent Stripe
        try {
            $intent = \Stripe\PaymentIntent::create([
                'amount' => $data->amount * 100, // en cents
                'currency' => 'usd',
                'metadata' => [
                    'user_id' => $userData['id'],
                    'appointment_id' => $data->appointment_id ?? ''
                ]
            ]);
            echo json_encode(['success' => true, 'client_secret' => $intent->client_secret]);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['success' => false, 'message' => $e->getMessage()]);
        }
    } elseif (isset($_GET['action']) && $_GET['action'] == 'confirm') {
        // Confirmer le paiement et enregistrer en base
        if (!empty($data->payment_intent_id) && !empty($data->appointment_id) && !empty($data->amount)) {
            // Ici, vous pouvez vérifier le statut du PaymentIntent via Stripe API
            $paymentModel->user_id = $userData['id'];
            $paymentModel->appointment_id = $data->appointment_id;
            $paymentModel->amount = $data->amount;
            $paymentModel->status = 'succeeded';
            $paymentModel->stripe_payment_intent_id = $data->payment_intent_id;
            if ($paymentModel->create()) {
                // Ajouter au portefeuille ? ou déduire ? selon logique
                // Exemple : créditer le médecin ou débiter le patient
                // Ici on suppose que le patient paie, donc on ne touche pas au wallet
                echo json_encode(['success' => true, 'message' => 'Payment recorded']);
            } else {
                http_response_code(500);
                echo json_encode(['success' => false, 'message' => 'Failed to record payment']);
            }
        } else {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Missing fields']);
        }
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>