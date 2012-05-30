create table CURSIST
(
   PERSOONSNUMMER       int not null,
   EXTERN               bit not null,
   primary key (PERSOONSNUMMER)
);
 

create table CURSUS
(
   TYPENAAM             varchar(40) not null,
   SEIZOENCODE          varchar(10) not null,
   KOSTEN_INTERN        decimal(5,2) not null,
   KOSTEN_EXTERN        decimal(5,2) not null,
   primary key (TYPENAAM, SEIZOENCODE)
);
 

create table CURSUSBIJCURSIST
(
   PERSOONSNUMMER       int not null,
   TYPENAAM             varchar(40) not null,
   SEIZOENCODE          varchar(10) not null,
   BETAALD              bit not null,
   INSCHRIJFDATUM       date not null,
   primary key (TYPENAAM, PERSOONSNUMMER, SEIZOENCODE)
);
 
 
create table CURSUSTYPE
(
   TYPENAAM             varchar(40) not null,
   primary key (TYPENAAM)
);
 
 
create table DIPLOMA
(
   INSTANTIENAAM        varchar(50) not null,
   DIPLOMANAAM          varchar(50) not null,
   primary key (INSTANTIENAAM, DIPLOMANAAM)
);

create table DIPLOMABIJPERSOON
(
   PERSOONSNUMMER       int not null,
   INSTANTIENAAM        varchar(50) not null,
   DIPLOMANAAM          varchar(50) not null,
   DIPLOMANUMMER        int not null,
   EXAMENDATUM          date not null,
   VERLOOPDATUM         date not null,
   primary key (PERSOONSNUMMER, INSTANTIENAAM, DIPLOMANAAM)
);

create table FUNCTIE
(
   FUNCTIE              varchar(13) not null,
   primary key (FUNCTIE)
);

create table GEGEVENLES
(
   LESNAAM              varchar(50) not null,
   LESDATUM             datetime not null,
   TYPENAAM             varchar(40) not null,
   SEIZOENCODE          varchar(10) not null,
   LOCATIE              varchar(100) not null,
   MAX_AANTAL_INSCHRIJVINGEN int not null,
   primary key (LESNAAM, LESDATUM)
);
 
 
create table INSCHRIJVING
(
   PERSOONSNUMMER       int not null,
   LESNAAM              varchar(50) not null,
   LESDATUM             datetime not null,
   STATUS               varchar(12) not null,
   AANWEZIG             bit null,
   primary key (PERSOONSNUMMER, LESNAAM, LESDATUM)
);
 

create table INSTANTIE
(
   INSTANTIENAAM        varchar(50) not null,
   PLAATSNAAM           varchar(60) not null,
   STRAATNAAM           varchar(45) not null,
   HUISNUMMER           int not null,
   HUISNUMMER_TOEVOEGING varchar(5),
   CONTACTPERSOON       varchar(50),
   primary key (INSTANTIENAAM)
);
 
 
create table INSTRUCTEUR
(
   PERSOONSNUMMER       int not null,
   primary key (PERSOONSNUMMER)
);
 
 
create table INSTRUCTEURBEVOEGDHEID
(
   I_BEVOEGDHEIDSNAAM   varchar(50) not null,
   primary key (I_BEVOEGDHEIDSNAAM)
);
 

create table INSTRUCTEURBIJLES
(
   PERSOONSNUMMER       int not null,
   LESNAAM              varchar(50) not null,
   LESDATUM             datetime not null,
   FUNCTIE              varchar(13) not null,
   primary key (LESNAAM, PERSOONSNUMMER, LESDATUM)
);
 
 
create table INSTRUCTEUR_HEEFT_BEVOEGDHEID
(
   PERSOONSNUMMER       int not null,
   I_BEVOEGDHEIDSNAAM   varchar(50) not null,
   primary key (PERSOONSNUMMER, I_BEVOEGDHEIDSNAAM)
);
 
 
create table IS_LID_VAN
(
   VERENIGINGSID        int not null,
   PERSOONSNUMMER       int not null,
   primary key (VERENIGINGSID, PERSOONSNUMMER)
);
 
 
create table LES
(
   LESNAAM              varchar(50) not null,
   L_BEVOEGDHEIDSNAAM   varchar(50) not null,
   I_BEVOEGDHEIDSNAAM   varchar(50) not null,
   ONDERWERP            varchar(50) not null,
   OMSCHRIJVING         text,
   OPMERKING_EN_        varchar(500),
   primary key (LESNAAM)
);
 
 
create table LOTUS
(
   PERSOONSNUMMER       int not null,
   primary key (PERSOONSNUMMER)
);
create table LOTUSBEVOEGDHEID
(
   L_BEVOEGDHEIDSNAAM   varchar(50) not null,
   primary key (L_BEVOEGDHEIDSNAAM)
);
 
 
create table LOTUSBIJLES
(
   PERSOONSNUMMER       int not null,
   LESNAAM              varchar(50) not null,
   LESDATUM             datetime not null,
   primary key (LESNAAM, PERSOONSNUMMER, LESDATUM)
);
 
 
create table LOTUS_HEEFT_BEVOEGDHEID
(
   PERSOONSNUMMER       int not null,
   L_BEVOEGDHEIDSNAAM   varchar(50) not null,
   primary key (PERSOONSNUMMER, L_BEVOEGDHEIDSNAAM)
);
 
