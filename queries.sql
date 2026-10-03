-- 1. Определение диапазона заработных плат в общем, а именно средние значения, минимумы 
--    и максимумы нижних и верхних порогов зарплат.
SELECT 
	ROUND(AVG(salary_from),2) AS avg_salary_from,
	ROUND(AVG(salary_to),2) AS avg_salary_to,
	MIN(salary_from) AS min_salary_from,
	MIN(salary_to) AS min_salary_to,
	MAX(salary_from) AS max_salary_from,
	MAX(salary_to) AS max_salary_to
FROM public.parcing_table;
-- Среднее минимальное значение в категории "от" составляет 109525.09, а среднее значение в категории "до" - 153846.71.
-- Это значит, что работодатели готовы платить в среднем около 130000 рублей. Минимальное значение предлагаемой зарплаты составило 
-- 50.0 (что с большей вероятностью является ошибкой), а максимальное значение - 398000.0. Максимальное значение предлагаемой 
-- зарплаты - 497500.0.


-- 2. Выявить регионы и компании, в которых сосредоточено наибольшее количество вакансий 
SELECT 
	area,
	COUNT(*) AS cnt_vacancy
FROM public.parcing_table
GROUP BY area
ORDER BY cnt_vacancy DESC;
-- Москва и Санкт-Петербург — лидеры по количеству вакансий. 
-- Это неудивительно, учитывая, что это крупнейшие города 
-- с развитой инфраструктурой и большим количеством компаний. 
-- В Екатеринбурге, Нижнем Новгороде и Новосибирске также значительное 
-- количество вакансий — это указывает на развитый рынок труда для аналитиков данных в этих регионах.
SELECT 
	employer,
	COUNT(*) AS cnt_vacancy
FROM public.parcing_table
GROUP BY employer
ORDER BY cnt_vacancy DESC;
-- Наибольшее количество вакансий предлагает компания СБЕР. Это крупнейший российский банк, 
-- поэтому спрос на аналитиков данных и системных аналитиков довольно большой. Также WILDBERRIES и Ozon предлагают значительное 
-- количество вакансий, поскольку данные маркетплейсы пользуются большой популярностью в стране, что приводит 
-- к потребности аналитиков.
SELECT 
	area,
	employer,
	COUNT(*) AS cnt_vacancy
FROM public.parcing_table
GROUP BY area, employer
ORDER BY cnt_vacancy DESC;
-- Самое большое количество вакансий было предложено в Москве от компании СБЕР - 187 вакансий. 


-- 3. Какие преобладают типы занятости, а также графики работы.
SELECT 
	employment,
	COUNT(*) AS cnt_vacancy
FROM public.parcing_table
GROUP BY employment
ORDER BY cnt_vacancy DESC;
-- Подавляющая часть работодалетей требует полную занятость - 1764 заявок с полной занятостью. 
-- Это указывает на то, что работодатели предпочитают нанимать 
-- аналитиков данных и системных аналитиков на постоянные позиции.
-- Возможно, дело в необходимости глубоко погружаться в проекты и
-- долго в них участвовать.
-- Меньше всего они заинтересованы в проектной деятельности.
SELECT 
	schedule,
	COUNT(*) AS cnt_vacancy
FROM public.parcing_table
GROUP BY schedule
ORDER BY cnt_vacancy DESC;
-- Большинство вакансий (1441) предлагают работу с полным днём. 
-- Однако значительное количество вакансий (310) также позволяет 
-- удалённую работу. 


-- 4. Распределение грейдов (Junior, Middle, Senior) среди аналитиков данных и системных аналитиков
SELECT 
	experience,
	COUNT(*) AS cnt_vacancy
FROM public.parcing_table
GROUP BY experience
ORDER BY cnt_vacancy;
-- Наибольшее количество вакансий предназначено для специалистов с опытом от 1 до 3 лет (Junior+), 
-- что свидетельствует о высоком спросе на специалистов начального и среднего уровней. 
-- Вакансий для Middle-специалистов (3–6 лет) также много, в то время как спрос 
-- на Senior-специалистов (6+ лет) крайне низкий, возможно, из-за узкого круга
-- специалистов с таким уровнем опыта или предпочитаемых долгосрочных позиций.

SELECT 
	COUNT(*)
FROM public.parcing_table
WHERE 
	name LIKE '%Аналитик данных%' OR  
	name LIKE '%аналитик данных%' OR 
	name LIKE '%Системный аналитик%' OR 
	name LIKE '%системный аналитик%';
-- Всего вакансий по аналитике данных и системной аналитике - 1326
SELECT
	experience,
	COUNT(*) AS cnt_vacancy,
	ROUND(COUNT(*)/1326.0,4)*100.0 AS percent_vacancies
