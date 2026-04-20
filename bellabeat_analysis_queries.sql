-- BELLABEAT CASE STUDY: SQL ANALYSIS QUERIES  

-- Author: Fatina Crabbe  

-- Description: These queries were executed in BigQuery to clean, transform, and analyze smart device data.  

-- 1. WEEKEND TRENDS 

 -- Objective: Identifying the "Sunday Dip" by calculating average steps per day of the week.  

SELECT 

FORMAT_DATE('%A', activity_date) AS day_of_week, 

ROUND(AVG(total_steps), 2) AS avg_steps, 

ROUND(AVG(calories), 2) AS avg_calories 

FROM `cleaned_data_bellabeat.v_daily_activity` 

GROUP BY day_of_week 

ORDER BY avg_steps DESC 

 

-- 2. PEAK HOURS  

-- Objective: Determining which hours of the day see the highest user activity for push notification timing.  

SELECT 

EXTRACT(HOUR FROM activity_time) AS hour_of_day, 

ROUND(AVG(step_total), 2) AS avg_steps_per_hour 

FROM `cleaned_data_bellabeat.v_hourly_steps` 

GROUP BY hour_of_day 

ORDER BY avg_steps_per_hour DESC 

 

-- 3. USER SEGMENTATION  

-- Objective: Categorizing users (e.g., Sedentary, Active, Very Active) based on their daily step averages.  

SELECT 

id, 

ROUND(AVG(total_steps), 2) AS avg_steps, 

CASE 

WHEN AVG(total_steps) < 5000 THEN 'Sedentary' 

WHEN AVG(total_steps) BETWEEN 5000 AND 7499 THEN 'Lightly Active' 

WHEN AVG(total_steps) BETWEEN 7500 AND 9999 THEN 'Fairly Active' 

WHEN AVG(total_steps) >= 10000 THEN 'Very Active' 

END AS user_type 

FROM `cleaned_data_bellabeat.v_daily_activity` 

GROUP BY id 

ORDER BY avg_steps DESC 

 

-- 4. DAILY AVERAGE  

-- Objective: Calculating the baseline metrics for steps, calories, and active minutes across the entire dataset. 

SELECT  

ROUND(AVG(total_steps), 2) AS avg_steps, 

ROUND(AVG(total_distance), 2) AS avg_distance, 

ROUND(AVG(calories), 2) AS avg_calories, 

ROUND(AVG(total_minutes_asleep), 2) AS avg_sleep_mins, 

ROUND(AVG(total_time_in_bed), 2) AS avg_time_in_bed 

FROM `cleaned_data_bellabeat.v_daily_activity` AS activity 

LEFT JOIN `cleaned_data_bellabeat.v_sleep_day` AS sleep 

ON activity.id = sleep.id AND activity.activity_date = sleep.sleep_date 

 

-- 5. CORRELATION FINAL  

-- Objective: Joining the activity and sleep tables to analyze the relationship between movement and rest.  

SELECT 

a.Id, 

a.activity_date, 

a.total_steps, 

s.total_minutes_asleep 

FROM `cleaned_data_bellabeat.v_daily_activity` AS a 

INNER JOIN `cleaned_data_bellabeat.v_sleep_log` AS s 

-- We cast both to STRING to ensure they match perfectly 

ON CAST(a.Id AS STRING) = CAST(s.Id AS STRING)  

AND a.activity_date = CAST(s.sleep_date AS DATE) 

WHERE s.total_minutes_asleep IS NOT NULL 

 
