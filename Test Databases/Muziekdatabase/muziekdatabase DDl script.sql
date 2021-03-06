-- COPYRIGHT HAN

/*==============================================================*/
/* Database name:  muziekdatabase                               */
/* DBMS name:      Microsoft SQL Server 2008                   */
/*==============================================================*/


use master
go

if object_id('muziekdatabase') is not null
	drop database muziekdatabase
go


/*==============================================================*/
/* Database: muziekdatabase                                     */
/*==============================================================*/
create database muziekdatabase
go


use muziekdatabase
go


/*==============================================================*/
/* Table: Bezettingsregel                                       */
/*==============================================================*/
create table Bezettingsregel (
   stuknr               numeric(5)           not null,
   instrumentnaam       varchar(14)          not null,
   toonhoogte           varchar(7)           not null,
   aantal               numeric(2)           not null,
   constraint PK_BEZETTINGSREGEL primary key  (stuknr, instrumentnaam, toonhoogte)
)
go


/*==============================================================*/
/* Table: Componist                                             */
/*==============================================================*/
create table Componist (
   componistId          numeric(4)           not null,
   naam                 varchar(20)          not null,
   geboortedatum        datetime             null,
   schoolId             numeric(2)           null,
   constraint PK_COMPONIST primary key  (componistId),
   constraint AK_COMPONIST unique (naam)
)
go


/*==============================================================*/
/* Table: Genre                                                 */
/*==============================================================*/
create table Genre (
   genrenaam            varchar(10)          not null,
   constraint PK_GENRE primary key  (genrenaam)
)
go


/*==============================================================*/
/* Table: Instrument                                            */
/*==============================================================*/
create table Instrument (
   instrumentnaam       varchar(14)          not null,
   toonhoogte           varchar(7)           not null,
   constraint PK_INSTRUMENT primary key  (instrumentnaam, toonhoogte)
)
go


/*==============================================================*/
/* Table: Muziekschool                                          */
/*==============================================================*/
create table Muziekschool (
   schoolId             numeric(2)           not null,
   naam                 varchar(30)          not null,
   plaatsnaam           varchar(20)          not null,
   constraint PK_MUZIEKSCHOOL primary key  (schoolId),
   constraint AK_MUZIEKSCHOOL unique (naam)
)
go


/*==============================================================*/
/* Table: Niveau                                                */
/*==============================================================*/
create table Niveau (
   niveaucode           char(1)              not null,
   omschrijving         varchar(15)          not null,
   constraint PK_NIVEAU primary key  (niveaucode),
   constraint AK_NIVEAU unique (omschrijving)
)
go


/*==============================================================*/
/* Table: Stuk                                                  */
/*==============================================================*/
create table Stuk (
   stuknr               numeric(5)           not null,
   componistId          numeric(4)           not null,
   titel                varchar(20)          not null,
   stuknrOrigineel      numeric(5)           null,
   genrenaam            varchar(10)          not null,
   niveaucode           char(1)              null,
   speelduur            numeric(3,1)         null,
   jaartal              numeric(4)           not null,
   constraint PK_STUK primary key  (stuknr),
   constraint AK_STUK unique (componistId, titel)
)
go


alter table Bezettingsregel
   add constraint FK_BEZETTIN_REF_STUK foreign key (stuknr)
      references Stuk (stuknr)
--      on update cascade on delete cascade
go


alter table Bezettingsregel
   add constraint FK_BEZETTIN_REF_INSTRUME foreign key (instrumentnaam, toonhoogte)
      references Instrument (instrumentnaam, toonhoogte)
--      on update cascade
go


alter table Componist
   add constraint FK_COMPONIS_REF_MUZIEKSC foreign key (schoolId)
      references Muziekschool (schoolId)
--      on update cascade
go


alter table Stuk
   add constraint FK_STUK_REF_COMPONIST foreign key (componistId)
      references Componist (componistId)
--      on update cascade
go


alter table Stuk
   add constraint FK_STUK_REF_GENRE foreign key (genrenaam)
      references Genre (genrenaam)
--      on update cascade
go


alter table Stuk
   add constraint FK_STUK_REF_NIVEAU foreign key (niveaucode)
      references Niveau (niveaucode)
--      on update cascade
go


alter table Stuk
   add constraint FK_STUK_REF_STUK foreign key (stuknrOrigineel)
      references Stuk (stuknr)
go


