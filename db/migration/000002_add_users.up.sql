create table "users" ( 
    "username" varchar PRIMARY KEY,
    "hashed_password" varchar NOT NULL,
    "full_name" VARCHAR not NULL,
    "email" varchar UNIQUE NOT NULL,
    "password_changed_at" TIMESTAMPtz not NULL DEFAULT '0001-01-01 00:00:00Z',
    "created_at" TIMESTAMPtz not null DEFAULT (now()) 
);

alter table
    "accounts"
add
    FOREIGN key ("owner") REFERENCES "users" ("username");

-- create UNIQUE INDEX on "accounts" ("owner", "currency");
ALTER TABLE
    "accounts"
ADD
    CONSTRAINT "owner_currency_key" UNIQUE ("owner", "currency");