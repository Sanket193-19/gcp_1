CREATE TABLE IF NOT EXISTS `project-4dd17051-6b0d-4014-b11.gold_dataset.provider_charge_summary` (
    Provider_Name STRING,
    Dept_Name STRING,
    Amount FLOAT64
);

# truncate table
TRUNCATE TABLE `project-4dd17051-6b0d-4014-b11.gold_dataset.provider_charge_summary`;

# insert data
INSERT INTO `project-4dd17051-6b0d-4014-b11.gold_dataset.provider_charge_summary`
SELECT 
    CONCAT(p.firstname, ' ', p.LastName) AS Provider_Name,
    d.Name AS Dept_Name,
    SUM(t.Amount) AS Amount
FROM `project-4dd17051-6b0d-4014-b11.silver_dataset.transactions` t
LEFT JOIN `project-4dd17051-6b0d-4014-b11.silver_dataset.providers` p 
    ON SPLIT(p.ProviderID, "-")[SAFE_OFFSET(1)] = t.ProviderID
LEFT JOIN `project-4dd17051-6b0d-4014-b11.silver_dataset.departments` d 
    ON SPLIT(d.Dept_Id, "-")[SAFE_OFFSET(0)] = p.DeptID
WHERE t.is_quarantined = FALSE AND d.Name IS NOT NULL
GROUP BY Provider_Name, Dept_Name;