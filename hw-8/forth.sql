
create or replace function GET_YEARS_SERVICE(emp_id integer)
returns integer as $$
declare
    years_of_service integer;
begin
    select extract(year from age(current_date, hire_date)) into years_of_service
    from employees
    where employee_id = emp_id;

    if years_of_service is null then
        raise exception 'invalid employee id: %', emp_id;
    end if;

    return years_of_service;
exception
    when others then
        raise;
end;
$$ language plpgsql;



do $$
begin
    raise notice 'years of service: %', GET_YEARS_SERVICE(999);
end;
$$;

do $$
begin
    raise notice 'years of service: %', GET_YEARS_SERVICE(106); -- years of service: 1
end;
$$;

select employee_id, hire_date, current_date from employees e where e.employee_id=106; -- 106, 2022-12-15, 2024-11-10 (almost 2 years)

