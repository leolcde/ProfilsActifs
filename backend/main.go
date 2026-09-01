package main

import (
	"fmt"
	"net/http"
)

func handler(res http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(res, "Hello, world!")
}

func health(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	res.WriteHeader(http.StatusOK)
	fmt.Fprintf(res, `{"status":"ok"}`)
}

func main() {
	http.HandleFunc("/", handler)
	http.HandleFunc("/health", health)

	fmt.Println("serv up in http://localhost:8080")

	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		fmt.Println("Erreur:", err)
	}
}
