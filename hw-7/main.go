package main

import (
	"database/sql"
	"log"

	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

func connString() string {
	return "host=localhost port=5432 user=postgres dbname=postgres password=postgres sslmode=disable"
}

var db *sql.DB

func main() {
	var err error
	db, err = sql.Open("postgres", connString())
	if err != nil {
		log.Fatalf("Error while connecting to database: %s", err)
	}
	defer db.Close()

	if err := runMigrations(db); err != nil {
		log.Fatalf("Could not run migrations: %v", err)
	}

	q := sqlx.NewDb(db, "postgres")
	// Scripts

	task[FirstRecord](q, firstTask, "ATH2004")
	task[SecondRecord](q, secondTask)
	task[ThirdRecord](q, thirdTask, "ATH2004")
	task[ForthRecord](q, forthTask)
	task[FifthRecord](q, fithTask)
}

func runMigrations(db *sql.DB) error {
	driver, err := postgres.WithInstance(db, &postgres.Config{})
	if err != nil {
		return err
	}

	m, err := migrate.NewWithDatabaseInstance(
		"file:///Users/egtarasov/University/db/hw-7/migrations",
		"postgres",
		driver,
	)

	if err != nil {
		return err
	}

	err = m.Up()
	if err != nil && err != migrate.ErrNoChange {
		return err
	}

	return nil
}
