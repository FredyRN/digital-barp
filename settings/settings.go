package config

import (
	"os"

	"github.com/go-yaml/yaml"
)

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

func Load(file string) (*Configuration, error) {
	config := &Configuration{}
	content, err := os.ReadFile(file)
	if err != nil {
		return nil, err
	}
	err = yaml.Unmarshal(content, config)
	if err != nil {
		return nil, err
	}
	return config, nil
}
