package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"time"
	"github.com/lib/pq"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var db *gorm.DB

type Question struct {
	ID        uint           `gorm:"primaryKey"`
	Content   string
	Options   pq.StringArray `gorm:"type:text[]"`
	Weight    int
	CreatedAt time.Time
}

type QuestionsAnswer struct {
	ID         uint           `gorm:"primaryKey"`
	ProfileID  uint
	QuestionID uint
	Options    pq.StringArray `gorm:"type:text[]"`
	CreatedAt  time.Time
}

type CertificationResult struct {
	ID          uint `gorm:"primaryKey"`
	ProfileID   uint
	TotalScore  int
	BadgeEarned bool
	CreatedAt   time.Time
}

// corsMiddleware ajoute les en-têtes nécessaires pour que le frontend Vue
// (sur un port différent, ex: localhost:5173) puisse appeler cette API.
func corsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		// Le navigateur envoie une requête OPTIONS "de vérification" avant
		// la vraie requête (preflight) ; on répond OK sans aller plus loin.
		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusOK)
			return
		}

		next.ServeHTTP(w, r)
	})
}

func listerQuestionsHandler(w http.ResponseWriter, r *http.Request) {
	var questions []Question
	db.Find(&questions)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(questions)
}

func demarrerQuestionnaireHandler(w http.ResponseWriter, r *http.Request) {
	var body struct {
		ProfileID uint `json:"profile_id"`
	}
	json.NewDecoder(r.Body).Decode(&body)

	db.Where("profile_id = ?", body.ProfileID).Delete(&QuestionsAnswer{})

	fmt.Fprintf(w, "Questionnaire réinitialisé pour le profil %d", body.ProfileID)
}

func enregistrerReponseHandler(w http.ResponseWriter, r *http.Request) {
	var body struct {
		ProfileID  uint     `json:"profile_id"`
		QuestionID uint     `json:"question_id"`
		Options    []string `json:"options"`
	}
	json.NewDecoder(r.Body).Decode(&body)

	reponse := QuestionsAnswer{
		ProfileID:  body.ProfileID,
		QuestionID: body.QuestionID,
		Options:    body.Options,
	}

	result := db.Create(&reponse)
	if result.Error != nil {
		fmt.Println("Erreur d'insertion :", result.Error)
		http.Error(w, "Impossible d'enregistrer la réponse", http.StatusBadRequest)
		return
	}

	fmt.Fprintf(w, "Réponse enregistrée pour la question %d", body.QuestionID)
}

func validerQuestionnaireHandler(w http.ResponseWriter, r *http.Request) {
	var body struct {
		ProfileID uint `json:"profile_id"`
	}
	json.NewDecoder(r.Body).Decode(&body)

	var reponses []QuestionsAnswer
	db.Where("profile_id = ?", body.ProfileID).Find(&reponses)

	// Règle métier confirmée par le client :
	// chaque réponse "Oui" rapporte le poids de la question (1 point/question),
	// le badge "PermisDeTravaillerJEB" est débloqué au-delà de 50 points.
	score := 0
	for _, rep := range reponses {
		if len(rep.Options) > 0 && rep.Options[0] == "Oui" {
			var q Question
			db.First(&q, rep.QuestionID)
			score += q.Weight
		}
	}
	badge := score > 50

	resultat := CertificationResult{
		ProfileID:   body.ProfileID,
		TotalScore:  score,
		BadgeEarned: badge,
	}
	db.Create(&resultat)

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(resultat)
}

func handler(res http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(res, "Hello, world!")
}

func health(res http.ResponseWriter, req *http.Request) {
	res.Header().Set("Content-Type", "application/json")
	res.WriteHeader(http.StatusOK)
	fmt.Fprintf(res, `{"status":"ok"}`)
}

func main() {
	dsn := os.Getenv("DATABASE_URL")
	var err error
	db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		fmt.Println("Erreur de connexion à la base :", err)
		return
	}
	fmt.Println("Connexion à PostgreSQL réussie !")

	mux := http.NewServeMux()
	mux.HandleFunc("/", handler)
	mux.HandleFunc("/health", health)
	mux.HandleFunc("/questionnaire", listerQuestionsHandler)
	mux.HandleFunc("/questionnaire/demarrer", demarrerQuestionnaireHandler)
	mux.HandleFunc("/questionnaire/reponse", enregistrerReponseHandler)
	mux.HandleFunc("/questionnaire/valider", validerQuestionnaireHandler)

	db.Where("1 = 1").Delete(&Question{})
	for _, q := range questionsAPoser {
		db.Create(&q)
	}
	fmt.Println("100 questions insérées !")
	fmt.Println("serv up in http://localhost:8080")

	err = http.ListenAndServe(":8080", corsMiddleware(mux))
	if err != nil {
		fmt.Println("Erreur:", err)
	}
}