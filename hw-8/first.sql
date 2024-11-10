-- 1. Create Stored procedure.
-- In this exercise, create a procedure to add a new job into the JOBS table.
-- a. Create a stored procedure called NEW_JOB to enter a new order into the JOBS table. The procedure should accept three parameters.
-- The first and second parameters supply a job ID and a job title.
-- The third parameter supplies the minimum salary.
-- Use the maximum salary for the new job as twice the minimum salary supplied for the job ID.

-- b. Invoke the procedure to add a new job with job ID 'SY_ANAL', job title 'System Analyst', and minimum salary 6,000.

CREATE PROCEDURE NEW_JOB(job_id varchar, job_title varchar, min_salary integer)
LANGUAGE SQL
AS $$
insert into jobs (job_id, job_title, min_salary, max_salary)  values (job_id, job_title, min_salary, min_salary*2)
$$;

call NEW_JOB('SY_ANAL', 'System Analyst', 6000);