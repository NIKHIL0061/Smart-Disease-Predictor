
-- 1. CREATE DATABASE
-- ----------------------
CREATE DATABASE IF NOT EXISTS disease_predictor;
USE disease_predictor;

-- ----------------------
-- 2. CREATE TABLES
-- ----------------------

-- Symptoms Table
CREATE TABLE IF NOT EXISTS symptoms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Diseases Table
CREATE TABLE IF NOT EXISTS diseases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Disease Symptoms Table (linking table)
CREATE TABLE IF NOT EXISTS disease_symptoms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    disease_id INT,
    symptom_id INT,
    FOREIGN KEY (disease_id) REFERENCES diseases(id),
    FOREIGN KEY (symptom_id) REFERENCES symptoms(id)
);

-- Precautions Table
CREATE TABLE IF NOT EXISTS precautions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    disease_id INT,
    precaution VARCHAR(255),
    FOREIGN KEY (disease_id) REFERENCES diseases(id)
);

-- ----------------------
-- 3. CLEAR OLD DATA
-- ----------------------
SET SQL_SAFE_UPDATES = 0;

DELETE FROM disease_symptoms;
DELETE FROM precautions;
DELETE FROM diseases;
DELETE FROM symptoms;

ALTER TABLE disease_symptoms AUTO_INCREMENT = 1;
ALTER TABLE precautions AUTO_INCREMENT = 1;
ALTER TABLE diseases AUTO_INCREMENT = 1;
ALTER TABLE symptoms AUTO_INCREMENT = 1;

SET SQL_SAFE_UPDATES = 1;

-- ----------------------
-- 4. INSERT SYMPTOMS
-- ----------------------
INSERT INTO symptoms (name) VALUES
('Fever'),
('Cough'),
('Headache'),
('Stomach Pain'),
('Itching'),
('Shortness of Breath'),
('Joint Pain'),
('Loss of Smell'),
('Vomiting'),
('Runny Nose'),
('Chest Pain'),
('Sneezing'),
('Loss of Taste'),
('Eye Redness'),
('Weakness'),
('Dry Skin');

-- ----------------------
-- 5. INSERT DISEASES
-- ----------------------
INSERT INTO diseases (name, description) VALUES
('Common Cold', 'A mild viral infection of the nose and throat causing sneezing, runny nose and sore throat.'),
('Flu (Influenza)', 'A contagious respiratory illness caused by influenza viruses with fever and body aches.'),
('Typhoid', 'A bacterial infection caused by Salmonella typhi, spread through contaminated food and water.'),
('Malaria', 'A mosquito-borne disease caused by Plasmodium parasites, common in tropical regions.'),
('Dengue', 'A viral infection spread by Aedes mosquitoes causing high fever and severe joint pain.'),
('Tuberculosis', 'A bacterial infection primarily affecting the lungs, spread through the air.'),
('Diabetes', 'A chronic condition where the body cannot properly regulate blood sugar levels.'),
('Chickenpox', 'A highly contagious viral infection causing an itchy blister-like rash on the body.'),
('Food Poisoning', 'Illness caused by eating contaminated food, leading to stomach and digestive issues.'),
('COVID-19', 'A respiratory illness caused by the SARS-CoV-2 virus with varied symptoms.');

-- ----------------------------------------
-- 6. LINK DISEASES TO SYMPTOMS
-- ----------------------------------------

-- Common Cold
INSERT INTO disease_symptoms (disease_id, symptom_id)
SELECT d.id, s.id FROM diseases d, symptoms s
WHERE d.name = 'Common Cold' AND s.name IN (
  'Cough', 'Runny Nose', 'Sneezing', 'Headache', 'Weakness'
);

-- Flu
INSERT INTO disease_symptoms (disease_id, symptom_id)
SELECT d.id, s.id FROM diseases d, symptoms s
WHERE d.name = 'Flu (Influenza)' AND s.name IN (
  'Fever', 'Cough', 'Headache', 'Weakness', 'Chest Pain', 'Runny Nose'
);

-- Typhoid
INSERT INTO disease_symptoms (disease_id, symptom_id)
SELECT d.id, s.id FROM diseases d, symptoms s
WHERE d.name = 'Typhoid' AND s.name IN (
  'Fever', 'Headache', 'Stomach Pain', 'Vomiting', 'Weakness'
);

-- Malaria
INSERT INTO disease_symptoms (disease_id, symptom_id)
SELECT d.id, s.id FROM diseases d, symptoms s
WHERE d.name = 'Malaria' AND s.name IN (
  'Fever', 'Headache', 'Vomiting', 'Weakness', 'Joint Pain'
);

-- Dengue
INSERT INTO disease_symptoms (disease_id, symptom_id)
SELECT d.id, s.id FROM diseases d, symptoms s
WHERE d.name = 'Dengue' AND s.name IN (
  'Fever', 'Headache', 'Joint Pain', 'Eye Redness', 'Vomiting', 'Weakness'
);

-- Tuberculosis
INSERT INTO disease_symptoms (disease_id, symptom_id)
SELECT d.id, s.id FROM diseases d, symptoms s
WHERE d.name = 'Tuberculosis' AND s.name IN (
  'Cough', 'Fever', 'Chest Pain', 'Shortness of Breath', 'Weakness'
);

