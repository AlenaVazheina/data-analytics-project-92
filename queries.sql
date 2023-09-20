select count(customer_id) as "customers_count"
from customers -- функция count считает общее количество покупателей из таблицы customers по признаку customer_id

--Анализ отдела продаж
-- 1 задача


select 
concat(e.first_name, ' ', e.last_name) as "name",--конкатенация имени и фамилии продавца
floor(COUNT(s.sales_id)) as "operations",--вычисление с помощбю функции count количества сделок, округление вниз до целого
floor(sum(s.quantity * p.price)) as "income"--вычисление суммарного дохода (произведение количества товаров на их цену) с использованием функции SUM, округление вниз
from sales s
join employees e 
on e.employee_id = s.sales_person_id 
join products p 
on s.product_id = p.product_id --соединение таблиц по связанным полям: "sales_person_id" в таблице "sales" и "employee_id" в таблице "employees", а также "product_id" в таблице "sales" и "product_id" в таблице "products"
group by concat(e.first_name, ' ', e.middle_initial, ' ', e.last_name), e.employee_id--группировка результатов по имени и идентификатору продавца
order by income desc--сортировка результатов по убыванию дохода (по убыванию значения "income")
limit 10--ограничение выборки до 10 строк с наибольшим доходом с помощью

--2 задача
SELECT CONCAT(e.first_name, ' ', e.last_name) AS "name",--конкатенация имени и фамилии продавца
       round(AVG(s.quantity * p.price)) AS average_income--!в задании указано округлиение вниз т е floor, но тесты проходят только с округлением round!округление вниз среднего дохода, вычисленного как среднее значение произведения количества товаров на их цену с использованием функции AVG 
FROM sales s
JOIN employees e ON e.employee_id = s.sales_person_id 
JOIN products p ON s.product_id = p.product_id --соединение таблиц по связанным полям: "sales_person_id" в таблице "sales" и "employee_id" в таблице "employees", а также "product_id" в таблице "sales" и "product_id" в таблице "products"
GROUP BY e.employee_id--группировка результатов по идентификатору продавца
HAVING AVG(s.quantity * p.price) < 
(SELECT AVG(s2.quantity * p2.price) FROM sales s2 JOIN products p2 ON s2.product_id = p2.product_id)--фильтрация результатов с помощью выражения HAVING и подзапроса, чтобы выбрать только тех продавцов, у которых средний доход меньше среднего дохода по всем продавцам
order by average_income;--сортировка результатов по возрастанию среднего дохода

--3 задача
select
	concat(e.first_name, ' ', e.last_name) as full_name,--конкатенация имени и фамилии продавца, используем full_name, т.к. name зарезервированое слово
	to_char(sale_date, 'day') as weekday,--с помощью to_char выделяем день недели из sale_sate
	round(sum(quantity * price)) as income--в задании указано округлиение вниз т е floor, но тесты проходят только с округлением round, округление вниз суммарного дохода, вычисленного как произведение количества товаров на их цену с использованием
from sales s
	join employees e 
		on e.employee_id = s.sales_person_id 
	join products p 
		on s.product_id = p.product_id --соединение таблиц по связанным полям: "sales_person_id" в таблице "sales" и "employee_id" в таблице "employees", а также "product_id" в таблице "sales" и "product_id" в таблице "products"
group by full_name, weekday, to_char(s.sale_date , 'ID')
order by to_char(s.sale_date , 'ID'), full_name; 
--группировка результатов по имени продавца и дате продажи

--Анализ покупателей
--1 задача
select
    case--используется для определения категорий возраста на основе значения в столбце age
        WHEN age BETWEEN 16 AND 25 THEN '16-25'--указывает, что если возраст находится в диапазоне от 16 до 25 лет, покупатель будет отнесен к категории '16-25'
        WHEN age BETWEEN 26 AND 40 THEN '26-40'--указывает, что если возраст находится в диапазоне от 26 до 40 лет, покупатель будет отнесен к категории '26-40'
        ELSE '40+'--указывает, что все остальные покупатели, возраст которых не соответствует предыдущим двум условиям, будут отнесены к категории '40+'
    end as age_category,
    count(*) as count--подсчитывает количество строк (клиентов), которые попадают в каждую категорию возраста
from
    customers
GROUP BY
    age_category--группирует результаты по категориям возраста, созданным в case
ORDER BY
    age_category;
    
 
   
   --2 задача
   
   select concat(extract(year from sale_date), '-', LPAD(EXTRACT(MONTH FROM sale_date)::TEXT, 2, '0')) as date,--извлекаем год из столбца sale_date, месяц из sale_date и преобразуем его в текстовый формат, lpad добавляет нoль в начало текстовой строки месяца, если месяц представлен одной цифрой. Это используется для форматирования месяца в виде двухзначного числа
   count(distinct customer_id) as total_customers,--считаем количество уникальных покупателей в каждом месяце
   floor(sum(price * quantity)) as income --вычисляем общий доход в каждом месяце, умножая цену (price) на количество (quantity) и округляя результат вниз до целого числа
   from sales s
   join products p
   on s.product_id = p.product_id
   group by date
   order by date;

  
  
  --3 задача
  with tab as(
  select customer_id,
  min(sale_date) as first_ph_sale_date
  from sales s
  group by customer_id)--создание временной таблицы tab, которая вычисляет для каждого customer_id дату первой покупки с использованием функции MIN(sale_date) и группировки по customer_id
  
  select distinct(CONCAT(c.first_name, ' ',c.last_name)) as customer,
  sale_date,
  CONCAT(e.first_name, ' ',e.last_name) as seller--выборка данных из таблиц customers, sales, products и employees, имена продавцов и покупателей соединяем с помощью concat
  from customers c
  join sales s 
  on c.customer_id = s.customer_id
  join products p 
  on p.product_id = s.product_id 
  join employees e
  on e.employee_id = s.sales_person_id--соединение таблиц для получения информации о покупателях (customers), продажах (sales), продуктах (products) и сотрудниках (employees)
  join tab t
  on s.customer_id = t.customer_id and s.sale_date = t.first_ph_sale_date--соединение с временной таблицей tab по customer_id и sale_date, чтобы связать каждую продажу с информацией о первой покупке покупателя
  where price = 0--фильтруем результаты, выбираем только те строки, где цена товара равно нулю, что соответствует акционным товарам
  order by customer;
