# Employee Churn Data Exploration

USE employee_churn_analysis;

SELECT * FROM employee_churn_info;

#1. Churn Rate by Department: Data was gathered on the likelineess of each department to leave. 

SELECT
  Department,
  ROUND(AVG(CASE WHEN ChurnLikelihood = 'Highly Likely to Churn' THEN 1 ELSE 0 END)*100,1) AS ChurnRate_High,
  ROUND(AVG(CASE WHEN ChurnLikelihood = 'Moderately Likely to Churn' THEN 1 ELSE 0 END)*100,1) AS ChurnRate_Moderate,
  ROUND(AVG(CASE WHEN ChurnLikelihood = 'Slightly Likely to Churn' THEN 1 ELSE 0 END)*100,1) AS ChurnRate_Low
FROM employee_churn_info
GROUP BY Department
ORDER BY ChurnRate_High DESC;

-- Looking at each department we can see that the Procurement Department had the highest average churn rate likeliness at 66.2% where Administration had the least with 48.3%.

#2. Salary Distribution by Job Satisfaction Level:
SELECT
    JobSatisfaction,
    DENSE_RANK() OVER (
						ORDER BY (COUNT(JobSatisfaction) /(
                        SELECT COUNT(*)
						FROM employee_churn_info 
                        WHERE JobSatisfaction <> 'No Rating') * 100) DESC) AS RankByPercentage,
    ROUND(COUNT(JobSatisfaction) / (
					    SELECT COUNT(*) 
					    FROM employee_churn_info 
						WHERE JobSatisfaction <> 'No Rating') * 100, 1) AS PercentageofTotal,
    COUNT(JobSatisfaction) AS RangeCount,
    MIN(Salary) AS MinSalary,
    MAX(Salary) AS MaxSalary,
	DENSE_RANK() OVER (ORDER BY AVG(Salary) DESC) AS RankByAvgSalary,
    ROUND(AVG(Salary), 1) AS AvgSalary
FROM employee_churn_info
WHERE JobSatisfaction <> 'No Rating'
GROUP BY JobSatisfaction
ORDER BY PercentageofTotal DESC;


-- This insight allows us to see how salary may not be contributing factor to Job satisfaction as 'Satisfied' and 'Very Satisfied' came 2nd and 3rd when it came to the percentage of people who rated their Job satisfaction, however of those percentages  the rank in terms of average salary was 3rd and 4th.  


#3. Work-Life Balance and Average Tenure:

SELECT
  WorkLifeBalance,
  ROUND(AVG(Tenure),1) AS AvgTenure
FROM employee_churn_info
GROUP BY WorkLifeBalance
ORDER BY  AvgTenure DESC;

-- Looking at the data, the good and excellent ratings with work life balance had a tenure of almost 8 years and the fair ratings with about 7 years. Not a big difference.

SELECT DISTINCT WorkLifeBalance
FROM employee_churn_info;


#4. Average Tenure by department with reference to churn rate:
SELECT
  department,
  DENSE_RANK() OVER(ORDER BY ROUND(AVG(CASE WHEN ChurnLikelihood = 'Highly Likely to Churn' THEN 1 ELSE 0 END)*100, 2) DESC) AS DenseRank_Churn,
  ROUND(AVG(CASE WHEN ChurnLikelihood = 'Highly Likely to Churn' THEN 1 ELSE 0 END)*100, 1) AS ChurnRate_High,
  ROUND(AVG(CASE WHEN ChurnLikelihood = 'Moderately Likely to Churn' THEN 1 ELSE 0 END)*100, 1) AS ChurnRate_Moderate,
  ROUND(AVG(CASE WHEN ChurnLikelihood = 'Slightly Likely to Churn' THEN 1 ELSE 0 END)*100, 1) AS ChurnRate_Low,
  ROUND(AVG(Tenure), 2) AS AvgTenure,
  DENSE_RANK() OVER (ORDER BY AVG(Tenure) DESC) AS DenseRank_AvgTenure
FROM employee_churn_info
GROUP BY Department
ORDER BY ChurnRate_High DESC;


-- This insight looks into a correlation to the the earlier query and shows the churn rate for each department and they ordered with the highest first now we can see also out of the 15 departments, legal had the second highest churn rate and was at the bottom when it came to average tenure at 13th also. On the flip side IT support which was 10th in churn rate , was ranked 1st in average tenure.

#5 Average tenure by branch in relation to average salary:

