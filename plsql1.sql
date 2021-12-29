SET SERVEROUTPUT ON
CREATE OR REPLACE PACKAGE  sales AS
--add product
   PROCEDURE add_products(
   p_name     product.product_name%type,
   p_desc     product.description%type,
   p_cost     product.standard_cost%type,  
   p_price    product.list_price%type,
   p_catagory product.category_id%type,
   p_status  out varchar2,
   p_error   out  varchar2);
 -- Removes a product
PROCEDURE remove_product(p_id   product.product_id%type,
                         p_status out varchar2,
                         p_error out varchar2);
--end PAK_EMP;
--add employee
PROCEDURE  add_employee(
p_first_name  employees.first_name % type,
p_last_name   employees.last_name %type,
p_email       employees.email%type,
p_mobNo       employees.phonenumber%type,
p_hire_date   employees.hire_date %type,
p_manager_id  employees.manager_id %type,
p_job_title   employees.job_title% type,
e_status out varchar2,e_error out varchar2);

--remove employees
PROCEDURE remove_employees(e_id employees.employee_id%type,e_status out varchar2,e_error out varchar2);
                              
                              
--add customer
   PROCEDURE add_customer(
   c_name    customers.name%type,
   c_ad      customers.address%type,
   c_website customers.website%type,
   c_limit   customers.credit_limit%type,c_status out varchar2,c_error out varchar2);
  --remove customer
  PROCEDURE remove_customer(c_id customers.customer_id%type,c_status out varchar2,c_error out varchar2);

--add orders
 PROCEDURE add_orders(
 c_id in number,o_status in varchar2,
 s_id in number,o_date in date,
 ord_status out varchar2,ord_error out varchar2);
--cancel order
 PROCEDURE cancel_order(o_id in number,
                        ord_status out varchar2,
                        ord_error out varchar2);
 --add order_items
 PROCEDURE add_order_items(o_id in number,i_id in number ,
                           p_id in number,quan in number,
                            u_price in number,
                            o_status out varchar2,o_error out varchar2);
 --delete order_items
 PROCEDURE remove_order_items(o_id in number,
                              o_status out varchar2,o_error out varchar2);
 --add category
 PROCEDURE add_category(ca_id in  varchar2,ca_name in varchar2,
                        ca_status out varchar2,ca_error out varchar2);
 --remove category
 PROCEDURE remove_category(ca_id in product_categories.category_id%type,
                          ca_status out varchar2,ca_error out varchar2);
end sales;
/

CREATE OR REPLACE PACKAGE BODY sales as
PROCEDURE add_products(
   p_name     product.product_name %type,
   p_desc     product.description%type,
   p_cost     product.standard_cost%type,  
   p_price    product.list_price%type,
   p_catagory product.category_id%type,
   p_status  out varchar2,
   p_error   out  varchar2)
   IS
   BEGIN
      INSERT INTO product (product_name,description,standard_cost,list_price,category_id)
         VALUES( p_name, p_desc, p_cost, p_price,p_catagory);
         if sql%rowcount>0
         then p_status:='product inserted';
         end if;
         commit;
         EXCEPTION
         
         when others then
         p_status:='p_name'||' '||'product not inserted';
         p_error:=sqlcode||sqlerrm;
   END add_products;
   
   PROCEDURE remove_product(p_id   product.product_id%type,p_status out varchar2,p_error out varchar2) IS
   BEGIN
      DELETE FROM product
      WHERE product_id = p_id;
      if sql%rowcount>0
      then p_status:='Product Id:'||p_id||' '||'Deleted';
      end if;
      if sql%rowcount=0
      then p_status:='Product Id:'||p_id||' '||' Not Deleted';
      end if;
      commit;
         EXCEPTION
        when no_data_found then
         DBMS_OUTPUT.PUT_LINE('Employee id '||' '|| p_id || ' '|| 'does not found');
         when others then
         p_status:='no data found';
         p_error:=sqlcode||sqlerrm;
         
   END remove_product;

PROCEDURE  add_employee(
p_first_name  employees.first_name % type,
p_last_name   employees.last_name %type,
p_email       employees.email%type,
p_mobNo       employees.phonenumber%type,
p_hire_date   employees.hire_date %type,
p_manager_id  employees.manager_id %type,
p_job_title   employees.job_title% type,
e_status out varchar2,e_error out varchar2)
is
BEGIN
INSERT INTO EMPLOYEES( first_name,last_name,email,phonenumber,hire_date,manager_id,job_title)
            values(p_first_name,p_last_name,p_email,p_mobNo,p_hire_date,p_manager_id,p_job_title);
             if sql%rowcount>0
         then e_status:='employee inserted';
         end if;
         commit;
         EXCEPTION
         when others then
         e_status:='employee not inserted';
         e_error:=sqlcode||sqlerrm;
