all: install create-db write-db print-db


install: install-mongodb install-postgresql install-redis install-rabbitmq install-mysql install-sqlite3

install-mongodb:
	# install mongodb
	apt install -y mongodb

install-postgresql:
	# install postgresql
	apt install -y postgresql postgresql-contrib

install-redis:
	# install redis
	apt install -y redis-server

install-rabbitmq:	
	# install rabbitmq
	apt install -y rabbitmq-server

install-mysql:
	# install mysql
	apt install -y mysql-server mysql-client

install-sqlite3:
	# install sqlite3
	apt install -y sqlite3 libsqlite3-dev


create-db-mongodb:
	# create mongodb database with the name 'test'
	mongo
	use test
	db.test.insert({name: 'test'})

create-db-postgresql:
	# create postgresql database with the name 'test'
	sudo -u postgres psql
	create database test;
	create user test with password 'test';
	grant all privileges on database test to test;

create-db-mysql:
	# create mysql database with the name 'test'
	mysql -u root -p
	create database test;
	create user test identified by 'test';
	grant all privileges on test.* to test@localhost identified by 'test';

create-db-sqlite3:
	# create sqlite3 database with the name 'test'
	sqlite3 test.db
	.quit

create-db-redis:
	# create redis database with the name 'test'
	redis-cli
	set test test
	get test
	quit

create-db-rabbitmq:
	# create rabbitmq database with the name 'test'
	rabbitmqctl add_user test test
	rabbitmqctl set_user_tags test administrator
	rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

create-db: create-db-mongodb create-db-postgresql create-db-mysql create-db-sqlite3 create-db-redis create-db-rabbitmq

# write to database with data from examples/{mongodb,postgresql,mysql,sqlite3,redis,rabbitmq}.csv

write-db-mongodb:
	# write to mongodb database with data from examples/mongodb.csv
	mongoimport --db test --collection test --type csv --headerline --file examples/mongodb.csv

write-db-postgresql:
	# write to postgresql database with data from examples/postgresql.csv it has 6 columns and two rows
	psql -U test -d test -c "COPY test FROM 'examples/postgresql.csv' DELIMITER ',' CSV HEADER;"


write-db-mysql:
	# write to mysql database with data from examples/mysql.csv each csv only has 6 columns and two rows
	# file examples/mysql.csv has 6 columns and two rows
	mysql -u test -p test -e "LOAD DATA LOCAL INFILE 'examples/mysql.csv' INTO TABLE test FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;"

write-db-sqlite3:
	# write to sqlite3 database with data from examples/sqlite3.csv
	sqlite3 test.db
	.mode csv
	.import examples/sqlite3.csv test
	.quit

write-db-redis:
	# write to redis database with data from examples/redis.csv
	redis-cli
	set test test
	get test
	quit

write-db-rabbitmq:
	# write to rabbitmq database with data from examples/rabbitmq.csv
	rabbitmqctl add_user test test
	rabbitmqctl set_user_tags test administrator
	rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

write-db: write-db-mongodb write-db-postgresql write-db-mysql write-db-sqlite3 write-db-redis write-db-rabbitmq

print-db-mongodb:
	# print mongodb database with the name 'test'
	mongo
	use test
	db.test.find()

print-db-postgresql:
	# print postgresql database with the name 'test'
	psql -U test -d test -c "SELECT * FROM test;"

print-db-mysql:
	# print mysql database with the name 'test'
	mysql -u test -p test -e "SELECT * FROM test;"

print-db-sqlite3:
	# print sqlite3 database with the name 'test'
	sqlite3 test.db
	.mode csv
	.headers on
	.output test.csv
	.output stdout
	select * from test;
	.quit

print-db-redis:
	# print redis database with the name 'test'
	redis-cli
	get test
	quit

print-db-rabbitmq:
	# print rabbitmq database with the name 'test'
	rabbitmqctl add_user test test
	rabbitmqctl set_user_tags test administrator
	rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

print-db: print-db-mongodb print-db-postgresql print-db-mysql print-db-sqlite3 print-db-redis print-db-rabbitmq

