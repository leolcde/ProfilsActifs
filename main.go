package main

import (
	"fmt"
	"net/http"
	"encoding/json"
)

var nextID = 1
var comptes []Compte

type Compte struct {
	ID int `json:"id"`
	Titulaire string `json:"titulaire"`
	Solde float64 `json:"solde"`
}

func (c *Compte) Deposer(montant float64) {
	c.Solde = c.Solde + montant
}

func (c Compte) Afficher() string {
	return fmt.Sprintf("Compte de %s : %f", c.Titulaire, c.Solde)
}

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Bonjour depuis Go !")
}

func compteHandler(w http.ResponseWriter, r *http.Request) {
    devi := Compte{Titulaire: "Devi", Solde: 150}
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(devi)
}
func creerCompte(w http.ResponseWriter, r *http.Request) {
	
}

func main() {
    http.HandleFunc("/", handler)
    http.HandleFunc("/compte", compteHandler)
    fmt.Println("Serveur lancé sur http://localhost:8080")
    http.ListenAndServe(":8080", nil)
}
