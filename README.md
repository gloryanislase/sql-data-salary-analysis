# sql-data-salary-analysis
Project portfolio analyzing Data Analyst Job Salaries using SQL

# SQL Project: Analisis Gaji di Bidang Data Analyst

## Ringkasan Proyek
Proyek ini bertujuan untuk menggali wawasan dari dataset Data Science Job Salaries yang bersumber dari Kaggle. Dengan menggunakan SQL, saya melakukan pembersihan data, analisis eksplorasi, dan menjawab beberapa pertanyaan bisnis kunci seputar tren gaji, pengaruh tingkat pengalaman, dan lokasi kerja yang paling prospektif, dengan fokus utama pada peran Data Analyst.

Dataset: Data Science Job Salaries (https://www.kaggle.com/datasets/ruchi798/data-science-job-salaries).

Tools : BigQuery

## Tahapan Analisis

Berikut adalah langkah-langkah yang saya lakukan untuk menganalisis data ini.

### 1. Pembersihan dan Validasi Data

Langkah pertama adalah memastikan kualitas data. Saya memeriksa apakah ada nilai yang hilang (NULL) pada kolom-kolom penting untuk memastikan analisis yang akan dilakukan akurat.

Pertanyaan: Apakah ada data yang tidak lengkap (NULL) di dalam dataset?

Hasil: Setelah diperiksa, dataset ini bersih dan tidak ditemukan baris dengan nilai NULL.

```sql
-- Memeriksa apakah ada data yang NULL
SELECT *
FROM Salaries.ds_salaries
WHERE work_year IS NULL
   OR experience_level IS NULL
   OR employment_type IS NULL
   OR job_title IS NULL
   OR salary_in_usd IS NULL
   OR employee_residence IS NULL
   OR remote_ratio IS NULL
   OR company_location IS NULL
   OR company_size IS NULL;
```

### 2. Eksplorasi Awal: Memahami Ragam Pekerjaan

Selanjutnya, saya melihat ragam job_title yang ada untuk memahami cakupan data. Dari sini, saya memutuskan untuk memfokuskan analisis pada peran yang berkaitan dengan "Data Analyst".

Pertanyaan: Pekerjaan apa saja yang teridentifikasi sebagai "Data Analyst"?

Hasil: Terdapat beberapa variasi jabatan seperti Data Analyst, Lead Data Analyst, Principal Data Analyst, dll.

```SQL
-- Melihat job apa saja yang berkaitan dengan data analyst
SELECT DISTINCT job_title
FROM Salaries.ds_salaries
WHERE job_title LIKE "%Data Analyst%"
ORDER BY job_title;
```

### 3. Analisis Gaji Data Analyst 📊

Ini adalah inti dari analisis, di mana saya mencoba menjawab pertanyaan spesifik seputar kompensasi untuk Data Analyst.

Pertanyaan 1: Bagaimana rata-rata gaji bulanan Data Analyst bervariasi berdasarkan tingkat pengalaman (experience_level) dan tipe pekerjaan (employment_type)?

```SQL
-- Rata-rata gaji berdasarkan experience level dan jenis employment
SELECT 
    experience_level, 
    employment_type,
    (AVG(salary_in_usd) * 16289.24) / 12 AS avg_sal_rp_monthly -- Asumsi kurs saat ini
FROM Salaries.ds_salaries
WHERE job_title LIKE "%Data Analyst%"
GROUP BY experience_level, employment_type
ORDER BY experience_level, employment_type;
```
Hasil: Untuk posisi Full-Time (FT), terlihat jelas adanya peningkatan gaji yang konsisten seiring naiknya level pengalaman dari Pemula (EN) hingga Eksekutif (EX). Selain itu, tipe pekerjaan menjadi pembeda signifikan, terutama pada level Pemula, di mana gaji untuk Full-Time jauh lebih tinggi dibandingkan dengan tipe Kontrak (CT) dan Paruh Waktu (PT).

(Di sini Anda bisa menambahkan tabel singkat atau visualisasi sederhana dari hasilnya)

Pertanyaan 2: Negara mana yang menawarkan gaji rata-rata tertinggi untuk Data Analyst full-time di level pemula (Entry-level) dan menengah (Mid-level)?
```SQL

-- Negara dengan gaji paling menarik untuk posisi FT EN/MI Data Analyst
SELECT 
    company_location,
    AVG(salary_in_usd) AS avg_sal_in_usd
FROM Salaries.ds_salaries
WHERE job_title LIKE "%Data Analyst%"
    AND employment_type = "FT"
    AND experience_level IN ("EN", "MI")
GROUP BY company_location
ORDER BY avg_sal_in_usd DESC
LIMIT 10;
```
Hasil : Gaji rata-rata tertinggi untuk Data Analyst full-time di level pemula (Entry-level) dan menengah (Mid-level) berada di negara Amerika Serikat (US)

![Grafik Perbandingan Gaji](Perbandingan%20Gaji%20Rata-Rata%20Analis%20Data%20Berdasarkan%20Lokasi.png)

### 4. Analisis Lanjutan: Tren Kesenjangan Gaji 📈

Untuk menunjukkan kemampuan analisis yang lebih kompleks, saya menggunakan CTE dan FULL OUTER JOIN untuk membandingkan rata-rata gaji antara level Mid-level (MI) dan Executive (EX) dari tahun ke tahun.

Pertanyaan: Bagaimana tren perbedaan gaji antara Data Analyst level Mid dan Executive dari waktu ke waktu?

```SQL
-- CTE untuk membandingkan gaji MI vs EX per tahun
WITH ds_1 AS (
    -- Rata-rata gaji untuk level Executive (EX) per tahun
    SELECT 
        work_year, AVG(salary_in_usd) AS avg_salary_usd
    ... -- (Sertakan CTE lengkap Anda di sini)
),
ds_2 AS (
    -- Rata-rata gaji untuk level Mid-level (MI) per tahun
    SELECT
        work_year, AVG(salary_in_usd) AS avg_salary_usd
    ... -- (Sertakan CTE lengkap Anda di sini)
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
```
(Jelaskan temuan Anda dari output kueri ini, misalnya: "Pada tahun 2020, tidak ada data untuk level Executive, namun kesenjangan gaji terlihat jelas pada tahun 2021 dan 2022.")
