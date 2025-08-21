select * from Salaries.ds_salaries;

-- 1. Memeriksa apakah ada data yang NULL ?
SELECT *
FROM Salaries.ds_salaries
WHERE work_year IS NULL
OR experience_level IS NULL
OR employment_type IS NULL
OR job_title IS NULL
OR salary IS NULL
OR salary_currency IS NULL
OR salary_in_usd IS NULL
OR employee_residence IS NULL
OR remote_ratio IS NULL
OR company_location IS NULL
OR company_size IS NULL;

-- 2. Melihat job title apa saja.
select distinct job_title
FROM Salaries.ds_salaries 
order by job_title;

-- 3. Melihat job apa saja yang berkaitan dengan data analyst.
SELECT DISTINCT job_title
FROM Salaries.ds_salaries 
WHERE job_title LIKE "%Data Analyst%"
ORDER BY job_title;

-- 4. Rata-rata data gaji data analyst.
SELECT (AVG(salary_in_usd) * 16289.24) / 12 AS avg_sal_rp_monthly
FROM Salaries.ds_salaries;

-- 4.1 Berapa rata-rata gaji data analyst berdasarkan experience level?
SELECT experience_level, 
  (AVG(salary_in_usd) * 16289.24) / 12 AS avg_sal_rp_monthly 
FROM Salaries.ds_salaries
GROUP BY experience_level;


-- 4.2 Berapa rata-rata gaji data analyst berdasarkan experience level dan jenis employment?
SELECT experience_level, 
  employment_type,
  (AVG(salary_in_usd) * 16289.24) / 12 AS avg_sal_rp_monthly 
FROM Salaries.ds_salaries
GROUP BY experience_level,
  employment_type
ORDER BY experience_level, employment_type;

-- 5. Negara dengan gaji paling menarik untuk posisi full time entry-level/mid-level data analyst.
SELECT company_location,
  AVG(salary_in_usd) avg_sal_in_usd
FROM Salaries.ds_salaries
WHERE job_title LIKE "%Data Analyst%"
  AND employment_type = "FT"
  AND experience_level IN ("EN", "MI")
GROUP BY company_location
--memiliki gaji >=2000
HAVING avg_sal_in_usd >=2000;

-- 6. Tahun kenaikan gaji dari level mid ke senior yang paling tinggi 
-- (untuk pekerjaan yang berkaitan dengan data analyst penuh waktu).

WITH ds_1 AS (
    -- Rata-rata gaji untuk level Executive (EX) per tahun
    SELECT 
        work_year,
        AVG(salary_in_usd) AS avg_salary_usd
    FROM 
        Salaries.ds_salaries
    WHERE 
        employment_type = 'FT'
        AND experience_level = 'EX'
        AND job_title LIKE '%Data Analyst%'
    GROUP BY 
        work_year
),
ds_2 AS (
    -- Rata-rata gaji untuk level Mid-level (MI) per tahun
    SELECT 
        work_year,
        AVG(salary_in_usd) AS avg_salary_usd
    FROM 
        Salaries.ds_salaries
    WHERE 
        employment_type = 'FT'
        AND experience_level = 'MI'
        AND job_title LIKE '%Data Analyst%'
    GROUP BY 
        work_year
)
SELECT 
    COALESCE(ds_1.work_year, ds_2.work_year) AS work_year,
    ds_1.avg_salary_usd AS avg_salary_executive,
    ds_2.avg_salary_usd AS avg_salary_mid_level,
    ds_1.avg_salary_usd - ds_2.avg_salary_usd AS differences
FROM 
    ds_1 
FULL OUTER JOIN ds_2 ON ds_1.work_year = ds_2.work_year
ORDER BY
    work_year;
    





