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
    
   select count(distinct sale_date) from sales
   
   2
   
   select concat(extract(year from sale_date), '-', LPAD(EXTRACT(MONTH FROM sale_date)::TEXT, 2, '0')) as date,--извлекаем год из столбца sale_date, месяц из sale_date и преобразуем его в текстовый формат, lpad добавляет нoль в начало текстовой строки месяца, если месяц представлен одной цифрой. Это используется для форматирования месяца в виде двухзначного числа
   count(distinct customer_id) as total_customers,--считаем количество уникальных покупателей в каждом месяце
   floor(sum(price * quantity)) as income --вычисляем общий доход в каждом месяце, умножая цену (price) на количество (quantity) и округляя результат вниз до целого числа
   from sales s
   join products p
   on s.product_id = p.product_id
   group by date
   order by date;

  
  
  3
  with tab as(
  select customer_id,
  min(sale_date) as first_ph_sale_date
  from sales s
  group by customer_id)--создание временной таблицы tab, которая вычисляет для каждого customer_id дату первой покупки с использованием функции MIN(sale_date) и группировки по customer_id
  
  select distinct(CONCAT(c.first_name, ' ', c.middle_initial, ' ', c.last_name)) as customer,
  sale_date,
  CONCAT(e.first_name, ' ', e.middle_initial, ' ', e.last_name) as seller--выборка данных из таблиц customers, sales, products и employees, имена продавцов и покупателей соединяем с помощью concat
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

  