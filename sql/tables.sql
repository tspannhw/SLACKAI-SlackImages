create or replace TABLE DEMO.DEMO.RAWSLACKIMAGES (
	UUID VARCHAR(16777216),
	FILENAME VARCHAR(16777216),
	JSON_DATA TEXT
);


create or replace ICEBERG TABLE DEMO.DEMO.SLACKIMAGES (
	UUID VARCHAR,
    messagerealname VARCHAR,
	FILENAME VARCHAR,
    messagechannel VARCHAR,
    messageusertz VARCHAR,
    messagefiletype VARCHAR,
	IMAGE_TEXT TEXT,
    `IMAGE` TEXT,
    messageusername VARCHAR,
    messagetimestamp VARCHAR,
	ts VARCHAR
)
CATALOG = 'SNOWFLAKE';


select * from DEMO.DEMO.SLACKIMAGES;

select * from demo.demo.RAWSLACKIMAGES;
