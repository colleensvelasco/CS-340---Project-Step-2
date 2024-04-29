/* CREATES FINDING DORY DENTAL TABLES */

/* CREATES SPECIALTIES TABLE */
CREATE TABLE Specialties (
    specialtyID int AUTO_INCREMENT UNIQUE NOT NULL,
    specialtyName VARCHAR(50) NOT NULL,
    PRIMARY KEY (specialtyID)
);

/* CREATES PROVIDERS TABLE */
CREATE TABLE Providers (
    providerID int AUTO_INCREMENT UNIQUE NOT NULL,
    name VARCHAR(50) NOT NULL,
    specialtyID int AUTO_INCREMENT UNIQUE NOT NULL,
    PRIMARY KEY (providerID),
    FOREIGN KEY (specialtyID) REFERENCES Specialties(specialtyID)
);

/* CREATES PATIENTS TABLE */
CREATE TABLE Patients (
    patientID int AUTO_INCREMENT UNIQUE NOT NULL,
    patientName VARCHAR(50) NOT NULL,
    birthDate date NOT NULL,
    email VARCHAR(50) NOT NULL,
    providerID int AUTO_INCREMENT UNIQUE NOT NULL,
    PRIMARY KEY (patientID),
    FOREIGN KEY (providerID) REFERENCES Providers(providerID)
);

/* CREATES TREATMENTORDERS TABLE */
CREATE TABLE TreatmentOrders (
    treatmentOrderID int AUTO_INCREMENT UNIQUE NOT NULL,
    patientID int AUTO_INCREMENT UNIQUE NOT NULL,
    totalCost int NOT NULL,
    PRIMARY KEY (treatmentOrderID),
    FOREIGN KEY (patientID) REFERENCES Patients(patientID)
);


/* CREATES TREATMENTS TABLE */
CREATE TABLE Treatments (
    treatmentID int AUTO_INCREMENT UNIQUE NOT NULL, 
    treatmentName VARCHAR(50) NOT NULL,
    treatmentDesc VARCHAR(50) NOT NULL,
    cost int NOT NULL,
    PRIMARY KEY (treatmentID),
    FOREIGN KEY (treatment)
);


/* CREATES TREATMENTS_TREATMENTORDERS TABLE */
