package settings

import (
	_ "embed"

	"github.com/go-yaml/yaml"
)

//go:embed settings.yaml
var settingsFile []byte

type Database struct {
	Host     string `yaml:"host"`
	Port     int    `yaml:"port"`
	User     string `yaml:"user"`
	Password string `yaml:"password"`
	Name     string `yaml:"name"`
}

type Configuration struct {
	DB Database `yaml:"Database"`
}

func Load() (*Configuration, error) {
	config := &Configuration{}
	// content, err := os.ReadFile(file)
	// if err != nil {
	// 	return nil, err
	// }
	err := yaml.Unmarshal(settingsFile, config)
	if err != nil {
		return nil, err
	}
	return config, nil
}
