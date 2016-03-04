--First run data:
--Status,Score,Match_type,Match_addr,Side,Ref_ID,X,Y,Addr_type,ARC_Single_Line_Input,property_id,banana,source,rawAddress
--M,100,A,"11436 Morrish Rd, Gaines, MI, 48436",L,278400301482539,-83.827902,42.857012,StreetAddress,11436 MORRISH RD GAINES MI 48436,133642574,(133642574=> u''=> u''=> u''=> u''=> u'11436 MORRISH RD GAINES MI 48436'),recorder,11436 MORRISH RD GAINES MI 48436

--DROP TABLE geocoded;
CREATE TABLE geocoded (
   x2		decimal,
   y2		decimal,
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
--COPY geocoded FROM '/home/arthur/Desktop/geocoding_first_pass.csv' WITH DELIMITER ',' NULL AS '' CSV HEADER;
--ALTER TABLE geocoded DROP COLUMN x2;
--ALTER TABLE geocoded DROP COLUMN y2;
--VACUUM ANALYZE geocoded;

--Second run data:
--X,Y,Status,Score,Match_type,Match_addr,Side,Ref_ID,X,Y,User_fld,Addr_type,ARC_Single_Line_Input,property_id,banana,rawaddress
--13265234.266076117753983,487432.327099740505219,M,65.28,A,"13092 White Oaks Dr, 48436",R,21143,-83.83769,42.836308,0,StreetAddress,13092 WHITE OAKS GAINES MI 48436,133643084,(133643084=> u''=> u''=> u''=> u''=> u'13092 WHITE OAKS'),13092 WHITE OAKS GAINES MI 48436

--DROP TABLE geocoded_extra;
CREATE TABLE geocoded_extra (
   x2		decimal,
   y2		decimal,
   status	varchar(1),
   score	decimal,
   match_type	varchar(1),
   match_addr	varchar(255),
   side		varchar(1),
   ref_id	bigint,
   x		decimal,
   y		decimal,
   user_fld	varchar(1),
   addr_type	varchar(255),
   single_line	varchar(255),
   property_id	integer,
   match_info	text,
   raw_addr	varchar(255))
--COPY geocoded_extra FROM '/home/arthur/Desktop/geocoding_second_pass.csv' WITH DELIMITER ',' NULL AS '' CSV HEADER;
--ALTER TABLE geocoded_extra DROP COLUMN x2;
--ALTER TABLE geocoded_extra DROP COLUMN y2;
--VACUUM ANALYZE geocoded_extra;
