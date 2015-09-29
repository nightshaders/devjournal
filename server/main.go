package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"github.com/nightshaders/ywebserver/server"
	"github.com/nightshaders/ywebserver/handlers"
	"github.com/nightshaders/devjournal/server/embedded"
)

func main() {
	server.NewCli(Serve).Run(os.Args)
}

func Serve(r *server.Server) {
	r.Conf.EmbededAsset = embedded.Asset

	fmt.Println(r.Conf.String())
	fmt.Println("Starting Web Server")

	r.HandleFunc("/user", handlers.CreateUser).Methods("POST")
	r.HandleFunc("/users", handlers.GetUsers).Methods("GET")
	r.HandleFunc("/hello/{name}", handlers.Hello).Methods("GET")
	r.HandleHttp("/x", &handlers.HandlerX{"Superman"})

	// Handling static assets
	if r.Conf.ServeEmbedddedAssets {
		r.MatcherFunc(server.EmbeddedCheck(r.Conf)).
		  HandlerFunc(server.ServeEmbedded(r.Conf))
	} else {
		r.MatcherFunc(server.MatchAssets).
		  HandlerFunc(server.ServeFile(r.Conf))
	}

	err := http.ListenAndServe(r.Conf.Host(), r)
	if err != nil {
		log.Fatal(err)
	}
}

