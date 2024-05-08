-- DATA MANIPULATION QUERIES

---- PATIENTS ----

-- SELECT - Show all patients 
SELECT patientID, patientName, birthDate, email, 
    Providers.name AS assignedProvider
    FROM Patients
    INNER JOIN Providers 
    ON assignedProvider = Providers.providerID

-- Provider Dropdown (gets all providerIDs and names to populate provider dropdown) when adding
-- new Patient
SELECT providerID, name FROM Providers

-- CREATE - Adds new patients 
INSERT INTO Patients (patientName, birthDate, email, assignedProvider)
    VALUES (:patientName, :birthDateInput, :emailInput, :assignedProvider_id_from_dropdown_Input)

-- DELETE - Deletes a patient
DELETE FROM Patients WHERE patientID = :patient_ID_selected_from_browse_patients_page

-- UPDATE - Updates a patient
SELECT patientID, patientName, birthDate, email, assignedProvider
    FROM Patients
    WHERE patientID = :patient_ID_selected_from_browse_patients_page

-- SAVE -> Updates Patient Record
UPDATE Patients
    SET patientName = :patientNameInput, birthDate = :birthDateInput, 
        email = :emailInput, assignedProvider = :assignedProvider_id_from_dropdown_Input
    WHERE patientID = :patient_ID_from_update_form



---- SPECIALTIES ---- 

-- SELECT - Show all specialties
SELECT specialtyID, specialtyName FROM Specialties 

-- CREATE - Add a new specialty
INSERT INTO Specialties (specialtyName)
    VALUES (:specialtyName)



---- PROVIDERS ----

-- SELECT - Show all providers 
SELECT providerID, name, 
    Specialties.specialtyName AS dentalSpecialty
    FROM Providers
    INNER JOIN Specialties
    ON dentalSpecialty = Specialties.specialtyID 

-- Specialty Dropdown (gets all specialtyIDs and specialtyNames)
SELECT specialtyID, specialtyName FROM Specialties

-- CREATE - Adds new provider
INSERT INTO Providers (name, dentalSpecialty)
    VALUES (:name, :dentalSpecialty_id_from_dropdown_Input)



---- TREATMENTS ----

-- SELECT - Show all treatments
SELECT treatmentID, treatmentName, treatmentDesc, cost FROM Treatments

-- CREATE - Adds new treatment
INSERT INTO Treatments (treatmentName, treatmentDesc, cost)
    VALUES (:treatmentName, :treatmentDesc, :cost)



---- TREATMENT ORDERS ----


