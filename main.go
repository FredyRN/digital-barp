package main

import (
	"github.com/FredyRN/go-inventory/settings"
	"go.uber.org/fx"
	"log"
)

func main() {
	app := fx.New(
		fx.Provide(
			settings.New,
		),
		fx.Invoke(
			func(s *settings.Settings) {
				log.Println(s)
			},
		),
	)

	app.Run()
}