END add_employee;

PROCEDURE remove_employees(e_id employees.employee_id%type,e_status out varchar2,e_error out varchar2)IS
  BEGIN
      DELETE FROM employees WHERE employee_id=e_id;
      if sql%rowcount>0
         then e_status:=e_id||' '||'DELETED';
         end if;
        if sql%rowcount=0
        then e_status:=e_id||' '||'not deleted';
        end if;
         commit;
         EXCEPTION
         when no_data_found then
         DBMS_OUTPUT.PUT_LINE('Employee id '||' '|| e_id || ' '|| 'does not found');
         when others then
         e_status:='Employee ID'||e_id||' '|| 'not deleted';
         e_error:=sqlcode||sqlerrm;
  END remove_employees;
  
  
  PROCEDURE add_customer(
   c_name customers.name%type,
   c_ad customers.address%type,
   c_website customers.website%type,
   c_limit customers.credit_limit%type,c_status out varchar2,c_error out varchar2)IS
   BEGIN
   INSERT INTO customers(name,address,website,credit_limit )
   VALUES(c_name,c_ad,c_website,c_limit);
   if sql%rowcount>0
         then c_status:='inserted';
         end if;
         commit;
         EXCEPTION
         when others then
         c_status:='not inserted';
         c_error:=sqlcode||sqlerrm;
   END add_customer;
   
   PROCEDURE remove_customer(c_id customers.customer_id%type,c_status out varchar2,c_error out varchar2)IS
   BEGIN
   DELETE FROM customers WHERE customer_id=c_id;
   if sql%rowcount>0
         then c_status:='deleted';
         end if;
         if sql%rowcount=0
         then 
         c_status:=' not deleted';
         end if;
         commit;
         EXCEPTION
         when no_data_found then
         DBMS_OUTPUT.PUT_LINE('customer id '||c_id||' '|| 'does not found');
         when others then
         c_status:='Customer ID'||c_id||' '||'not found';
         c_error:=sqlcode||sqlerrm;
   END remove_customer;
   
--add orders
 PROCEDURE add_orders(
 c_id in number,o_status in varchar2,
 s_id in number,o_date in date,
 ord_status out varchar2,ord_error out varchar2)
 IS
 BEGIN
 INSERT INTO orders(customer_id ,status,salesman_id ,order_date)
 VALUES(c_id,o_status,s_id,o_date);
 if sql%rowcount>0
         then ord_status:='inserted';
         end if;
         commit;
        
         EXCEPTION
         when others then
         ord_status:='not inserted';
         ord_error:=sqlcode||sqlerrm;
 END add_orders;

 
 PROCEDURE cancel_order(o_id in number,
                        ord_status out varchar2,
                        ord_error out varchar2) IS
 BEGIN
 UPDATE orders SET status='cancelled' where order_id=o_id;
 if sql%rowcount>0
         then ord_status:='cancelled';
         end if;
         if sql%rowcount=0
        then ord_status:='not cancelled';
        end if;
        commit;
         EXCEPTION
         when others then
        ord_status:='not cancelled';
         ord_error:=sqlcode||sqlerrm;
 END cancel_order;
 
PROCEDURE add_order_items(o_id in number,i_id in number ,
                           p_id in number,quan in number,
                            u_price in number,
                            o_status out varchar2,o_error out varchar2)
IS
BEGIN
 INSERT INTO order_item(order_id ,item_id ,product_id ,quantity ,unit_price)
 values(o_id,i_id,p_id,quan,u_price);
 if sql%rowcount>0
         then o_status:='inserted';
         end if;
         commit;
         EXCEPTION
         when others then
         o_status:='not inserted';
         o_error:=sqlcode||sqlerrm;
 END add_order_items;
 
  PROCEDURE remove_order_items(o_id in number,
                              o_status out varchar2,o_error out varchar2)IS
  BEGIN
   DELETE FROM order_item WHERE order_id=o_id;
   if sql%rowcount>0
         then o_status:='deleted';
         end if;
          if sql%rowcount=0
        then o_status:='not deleted';
        end if;
         commit;
         EXCEPTION
         when others then
         o_status:='not deleted';
         o_error:=sqlcode||sqlerrm;
   END remove_order_items;
   --add category
   PROCEDURE add_category(ca_id in  varchar2,ca_name in varchar2,
                        ca_status out varchar2,ca_error out varchar2) is
   begin
   insert into product_categories (category_id,category_name)values(ca_id,ca_name);
   if sql%rowcount>0
         then ca_status:='inserted';
         end if;
         commit;
         EXCEPTION
         when others then
         ca_status:='not inserted';
         ca_error:=sqlcode||sqlerrm;
 END add_category;
 --remove category
 
 PROCEDURE remove_category(ca_id in product_categories.category_id%type,
                          ca_status out varchar2,ca_error out varchar2) is
 begin
 delete from product_categories where category_id=ca_id;
 if sql%rowcount>0
         then ca_status:='deleted';
         end if;
          if sql%rowcount=0
        then ca_status:='not deleted';
        end if;
         commit;
         EXCEPTION
         when others then
         ca_status:='not deleted';
         ca_error:=sqlcode||sqlerrm;
   END remove_category;
