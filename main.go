package main

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"github.com/FredyRN/digital-barp/settings"
)

func main() {
	conf, err := settings.Load("settings.yml")
	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "It works!")
	})
	e.Logger.Fatal(e.Start(":1323"))
}
