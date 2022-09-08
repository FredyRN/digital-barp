package main

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"github.com/FredyRN/digital-barp/settings"
)

func main() {
	config, err := settings.Load("config.yml")
	if err != nil {
		return err
	}
	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "It works!")
	})
	e.Logger.Fatal(e.Start(":1323"))
}
