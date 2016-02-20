--Status,Score,Match_type,Match_addr,Side,Ref_ID,X,Y,Addr_type,ARC_Single_Line_Input,property_id,banana,source,rawAddress
--M,100,A,"11436 Morrish Rd, Gaines, MI, 48436",L,278400301482539,-83.827902,42.857012,StreetAddress,11436 MORRISH RD GAINES MI 48436,133642574,(133642574=> u''=> u''=> u''=> u''=> u'11436 MORRISH RD GAINES MI 48436'),recorder,11436 MORRISH RD GAINES MI 48436

--DROP TABLE geocoded;
CREATE TABLE geocoded (
   status	varchar(1),
   score	decimal,
   match_type	varchar(1),
   match_addr	varchar(255),
   side		varchar(1),
   ref_id	bigint,
   x		decimal,
   y		decimal,
   addr_type	varchar(255),
   single_line	varchar(255),
   property_id	integer,
   match_info	text,
   source	varchar(255),
   raw_addr	varchar(255))

--COPY geocoded FROM '/home/arthur/Desktop/geocoding_first_run.csv' WITH DELIMITER ',' NULL AS '' CSV HEADER;