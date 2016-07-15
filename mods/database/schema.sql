PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE users (
    id                   integer NOT NULL,
    username             varchar(100) NOT NULL UNIQUE,
    CONSTRAINT Pk_users PRIMARY KEY ( id )
);

CREATE TABLE sexes ( 
	id                   integer NOT NULL,
	title                varchar(100) NOT NULL,
	CONSTRAINT Pk_sexes PRIMARY KEY ( id )
);
INSERT INTO "sexes" VALUES(1, 'мужчина');
INSERT INTO "sexes" VALUES(2, 'женщина');

CREATE TABLE races ( 
	id                   integer NOT NULL,
	title                varchar(100) NOT NULL,
	CONSTRAINT Pk_Table_0 PRIMARY KEY ( id )
);
INSERT INTO "races" VALUES(1, 'человек');

CREATE TABLE ch_classes ( 
	id                   integer NOT NULL,
	title                varchar(100) NOT NULL,
	CONSTRAINT Pk_ch_classes PRIMARY KEY ( id )
);
INSERT INTO "ch_classes" VALUES(-10, 'ГМ');
INSERT INTO "ch_classes" VALUES(0, 'непроверен');
INSERT INTO "ch_classes" VALUES(10, 'требует исправлений');
INSERT INTO "ch_classes" VALUES(20, 'проверен / жив');
INSERT INTO "ch_classes" VALUES(100, 'мёртв');

CREATE TABLE characters ( 
	id                   integer NOT NULL,
	user_id              integer NOT NULL,
	real_name            varchar(50) NOT NULL,
	visible_name         varchar(50),
	age                  integer NOT NULL,
	sex                  integer NOT NULL DEFAULT(0),
	race                 integer NOT NULL DEFAULT(0),
	appearance           text NOT NULL,
	quenta               text NOT NULL,
	class                integer NOT NULL,
	CONSTRAINT Pk_characters PRIMARY KEY ( id ),
	FOREIGN KEY ( user_id ) REFERENCES users( id ),
	FOREIGN KEY ( sex ) REFERENCES sexes( id ),
	FOREIGN KEY ( race ) REFERENCES races( id ),
	FOREIGN KEY ( class ) REFERENCES ch_classes( id )  
);

CREATE TABLE skills ( 
	id                   integer NOT NULL,
	character_id         integer NOT NULL,
	name                 varchar(100) NOT NULL,
	level                varchar(100) NOT NULL,
	CONSTRAINT Pk_skills PRIMARY KEY ( id ),
	FOREIGN KEY ( character_id ) REFERENCES characters( id )  
);
COMMIT;