create table PERSOON
(
   PERSOONSNUMMER       int not null,
   VOORNAAM             varchar(50) not null,
   TUSSENVOEGSEL        varchar(10),
   ACHTERNAAM           varchar(55) not null,
   GEBOORTEDATUM        date not null,
   STRAATNAAM           varchar(45) not null,
   HUISNUMMER           int not null,
   HUISNUMMER_TOEVOEGING varchar(5),
   POSTCODE             varchar(6) not null,
   PLAATSNAAM           varchar(60) not null,
   TELEFOONNUMMER       numeric(13,0),
   MOBIELE_TELEFOONNUMMER numeric(13,0),
   EMAILADRES           varchar(345) not null,
   OPMERKING_EN_        varchar(500),
   INSCHRIJFDATUM       date not null,
   UITSCHRIJFDATUM      date,
   primary key (PERSOONSNUMMER)
);
 
 create table SEIZOEN
(
   SEIZOENCODE          varchar(10) not null,
   BEGINDATUM           date not null,
   EINDDATUM            date not null,
   primary key (SEIZOENCODE)
);
 

create table STATUS
(
   STATUS               varchar(12) not null,
   primary key (STATUS)
);
 
 
create table TC_ONDERSTEUNEND
(
   PERSOONSNUMMER       int not null,
   primary key (PERSOONSNUMMER)
);
 

create table VERENIGING
(
   VERENIGINGSID        int not null,
   VERENIGINGSNAAM      varchar(50) not null,
   LOCATIE              varchar(100) not null,
   primary key (VERENIGINGSID)
);
 
 
alter table CURSIST add constraint FK_IS_EEN2 foreign key (PERSOONSNUMMER)
      references PERSOON (PERSOONSNUMMER) on delete no action on update no action;
 
alter table CURSUS add constraint FK_IS_VAN_EEN_BEPAALD foreign key (TYPENAAM)
      references CURSUSTYPE (TYPENAAM) on delete no action on update no action;
 
alter table CURSUS add constraint FK_WORDT_GEGEVEN_IN foreign key (SEIZOENCODE)
      references SEIZOEN (SEIZOENCODE) on delete no action on update no action;
 
alter table CURSUSBIJCURSIST add constraint FK_BETAALD_VOOR foreign key (PERSOONSNUMMER)
      references CURSIST (PERSOONSNUMMER) on delete no action on update no action;
 
alter table CURSUSBIJCURSIST add constraint FK_KOST_GELD_VOOR foreign key (TYPENAAM, SEIZOENCODE)
      references CURSUS (TYPENAAM, SEIZOENCODE) on delete no action on update no action;
 
alter table DIPLOMA add constraint FK_IS_TE_HALEN_BIJ foreign key (INSTANTIENAAM)
      references INSTANTIE (INSTANTIENAAM) on delete no action on update no action;
 
alter table DIPLOMABIJPERSOON add constraint FK_GENAAMD foreign key (INSTANTIENAAM, DIPLOMANAAM)
      references DIPLOMA (INSTANTIENAAM, DIPLOMANAAM) on delete no action on update no action;
 
alter table DIPLOMABIJPERSOON add constraint FK_HEEFT_BEHAALD foreign key (PERSOONSNUMMER)
      references PERSOON (PERSOONSNUMMER) on delete no action on update no action;
 
alter table GEGEVENLES add constraint FK_BEVAT foreign key (TYPENAAM, SEIZOENCODE)
      references CURSUS (TYPENAAM, SEIZOENCODE) on delete no action on update no action;
 
alter table GEGEVENLES add constraint FK_WORDT_GEGEVEN_OP foreign key (LESNAAM)
      references LES (LESNAAM) on delete no action on update no action;
 
