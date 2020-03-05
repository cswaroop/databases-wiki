SELECT version();
SELECT current_date();
SELECT 2+2;


INSERT INTO weather VALUES
('San Francisco', 46, 50, 0.25, '2017-11-01');

INSERAT INTO weather (date, city, temp_hi, temp_lo) VALUES
('2017-09-11', 'Bangalore', 40, 15);

COPY weather FROM 'C:/temp/a.txt';