end  sales;
/

select * from product;
--ADD PRODUCT
DECLARE 
   p_status varchar2(20);
   p_error varchar2(300);
BEGIN
  sales.add_products('MOBILE HOLDER','HOLDER WITH CHARGER FOR BIKES',1400,1500,'C3',p_status,p_error);
  DBMS_OUTPUT.PUT_LINE(p_status||' '||p_error);
  end;
--DELETE PRODUCT
SET SERVEROUTPUT ON
DECLARE 
     pro_id product.product_id%type:=&enter_id;
     p_status varchar2(200);
     p_error varchar2(500);
      
BEGIN
   sales.remove_product(pro_id,p_status,p_error);
   dbms_output.put_line(p_status||' '||p_error);
end remove_product;
select * from employees;
--ADD EMPLOYEE
DECLARE
   e_status varchar2(20);
   e_error varchar2(200);
BEGIN
   sales.add_employee('LENIN','RAJ', 'lenin@gmail.com', '9876543450', '18-10-2018',21, 'SALES',e_status,e_error);
      dbms_output.put_line(e_status||' '||e_error);
end add_employee;
--DELETE employee
DECLARE 
     emp_id employees.employee_id%type:=&enter_id;
     e_status varchar2(200);
     e_error varchar2(500);
BEGIN
   sales.remove_employees(emp_id,e_status,e_error);
   dbms_output.put_line(e_status||' '||e_error);
end remove_employees;
select * from customers;
--ADD customer
DECLARE
   c_status varchar2(20);
   c_error varchar2(200);
BEGIN
   sales.add_customer('DEVA','Berkeley Gardens 12 Brewery','www.amazon.com','6000',c_status,c_error);
      dbms_output.put_line(c_status||' '||c_error);
end add_customer;
--DELETE customer
DECLARE 
     cus_id customers.customer_id%type:=&enter_id;
     c_status varchar2(200);
     c_error varchar2(500);
BEGIN
   sales.remove_customer(cus_id,c_status,c_error);
   dbms_output.put_line(c_status||' '||c_error);
end remove_customer;
select * from orders;
--ADD orders
DECLARE
    ord_status varchar2(30);
    ord_error varchar2(300);
BEGIN
    sales.add_orders(108,'PENDING',110,'29-11-2021',ord_status,ord_error);
    dbms_output.put_line(ord_status||' '||ord_error);
end add_orders;
--cancel orders
DECLARE
    o_id integer:=&Enter_o_id;
    status varchar2(200);
    or_error varchar2(500);
BEGIN
    sales.cancel_order(o_id,status,or_error);
    dbms_output.put_line(status||' '||or_error);
end cancel_order;

select * from order_item;
--add order_items
DECLARE
    status varchar2(200);
    o_error varchar2(300);
BEGIN
    sales.add_order_items(2,1,2,1,30000,status,o_error);
     dbms_output.put_line(status||' '||o_error);
end add_order_items;
DECLARE
    o_id integer:=&Enter_o_id;
    status varchar2(200);
    o_error varchar2(300);
BEGIN
    sales.remove_order_items(o_id,status,o_error);
          dbms_output.put_line(status||' '||o_error);

end remove_order_items;


select * from product_categories;
set serveroutput on
--add category
DECLARE
   ca_status varchar2(200);
   ca_error varchar2(400);
BEGIN
  sales.add_category('C1','ELECTRONICS',ca_status,ca_error);
      dbms_output.put_line(ca_status||' '||ca_error);
end add_category;
--delete category
 declare
 ca_id  VARCHAR2(80) := '&enter_id';
 ca_status varchar2(200);
  ca_error varchar2(400);
begin
  sales.remove_category(ca_id,ca_status,ca_error);
  dbms_output.put_line(ca_status||' '||ca_error);
end;
/

 select * from product;
 select * from employees;
 select * from customers;
 select * from orders;
 select * from order_item;
 select * from product_categories;
 desc product_categories;