package srvname

import (
	"log"
	"net/http"
	"os"
)

func StartServer() {
	addr := os.Getenv("SRV_ADDR")
	if addr == "" {
		addr = ":8000"
	}

	log.Printf("StartServer addr=%v\n", addr)
	log.Fatal(http.ListenAndServe(addr, nil))
}
