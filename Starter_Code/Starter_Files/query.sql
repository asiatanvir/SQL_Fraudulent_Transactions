----Query 1
---- How can you isolate (or group) the transactions of each cardholder?

SELECT ch.name AS "customer_name", t.card As "credit_card",
CAST(sum(t.amount)AS INT) As "total_amount"

FROM "transaction" as t
INNER JOIN credit_card as cc ON t.card=cc.card
INNER JOIN card_holder as ch ON cc.cardholder_id = ch.id
Group by "credit_card","customer_name"
order by "customer_name" ASC;

---- Query # 2
---- Count the transactions that are less than $2.00 per cardholder.

SELECT ch.name AS "customer_name",t.card As "credit_card", count(t.card) As "transaction_lessthan_$2_count"
FROM "transaction" as t
INNER JOIN credit_card as cc ON t.card=cc.card
INNER JOIN card_holder as ch ON cc.cardholder_id = ch.id
WHERE t.amount < 2
Group by "customer_name","credit_card"
order by "customer_name" ASC;

----Query # 3
----What are the top 100 highest transactions made between 7:00 am and 9:00 am

SELECT ch.name AS "cardholder_name", t.id AS "transaction_id", t.amount, 
t.date :: timestamp :: date AS "Date", 
t.date :: timestamp :: time AS "Time"

FROM transaction as t
INNER JOIN credit_card as cc ON t.card=cc.card
INNER JOIN card_holder as ch ON cc.cardholder_id = ch.id
WHERE date :: timestamp :: time > '07:00:00' AND date :: timestamp :: time < '09:00:00'
Group by "cardholder_name","transaction_id"
ORDER BY "amount" DESC
LIMIT 100;

---- Query # 4
-----Do you see any anomalous transactions that could be fraudulent between 7 am to 9am?
-------anomalous transactions by amount during 7 am to 9 am
SELECT ch.name AS "cardholder_name", t.id AS "transaction_id", t.amount, 
t.date :: timestamp :: date AS "Date", 
t.date :: timestamp :: time AS "Time"

FROM transaction as t
INNER JOIN credit_card as cc ON t.card=cc.card
INNER JOIN card_holder as ch ON cc.cardholder_id = ch.id
WHERE (t.amount <2 OR t.amount >  30 ) AND t.date :: timestamp :: time > '07:00:00'
AND t.date :: timestamp :: time < '09:00:00'
Group by "cardholder_name","transaction_id"
ORDER BY "amount" DESC;

----Query # 5
---Is there a higher number of fraudulent transactions made during 7 am to 9 am time frame versus the rest of the day?

------anomalous transactions by count during 7 am to 9 am
SELECT ch.name AS "cardholder_name", t.card As "credit_card",
count(t.card) As "anomalous_transaction" 

FROM transaction as t
INNER JOIN credit_card as cc ON t.card=cc.card
INNER JOIN card_holder as ch ON cc.cardholder_id = ch.id
WHERE (t.amount <2 OR t.amount >  30 ) AND date :: timestamp :: time > '07:00:00' 
AND date :: timestamp :: time < '09:00:00'
Group by "cardholder_name","credit_card"
ORDER BY "anomalous_transaction" DESC
;

----Query # 6(a)
----Rest of the day anomalous_trsanctions by count

SELECT ch.name AS "cardholder_name", t.card As "credit_card",
count(t.card) As "anomalous_transaction" 

FROM transaction as t
INNER JOIN credit_card as cc ON t.card=cc.card
INNER JOIN card_holder as ch ON cc.cardholder_id = ch.id
WHERE (t.amount <2 OR t.amount >  30 ) AND (date :: timestamp :: time > '09:00:00' 
OR date :: timestamp :: time < '07:00:00')
Group by "cardholder_name","credit_card"
ORDER BY "anomalous_transaction" DESC
;

----Query # 6(b)
----Rest of the day anomalous_trsanctions by amount
SELECT ch.name AS "cardholder_name", t.id AS "transaction_id", t.amount, 
t.date :: timestamp :: date AS "Date", 
t.date :: timestamp :: time AS "Time"

FROM transaction as t
INNER JOIN credit_card as cc ON t.card=cc.card
INNER JOIN card_holder as ch ON cc.cardholder_id = ch.id
WHERE (t.amount <2 OR t.amount >  30 ) AND ( t.date :: timestamp :: time > '09:00:00'
OR t.date :: timestamp :: time < '07:00:00')
Group by "cardholder_name","transaction_id"
ORDER BY "amount" DESC;


----- Query # 7
---What are the top 5 merchants prone to being hacked using small transactions?
SELECT merchant_category.name AS "merchant_category", m.name AS "merchant_name", 
count(t.id_merchant) As "anomalous_transactions" 

