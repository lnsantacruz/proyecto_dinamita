SELECT *
FROM
(    

SELECT e.employee_id, d.department_name, c.country_name    
FROM          
hr.employees e,          
hr.departments d,          
hr.locations l,          
hr.countries c    
WHERE e.department_id = d.department_id    
AND   d.location_id = l.location_id    
AND   l.country_id = c.country_id

)
WHERE department_name IN ( 'purchasing','Shipping','Sales','Marketing');

