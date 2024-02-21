# Employee Churn Data Cleaning

USE employee_churn_analysis;

SELECT * FROM employee_churn_info;

#1.Identifying the columns with the blanks, followed by the replacement of the blank values

-- Branch blanks and nulls replaced with Unknown
UPDATE employee_churn_info
SET Branch = 'Unknown'
WHERE Branch IS NULL OR Branch = '';

-- Tenure blanks and nulls replaced with 0, since for some of the inisghts I will be doing these wont matter
UPDATE employee_churn_info
SET Tenure = 0
WHERE Tenure IS NULL OR Tenure = '';

-- Here we have identified a blank Employee ID

SELECT *  
FROM employee_churn_info
WHERE EmployeeID IS NULL OR EmployeeID =  '';


-- Here we have identified a blank Employee ID and will remove it
SELECT *  
FROM employee_churn_info
WHERE EmployeeID IS NULL OR EmployeeID =  '';

DELETE FROM employee_churn_info
WHERE EmployeeID IS NULL OR EmployeeID =  '';



-- currently the values for OverTime were True and NULL values, so decided to replace True with Yes and NULLS with No
SELECT DISTINCT(OverTime)
FROM employee_churn_info;

UPDATE employee_churn_info
	SET Overtime = CASE 
				 WHEN OverTime = 'TRUE' THEN  'Yes'
                 ELSE 'No'
	END
WHERE OverTime IS NULL or OverTime = '' or OverTime = 'True';	

-- Years Since Promotion. There are lot of employees that havent been promoted so decided to update the values to 0

UPDATE employee_churn_info
SET YearsSincePromotion = 0
WHERE YearsSincePromotion IS NULL OR YearsSincePromotion = '';

#2. Standardizing the Data
SELECT * FROM employee_churn_info;

-- Could see that we had some decimals that were not rounded so updated that here with the Round function

UPDATE employee_churn_info
SET WorkLifeBalance = Round(WorkLifeBalance,1)
;

UPDATE employee_churn_info
SET PerformanceRating = Round(PerformanceRating,1)
;

UPDATE employee_churn_info
SET EnvironmentSatisfaction = Round(EnvironmentSatisfaction,1)
;

-- found some null values and changed them 0.
SELECT * FROM employee_churn_info
WHERE Traininghours IS NULL;

UPDATE employee_churn_info
SET Traininghours = 0
WHERE Traininghours IS NULL OR Traininghours = '';

SELECT * FROM employee_churn_info
WHERE NumProjects IS NULL; 

UPDATE employee_churn_info
SET NumProjects = 0
WHERE NumProjects IS NULL or NumProjects ='';



#3. To help with interpretability, I replaced the int values in  JobSatisFaction, WorkLifeBalance, PerformanceRating and EnvironmentSatisfaction with VARCHAR values
ALTER TABLE employee_churn_info
MODIFY COLUMN JobSatisfaction VARCHAR(20);

UPDATE employee_churn_info
SET JobSatisfaction =
    CASE
        WHEN ROUND(JobSatisfaction) = 1 THEN 'Very Dissatisfied'
        WHEN ROUND(JobSatisfaction) = 2 THEN 'Dissatisfied'
        WHEN ROUND(JobSatisfaction) = 3 THEN 'Neutral'
        WHEN ROUND(JobSatisfaction) = 4 THEN 'Satisfied'
        WHEN ROUND(JobSatisfaction) = 5 THEN 'Very Satisfied'
        ELSE 'No Rating' 
    END;
    
    -- Alter the data type of the existing column
ALTER TABLE employee_churn_info
MODIFY COLUMN WorkLifeBalance VARCHAR(20);


UPDATE employee_churn_info
SET WorkLifeBalance =
    CASE
        WHEN Round(WorkLifeBalance) = 1 THEN 'Poor'
        WHEN Round(WorkLifeBalance)= 2 THEN 'Fair'
        WHEN Round(WorkLifeBalance) = 3 THEN 'Average'
        WHEN Round(WorkLifeBalance) = 4 THEN 'Good'
        WHEN Round(WorkLifeBalance) = 5 THEN 'Excellent'
        ELSE 'No Rating' 
    END;


ALTER TABLE employee_churn_info
MODIFY COLUMN EnvironmentSatisfaction VARCHAR(20);


UPDATE employee_churn_info
SET EnvironmentSatisfaction =
    CASE
        WHEN ROUND(EnvironmentSatisfaction) = 1 THEN 'Very Dissatisfied'
        WHEN ROUND(EnvironmentSatisfaction) = 2 THEN 'Dissatisfied'
        WHEN ROUND(EnvironmentSatisfaction) = 3 THEN 'Neutral'
        WHEN ROUND(EnvironmentSatisfaction) = 4 THEN 'Satisfied'
        WHEN ROUND(EnvironmentSatisfaction) = 5 THEN 'Highly Satisfied'
        ELSE 'No Rating'  
    END;
    
    ALTER TABLE employee_churn_info
MODIFY COLUMN PerformanceRating VARCHAR(20);

UPDATE employee_churn_info
SET PerformanceRating =
    CASE
        WHEN Round(PerformanceRating) = 1 THEN 'Poor'
        WHEN Round(PerformanceRating)= 2 THEN 'Fair'
        WHEN Round(PerformanceRating) = 3 THEN 'Average'
        WHEN Round(PerformanceRating) = 4 THEN 'Good'
        WHEN Round(PerformanceRating) = 5 THEN 'Excellent'
        ELSE 'No Rating' 
    END;

    
    

SELECT DISTINCT Branch
FROM employee_churn_info;

SELECT * FROM employee_churn_info;






