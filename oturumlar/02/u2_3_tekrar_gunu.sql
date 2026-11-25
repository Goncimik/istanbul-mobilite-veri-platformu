-- Oturum 2 | Uygulama 3

-- Adım 1: Tekrar gönderilen günleri bulma
SELECT gun, satir,
       lag(satir, 7) OVER (ORDER BY gun) AS gecen_hafta,
       round(satir / gecen_hafta, 2) AS kat
FROM (SELECT transition_date AS gun, count(*) AS satir
      FROM lake.bronze.toplu_ulasim
      GROUP BY ALL)
ORDER BY kat DESC
LIMIT 3;

-- Adım 2: Günlük yolculuk toplamları
CREATE OR REPLACE TABLE gunluk_bronze AS
SELECT transition_date AS gun, sum(number_of_passage) AS yolculuk
FROM lake.bronze.toplu_ulasim
GROUP BY ALL;

-- Adım 3: Tekrar gönderilen günleri düzeltme
UPDATE gunluk_bronze
SET yolculuk = yolculuk // 2
WHERE gun IN (DATE '2024-01-10', DATE '2024-02-14');

-- Adım 4: Bütün çarşambalar
SELECT gun, yolculuk
FROM gunluk_bronze
WHERE dayofweek(gun) = 3
ORDER BY gun;

-- İleri görev: Mart ayındaki tekrar gönderilen gün
SELECT gun, satir,
       lag(satir, 7) OVER (ORDER BY gun) AS gecen_hafta,
       round(satir / gecen_hafta, 2) AS kat
FROM (SELECT transition_date AS gun, count(*) AS satir
      FROM read_csv('veri/toplu_ulasim_2024_03.csv.gz')
      GROUP BY ALL)
ORDER BY kat DESC
LIMIT 3;