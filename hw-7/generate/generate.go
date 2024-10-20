package main

import (
	"database/sql"
	"log"
	"math/rand"
	"time"

	"github.com/go-faker/faker/v4"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

type Country struct {
	Name       string `db:"name"`
	CountryID  string `db:"country_id"`
	AreaSQKM   int64  `db:"area_sqkm"`
	Population int64  `db:"population"`
}

type Olimpic struct {
	OlimpicID string    `db:"olympic_id"`
	CountryID string    `db:"country_id"`
	City      string    `db:"city"`
	Year      int64     `db:"year"`
	StartDate time.Time `db:"startdate"`
	EndDate   time.Time `db:"enddate"`
}

type Player struct {
	Name      string    `db:"name"`
	PlayerID  string    `db:"player_id"`
	CountryID string    `db:"country_id"`
	Birthdate time.Time `db:"birthdate"`
}

type Event struct {
	EventID   string `db:"event_id"`
	Name      string `db:"name"`
	OlimpicID string `db:"olympic_id"`
	EventType string `db:"eventtype"`
	Team      int64  `db:"is_team_event"`
	Players   int64  `db:"num_players_in_team"`
	Noted     string `db:"result_noted_in"`
}

type Result struct {
	EventID  string  `db:"event_id"`
	PlayerID string  `db:"player_id"`
	Medal    string  `db:"medal"`
	Result   float64 `db:"result"`
}

const (
	countryQuery = `insert into countries (name, country_id, area_sqkm, population) VALUES (:name, :country_id, :area_sqkm, :population) returning country_id`
	olimpicQuery = `insert into olympics (olympic_id, country_id, city, year, startdate, enddate) VALUES (:olympic_id, :country_id, :city, :year, :startdate, :enddate)  returning olympic_id`
	playerQuery  = `insert into players (name, player_id, country_id, birthdate) VALUES (:name, :player_id, :country_id, :birthdate) returning player_id`
	eventQuery   = `insert into events 
	(event_id, name, eventtype, olympic_id, is_team_event, num_players_in_team, result_noted_in)
	VALUES (:event_id, :name, :eventtype, :olympic_id, :is_team_event, :num_players_in_team, :result_noted_in) returning event_id`
	resultQuery = `insert into results (event_id, player_id, medal, result) VALUES (:event_id, :player_id, :medal, :result)`
)

var q sqlx.Ext

type seeder struct {
	countriyIDs []string
	olimpicIDs  []string
	playerIDs   []string
	eventIDs    []string
}

func (s *seeder) seed(count int) {
	s.countriyIDs = s.seedCountries(count)
	s.olimpicIDs = s.seedOlimpics(count)
	s.playerIDs = s.seedPlayers(count)
	s.eventIDs = s.seedEvents(count)
	s.seedResults(count)
}

func (s *seeder) seedResults(count int) {
	// ids := make([]string, 0, count)
	var object Result
	objects := make([]Result, 0, count)
	medals := []string{"GOLD", "SILVER", "BRONZE"}
	for range count {
		if err := faker.FakeData(&object); err != nil {
			panic(err)
		}
		object.EventID = s.eventIDs[rand.Intn(len(s.eventIDs))]
		object.PlayerID = s.playerIDs[rand.Intn(len(s.playerIDs))]
		object.Medal = medals[rand.Intn(3)]
		objects = append(objects, object)
		// ids = append(ids, object.EventID)
	}

	if _, err := sqlx.NamedExec(q, resultQuery, objects); err != nil {
		panic(err)
	}

	// return ids
}

func (s *seeder) seedEvents(count int) []string {
	var object Event
	objects := make([]Event, 0, count)
	unique := map[string]bool{}
	for range count {
		if err := faker.FakeData(&object); err != nil {
			panic(err)
		}
		object.Team = object.Team % 2
		object.EventType = object.EventType[:min(20, len(object.EventType))]
		object.EventID = object.EventID[:7]
		if unique[object.EventID] {
			continue
		}
		unique[object.EventID] = true
		object.OlimpicID = s.olimpicIDs[rand.Intn(len(s.olimpicIDs))]
		objects = append(objects, object)
	}

	return getIDS(objects, eventQuery)
}

func (s *seeder) seedPlayers(count int) []string {
	var object Player
	objects := make([]Player, 0, count)
	unique := map[string]bool{}
	for range count {
		if err := faker.FakeData(&object); err != nil {
			panic(err)
		}
		object.PlayerID = object.PlayerID[:10]
		if unique[object.PlayerID] {
			continue
		}
		unique[object.PlayerID] = true
		object.CountryID = s.countriyIDs[rand.Intn(len(s.countriyIDs))]
		objects = append(objects, object)
	}

	return getIDS(objects, playerQuery)
}

func (s *seeder) seedOlimpics(count int) []string {
	var object Olimpic
	objects := make([]Olimpic, 0, count)
	unique := map[string]bool{}
	for range count {
		if err := faker.FakeData(&object); err != nil {
			panic(err)
		}
		object.OlimpicID = object.OlimpicID[:7]
		if unique[object.OlimpicID] {
			continue
		}
		unique[object.OlimpicID] = true
		object.CountryID = s.countriyIDs[rand.Intn(len(s.countriyIDs))]
		objects = append(objects, object)
	}

	return getIDS(objects, olimpicQuery)
}

func (s *seeder) seedCountries(count int) []string {
	var country Country
	countres := make([]Country, 0, count)
	unique := map[string]bool{}
	for range count {
		if err := faker.FakeData(&country); err != nil {
			panic(err)
		}
		country.CountryID = country.CountryID[:3]
		if unique[country.CountryID] {
			continue
		}
		unique[country.CountryID] = true
		countres = append(countres, country)
	}

	return getIDS(countres, countryQuery)
}

func getIDS[T any](objects []T, query string) (ids []string) {
	res, err := sqlx.NamedQuery(q, query, objects)
	if err != nil {
		panic(err)
	}

	var id string
	for res.Next() {
		_ = res.Scan(&id)
		ids = append(ids, id)
	}

	return ids
}

func connString() string {
	return "host=localhost port=5432 user=postgres dbname=postgres password=postgres sslmode=disable"
}

func main() {
	db, err := sql.Open("postgres", connString())
	if err != nil {
		log.Fatalf("Error while connecting to database: %s", err)
	}
	defer db.Close()

	q = sqlx.NewDb(db, "postgres")

	seeder := seeder{}
	seeder.seed(100)
}