-- Diabetes
INSERT INTO disease_symptoms (disease_id, symptom_id)
SELECT d.id, s.id FROM diseases d, symptoms s
WHERE d.name = 'Diabetes' AND s.name IN (
  'Weakness', 'Dry Skin', 'Headache', 'Itching'
);

-- Chickenpox
INSERT INTO disease_symptoms (disease_id, symptom_id)
SELECT d.id, s.id FROM diseases d, symptoms s
WHERE d.name = 'Chickenpox' AND s.name IN (
  'Fever', 'Itching', 'Dry Skin', 'Weakness', 'Headache'
);

-- Food Poisoning
INSERT INTO disease_symptoms (disease_id, symptom_id)
SELECT d.id, s.id FROM diseases d, symptoms s
WHERE d.name = 'Food Poisoning' AND s.name IN (
  'Vomiting', 'Stomach Pain', 'Weakness', 'Fever', 'Headache'
);

-- COVID-19
INSERT INTO disease_symptoms (disease_id, symptom_id)
SELECT d.id, s.id FROM diseases d, symptoms s
WHERE d.name = 'COVID-19' AND s.name IN (
  'Fever', 'Cough', 'Loss of Smell', 'Loss of Taste', 'Shortness of Breath', 'Weakness'
);

-- ----------------------
-- 7. INSERT PRECAUTIONS
-- ----------------------
INSERT INTO precautions (disease_id, precaution)
SELECT d.id, p.precaution FROM diseases d
JOIN (
  SELECT 'Common Cold' AS disease, 'Rest and stay hydrated' AS precaution UNION ALL
  SELECT 'Common Cold', 'Gargle with warm salt water' UNION ALL
  SELECT 'Common Cold', 'Use over-the-counter cold medicine' UNION ALL
  SELECT 'Common Cold', 'Use a humidifier at home' UNION ALL

  SELECT 'Flu (Influenza)', 'Get plenty of rest' UNION ALL
  SELECT 'Flu (Influenza)', 'Drink fluids to prevent dehydration' UNION ALL
  SELECT 'Flu (Influenza)', 'Take paracetamol for fever' UNION ALL
  SELECT 'Flu (Influenza)', 'Avoid close contact with others' UNION ALL

  SELECT 'Typhoid', 'Drink only boiled or bottled water' UNION ALL
  SELECT 'Typhoid', 'Eat freshly cooked food only' UNION ALL
  SELECT 'Typhoid', 'Take prescribed antibiotics' UNION ALL
  SELECT 'Typhoid', 'Get plenty of rest and stay hydrated' UNION ALL

  SELECT 'Malaria', 'Use mosquito nets while sleeping' UNION ALL
  SELECT 'Malaria', 'Apply mosquito repellent regularly' UNION ALL
  SELECT 'Malaria', 'Take prescribed antimalarial medication' UNION ALL
  SELECT 'Malaria', 'Wear long sleeves and pants outdoors' UNION ALL

  SELECT 'Dengue', 'Use mosquito repellent and nets' UNION ALL
  SELECT 'Dengue', 'Drink plenty of fluids and rest' UNION ALL
  SELECT 'Dengue', 'Use paracetamol for fever, avoid aspirin' UNION ALL
  SELECT 'Dengue', 'Monitor symptoms and visit doctor if worse' UNION ALL

  SELECT 'Tuberculosis', 'Complete the full course of antibiotics' UNION ALL
  SELECT 'Tuberculosis', 'Cover mouth when coughing or sneezing' UNION ALL
  SELECT 'Tuberculosis', 'Ensure good ventilation in living spaces' UNION ALL
  SELECT 'Tuberculosis', 'Avoid close contact with others until treated' UNION ALL

  SELECT 'Diabetes', 'Monitor blood sugar levels daily' UNION ALL
  SELECT 'Diabetes', 'Follow a low sugar balanced diet' UNION ALL
  SELECT 'Diabetes', 'Exercise regularly for at least 30 minutes' UNION ALL
  SELECT 'Diabetes', 'Take prescribed medication on time' UNION ALL

  SELECT 'Chickenpox', 'Avoid scratching the rash to prevent scars' UNION ALL
  SELECT 'Chickenpox', 'Apply calamine lotion to soothe itching' UNION ALL
  SELECT 'Chickenpox', 'Stay isolated to avoid spreading infection' UNION ALL
  SELECT 'Chickenpox', 'Keep nails short and hands clean' UNION ALL

  SELECT 'Food Poisoning', 'Drink plenty of water and ORS solution' UNION ALL
  SELECT 'Food Poisoning', 'Avoid solid food until vomiting stops' UNION ALL
  SELECT 'Food Poisoning', 'Rest and monitor symptoms carefully' UNION ALL
  SELECT 'Food Poisoning', 'See a doctor if symptoms last more than 2 days' UNION ALL

  SELECT 'COVID-19', 'Isolate yourself from others immediately' UNION ALL
  SELECT 'COVID-19', 'Wear a mask and maintain distance' UNION ALL
  SELECT 'COVID-19', 'Stay hydrated and rest completely' UNION ALL
  SELECT 'COVID-19', 'Monitor oxygen levels and seek help if low'
) p ON d.name = p.disease;

-- ----------------------
-- 8. VERIFY DATA
-- ----------------------
SELECT COUNT(*) AS total_diseases FROM diseases;
SELECT COUNT(*) AS total_symptoms FROM symptoms;
SELECT COUNT(*) AS total_precautions FROM precautions;
