CREATE TABLE characters ( 
	id                   integer NOT NULL  ,
	username             char(100) NOT NULL  ,
	name                 varchar(100) NOT NULL  ,
	visible_name         varchar(100)   ,
	quenta               text   , active integer   NOT NULL DEFAULT 0,
	CONSTRAINT Pk_characters PRIMARY KEY ( id )
 );
CREATE TABLE skills ( 
	id                   integer NOT NULL  ,
	character_id         integer NOT NULL  ,
	name                 varchar(100) NOT NULL  ,
	level                varchar(100) NOT NULL  ,
	CONSTRAINT Pk_skills PRIMARY KEY ( id )
 );