FROM public.parcing_table
WHERE 
	name LIKE '%Аналитик данных%' OR  
	name LIKE '%аналитик данных%' OR 
	name LIKE '%Системный аналитик%' OR 
	name LIKE '%системный аналитик%'
GROUP BY experience
ORDER BY cnt_vacancy;
-- Большинство вакансий для аналитиков данных и системных аналитиков предназначены
-- для специалистов уровня Junior+ (64.40%) и Middle (26.02%). Это подтверждает высокую 
-- потребность в специалистах начального и среднего уровней. 
-- Доли вакансий для стажёров (9.13%) и Senior (0.45%) значительно ниже.


-- 5. Выявите основных работодателей, предлагаемые зарплаты и условия труда для аналитиков.
SELECT 
	employer,
	COUNT(*) AS cnt_vacancy,
	ROUND(AVG(salary_from),2) AS avg_salary_from,
	ROUND(AVG(salary_to),2) AS avg_salary_to,
	employment
FROM public.parcing_table
WHERE 
	name LIKE '%Аналитик данных%' OR  
	name LIKE '%аналитик данных%' OR 
	name LIKE '%Системный аналитик%' OR 
	name LIKE '%системный аналитик%'
GROUP BY employer, employment
ORDER BY cnt_vacancy DESC;
-- СБЕР выделяется как основной работодатель для аналитиков данных и системных аналитиков 
-- с 117 вакансиями и средней зарплатой от 110583 рублей до 73333 рублей. 
-- Средняя зарплата «до» ниже средней зарплаты «от» — скорее всего, СБЕР часто пишет сумму «до», не указываю сумму «от». 
-- Основной тип занятости в СБЕР — полная занятость с полным рабочим днём. Значит, компания предпочитает длительное сотрудничество с сотрудниками.
-- Банк ВТБ (ПАО) и Ozon также предлагают достаточно вакансий с аналогичными условиями занятости.


-- 6. Определение наиболее востребованных навыков (как жёсткие, так и мягкие) для различных грейдов и позиций.
SELECT 
	key_skills_1,
	COUNT(*) AS cnt_vacancy
FROM public.parcing_table
WHERE key_skills_1 IS NOT NULL
GROUP BY key_skills_1
ORDER BY cnt_vacancy DESC;
-- Среди ключевых навыков чаще упоминается «Анализ данных» (312 упоминаний), 
-- что логично для позиций аналитиков данных. SQL (161 упоминание) и MS SQL (87 упоминаний) также являются
-- важными навыками, что подчёркивает важность работы с базами данных. «Документация» (89 упоминаний) 
-- указывает на необходимость ведения точных записей и отчётов. 


-- 7. Влияние удаленки на зарплату
SELECT 
	schedule,
	COUNT(*) AS cnt_vacancy,
	ROUND(AVG(salary_from),2) AS avg_salary_from,
	ROUND(AVG(salary_to),2) AS avg_salary_to
FROM public.parcing_table
GROUP BY schedule
ORDER BY cnt_vacancy DESC;
-- В разультате получилось, что предлагаемая зарплата для полного дня - 103264,4-133374.67
-- А удаленная работа - 134780.28-200251.49.


-- 8.Динамика вакансий по месяцам (Тренд)
SELECT 
	CASE 
		WHEN EXTRACT(MONTH FROM published_at) = 1 THEN 'января'
		WHEN EXTRACT(MONTH FROM published_at) = 2 THEN 'февраль'
		WHEN EXTRACT(MONTH FROM published_at) = 3 THEN 'март'
		WHEN EXTRACT(MONTH FROM published_at) = 4 THEN 'апрель'
		WHEN EXTRACT(MONTH FROM published_at) = 5 THEN 'май'
		WHEN EXTRACT(MONTH FROM published_at) = 6 THEN 'июнь'
		WHEN EXTRACT(MONTH FROM published_at) = 7 THEN 'июль'
		WHEN EXTRACT(MONTH FROM published_at) = 8 THEN 'август'
		WHEN EXTRACT(MONTH FROM published_at) = 9 THEN 'сентябрь'
		WHEN EXTRACT(MONTH FROM published_at) = 10 THEN 'октябрь'
		WHEN EXTRACT(MONTH FROM published_at) = 11 THEN 'ноябрь'
		WHEN EXTRACT(MONTH FROM published_at) = 12 THEN 'декабрь'
	END AS monthDATE,
	COUNT(*) AS cnt_vacancy
FROM public.parcing_table
GROUP BY monthDATE
ORDER BY cnt_vacancy;
-- Больше всего вакансий открывается в мае
