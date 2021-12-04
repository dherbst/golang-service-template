package main

import (
	"log"

	srvname "github.com/dherbst/golang-service-template"
)

func main() {
	log.Println("srvnamed start")
	srvname.StartServer()
}