alter table INSCHRIJVING add constraint FK_INGESCHREVEN_BIJ foreign key (LESNAAM, LESDATUM)
      references GEGEVENLES (LESNAAM, LESDATUM) on delete no action on update no action;
 
alter table INSCHRIJVING add constraint FK_INSCHRIJVINGSSTATUS foreign key (STATUS)
      references STATUS (STATUS) on delete no action on update no action;
 
alter table INSCHRIJVING add constraint FK_WORDT_BIJGEHOUDEN_IN foreign key (PERSOONSNUMMER)
      references CURSIST (PERSOONSNUMMER) on delete no action on update no action;
 
alter table INSTRUCTEUR add constraint FK_IS_EEN foreign key (PERSOONSNUMMER)
      references PERSOON (PERSOONSNUMMER) on delete no action on update no action;
 
alter table INSTRUCTEURBIJLES add constraint FK_AANGENOMEN_FUNCTIE_BIJ_EEN_LES foreign key (FUNCTIE)
      references FUNCTIE (FUNCTIE) on delete no action on update no action;
 
alter table INSTRUCTEURBIJLES add constraint FK_INSTRUCTEUR_DOET_MEE_AAN foreign key (PERSOONSNUMMER)
      references INSTRUCTEUR (PERSOONSNUMMER) on delete no action on update no action;
 
alter table INSTRUCTEURBIJLES add constraint FK_INSTRUCTEUR_VOOR_DE_LES foreign key (LESNAAM, LESDATUM)
      references GEGEVENLES (LESNAAM, LESDATUM) on delete no action on update no action;
 
alter table INSTRUCTEUR_HEEFT_BEVOEGDHEID add constraint FK_INSTRUCTEUR_HEEFT_BEVOEGDHEID foreign key (PERSOONSNUMMER)
      references INSTRUCTEUR (PERSOONSNUMMER) on delete no action on update no action;
 
alter table INSTRUCTEUR_HEEFT_BEVOEGDHEID add constraint FK_INSTRUCTEUR_HEEFT_BEVOEGDHEID2 foreign key (I_BEVOEGDHEIDSNAAM)
      references INSTRUCTEURBEVOEGDHEID (I_BEVOEGDHEIDSNAAM) on delete no action on update no action;
 
alter table IS_LID_VAN add constraint FK_IS_LID_VAN foreign key (VERENIGINGSID)
      references VERENIGING (VERENIGINGSID) on delete no action on update no action;
 
alter table IS_LID_VAN add constraint FK_IS_LID_VAN2 foreign key (PERSOONSNUMMER)
      references PERSOON (PERSOONSNUMMER) on delete no action on update no action;
 
alter table LES add constraint FK_DE_BEVOEGHEID_VOOR_LES foreign key (I_BEVOEGDHEIDSNAAM)
      references INSTRUCTEURBEVOEGDHEID (I_BEVOEGDHEIDSNAAM) on delete no action on update no action;
 
alter table LES add constraint FK_DE_LOTUSBEVOEGDHEID_VOOR_LES foreign key (L_BEVOEGDHEIDSNAAM)
      references LOTUSBEVOEGDHEID (L_BEVOEGDHEIDSNAAM) on delete no action on update no action;
 
alter table LOTUS add constraint FK_IS_EEN3 foreign key (PERSOONSNUMMER)
      references PERSOON (PERSOONSNUMMER) on delete no action on update no action;
 
alter table LOTUSBIJLES add constraint FK_LOTUSBIJLES foreign key (PERSOONSNUMMER)
      references LOTUS (PERSOONSNUMMER) on delete no action on update no action;
 
alter table LOTUSBIJLES add constraint FK_LOTUSBIJLES2 foreign key (LESNAAM, LESDATUM)
      references GEGEVENLES (LESNAAM, LESDATUM) on delete no action on update no action;
 
alter table LOTUS_HEEFT_BEVOEGDHEID add constraint FK_LOTUS_HEEFT_BEVOEGDHEID foreign key (PERSOONSNUMMER)
      references LOTUS (PERSOONSNUMMER) on delete no action on update no action;
 
alter table LOTUS_HEEFT_BEVOEGDHEID add constraint FK_LOTUS_HEEFT_BEVOEGDHEID2 foreign key (L_BEVOEGDHEIDSNAAM)
      references LOTUSBEVOEGDHEID (L_BEVOEGDHEIDSNAAM) on delete no action on update no action;
 
alter table TC_ONDERSTEUNEND add constraint FK_IS_EEN4 foreign key (PERSOONSNUMMER)
      references PERSOON (PERSOONSNUMMER) on delete no action on update no action;