CREATE TABLE IF NOT EXISTS `project-4dd17051-6b0d-4014-b11.gold_dataset.patient_history` (
    Patient_Key STRING,
    FirstName STRING,
    LastName STRING,
    Gender STRING,
    DOB DATE,
    Address STRING,
    EncounterDate DATE,
    EncounterType STRING,
    Transaction_Key STRING,
    VisitDate DATE,
    ServiceDate DATE,
    BilledAmount FLOAT64,
    PaidAmount FLOAT64,
    ClaimStatus STRING,
    ClaimAmount STRING,
    ClaimPaidAmount STRING,
    PayorType STRING
);


# TRUNCATE TABLE
TRUNCATE TABLE `project-4dd17051-6b0d-4014-b11.gold_dataset.patient_history`;
INSERT INTO `project-4dd17051-6b0d-4014-b11.gold_dataset.patient_history`
SELECT 
    p.Patient_Key,
    p.FirstName,
    p.LastName,
    p.Gender,
    p.DOB,
    p.Address,
    e.EncounterDate,
    e.EncounterType,
    t.Transaction_Key,
    t.VisitDate,
    t.ServiceDate,
    t.Amount AS BilledAmount,
    t.PaidAmount,
    c.ClaimStatus,
    c.ClaimAmount,
    c.PaidAmount AS ClaimPaidAmount,
    c.PayorType
FROM `project-4dd17051-6b0d-4014-b11.silver_dataset.patients` p
LEFT JOIN `project-4dd17051-6b0d-4014-b11.silver_dataset.encounters` e 
    ON SPLIT(p.Patient_Key, '-')[OFFSET(0)] || '-' || SPLIT(p.Patient_Key, '-')[OFFSET(1)] = e.PatientID
LEFT JOIN `project-4dd17051-6b0d-4014-b11.silver_dataset.transactions` t 
    ON SPLIT(p.Patient_Key, '-')[OFFSET(0)] || '-' || SPLIT(p.Patient_Key, '-')[OFFSET(1)] = t.PatientID
LEFT JOIN `project-4dd17051-6b0d-4014-b11.silver_dataset.claims` c 
    ON t.SRC_TransactionID = c.TransactionID
WHERE p.is_current = TRUE;
