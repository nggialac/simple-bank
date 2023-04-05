postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=123456 -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb --username=root --owner=root simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:123456@localhost:5432/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://root:123456@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:123456@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:123456@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	docker run --rm -v "%cd%:/src" -w /src kjconroy/sqlc generate

test:
	go test -v -cover ./...

server:
	go run .

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/nggialac/simple-bank/db/sqlc Store

# create new gen file sql to migration
migrateupdate:
	migrate create -ext sql -dir db/migration -seq add_users
	
.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc test server mock migrateupdate

# sqlc can run only on CMD
# running docker postgres image
# docker run -v C:\Users\PC\go_projects\simple-bank\db\migration:/migrations migrate/migrate -path=/migrations/ -database postgres://root:123456@127.0.0.1:5432/postgres?sslmode=disable up 2
