/* PROJECT GROUP 52 - TEAM FINDING DORY 

Team Members:
Michelle Rollberg
Colleen S. H. Velasco

*/


SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

/* CREATES FINDING DORY DENTAL TABLES AND INSERT SAMPLE DATA */

/* CREATES AND INSERTS INTO SPECIALTIES TABLE */
CREATE OR REPLACE TABLE Specialties (
    specialtyID int UNIQUE NOT NULL AUTO_INCREMENT PRIMARY KEY,
    specialtyName VARCHAR(50) NOT NULL
);

INSERT INTO Specialties (specialtyName) 
    VALUES ('General'), ('Orthodontics'), ('Endodontics'), ('Periodontics');



/* CREATES AND INSERTS INTO PROVIDERS TABLE */
CREATE OR REPLACE TABLE Providers (
    providerID int UNIQUE NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    specialtyID int NOT NULL,
    FOREIGN KEY (specialtyID) REFERENCES Specialties(specialtyID)
);

INSERT INTO Providers (name, specialtyID)
    VALUES ('Dr. Robert Green', (SELECT specialtyID from Specialties where specialtyName = 'General')),
    ('Dr. Liz Dee', (SELECT specialtyID from Specialties where specialtyName = 'General')),
    ('Dr. Sam Kim', (SELECT specialtyID from Specialties where specialtyName = 'Periodontics')),
    ('Dr. Ana Garcia', (SELECT specialtyID from Specialties where specialtyName = 'Endodontics'));



/* CREATES AND INSERTS INTO PATIENTS TABLE */
CREATE OR REPLACE TABLE Patients (
    patientID int UNIQUE NOT NULL AUTO_INCREMENT PRIMARY KEY,
    patientName VARCHAR(50) NOT NULL,
    birthDate date NOT NULL,
    email VARCHAR(50) NOT NULL,
    providerID int,
    FOREIGN KEY (providerID) REFERENCES Providers(providerID)
);

INSERT INTO Patients (patientName, birthDate, email, providerID) 
    VALUES ('Abby Lee', '19960805', 'abbylee@gmail.com', NULL),
    ('Greg Bill', '19691012', 'gbill@yahoo.com', (SELECT providerID from Providers where name = 'Dr. Robert Green')),
    ('Hannah Williams', '20000124','hills@gmail.com', (SELECT providerID from Providers where name = 'Dr. Sam Kim')),
    ('Alex Cruz', '19900920', 'cruzesa@yahoo.com', (SELECT providerID from Providers where name = 'Dr. Robert Green'));



/* CREATES AND INSERTS INTO TREATMENTS TABLE */
CREATE OR REPLACE TABLE Treatments (
    treatmentID int UNIQUE NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    treatmentName VARCHAR(50) NOT NULL,
    treatmentDesc VARCHAR(50) NOT NULL,
    cost int NOT NULL
);

INSERT INTO Treatments (treatmentName, treatmentDesc, cost)
    VALUES ('prophy', 'Preventative, yearly cleaning', 125),
    ('exam', 'Preventative, yearly checkup', 25),
    ('filling', 'Treatment for hole or decay of tooth', 175),
    ('root canal', 'Treatment to repair and save infected and damaged tooth', 1000);



/* CREATES AND INSERTS INTO TREATMENTORDERS TABLE */
CREATE OR REPLACE TABLE TreatmentOrders (
    treatmentOrderID int UNIQUE NOT NULL AUTO_INCREMENT PRIMARY KEY,
    patientID int NOT NULL,
    dateTx date NOT NULL,
    totalCost int NOT NULL,
    FOREIGN KEY (patientID) REFERENCES Patients(patientID) ON DELETE CASCADE
);
-- if patientID is deleted from Patients, is deleted from TreatmentOrders table

INSERT INTO TreatmentOrders (patientID, dateTx, totalCost) 
    VALUES ((SELECT patientID from Patients where patientName = 'Abby Lee'), '20240821', 150), 
    ((SELECT patientID from Patients where patientName = 'Greg Bill'), '20240810', 175),
    ((SELECT patientID from Patients where patientName = 'Hannah Williams'), '20240811', 1000),
    ((SELECT patientID from Patients where patientName = 'Alex Cruz'), '20240918', 25);



/* CREATES AND INSERTS INTO TREATMENTS_TREATMENTORDERS TABLE */
CREATE OR REPLACE TABLE Treatments_TreatmentOrders (
    treatmentOrderID int NOT NULL,
    treatmentID int NOT NULL,
    FOREIGN KEY (treatmentOrderID) REFERENCES TreatmentOrders(treatmentOrderID) ON DELETE CASCADE,
    FOREIGN KEY (treatmentID) REFERENCES Treatments(treatmentID) ON DELETE CASCADE,
    PRIMARY KEY (treatmentOrderID, treatmentID)
);
-- if treatmentOrderID is deleted from TreatmentOrders, is deleted from Treatments_TreatmentOrders table
-- if treatmentID is deleted from Treatments, is deleted from Treatments_TreatmentOrders table


INSERT INTO Treatments_TreatmentOrders (treatmentOrderID, treatmentID)
    VALUES ((SELECT treatmentOrderID from TreatmentOrders where patientID = 1 and dateTx = '20240821'), 
    (SELECT treatmentID from Treatments where treatmentName = 'prophy')),
    ((SELECT treatmentOrderID from TreatmentOrders where patientID = 1 and dateTx = '20240821'), (SELECT treatmentID from Treatments where treatmentName = 'exam')),
    ((SELECT treatmentOrderID from TreatmentOrders where patientID = 2 and dateTx = '20240810'), (SELECT treatmentID from Treatments where treatmentName = 'filling')),
    ((SELECT treatmentOrderID from TreatmentOrders where patientID = 3 and dateTx = '20240811'), (SELECT treatmentID from Treatments where treatmentName = 'root canal')),
    ((SELECT treatmentOrderID from TreatmentOrders where patientID = 4 and dateTx = '20240918'), (SELECT treatmentID from Treatments where treatmentName = 'exam'));




SET FOREIGN_KEY_CHECKS=1;
COMMIT;
