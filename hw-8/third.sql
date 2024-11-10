create or replace procedure UPD_JOBSAL(job_id varchar, new_min_salary integer, new_max_salary integer)
language plpgsql
as $$
begin
    if new_max_salary < new_min_salary then
        raise exception 'The maximum salary (%) must be greater than the minimum salary (%)', new_max_salary, new_min_salary;
    end if;

    update jobs j
    set
        min_salary = new_min_salary,
        max_salary = new_max_salary
    where j.job_id = UPD_JOBSAL.job_id;

    if not found then
        raise exception 'Job ID (%) not found', job_id;
    end if;

exception
    when sqlstate '55P03' then
        raise exception 'The row is locked';
end;
$$;


call UPD_JOBSAL('SY_ANAL', 7000, 140);


alter table employees disable trigger all;
alter table jobs disable trigger all;

call UPD_JOBSAL('SY_ANAL', 7000, 14000);

select job_id, jobs.min_salary, jobs.max_salary from jobs where job_id='SY_ANAL';

call UPD_JOBSAL('dskmgjldsjlkgsad', 7000, 14000);

alter table employees enable trigger all;
alter table jobs enable trigger all;
