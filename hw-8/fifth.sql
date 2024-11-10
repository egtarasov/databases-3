create or replace function GET_JOB_COUNT(emp_id integer)
returns integer as $$
declare
    job_count integer;
begin
    if not exists (select 1 from employees where employee_id = emp_id) then
        raise exception 'invalid employee ID: %', emp_id;
    end if;

    select count(distinct job_id) into job_count
    from (
        select job_id from job_history where employee_id = emp_id
        union
        select job_id from employees where employee_id = emp_id
    ) as jobs;

    return job_count;
exception
    when others then
        raise;
end;
$$ language plpgsql;

select GET_JOB_COUNT(176); -- 2
