create or replace procedure ADD_JOB_HIST(emp_id integer, new_job_id varchar)
language plpgsql
as $$
begin
    alter table employees disable trigger all;
    alter table jobs disable trigger all;
    alter table job_history disable trigger all;

    if not exists (select 1 from employees e where e.employee_id = emp_id) then
        raise exception 'employee does not exist';
    end if;


    insert into job_history (employee_id, start_date, end_date, job_id, department_id)
    select e.employee_id, e.hire_date, current_date, e.job_id, e.department_id from employees e where e.employee_id = emp_id;

    update employees
    set job_id = new_job_id,
        hire_date = current_date,
        salary = (select min_salary+500 from jobs where job_id = new_job_id)
    where employee_id = emp_id;

    alter table employees enable trigger all;
    alter table jobs enable trigger all;
    alter table job_history enable trigger all;

    commit;
exception
    when no_data_found then
        raise exception 'job id not found';
    when others then
        raise;
end;
$$;



CALL ADD_JOB_HIST(101, 'SY_ANAL');
