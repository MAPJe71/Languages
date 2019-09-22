-- Package body:

CREATE OR REPLACE PACKAGE BODY emp_actions AS

  -- Code for procedure hire_employee:

  PROCEDURE hire_employee (
    employee_id     NUMBER,
    last_name       VARCHAR2,
    first_name      VARCHAR2,
    email           VARCHAR2,
    phone_number    VARCHAR2,
    hire_date       DATE,
    job_id          VARCHAR2,
    salary          NUMBER,
    commission_pct  NUMBER,
    manager_id      NUMBER,
    department_id   NUMBER
  ) IS
  BEGIN
    INSERT INTO employees
      VALUES (employee_id,
              last_name,
              first_name,
              email,
              phone_number,
              hire_date,
              job_id,
              salary,
              commission_pct,
              manager_id,
              department_id);
  END hire_employee;

  -- Code for procedure fire_employee:

  PROCEDURE fire_employee (emp_id NUMBER) IS
  BEGIN
    DELETE FROM employees
      WHERE employee_id = emp_id;
  END fire_employee;

  -- Code for function num_above_salary:

  FUNCTION num_above_salary (emp_id NUMBER) RETURN NUMBER IS
    emp_sal NUMBER(8,2);
    num_count NUMBER;
  BEGIN
    SELECT salary INTO emp_sal
      FROM employees
        WHERE employee_id = emp_id;

    SELECT COUNT(*) INTO num_count
      FROM employees
        WHERE salary > emp_sal;

    RETURN num_count;
  END num_above_salary;
END emp_actions;
/