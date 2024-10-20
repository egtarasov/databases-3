package main

import (
	"fmt"
	"log"

	"github.com/jmoiron/sqlx"
)

type FirstRecord struct {
	Year         int `db:"birth_year"`
	Count        int `db:"count"`
	GoldenMedals int `db:"golden_medals"`
}

type SecondRecord struct {
	EventID   string `db:"event_id"`
	EventName string `db:"name"`
}

type ThirdRecord struct {
	Name      string `db:"name"`
	OlimpicID string `db:"olympic_id"`
}

type ForthRecord string

type FifthRecord string

const (
	firstTask = `
select
    date_part('year', p.birthdate) birth_year,
    count(*) count,
    count(case when r.medal='GOLD' THEN 1 END) golden_medals
from results r
join players p on p.player_id = r.player_id
join events e on r.event_id = e.event_id
join olympics o on o.olympic_id = e.olympic_id
where o.olympic_id = $1
group by date_part('year', p.birthdate)
`

	secondTask = `
select e.event_id, e.name from results r
join events e on e.event_id = r.event_id
where e.is_team_event=0
group by  e.event_id, e.name
having
    COUNT(distinct case when r.Medal = 'GOLD' then r.player_id end) >= 2
And count(distinct r.result) <> count(*)
`

	thirdTask = `
select p.name, e.olympic_id from results r
join players p on p.player_id = r.player_id
join events e on r.event_id = e.event_id
where r.medal in ('GOLD', 'SILVER', 'BRONZE') and e.olympic_id = $1
group by p.player_id, p.name, e.olympic_id
`

	forthTask = `
select
    country_id
from players p
group by country_id
order by cast(count(case when p.name ~ '^[aeiouAEIOU]'then 1 end) as float) / count(*) desc
limit 1
`

	fithTask = `
select
    c.country_id
from results r
join public.events e on e.event_id = r.event_id
join public.players p on p.player_id = r.player_id
join public.countries c on c.country_id = p.country_id
where e.olympic_id='SYD2000'
group by c.country_id
order by count(case when e.is_team_event=1 and r.medal in ('GOLD', 'SILVER', 'BRONZE') then 1 end) / (select population from countries where c.country_id = country_id)
limit 5
`
)

func task[T any](q sqlx.Queryer, query string, args ...any) {
	result := []T{}
	err := sqlx.Select(q, &result, query, args...)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(len(result), result[:min(len(result), 10)])
}
