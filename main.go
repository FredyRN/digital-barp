package main

import (
	"context"
	"net/http"

	"github.com/FredyRN/digital-barp/database"
	"github.com/FredyRN/digital-barp/settings"
	"github.com/labstack/echo/v4"
)

func main() {
	context_db := context.Background()
	conf, err := settings.Load()
	if err != nil {
		panic(err)
	}
	// Database connection
	db := database.Connection("postgres", context_db, conf)
	defer db.Close()
	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "It works!")
	})
	e.Logger.Fatal(e.Start(":1323"))
}