WITH BranchSalaryTenureCTE AS (
  SELECT
    Branch,
    DENSE_RANK() OVER (ORDER BY AVG(Salary) DESC) AS DenseRank_AvgSalary,
    ROUND(AVG(Salary), 2) AS AvgSalary,
    ROUND(AVG(Tenure), 2) AS AvgTenure,
    DENSE_RANK() OVER (ORDER BY AVG(Tenure) DESC) AS DenseRank_AvgTenure
  FROM employee_churn_info
  WHERE BRANCH <> 'Unknown'
  GROUP BY Branch
)
SELECT *
FROM BranchSalaryTenureCTE
ORDER BY AvgSalary DESC;

-- The results here highlight how the Chicago, Atlanta, and Denver were the top 3 ranked average tenure branches, even though they were ranked 6,7 and 8 in terms or average salary. The results suggests that employees in these branches tend to stay with the company for a longer duration, possibly due to factors other than salary.
-- take into consideration, Job Market competition abnd cost of living


#6 Average tenure by branch based on Environmental Satisfaction:

WITH BranchEnvironmentalSatisfaction AS (
  SELECT 
    DENSE_RANK() OVER (ORDER BY AVG(Tenure) DESC, Branch) AS DenseRank_AvgTenure,
    Branch,
    ROUND(AVG(Tenure), 2) AS AvgTenure,
    ROUND(COUNT(CASE WHEN EnvironmentSatisfaction = 'Very Dissatisfied' THEN 1 ELSE NULL END) / 
      COUNT(CASE WHEN EnvironmentSatisfaction <> 'No Rating' THEN 1 ELSE NULL END) * 100, 1) AS PercentageofVeryDissatisfied,
    
    ROUND(COUNT(CASE WHEN EnvironmentSatisfaction = 'Dissatisfied' THEN 1 ELSE NULL END) / 
      COUNT(CASE WHEN EnvironmentSatisfaction <> 'No Rating' THEN 1 ELSE NULL END) * 100, 1) AS PercentageofDissatisfied,
    
    ROUND(COUNT(CASE WHEN EnvironmentSatisfaction = 'Neutral' THEN 1 ELSE NULL END) / 
      COUNT(CASE WHEN EnvironmentSatisfaction <> 'No Rating' THEN 1 ELSE NULL END) * 100, 1) AS PercentageofNeutral,
    
    ROUND(COUNT(CASE WHEN EnvironmentSatisfaction = 'Satisfied' THEN 1 ELSE NULL END) / 
      COUNT(CASE WHEN EnvironmentSatisfaction <> 'No Rating' THEN 1 ELSE NULL END) * 100, 1) AS PercentageofSatisfied,
    
    ROUND(COUNT(CASE WHEN EnvironmentSatisfaction = 'Highly Satisfied' THEN 1 ELSE NULL END) / 
      COUNT(CASE WHEN EnvironmentSatisfaction <> 'No Rating' THEN 1 ELSE NULL END) * 100, 1) AS PercentageofHighlySatisfied
    
  FROM employee_churn_info
  WHERE EnvironmentSatisfaction <> 'No Rating' AND Branch <> 'Unknown'
  GROUP BY Branch
  ORDER BY AvgTenure DESC, Branch DESC -- Added Branch to break ties
)

SELECT
  DENSE_RANK() OVER (ORDER BY AvgTenure DESC, Branch) AS DenseRank_AvgTenure,
  Branch,
  AvgTenure,
  DENSE_RANK() OVER (ORDER BY PercentageofVeryDissatisfied DESC, Branch) AS DenseRankPercentageofVeryDissatisfied,
  DENSE_RANK() OVER (ORDER BY PercentageofDissatisfied DESC, Branch) AS DenseRankPercentageofDissatisfied,
  DENSE_RANK() OVER (ORDER BY PercentageofNeutral DESC, Branch) AS DenseRankPercentageofNeutral,
  DENSE_RANK() OVER (ORDER BY PercentageofSatisfied DESC, Branch) AS DenseRankPercentageofSatisfied,
  DENSE_RANK() OVER (ORDER BY PercentageofHighlySatisfied DESC, Branch) AS DenseRankPercentageofHighlySatisfied
FROM BranchEnvironmentalSatisfaction
ORDER BY AvgTenure DESC, Branch;

-- Here you can investigate a correlation between the different branches and the environment satisfaction rankings based on percentage of people who ticked each category. Denver is 2nd in Average Tenure however 1st in the category of 'Very Dissatisfied' and 2nd 'Disatisfied'. There must be other contributing factors into why they still have a longer average tenure than the other branches. This could be linked to better work life balance, maybe flexible working, or higher pay.






