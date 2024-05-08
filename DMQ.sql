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
    VALUES (:patientNameInput, :birthDateInput, :emailInput, :assignedProvider_id_from_dropdown_Input)

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
    VALUES (:specialtyNameInput)



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
    VALUES (:nameInput, :dentalSpecialty_id_from_dropdown_Input)



---- TREATMENTS ----

-- SELECT - Show all treatments
SELECT treatmentID, treatmentName, treatmentDesc, cost FROM Treatments

-- CREATE - Adds new treatment
INSERT INTO Treatments (treatmentName, treatmentDesc, cost)
    VALUES (:treatmentNameInput, :treatmentDescInput, :costInput)



---- TREATMENT ORDERS AND TREATMENT_TREATMENTORDERS ----

-- SELECT - Show all treatment orders
SELECT treatmentOrderID, patientID, dateTx, totalCost FROM TreatmentOrders

-- SELECT - Show all ordered treatments
SELECT treatmentOrderID, treatmentID FROM Treatments_TreatmentOrders

-- CREATE TREATMENT ORDER WITHOUT TREATMENTS - Adds treatment order without treatments
-- Total Cost is 0
INSERT INTO TreatmentOrders (patientID, dateTx, totalCost)
    VALUES (:patientIDInput, :dateTxInput, 0)

-- Treatment Dropdown (gets all treatmentIDs and names to populate provider dropdown) when adding
-- new treatment_treatmentorders (new treatments to specified treatment order)
SELECT treatmentID, treatmentName FROM Treatments

-- CREATE TREATMENT_TREATMENTORDER - Adds treatment order with treatments
INSERT INTO Treatments_TreatmentOrders (treatmentOrderID, treatmentID)
    VALUES (:treatmentOrderIDgenerated, :treatment_ID_from_dropdown_Input)

-- UPDATE TREATMENT_TREATMENTORDER - Updates treatment on treatment order
SELECT treatmentOrderID, treatmentID
    FROM Treatments_TreatmentOrders
    WHERE treatmentOrderID = :treatmentOrder_ID_selected_from_browse_ordertx_page AND 
        treatmentID = :treatment_ID_selected_from_browse_ordertx_page

-- SAVE -> Updates TREATMENT_TREATMENTORDER
UPDATE Treatments_TreatmentOrders
    SET treatmentID = :treatment_ID_from_dropdown_Input
    WHERE treatmentOrderID = :treatmentOrder_ID_selected_from_browse_ordertx_page AND 
        treatmentID = :treatment_ID_selected_from_browse_ordertx_page

-- DELETE TREATMENT_TREATMENTORDER
DELETE FROM Treatments_TreatmentOrders WHERE treatmentOrderID = :treatmentOrder_ID_selected_from_browse_ordertx_page AND 
        treatmentID = :treatment_ID_selected_from_browse_ordertx_page

