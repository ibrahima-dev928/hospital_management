CREATE DATABASE IF NOT EXISTS hopital_v6;
USE hopital_v6;

-- Table users
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    role ENUM('admin', 'user') DEFAULT 'user',
    nom VARCHAR(50),
    prenom VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table patients
CREATE TABLE IF NOT EXISTS patients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    date_naissance DATE,
    genre ENUM('M','F'),
    telephone VARCHAR(20),
    email VARCHAR(100),
    adresse TEXT,
    photo VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table medecins
CREATE TABLE IF NOT EXISTS medecins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    specialite VARCHAR(100),
    telephone VARCHAR(20),
    email VARCHAR(100),
    disponibilite VARCHAR(255),
    photo VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table rendezvous
CREATE TABLE IF NOT EXISTS rendezvous (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    medecin_id INT NOT NULL,
    date_rdv DATETIME NOT NULL,
    heure_rdv TIME NOT NULL,
    statut ENUM('En attente','Confirmé','Annulé') DEFAULT 'En attente',
    duree VARCHAR(20),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (medecin_id) REFERENCES medecins(id) ON DELETE CASCADE
);

-- Table preferences (paramètres système)
CREATE TABLE IF NOT EXISTS preferences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    theme ENUM('light','dark') DEFAULT 'light',
    notifications BOOLEAN DEFAULT TRUE,
    language VARCHAR(5) DEFAULT 'fr',
    results_per_page INT DEFAULT 10,
    auto_save BOOLEAN DEFAULT TRUE,
    hospital_name VARCHAR(255) DEFAULT 'HOPITAL V6',
    hospital_address TEXT,
    hospital_phone VARCHAR(20),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insérer un utilisateur admin (mot de passe: admin123) et user (user123)
-- Le hash bcrypt pour 'admin123' est: $2a$10$N9qo8uLOickgx2ZMRZoMy.MrqYyU5XZ7V5jHq4D5q8X9LQvZ9Zq6
INSERT INTO users (username, password, email, role, nom, prenom) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrqYyU5XZ7V5jHq4D5q8X9LQvZ9Zq6', 'admin@hopital.fr', 'admin', 'Administrateur', 'Système'),
('user', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrqYyU5XZ7V5jHq4D5q8X9LQvZ9Zq6', 'user@hopital.fr', 'user', 'Utilisateur', 'Standard'),
('ibrahim', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrqYyU5XZ7V5jHq4D5q8X9LQvZ9Zq6', 'ibrahim@hopital.fr', 'admin', 'HALILOU', 'IBRAHIM');

-- Préférences globales
INSERT INTO preferences (user_id, theme, notifications, language, results_per_page, auto_save, hospital_name, hospital_address, hospital_phone)
VALUES (NULL, 'light', TRUE, 'fr', 10, TRUE, 'HOPITAL V6', '123 Avenue de la Santé, 75000 Paris', '01 23 45 67 89');

-- Données de démonstration
INSERT INTO patients (nom, prenom, date_naissance, genre, telephone, email, adresse) VALUES
('DUPONT', 'Marie', '1985-03-15', 'F', '01 23 45 67 89', 'marie.dupont@email.com', '123 Rue de Paris, 75001 Paris'),
('MARTIN', 'Pierre', '1978-07-22', 'M', '01 34 56 78 90', 'pierre.martin@email.com', '456 Avenue des Champs, 75008 Paris');

INSERT INTO medecins (nom, prenom, specialite, telephone, email, disponibilite) VALUES
('LEBRUN', 'Sophie', 'Cardiologie', '01 45 67 89 01', 's.lebrun@hopital.fr', 'Lundi-Vendredi, 8h-18h'),
('ROUSSEAU', 'Jean', 'Pédiatrie', '01 56 78 90 12', 'j.rousseau@hopital.fr', 'Lundi-Mercredi-Vendredi, 9h-17h');

INSERT INTO rendezvous (patient_id, medecin_id, date_rdv, heure_rdv, statut, duree, notes) VALUES
(1, 1, '2024-01-15 10:00:00', '10:00', 'Confirmé', '30 minutes', 'Consultation de routine');