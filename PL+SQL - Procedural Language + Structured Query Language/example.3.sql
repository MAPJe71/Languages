-- create the audit table to track changes
CREATE TABLE emp_audit(date_of_action DATE, user_id VARCHAR2(20), 
                       package_name VARCHAR2(30));

CREATE OR REPLACE PACKAGE emp_admin AS
-- Declare externally visible types, cursor, exception
   TYPE EmpRecTyp IS RECORD (emp_id NUMBER, sal NUMBER);
   CURSOR desc_salary RETURN EmpRecTyp;
   invalid_salary EXCEPTION;
-- Declare externally callable subprograms
   FUNCTION hire_employee (last_name VARCHAR2,
                           first_name VARCHAR2,
                           email VARCHAR2,
                           phone_number VARCHAR2,
                           job_id VARCHAR2,
                           salary NUMBER,
                           commission_pct NUMBER,
                           manager_id NUMBER,
                           department_id NUMBER)
     RETURN NUMBER;
   PROCEDURE fire_employee
     (emp_id NUMBER); -- overloaded subprogram
   PROCEDURE fire_employee
     (emp_email VARCHAR2); -- overloaded subprogram
   PROCEDURE raise_salary (emp_id NUMBER, amount NUMBER);
   FUNCTION nth_highest_salary (n NUMBER) RETURN EmpRecTyp;
END emp_admin;
/

CREATE OR REPLACE PACKAGE BODY emp_admin AS
   number_hired NUMBER;  -- visible only in this package
-- Fully define cursor specified in package
   CURSOR desc_salary RETURN EmpRecTyp IS
      SELECT employee_id, salary
      FROM employees
      ORDER BY salary DESC;
-- Fully define subprograms specified in package
   FUNCTION hire_employee (last_name VARCHAR2,
                           first_name VARCHAR2,
                           email VARCHAR2,
                           phone_number VARCHAR2,
                           job_id VARCHAR2,
                           salary NUMBER,
                           commission_pct NUMBER,
                           manager_id NUMBER,
                           department_id NUMBER)
     RETURN NUMBER IS new_emp_id NUMBER;
   BEGIN

      new_emp_id := employees_seq.NEXTVAL;
      INSERT INTO employees VALUES (new_emp_id,
                                    last_name,
                                    first_name,
                                    email,
                                    phone_number,
                                    SYSDATE,
                                    job_id,
                                    salary,
                                    commission_pct,
                                    manager_id,
                                    department_id);
      number_hired := number_hired + 1;
      DBMS_OUTPUT.PUT_LINE('The number of employees hired is ' 
                           || TO_CHAR(number_hired) );   
      RETURN new_emp_id;
   END hire_employee;
   PROCEDURE fire_employee (emp_id NUMBER) IS
   BEGIN
      DELETE FROM employees WHERE employee_id = emp_id;
   END fire_employee;
   PROCEDURE fire_employee (emp_email VARCHAR2) IS
   BEGIN
      DELETE FROM employees WHERE email = emp_email;
   END fire_employee;
  -- Define local function, available only inside package
   FUNCTION sal_ok (jobid VARCHAR2, sal NUMBER) RETURN BOOLEAN IS
      min_sal NUMBER;
      max_sal NUMBER;
   BEGIN
      SELECT MIN(salary), MAX(salary)
        INTO min_sal, max_sal
        FROM employees
        WHERE job_id = jobid;
      RETURN (sal >= min_sal) AND (sal <= max_sal);
   END sal_ok;
   PROCEDURE raise_salary (emp_id NUMBER, amount NUMBER) IS
      sal NUMBER(8,2);
      jobid VARCHAR2(10);
   BEGIN
      SELECT job_id, salary INTO jobid, sal
        FROM employees
        WHERE employee_id = emp_id;
      IF sal_ok(jobid, sal + amount) THEN
         UPDATE employees SET salary =
           salary + amount WHERE employee_id = emp_id;
      ELSE
         RAISE invalid_salary;
      END IF;
   EXCEPTION  -- exception-handling part starts here
     WHEN invalid_salary THEN
       DBMS_OUTPUT.PUT_LINE
         ('The salary is out of the specified range.');
   END raise_salary;
   FUNCTION nth_highest_salary (n NUMBER) RETURN EmpRecTyp IS
      emp_rec EmpRecTyp;
   BEGIN
      OPEN desc_salary;
      FOR i IN 1..n LOOP
         FETCH desc_salary INTO emp_rec;
      END LOOP;
      CLOSE desc_salary;
      RETURN emp_rec;
   END nth_highest_salary;
BEGIN  -- initialization part starts here
   INSERT INTO emp_audit VALUES (SYSDATE, USER, 'EMP_ADMIN');
   number_hired := 0;
END emp_admin;
/

-- invoking the package procedures
DECLARE
  new_emp_id NUMBER(6);
BEGIN
  new_emp_id := emp_admin.hire_employee ('Belden',
                                         'Enrique',
                                         'EBELDEN',
                                         '555.111.2222',
                                         'ST_CLERK',
                                         2500,
                                         .1,
                                         101,
                                         110);
  DBMS_OUTPUT.PUT_LINE
    ('The new employee id is ' || TO_CHAR(new_emp_id));
  EMP_ADMIN.raise_salary(new_emp_id, 100);
  DBMS_OUTPUT.PUT_LINE('The 10th highest salary is '|| 
    TO_CHAR(emp_admin.nth_highest_salary(10).sal) || ',
            belonging to employee: ' ||
            TO_CHAR(emp_admin.nth_highest_salary(10).emp_id));
  emp_admin.fire_employee(new_emp_id);
-- you can also delete the newly added employee as follows:
--  emp_admin.fire_employee('EBELDEN');
END;
/
