package database

import (
	"context"
	"database/sql"
	"fmt"

	"github.com/FredyRN/digital-barp/settings"
	_ "github.com/lib/pq"
)

func Connection(DBEngine string, db_context context.Context, config *settings.Configuration) *sql.DB {
	connectionString := fmt.Sprintf(
		"host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		config.DB.Host,
		config.DB.Port,
		config.DB.User,
		config.DB.Password,
		config.DB.Name,
	)
	db, err := sql.Open(DBEngine, connectionString)
	if err != nil {
		panic(err)
	}
	err = db.PingContext(db_context)
	if err != nil {
		panic(err)
	}
	fmt.Println(db)
	return db
}
