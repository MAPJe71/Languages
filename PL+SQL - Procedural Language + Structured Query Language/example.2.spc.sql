-- Package specification:

CREATE OR REPLACE PACKAGE emp_actions AS

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
  );

  PROCEDURE fire_employee (emp_id NUMBER);

  FUNCTION num_above_salary (emp_id NUMBER) RETURN NUMBER;
END emp_actions;
/