create table "accounts" (
    "id" bigserial primary key,
    "owner" varchar not null,
    "balance" bigint not null,
    "currency" varchar not null,
    "created_at" TIMESTAMPtz not null DEFAULT(now())
);

create table "entries" (
    "id" bigserial PRIMARY KEY,
    "account_id" BIGINT not null,
    "amount" bigint not null,
    "created_at" TIMESTAMPtz not null default (now())
);

create table "transfers" (
    "id" bigserial PRIMARY key,
    "from_account_id" BIGINT not null,
    "to_account_id" BIGINT not null,
    "amount" bigint not null,
    "created_at" TIMESTAMPtz not null default (now())
);

alter TABLE
    "entries"
add
    FOREIGN key("account_id") REFERENCES "accounts"("id");

alter TABLE
    "transfers"
add
    FOREIGN key("from_account_id") REFERENCES "accounts"("id");

alter TABLE
    "transfers"
add
    FOREIGN key("to_account_id") REFERENCES "accounts"("id");

create INDEX on "accounts" ("owner");

create INDEX on "entries" ("account_id");

create INDEX on "transfers" ("from_account_id");

create INDEX on "transfers" ("to_account_id");

create INDEX on "transfers" ("from_account_id", "to_account_id");

COMMENT on COLUMN "entries"."amount" IS 'can be negative or positive';

comment on column "transfers"."amount" is 'must be positive';