create or replace function CHECK_SAL_RANGE()
returns trigger as $$
begin
    if exists (
        select 1 from employees
        where job_id = new.job_id
        and (salary < new.min_salary or salary > new.max_salary)
    ) then
        raise exception 'updating min_salary to % and max_salary to % will leave an employee''s salary % out of range.',
            new.min_salary, new.max_salary;
    end if;
    return new;
end;
$$ language plpgsql;

create trigger CHECK_SAL_RANGE
before update of min_salary, max_salary on jobs
for each row
execute function CHECK_SAL_RANGE();


call UPD_JOBSAL('SY_ANAL', 6000, 10000);

select job_id, min_salary, max_salary from jobs where job_id = 'SY_ANAL'; -- 6000, 10000
select employee_id, last_name, salary from employees where job_id = 'SY_ANAL' order by  salary; -- 6500, 6500, 7000
-- We did not have this trigger in task 3.
call UPD_JOBSAL('SY_ANAL', 5000, 7000);
select job_id, min_salary, max_salary from jobs where job_id = 'SY_ANAL'; -- 5000, 7000
select employee_id, last_name, salary from employees where job_id = 'SY_ANAL' order by  salary; -- 6500, 6500, 7000

call UPD_JOBSAL('SY_ANAL', 7000, 18000); -- ERROR: updating min_salary to 7000 and max_salary to 10000 will leave an employee's salary out of range.
