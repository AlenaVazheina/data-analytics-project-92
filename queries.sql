--1 задача

select 
concat(e.first_name, ' ', e.middle_initial, ' ', e.last_name) as "name",--конкатенация имени, среднего инициала и фамилии продавца
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
SELECT CONCAT(e.first_name, ' ', e.middle_initial, ' ', e.last_name) AS "name",--конкатенация имени, среднего инициала и фамилии продавца
       floor(AVG(s.quantity * p.price)) AS average_income--округление вниз среднего дохода, вычисленного как среднее значение произведения количества товаров на их цену с использованием функции AVG
FROM sales s
JOIN employees e ON e.employee_id = s.sales_person_id 
JOIN products p ON s.product_id = p.product_id --соединение таблиц по связанным полям: "sales_person_id" в таблице "sales" и "employee_id" в таблице "employees", а также "product_id" в таблице "sales" и "product_id" в таблице "products"
GROUP BY e.employee_id--группировка результатов по идентификатору продавца
HAVING AVG(s.quantity * p.price) < 
(SELECT AVG(s2.quantity * p2.price) FROM sales s2 JOIN products p2 ON s2.product_id = p2.product_id)--фильтрация результатов с помощью выражения HAVING и подзапроса, чтобы выбрать только тех продавцов, у которых средний доход меньше среднего дохода по всем продавцам
order by average_income;--сортировка результатов по возрастанию среднего дохода

--3 задача
select 
concat(e.first_name, ' ', e.middle_initial, ' ', e.last_name) as "name",--конкатенация имени, среднего инициала и фамилии продавца
case extract(dow from sale_date) 
        WHEN 0 THEN 'sunday'
        WHEN 1 THEN 'monday'
        WHEN 2 THEN 'tuesday'
        WHEN 3 THEN 'wednesday'
        WHEN 4 THEN 'thursday'
        WHEN 5 THEN 'friday'
        WHEN 6 THEN 'saturday'
    END AS weekday,--извлечение дня недели (значение от 0 до 6, где 0 - воскресенье, 1 - понедельник и так далее) из даты продажи
floor(sum(quantity * price)) as income--округление вниз суммарного дохода, вычисленного как произведение количества товаров на их цену с использованием
from sales s
join employees e 
on e.employee_id = s.sales_person_id 
join products p 
on s.product_id = p.product_id --соединение таблиц по связанным полям: "sales_person_id" в таблице "sales" и "employee_id" в таблице "employees", а также "product_id" в таблице "sales" и "product_id" в таблице "products"
group by concat(e.first_name, ' ', e.middle_initial, ' ', e.last_name), sale_date--группировка результатов по имени продавца и дате продажи
order by CASE EXTRACT(DOW FROM sale_date)
        WHEN 0 THEN 6
        ELSE EXTRACT(DOW FROM sale_date) - 1
    END, name --сортировка результатов сначала по дню недели (понедельник идет первым), а затем по имени продавца

