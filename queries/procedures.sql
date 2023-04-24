-- Procedure that sets all employees salary to the base level based on their job title
CREATE OR REPLACE PROCEDURE procedure_emp_salary()
AS $$
BEGIN
    UPDATE employee
    SET salary = (SELECT base_salary FROM job_title WHERE j_id = employee.j_id);
END;
$$ LANGUAGE plpgsql;

-- CALL procedure_emp_salary();
-- SELECT salary FROM employee; 

-- Procedure that adds 3 months to all temporary contracts
CREATE OR REPLACE PROCEDURE procedure_add_months()
AS $$
BEGIN
    UPDATE employee
    SET contract_end = (contract_end + INTERVAL '3 MONTHS') 
    WHERE employee.contract_type = 'Temporary';
END;
$$ LANGUAGE plpgsql; 

-- CALL procedure_add_months();
-- SELECT contract_type, contract_end FROM employee WHERE contract_type = 'Temporary' ORDER BY contract_end;

-- Procedure that increases salaries by a precentage based on the given precentage
CREATE OR REPLACE PROCEDURE procedure_inc_salary(salary_limit INTEGER)
AS $$
BEGIN
    IF salary_limit IS NOT NULL AND salary_limit > 0 THEN
        UPDATE employee
        SET salary = (salary * salary_limit/100);
    END IF; 
END; 
$$ LANGUAGE plpgsql;

-- CALL procedure_inc_salary(INSERT NUMBER HERE);
-- SELECT emp_name, salary FROM employee ORDER BY emp_name;

-- Procedure that calculates the correct salary based on the acquired skills
CREATE OR REPLACE PROCEDURE procedure_calc_salary()
AS $$
DECLARE old_salary INTEGER;
BEGIN
SELECT salary INTO old_salary FROM employee; 
 UPDATE employee
    SET salary = old_salary + (SELECT SUM(salary_benefit_value) FROM skills 
                WHERE s_id IN (SELECT s_id FROM employee_skills
                                WHERE e_id = employee.e_id))
    WHERE EXISTS (SELECT 1 FROM employee_skills WHERE e_id = employee.e_id);
END;
$$ LANGUAGE plpgsql;

--CALL procedure_calc_salary();

--Tested via the following query:
-- SELECT employee.e_id,
-- 	employee_skills.s_id,
-- 	employee.emp_name,
-- 	employee.salary,
-- 	skills.skill,
-- 	skills.salary_benefit,
-- 	skills.salary_benefit_value
-- FROM employee
-- INNER JOIN employee_skills ON employee.e_id = employee_skills.e_id
-- INNER JOIN skills ON employee_skills.s_id = skills.s_id
-- ORDER BY employee.e_id;
