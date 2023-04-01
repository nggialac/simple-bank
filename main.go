package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
	"github.com/nggialac/simple-bank/api"
	db "github.com/nggialac/simple-bank/db/sqlc"
	"github.com/nggialac/simple-bank/util"
)

func main() {
	cfg, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("cannot load config: ", err)
	}

	conn, err := sql.Open(cfg.DBDriver, cfg.DBSource)
	if err != nil {
		log.Fatal("cannot connect db", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(cfg.ServerAddress)
	if err != nil {
		log.Fatal("cannot start server at port: ", cfg.ServerAddress)
	}
}