FROM transaction as t
JOIN merchant AS m ON t.id_merchant=m.id
JOIN merchant_category ON m.id_merchant_category=merchant_category.id
WHERE t.amount <2  OR t.amount >  30 
Group by "merchant_name","merchant_category"
ORDER BY "anomalous_transactions" DESC
limit 5
;


---- Create a view for each of your above queries

---- create a view for  group of transactions of each cardholder?

CREATE VIEW "Cardholders_groupby_Transactions" AS
SELECT ch.name AS "customer_name", t.card As "credit_card",
CAST(sum(t.amount)AS INT) As "total_amount"

FROM "transaction" as t
INNER JOIN credit_card as cc ON t.card=cc.card
INNER JOIN card_holder as ch ON cc.cardholder_id = ch.id
Group by "credit_card","customer_name"
order by "customer_name" ASC;


---- Create a view for transactions that are less than $2.00 per cardholder.

CREATE VIEW "Transactions_per_cardholder_lessthan_2" AS

SELECT ch.name AS "customer_name",t.card As "credit_card", count(t.card) As "transaction_lessthan_$2_count"
FROM "transaction" as t
INNER JOIN credit_card as cc ON t.card=cc.card
INNER JOIN card_holder as ch ON cc.cardholder_id = ch.id
WHERE t.amount < 2
Group by "customer_name","credit_card"
order by "customer_name" ASC;


--- Top 100 highest transactions made between 7:00 am and 9:00 am

CREATE VIEW "Highest_transaction_between_7to9" AS

SELECT ch.name AS "cardholder_name", t.id AS "transaction_id", t.amount, 
t.date :: timestamp :: date AS "Date", 
t.date :: timestamp :: time AS "Time"

FROM transaction as t
INNER JOIN credit_card as cc ON t.card=cc.card
INNER JOIN card_holder as ch ON cc.cardholder_id = ch.id
WHERE date :: timestamp :: time > '07:00:00' AND date :: timestamp :: time < '09:00:00'
Group by "cardholder_name","transaction_id"
ORDER BY "amount" DESC
LIMIT 100;

-----Anomalous transactions that could be fraudulent?
CREATE VIEW "Anomalous_transactions_between_7to9" AS

SELECT ch.name AS "cardholder_name", t.id AS "transaction_id", t.amount, 
t.date :: timestamp :: date AS "Date", 
t.date :: timestamp :: time AS "Time"

FROM transaction as t
INNER JOIN credit_card as cc ON t.card=cc.card
INNER JOIN card_holder as ch ON cc.cardholder_id = ch.id
WHERE (t.amount <2 OR t.amount >  30 ) AND t.date :: timestamp :: time > '07:00:00'
AND t.date :: timestamp :: time < '09:00:00'
Group by "cardholder_name","transaction_id"
ORDER BY "amount" DESC;


---Is there a higher number of fraudulent transactions made during this time frame versus the rest of the day?

CREATE VIEW "Fraudulent_transactions_between_7to9" AS
SELECT ch.name AS "cardholder_name", t.card As "credit_card",
count(t.card) As "anomalous_transaction" 

FROM transaction as t
INNER JOIN credit_card as cc ON t.card=cc.card
INNER JOIN card_holder as ch ON cc.cardholder_id = ch.id
WHERE (t.amount <2 OR t.amount >  30 ) AND date :: timestamp :: time > '07:00:00' 
AND date :: timestamp :: time < '09:00:00'
Group by "cardholder_name","credit_card"
ORDER BY "anomalous_transaction" DESC
;


----Rest of the day

CREATE VIEW "Fraudulent_transactions_rest_of_day" AS
SELECT ch.name AS "cardholder_name", t.card As "credit_card",
count(t.card) As "anomalous_transaction" 

FROM transaction as t
INNER JOIN credit_card as cc ON t.card=cc.card
INNER JOIN card_holder as ch ON cc.cardholder_id = ch.id
WHERE (t.amount <2 OR t.amount >  30 ) AND (date :: timestamp :: time > '09:00:00' 
OR date :: timestamp :: time < '07:00:00')
Group by "cardholder_name","credit_card"
ORDER BY "anomalous_transaction" DESC
;


---What are the top 5 merchants prone to being hacked using small transactions?

CREATE VIEW "top_five_merchant_prone_to_hack" AS
SELECT merchant_category.name AS "merchant_category", m.name AS "merchant_name", 
count(t.id_merchant) As "anomalous_transactions" 

FROM transaction as t
JOIN merchant AS m ON t.id_merchant=m.id
JOIN merchant_category ON m.id_merchant_category=merchant_category.id
WHERE t.amount <2  OR t.amount >  30 
Group by "merchant_name","merchant_category"
ORDER BY "anomalous_transactions" DESC
limit 5
;


