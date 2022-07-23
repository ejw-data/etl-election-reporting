 create table vote_counts (
	 record_id integer NOT NULL PRIMARY KEY,
	 batch_id integer NOT NULL,
	 datetime date NOT NULL,
	 candidate varchar(16) NOT NULL,
	 votes integer NOT NULL,
	 state varchar(32) NOT NULL,
	 district varchar(32),
	 type varchar(32) 
 );