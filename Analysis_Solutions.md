# Solutions
## Question 1; Evaluate the median severity value of accidents caused by various Motorcyles
### First, I checked the data in vehicle_types and accident tables of motorcycles
````sql
SELECT vehicle_types FROM vehicle_types WHERE vehicle_types LIKE '%torcycle%';
SELECT vt.vehicle_types, a.accident_severity
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
WHERE vt.vehicle_types LIKE '%torcycle%'
ORDER BY a.accident_severity ;
  ````
### Then I found the Median
````sql
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
  ````
  
| Median |
| ------ |
| 3.00   |

## Question 2; Evaluate Accident Severity and Total Accidents per Vehicle Type
````sql
SELECT vt.vehicle_types as Vehicle_Type, a.accident_severity as Severity, count(vt.vehicle_types) as Total_Accidents
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY 1
ORDER BY 2,3;
  ````
  
| Vehicle_Type                           | Severity | Total_Accidents |
| -------------------------------------  | -------- | --------------- |
| Mobility scooter                       | 2        | 222             |
| Electric motorcycle                    | 3        | 9               |
| Tram                                   | 3        | 18              |
| Data missing or out of range           | 3        | 58              |
| Ridden horse                           | 3        | 107             |
| Motorcycle - unknown cc                | 3        | 275             |
| Minibus(8-16 passenger seats)          | 3        | 498             |
| Agricultural vehicle                   | 3        | 504             |
| Goods vehicle - unknow weight          | 3        | 615             |
| Other vehicle                          | 3        | 1286            |
| Goods over 3.5t and under 7.5t         | 3        | 1708            |
| Motorcycle over 125cc and up to 500cc  | 3        | 2187            |
| Motorcycle 50cc and under              | 3        | 2237            |
| Goods 7.5 tonnes mgw and over          | 3        | 4762            |
| Bus or coach (17 or more pass seats)   | 3        | 5381            |
| Taxi/Private hire car                  | 3        | 5420            |
| Motorcycle over 500cc                  | 3        | 7054            |
| Motorcycle 125cc and under             | 3        | 9234            |
| Van/Goods 3.5 tonnes mgw or under      | 3        | 13876           |
| Pedal cycle                            | 3        | 19440           |
| Car                                    | 3        | 182954          |

## Question 3; What is the Average Severity per vehicle type?
````sql
SELECT 
    vt.vehicle_types AS Vehicle_Type,
    ROUND(AVG(a.accident_severity),2) AS Average_Severity
FROM
    accident a
        JOIN
    vehicles v ON a.accident_index = v.accident_index
        JOIN
    vehicle_types vt ON v.vehicle_type = vt.vehicle_code
    Group by vt.vehicle_types
    ORDER BY Average_Severity;
  ````
     
| Vehicle_Type                           | Average_Severity |
| -------------------------------------  | ---------------- |
| Electric motorcycle                    | 2.44             |
| Motorcycle over 500cc                  | 2.58             |
| Agricultural vehicle                   | 2.68             |
| Motorcycle over 125cc and up to 500cc  | 2.69             |
| Motorcycle - unknown cc                | 2.69             |
| Mobility scooter                       | 2.72             |
| Goods 7.5 tonnes mgw and over          | 2.73             |
| Motorcycle 125cc and under             | 2.78             |
| Other vehicle                          | 2.78             |
| Goods over 3.5t and under 7.5t         | 2.81             |
| Pedal cycle                            | 2.81             |
| Data missing or out of range           | 2.81             |
| Minibus(8-16 passenger seats)          | 2.82             |
| Motorcycle 50cc and under              | 2.83             |
| Ridden horse                           | 2.83             |
| Goods vehicle - unknow weight          | 2.84             |
| Van/Goods 3.5 tonnes mgw or under      | 2.85             |
| Bus or coach (17 or more pass seats)   | 2.86             |
| Car                                    | 2.87             |
| Taxi/Private hire car                  | 2.88             |
| Tram                                   | 2.89             | 

## Question 4; What is the Average Severity and Total Accidents for Motor Bikes?
````sql
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
````

| Vehicle_Type                           | Average_Severity | Total_Accidents |
| -------------------------------------  | ---------------- | --------------- |
| Electric motorcycle                    | 2.44             | 9               |
| Motorcycle over 500cc                  | 2.58             | 7054            |
| Motorcycle - unknown cc                | 2.69             | 275             |
| Motorcycle over 125cc and up to 500cc  | 2.69             | 2187            |
| Motorcycle 125cc and under             | 2.78             | 9234            |
| Motorcycle 50cc and under              | 2.83             | 2237            |

