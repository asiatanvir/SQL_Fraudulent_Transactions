DROP TABLE IF EXISTS card_holder CASCADE;
DROP TABLE IF EXISTS credit_card CASCADE;
DROP TABLE IF EXISTS merchant_category CASCADE;
DROP TABLE IF EXISTS merchant CASCADE;
DROP TABLE IF EXISTS "transaction" CASCADE;
aw

CREATE TABLE card_holder(
	"id" serial PRIMARY KEY,
	"name" varchar(255) NOT NULL
);


CREATE TABLE credit_card(
	card varchar(20) PRIMARY KEY NOT NULL,
	cardholder_id INT NOT NULL,
	 FOREIGN KEY (cardholder_id) REFERENCES card_holder(id)
);

CREATE TABLE merchant_category(
	"id" int NOT NULL PRIMARY KEY,
	"name" varchar(255)
);

CREATE TABLE merchant(
	"id" INT NOT NULL PRIMARY KEY,
	"name" varchar(255),
	"id_merchant_category" INT NOT NULL,
	FOREIGN KEY("id_merchant_category") REFERENCES merchant_category("id")
);

CREATE TABLE "transaction"(
	"id" INT NOT NULL PRIMARY KEY,
	"date" TIMESTAMP NOT NULL,
	"amount" FLOAT NOT NULL,
	card varchar(20),
	id_merchant INT NOT NULL,
	FOREIGN KEY (id_merchant) REFERENCES merchant("id")
);

ALTER TABLE "transaction" ADD Constraint Fk_card_holder_id
FOREIGN KEY (card) REFERENCES credit_card("card");


