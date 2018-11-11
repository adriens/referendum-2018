drop table if exists referendum cascade;

create table referendum(
  id serial NOT NULL,
  province character varying(50),
  maire character varying(50),
  num_bv character varying(50),
  bv character varying(50),
  inscrits integer,
  votants integer,
  abstention integer,
  nuls integer,
  blancs integer,
  exprimes integer,
  oui integer,
  non integer,  
  CONSTRAINT persons_pkey PRIMARY KEY (id));
   
-- load into table
COPY referendum(province,maire,num_bv,bv,inscrits,votants,abstention,nuls,blancs,exprimes,oui,non) 
FROM 'C:\tmp\import-referendum-psql.csv' DELIMITER ',' CSV HEADER ;

create or replace view resultat_par_mairie as
select province,
   maire,
   sum(oui) as oui,
   sum(non) as non,
   case
       when sum(oui) > sum(non) then 'oui'
    when sum(oui) < sum(non) then 'non'
    when sum(oui) = sum(non) then 'egal'
    else 'other'
   end as resultat
from referendum
group by province, maire;


-- export csv
drop table if exists csv_export;
create table csv_export as select * from resultat_par_mairie;
COPY csv_export TO 'C:\tmp\resultat_par_mairie.csv' DELIMITER ',' CSV HEADER;