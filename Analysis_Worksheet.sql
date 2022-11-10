#Practice Project; Analysis of UK Road Accidents 2015 Data

/*Create Database*/
create schema british_accidents2015;
use british_accidents2015;

/* Create Tables and Load data into Tables*/
create table accident(accident_index varchar(13), accident_severity int);
create table vehicles(accident_index varchar(13), vehicle_type varchar(50));
create table vehicle_types(vehicle_code int, vehicle_type varchar(10));
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/portfolioproject/Accidents_2015.csv' 
INTO TABLE accident 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 lines
(@col1, @dummy, @dummy, @dummy, @dummy, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, accident_severity=@col2;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/portfolioproject/Vehicles_2015.csv'
INTO TABLE vehicles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, vehicle_type=@col2;
alter table vehicle_types
drop column vehicle_type;
alter table vehicle_types
add column vehicle_types varchar(255);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/portfolioproject/vehicle_types.csv'
INTO TABLE vehicle_types
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

#Question 1; Evaluate the median severity value of accidents caused by various Motorcyles
/* Checking the data in vehicle_types and accident tables of motorcycles*/
SELECT vehicle_types FROM vehicle_types WHERE vehicle_types LIKE '%torcycle%';
SELECT vt.vehicle_types, a.accident_severity
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
WHERE vt.vehicle_types LIKE '%torcycle%'
ORDER BY a.accident_severity ;

/* Median */
set @rowindex =-1;

SELECT 
    AVG(d.severity) AS Median
FROM
    (SELECT 
        @rowindex:=@rowindex + 1 AS rowindex,
            aw.accident_severity AS severity
    FROM
        (SELECT 
        vt.vehicle_types, a.accident_severity
    FROM
        accident a
    JOIN vehicles v ON a.accident_index = v.accident_index
    JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
    WHERE
        vt.vehicle_types LIKE '%torcycle%'
    ORDER BY a.accident_severity) AS aw) AS d
WHERE
    d.rowindex IN (FLOOR(@rowindex / 2) , CEIL(@rowindex / 2));
    
#Evaluate Accident Severity and Total Accidents per Vehicle Type
SELECT vt.vehicle_types as Vehicle_Type, a.accident_severity as Severity, count(vt.vehicle_types) as Total_Accidents
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY 1
ORDER BY 2,3 ;
/*note; the group by and order clauses translates to "Group by Column 1, Order by Columns 2 then Column 3"*/
#Average Severity per vehicle type
SELECT 
    vt.vehicle_types AS Vehicle_Type,
    AVG(a.accident_severity) AS Average_Severity
FROM
    accident a
        JOIN
    vehicles v ON a.accident_index = v.accident_index
        JOIN
    vehicle_types vt ON v.vehicle_type = vt.vehicle_code
    Group by vt.vehicle_types
    ORDER BY Average_Severity;
#Average Severity and Total Accidents for Motor Bikes
SELECT 
    vt.vehicle_types as Vehicle_Type,
    AVG(a.accident_severity) AS Average_Severity,
    COUNT(vt.vehicle_types) AS Total_Accidents
FROM
    accident a
        JOIN
    vehicles v ON a.accident_index = v.accident_index
        JOIN
    vehicle_types vt ON v.vehicle_type = vt.vehicle_code
WHERE
    vt.vehicle_types LIKE '%torcycle%'
group by vt.vehicle_types
order by Average_Severity,Total_Accidents;
