/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     24-5-2012 14:54:12                           */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('artikel') and o.name = 'fk_artikel_restaurant')
alter table artikel
   drop constraint fk_artikel_restaurant
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('artikel') and o.name = 'fk_artikel_artikeleenheid')
alter table artikel
   drop constraint fk_artikel_artikeleenheid
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('bestelling') and o.name = 'fk_bestelling_medewerker')
alter table bestelling
   drop constraint fk_bestelling_medewerker
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('bestelling') and o.name = 'fk_bestelling_restaurant')
alter table bestelling
   drop constraint fk_bestelling_restaurant
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('bestelling') and o.name = 'fk_bestelling_bestelstatus')
alter table bestelling
   drop constraint fk_bestelling_bestelstatus
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('bestellingproduct') and o.name = 'fk_kasbestellingproduct_bestelling')
alter table bestellingproduct
   drop constraint fk_kasbestellingproduct_bestelling
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('bestellingproduct') and o.name = 'fk_bestellingproduct_product')
alter table bestellingproduct
   drop constraint fk_bestellingproduct_product
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('bestellingproduct_historie') and o.name = 'fk_his_bestellingproduct_bestelling')
alter table bestellingproduct_historie
   drop constraint fk_his_bestellingproduct_bestelling
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('bestelling_historie') and o.name = 'fk_his_bestelli_reference_medewerk')
alter table bestelling_historie
   drop constraint fk_his_bestelli_reference_medewerk
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('dagmenu') and o.name = 'fk_dagmenu_restaurant')
alter table dagmenu
   drop constraint fk_dagmenu_restaurant
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('dagmenuproduct') and o.name = 'fk_dagmenuproduct_dagmenu')
alter table dagmenuproduct
   drop constraint fk_dagmenuproduct_dagmenu
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('dagmenuproduct') and o.name = 'fk_dagmenuproduct_product')
alter table dagmenuproduct
   drop constraint fk_dagmenuproduct_product
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('eetvoorkeur') and o.name = 'fk_eetvoorkeur_restaurant')
alter table eetvoorkeur
   drop constraint fk_eetvoorkeur_restaurant
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('eetvoorkeur') and o.name = 'fk_eetvoorkeur_medewerker')
alter table eetvoorkeur
   drop constraint fk_eetvoorkeur_medewerker
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('eetvoorkeurproduct') and o.name = 'fk_eetvoorkeurproduct_eetvoorkeur')
alter table eetvoorkeurproduct
   drop constraint fk_eetvoorkeurproduct_eetvoorkeur
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('eetvoorkeurproduct') and o.name = 'fk_eetvoorkeurproduct_product')
alter table eetvoorkeurproduct
   drop constraint fk_eetvoorkeurproduct_product
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('kassaverkoop') and o.name = 'fk_kassaver_reference_medewerk')
alter table kassaverkoop
   drop constraint fk_kassaver_reference_medewerk
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('kassaverkoop') and o.name = 'fk_kassaver_reference_restaura')
alter table kassaverkoop
   drop constraint fk_kassaver_reference_restaura
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('kassaverkoopproduct') and o.name = 'fk_kasproduct_bestelling')
alter table kassaverkoopproduct
   drop constraint fk_kasproduct_bestelling
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('kassaverkoopproduct') and o.name = 'fk_kassaver_reference_product')
alter table kassaverkoopproduct
   drop constraint fk_kassaver_reference_product
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('kassaverkoopproduct_historie') and o.name = 'fk_hiss_bestellingproduct_bestelling')
alter table kassaverkoopproduct_historie
   drop constraint fk_hiss_bestellingproduct_bestelling
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('kassaverkoop_historie') and o.name = 'fk_his_kassaver_reference_medewerk')
alter table kassaverkoop_historie
   drop constraint fk_his_kassaver_reference_medewerk
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('medewerkerrol') and o.name = 'fk_medewerkerrol_medewerker')
alter table medewerkerrol
   drop constraint fk_medewerkerrol_medewerker
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('medewerkerrol') and o.name = 'fk_medewerkerrol_restaurant')
alter table medewerkerrol
   drop constraint fk_medewerkerrol_restaurant
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('medewerkerrol') and o.name = 'fk_medewerkerrol_rol')
alter table medewerkerrol
   drop constraint fk_medewerkerrol_rol
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('product') and o.name = 'fk_product_productcategorie')
alter table product
   drop constraint fk_product_productcategorie
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('product') and o.name = 'fk_product_restaurant')
alter table product
   drop constraint fk_product_restaurant
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('productdieetcategorie') and o.name = 'fk_productdieetcategorie_product')
alter table productdieetcategorie
   drop constraint fk_productdieetcategorie_product
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('productdieetcategorie') and o.name = 'fk_productdieetcategorie_dieetcategorie')
alter table productdieetcategorie
   drop constraint fk_productdieetcategorie_dieetcategorie
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('productsamenstelling') and o.name = 'fk_productsamenstelling_artikel')
alter table productsamenstelling
   drop constraint fk_productsamenstelling_artikel
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('productsamenstelling') and o.name = 'fk_productsamenstelling_product')
alter table productsamenstelling
   drop constraint fk_productsamenstelling_product
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('restaurant') and o.name = 'fk_restaurant_plaats')
alter table restaurant
   drop constraint fk_restaurant_plaats
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('standaarddagmenu') and o.name = 'fk_standaarddagmenu_restaurant')
alter table standaarddagmenu
   drop constraint fk_standaarddagmenu_restaurant
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('standaarddagmenuproduct') and o.name = 'fk_standaarddagmenuproduct_standaarddagmenu')
alter table standaarddagmenuproduct
   drop constraint fk_standaarddagmenuproduct_standaarddagmenu
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('standaarddagmenuproduct') and o.name = 'fk_standaarddagmenuproduct_product')
alter table standaarddagmenuproduct
   drop constraint fk_standaarddagmenuproduct_product
go

if exists (select 1
            from  sysobjects
           where  id = object_id('bestellingen_van_restaurant')
            and   type = 'V')
   drop view bestellingen_van_restaurant
go

if exists (select 1
            from  sysobjects
           where  id = object_id('kassa_verkopen_van_restaurant')
            and   type = 'V')
   drop view kassa_verkopen_van_restaurant
go

if exists (select 1
            from  sysobjects
           where  id = object_id('medewerker_bestellingen')
            and   type = 'V')
   drop view medewerker_bestellingen
go

if exists (select 1
            from  sysobjects
           where  id = object_id('medewerker_maand_kosten')
            and   type = 'V')
   drop view medewerker_maand_kosten
go

if exists (select 1
            from  sysobjects
           where  id = object_id('restaurant_maand_omzet')
            and   type = 'V')
   drop view restaurant_maand_omzet
go

if exists (select 1
            from  sysobjects
           where  id = object_id('restaurant_verwachte_voorraad')
            and   type = 'V')
   drop view restaurant_verwachte_voorraad
go

if exists (select 1
            from  sysobjects
           where  id = object_id('artikel')
            and   type = 'U')
   drop table artikel
go

if exists (select 1
            from  sysobjects
           where  id = object_id('artikeleenheid')
            and   type = 'U')
   drop table artikeleenheid
go

if exists (select 1
            from  sysobjects
           where  id = object_id('bestelling')
            and   type = 'U')
   drop table bestelling
go

if exists (select 1
            from  sysobjects
           where  id = object_id('bestellingproduct')
            and   type = 'U')
   drop table bestellingproduct
go

if exists (select 1
            from  sysobjects
           where  id = object_id('bestellingproduct_historie')
            and   type = 'U')
   drop table bestellingproduct_historie
go

if exists (select 1
            from  sysobjects
           where  id = object_id('bestelling_historie')
            and   type = 'U')
   drop table bestelling_historie
go

if exists (select 1
            from  sysobjects
           where  id = object_id('bestelstatus')
            and   type = 'U')
   drop table bestelstatus
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dagmenu')
            and   type = 'U')
   drop table dagmenu
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dagmenuproduct')
            and   type = 'U')
   drop table dagmenuproduct
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dieetcategorie')
            and   type = 'U')
   drop table dieetcategorie
go

if exists (select 1
            from  sysobjects
           where  id = object_id('eetvoorkeur')
            and   type = 'U')
   drop table eetvoorkeur
go

if exists (select 1
            from  sysobjects
           where  id = object_id('eetvoorkeurproduct')
            and   type = 'U')
   drop table eetvoorkeurproduct
go

if exists (select 1
            from  sysobjects
           where  id = object_id('kassaverkoop')
            and   type = 'U')
   drop table kassaverkoop
go

if exists (select 1
            from  sysobjects
           where  id = object_id('kassaverkoopproduct')
            and   type = 'U')
   drop table kassaverkoopproduct
go

if exists (select 1
            from  sysobjects
           where  id = object_id('kassaverkoopproduct_historie')
            and   type = 'U')
   drop table kassaverkoopproduct_historie
go

if exists (select 1
            from  sysobjects
           where  id = object_id('kassaverkoop_historie')
            and   type = 'U')
   drop table kassaverkoop_historie
go

if exists (select 1
            from  sysobjects
           where  id = object_id('medewerker')
            and   type = 'U')
   drop table medewerker
go

if exists (select 1
            from  sysobjects
           where  id = object_id('medewerkerrol')
            and   type = 'U')
   drop table medewerkerrol
go

if exists (select 1
            from  sysobjects
           where  id = object_id('plaats')
            and   type = 'U')
   drop table plaats
go

if exists (select 1
            from  sysobjects
           where  id = object_id('product')
            and   type = 'U')
   drop table product
go

if exists (select 1
            from  sysobjects
           where  id = object_id('productcategorie')
            and   type = 'U')
   drop table productcategorie
go

if exists (select 1
            from  sysobjects
           where  id = object_id('productdieetcategorie')
            and   type = 'U')
   drop table productdieetcategorie
go

if exists (select 1
            from  sysobjects
           where  id = object_id('productsamenstelling')
            and   type = 'U')
   drop table productsamenstelling
go

if exists (select 1
            from  sysobjects
           where  id = object_id('restaurant')
            and   type = 'U')
   drop table restaurant
go

if exists (select 1
            from  sysobjects
           where  id = object_id('rol')
            and   type = 'U')
   drop table rol
go

if exists (select 1
            from  sysobjects
           where  id = object_id('standaarddagmenu')
            and   type = 'U')
   drop table standaarddagmenu
go

if exists (select 1
            from  sysobjects
           where  id = object_id('standaarddagmenuproduct')
            and   type = 'U')
   drop table standaarddagmenuproduct
go

if exists(select 1 from systypes where name='positiveinteger')
   execute sp_unbindrule positiveinteger
go

if exists(select 1 from systypes where name='positiveinteger')
   drop type positiveinteger
go

if exists(select 1 from systypes where name='positivemoney')
   execute sp_unbindrule positivemoney
go

if exists(select 1 from systypes where name='positivemoney')
   drop type positivemoney
go

if exists(select 1 from systypes where name='restaurantnummer')
   execute sp_unbindrule restaurantnummer
go

if exists(select 1 from systypes where name='restaurantnummer')
   drop type restaurantnummer
go

if exists (select 1 from sysobjects where id=object_id('r_positiveinteger') and type='R')
   drop rule  r_positiveinteger
go

if exists (select 1 from sysobjects where id=object_id('r_positivemoney') and type='R')
   drop rule  r_positivemoney
go

if exists (select 1 from sysobjects where id=object_id('r_restaurantnummer') and type='R')
   drop rule  r_restaurantnummer
go

create rule r_positiveinteger as
      @column >= 0
go

create rule r_positivemoney as
      @column >= 0
go

create rule r_restaurantnummer as
      @column >= 0
go

/*==============================================================*/
/* Domain: positiveinteger                                      */
/*==============================================================*/
create type positiveinteger
   from int
go

execute sp_bindrule r_positiveinteger, positiveinteger
go

/*==============================================================*/
/* Domain: positivemoney                                        */
/*==============================================================*/
create type positivemoney
   from numeric(10,2)
go

execute sp_bindrule r_positivemoney, positivemoney
go

/*==============================================================*/
/* Domain: restaurantnummer                                     */
/*==============================================================*/
create type restaurantnummer
   from numeric(4)
go

execute sp_bindrule r_restaurantnummer, restaurantnummer
go

/*==============================================================*/
/* Table: artikel                                               */
/*==============================================================*/
create table artikel (
   restaurantnummer     restaurantnummer     not null,
   artikelnaam          char(50)             not null,
   artikelvoorraad      positiveinteger      not null,
   eenheidnaam          char(20)             not null,
   bijbestelhoeveelheid int                  not null,
   constraint pk_artikel primary key nonclustered (restaurantnummer, artikelnaam)
)
go

/*==============================================================*/
/* Table: artikeleenheid                                        */
/*==============================================================*/
create table artikeleenheid (
   eenheidnaam          char(20)             not null,
   constraint pk_artikeleenheid primary key nonclustered (eenheidnaam)
)
go

/*==============================================================*/
/* Table: bestelling                                            */
/*==============================================================*/
create table bestelling (
   bestellingnummer     numeric              identity,
   restaurantnummer     restaurantnummer     not null,
   medewerkerid         numeric              not null,
   statusnaam           char(50)             null default 'wachten op goedkeuring',
   momentvanplaatsing   datetime             null,
   gewenstafnamemoment  datetime             not null,
   isbezorging          bit                  not null,
   bezorglocatie        char(50)             null,
   constraint pk_bestelling primary key (bestellingnummer)
)
go

/*==============================================================*/
/* Table: bestellingproduct                                     */
/*==============================================================*/
create table bestellingproduct (
   bestellingnummer     numeric              not null,
   restaurantnummer     restaurantnummer     not null,
   productnaam          char(50)             not null,
   prijs                positivemoney        null,
   aantal               positiveinteger      not null,
   constraint pk_bestellingproduct primary key (restaurantnummer, productnaam, bestellingnummer)
)
go

/*==============================================================*/
/* Table: bestellingproduct_historie                            */
/*==============================================================*/
create table bestellingproduct_historie (
   bestellingnummer     numeric              not null,
   restaurantnummer     restaurantnummer     not null,
   productnaam          char(50)             not null,
   prijs                positivemoney        not null,
   aantal               positiveinteger      not null,
   constraint pk_bestellingproduct_historie primary key (restaurantnummer, productnaam, bestellingnummer)
)
go

/*==============================================================*/
/* Table: bestelling_historie                                   */
/*==============================================================*/
create table bestelling_historie (
   bestellingnummer     numeric              not null,
   restaurantnummer     restaurantnummer     not null,
   medewerkerid         numeric              not null,
   statusnaam           char(50)             not null default 'wachten op goedkeuring',
   momentvanplaatsing   datetime             not null,
   gewenstafnamemoment  datetime             not null,
   isbezorging          bit                  not null,
   bezorglocatie        char(50)             null,
   constraint pk_bestelling_historie primary key (bestellingnummer)
)
go

/*==============================================================*/
/* Table: bestelstatus                                          */
/*==============================================================*/
create table bestelstatus (
   statusnaam           char(50)             not null,
   constraint pk_bestelstatus primary key (statusnaam)
)
go

/*==============================================================*/
/* Table: dagmenu                                               */
/*==============================================================*/
create table dagmenu (
   restaurantnummer     restaurantnummer     not null,
   dagmenudatum         datetime             not null,
   constraint pk_dagmenu primary key nonclustered (restaurantnummer, dagmenudatum)
)
go

/*==============================================================*/
/* Table: dagmenuproduct                                        */
/*==============================================================*/
create table dagmenuproduct (
   restaurantnummer     restaurantnummer     not null,
   dagmenudatum         datetime             not null,
   productrestaurantnummer restaurantnummer     not null,
   productnaam          char(50)             not null,
   constraint pk_dagmenuproduct primary key (restaurantnummer, dagmenudatum, productnaam, productrestaurantnummer)
)
go

/*==============================================================*/
/* Table: dieetcategorie                                        */
/*==============================================================*/
create table dieetcategorie (
   dieetcategorienaam   char(20)             not null,
   constraint pk_dieetcategorie primary key nonclustered (dieetcategorienaam)
)
go

/*==============================================================*/
/* Table: eetvoorkeur                                           */
/*==============================================================*/
create table eetvoorkeur (
   medewerkerid         numeric              not null,
   eetvoorkeurdag       date                 not null,
   restaurantnummer     restaurantnummer     not null,
   constraint pk_eetvoorkeur primary key (eetvoorkeurdag, medewerkerid)
)
go

/*==============================================================*/
/* Table: eetvoorkeurproduct                                    */
/*==============================================================*/
create table eetvoorkeurproduct (
   eetvoorkeurdag       date                 not null,
   medewerkerid         numeric              not null,
   restaurantnummer     restaurantnummer     not null,
   productnaam          char(50)             not null,
   constraint pk_eetvoorkeurproduct primary key (eetvoorkeurdag, medewerkerid, restaurantnummer, productnaam)
)
go

/*==============================================================*/
/* Table: kassaverkoop                                          */
/*==============================================================*/
create table kassaverkoop (
   kassaverkoopnummer   numeric              identity,
   restaurantnummer     restaurantnummer     not null,
   medewerkerid         numeric              not null,
   dag                  datetime             not null,
   constraint pk_kassaverkoop primary key (kassaverkoopnummer)
)
go

/*==============================================================*/
/* Table: kassaverkoopproduct                                   */
/*==============================================================*/
create table kassaverkoopproduct (
   kassaverkoopnummer   numeric              not null,
   restaurantnummer     restaurantnummer     not null,
   productnaam          char(50)             not null,
   prijs                positivemoney        not null,
   aantal               positiveinteger      not null,
   constraint pk_kassaverkoopproduct primary key (restaurantnummer, productnaam, kassaverkoopnummer)
)
go

/*==============================================================*/
/* Table: kassaverkoopproduct_historie                          */
/*==============================================================*/
create table kassaverkoopproduct_historie (
   kassaverkoopnummer   numeric              not null,
   restaurantnummer     restaurantnummer     not null,
   productnaam          char(50)             not null,
   prijs                positivemoney        not null,
   aantal               positiveinteger      not null,
   constraint pk_kassaverkoopproduct_histori primary key (restaurantnummer, productnaam, kassaverkoopnummer)
)
go

/*==============================================================*/
/* Table: kassaverkoop_historie                                 */
/*==============================================================*/
create table kassaverkoop_historie (
   kassaverkoopnummer   numeric              not null,
   restaurantnummer     restaurantnummer     not null,
   medewerkerid         numeric              not null,
   dag                  datetime             not null,
   constraint pk_kassaverkoop_historie primary key (kassaverkoopnummer)
)
go

/*==============================================================*/
/* Table: medewerker                                            */
/*==============================================================*/
create table medewerker (
   medewerkerid         numeric              identity,
   username             varchar(50)          not null,
   voornaam             char(30)             not null,
   tussenvoegsel        char(15)             null,
   achternaam           char(30)             not null,
   constraint pk_medewerker primary key nonclustered (medewerkerid)
)
go

/*==============================================================*/
/* Table: medewerkerrol                                         */
/*==============================================================*/
create table medewerkerrol (
   medewerkerid         numeric              not null,
   rolnaam              char(30)             not null,
   restaurantnummer     restaurantnummer     not null,
   constraint pk_medewerkerrol primary key (medewerkerid, rolnaam, restaurantnummer)
)
go

/*==============================================================*/
/* Table: plaats                                                */
/*==============================================================*/
create table plaats (
   plaatsnaam           char(50)             not null,
   constraint pk_plaats primary key nonclustered (plaatsnaam)
)
go

/*==============================================================*/
/* Table: product                                               */
/*==============================================================*/
create table product (
   restaurantnummer     restaurantnummer     not null,
   productnaam          char(50)             not null,
   productomschrijving  char(100)            null,
   productcategorienaam char(20)             not null,
   productprijs         positivemoney        not null,
   islunchproduct       bit                  not null,
   constraint pk_product primary key nonclustered (restaurantnummer, productnaam)
)
go

/*==============================================================*/
/* Table: productcategorie                                      */
/*==============================================================*/
create table productcategorie (
   productcategorienaam char(20)             not null,
   constraint pk_productcategorie primary key nonclustered (productcategorienaam)
)
go

/*==============================================================*/
/* Table: productdieetcategorie                                 */
/*==============================================================*/
create table productdieetcategorie (
   restaurantnummer     restaurantnummer     not null,
   productnaam          char(50)             not null,
   dieetcategorienaam   char(20)             not null,
   constraint pk_productdieetcategorie primary key (restaurantnummer, productnaam, dieetcategorienaam)
)
go

/*==============================================================*/
/* Table: productsamenstelling                                  */
/*==============================================================*/
create table productsamenstelling (
   restaurantnummer     restaurantnummer     not null,
   productnaam          char(50)             not null,
   artikelrestaurantnummer restaurantnummer     not null,
   artikelnaam          char(50)             not null,
   artikelhoeveelheid   positiveinteger      not null,
   constraint pk_productsamenstelling primary key (productnaam, restaurantnummer, artikelnaam, artikelrestaurantnummer)
)
go

/*==============================================================*/
/* Table: restaurant                                            */
/*==============================================================*/
create table restaurant (
   restaurantnummer     restaurantnummer     not null,
   plaatsnaam           char(50)             not null,
   constraint pk_restaurant primary key nonclustered (restaurantnummer)
)
go

/*==============================================================*/
/* Table: rol                                                   */
/*==============================================================*/
create table rol (
   rolnaam              char(30)             not null,
   constraint pk_rol primary key nonclustered (rolnaam)
)
go

/*==============================================================*/
/* Table: standaarddagmenu                                      */
/*==============================================================*/
create table standaarddagmenu (
   restaurantnummer     restaurantnummer     not null,
   standaarddagmenunaam char(30)             not null,
   constraint pk_standaarddagmenu primary key nonclustered (restaurantnummer, standaarddagmenunaam)
)
go

/*==============================================================*/
/* Table: standaarddagmenuproduct                               */
/*==============================================================*/
create table standaarddagmenuproduct (
   restaurantnummer     restaurantnummer     not null,
   standaarddagmenunaam char(30)             not null,
   productrestaurantnummer restaurantnummer     not null,
   productnaam          char(50)             not null,
   constraint pk_standaarddagmenuproduct primary key (restaurantnummer, standaarddagmenunaam, productnaam, productrestaurantnummer)
)
go

/*==============================================================*/
/* View: bestellingen_van_restaurant                            */
/*==============================================================*/
create view bestellingen_van_restaurant as
select
   bh.restaurantnummer,
   bh.statusnaam,
   bh.isbezorging,
   bph.productnaam,
   sum(bph.aantal) as [aantal_producten],
   sum(bph.aantal*bph.prijs)as[totaal_omzet]
from
   bestelling_historie bh
   inner join bestellingproduct_historie bph on  bh.bestellingnummer = bph.bestellingnummer
group by
   bh.restaurantnummer,
   bh.statusnaam,
   bh.isbezorging,
   bph.productnaam
   
union

select
   b.restaurantnummer,
   b.statusnaam,
   b.isbezorging,
   bp.productnaam,
   sum(bp.aantal) as [aantal_producten],
   sum(bp.aantal*bp.prijs)as[totaal_omzet]
from
   bestelling b
   inner join bestellingproduct bp on  b.bestellingnummer = bp.bestellingnummer
group by
   b.restaurantnummer,
   b.statusnaam,
   b.isbezorging,
   bp.productnaam
go

/*==============================================================*/
/* View: kassa_verkopen_van_restaurant                          */
/*==============================================================*/
create view kassa_verkopen_van_restaurant as
select k.restaurantnummer, convert(date,k.dag)as datum,kp.productnaam,sum(kp.aantal)as [totaal_verkocht],sum(kp.aantal*kp.prijs)as [totaal_omzet]
from kassaverkoop k
inner join kassaverkoopproduct kp on k.kassaverkoopnummer = kp.kassaverkoopnummer
group by k.restaurantnummer, convert(date,k.dag), kp.productnaam
union

select kh.restaurantnummer, convert(date,kh.dag),kph.productnaam,sum(kph.aantal),sum(kph.aantal*kph.prijs)
from kassaverkoop_historie kh
inner join kassaverkoopproduct_historie kph on kh.kassaverkoopnummer = kph.kassaverkoopnummer
group by kh.restaurantnummer,convert(date,kh.dag),kph.productnaam
go

/*==============================================================*/
/* View: medewerker_bestellingen                                */
/*==============================================================*/
create view medewerker_bestellingen as
select
   bh.medewerkerid,
   bh.statusnaam,
   bh.isbezorging,
   bph.productnaam,
   sum(bph.aantal) as [aantal_producten],
   sum(bph.aantal*bph.prijs)as[totale_kosten]
from
   bestelling_historie bh
   inner join bestellingproduct_historie bph on  bh.bestellingnummer = bph.bestellingnummer
group by
   bh.medewerkerid,
   bh.statusnaam,
   bh.isbezorging,
   bph.productnaam
   
union

select
   b.medewerkerid,
   b.statusnaam,
   b.isbezorging,
   bp.productnaam,
   sum(bp.aantal),
   sum(bp.aantal*bp.prijs)
from
   bestelling b
   inner join bestellingproduct bp on  b.bestellingnummer = bp.bestellingnummer
group by
   b.medewerkerid,
   b.statusnaam,
   b.isbezorging,
   bp.productnaam
go

/*==============================================================*/
/* View: medewerker_maand_kosten                                */
/*==============================================================*/
create view medewerker_maand_kosten as
select
   bh.medewerkerid,
   datename(month,bh.momentvanplaatsing) as maand,
   datepart(year,bh.momentvanplaatsing) as jaar,
   sum(bph.prijs*bph.aantal) as [kosten]
from
   bestelling_historie bh
   inner join bestellingproduct_historie bph on  bh.bestellingnummer = bph.bestellingnummer
group by
   bh.medewerkerid,
   datepart(year,bh.momentvanplaatsing),
   datename(month,bh.momentvanplaatsing)
union
select
   k.medewerkerid,
   datename(month,k.dag) as maand,
   datepart(year,k.dag) as jaar,
   sum(kp.prijs*kp.aantal) as [kosten]
from
   kassaverkoop k
   inner join kassaverkoopproduct kp on  k.kassaverkoopnummer = kp.kassaverkoopnummer
group by
   k.medewerkerid,
   datepart(year,k.dag),
   datename(month,k.dag)
union
select
   kh.medewerkerid,
   datename(month,kh.dag) as maand,
   datepart(year,kh.dag) as jaar,
   sum(kph.prijs*kph.aantal) as [kosten]
from
   kassaverkoop_historie kh
   inner join kassaverkoopproduct_historie kph on  kh.kassaverkoopnummer = kph.kassaverkoopnummer
group by
   kh.medewerkerid,
   datepart(year,kh.dag),
   datename(month,kh.dag)
go

/*==============================================================*/
/* View: restaurant_maand_omzet                                 */
/*==============================================================*/
create view restaurant_maand_omzet as
select bh.restaurantnummer,datename(month,bh.momentvanplaatsing) as maand, datepart(year,bh.momentvanplaatsing) as jaar, sum(bph.prijs*bph.aantal) as[omzet]
from bestelling_historie bh
inner join bestellingproduct_historie bph on bh.bestellingnummer = bph.bestellingnummer
group by bh.restaurantnummer,datepart(year,bh.momentvanplaatsing),datename(month,bh.momentvanplaatsing)

union

select k.restaurantnummer,datename(month,k.dag) as maand, datepart(year,k.dag) as jaar, sum(kp.prijs*kp.aantal) as[omzet]
from kassaverkoop k
inner join kassaverkoopproduct kp on k.kassaverkoopnummer = kp.kassaverkoopnummer
group by k.restaurantnummer,datepart(year,k.dag),datename(month,k.dag)

union

select kh.restaurantnummer,datename(month,kh.dag) as maand, datepart(year,kh.dag) as jaar, sum(kph.prijs*kph.aantal) as[kosten]
from kassaverkoop_historie kh
inner join kassaverkoopproduct_historie kph on kh.kassaverkoopnummer = kph.kassaverkoopnummer
group by kh.restaurantnummer,datepart(year,kh.dag),datename(month,kh.dag)
go

/*==============================================================*/
/* View: restaurant_verwachte_voorraad                          */
/*==============================================================*/
create view restaurant_verwachte_voorraad as
select b.restaurantnummer, convert(date,b.gewenstafnamemoment)as dag, ps.artikelnaam,a.artikelvoorraad,(sum(bp.aantal)*ps.artikelhoeveelheid) as [verbruik],(a.artikelvoorraad -(sum(bp.aantal)*ps.artikelhoeveelheid))as [verwachte_voorraad]
from bestelling b 
        inner join bestellingproduct bp on b.bestellingnummer = bp.bestellingnummer
            inner join productsamenstelling ps on bp.restaurantnummer = ps.restaurantnummer and bp.productnaam = ps.productnaam
                inner join artikel a on ps.restaurantnummer = a.restaurantnummer and ps.artikelnaam = a.artikelnaam
group by b.restaurantnummer,convert(date,b.gewenstafnamemoment),ps.artikelnaam,ps.artikelhoeveelheid,a.artikelvoorraad
go

alter table artikel
   add constraint fk_artikel_restaurant foreign key (restaurantnummer)
      references restaurant (restaurantnummer)
         on update cascade
go

alter table artikel
   add constraint fk_artikel_artikeleenheid foreign key (eenheidnaam)
      references artikeleenheid (eenheidnaam)
go

alter table bestelling
   add constraint fk_bestelling_medewerker foreign key (medewerkerid)
      references medewerker (medewerkerid)
         on update cascade
go

alter table bestelling
   add constraint fk_bestelling_restaurant foreign key (restaurantnummer)
      references restaurant (restaurantnummer)
         on update cascade
go

alter table bestelling
   add constraint fk_bestelling_bestelstatus foreign key (statusnaam)
      references bestelstatus (statusnaam)
         on update cascade
go

alter table bestellingproduct
   add constraint fk_kasbestellingproduct_bestelling foreign key (bestellingnummer)
      references bestelling (bestellingnummer)
         on update cascade on delete cascade
go

alter table bestellingproduct
   add constraint fk_bestellingproduct_product foreign key (restaurantnummer, productnaam)
      references product (restaurantnummer, productnaam)
         on update cascade
go

alter table bestellingproduct_historie
   add constraint fk_his_bestellingproduct_bestelling foreign key (bestellingnummer)
      references bestelling_historie (bestellingnummer)
         on update cascade on delete cascade
go

alter table bestelling_historie
   add constraint fk_his_bestelli_reference_medewerk foreign key (medewerkerid)
      references medewerker (medewerkerid)
         on update cascade
go

alter table dagmenu
   add constraint fk_dagmenu_restaurant foreign key (restaurantnummer)
      references restaurant (restaurantnummer)
         on update cascade on delete cascade
go

alter table dagmenuproduct
   add constraint fk_dagmenuproduct_dagmenu foreign key (restaurantnummer, dagmenudatum)
      references dagmenu (restaurantnummer, dagmenudatum)
         on update cascade on delete cascade
go

alter table dagmenuproduct
   add constraint fk_dagmenuproduct_product foreign key (productrestaurantnummer, productnaam)
      references product (restaurantnummer, productnaam)
         on update cascade on delete cascade
go

alter table eetvoorkeur
   add constraint fk_eetvoorkeur_restaurant foreign key (restaurantnummer)
      references restaurant (restaurantnummer)
         on update cascade
go

alter table eetvoorkeur
   add constraint fk_eetvoorkeur_medewerker foreign key (medewerkerid)
      references medewerker (medewerkerid)
         on update cascade
go

alter table eetvoorkeurproduct
   add constraint fk_eetvoorkeurproduct_eetvoorkeur foreign key (eetvoorkeurdag, medewerkerid)
      references eetvoorkeur (eetvoorkeurdag, medewerkerid)
         on update cascade on delete cascade
go

alter table eetvoorkeurproduct
   add constraint fk_eetvoorkeurproduct_product foreign key (restaurantnummer, productnaam)
      references product (restaurantnummer, productnaam)
         on update cascade
go

alter table kassaverkoop
   add constraint fk_kassaver_reference_medewerk foreign key (medewerkerid)
      references medewerker (medewerkerid)
         on update cascade
go

alter table kassaverkoop
   add constraint fk_kassaver_reference_restaura foreign key (restaurantnummer)
      references restaurant (restaurantnummer)
         on update cascade
go

alter table kassaverkoopproduct
   add constraint fk_kasproduct_bestelling foreign key (kassaverkoopnummer)
      references kassaverkoop (kassaverkoopnummer)
         on update cascade on delete cascade
go

alter table kassaverkoopproduct
   add constraint fk_kassaver_reference_product foreign key (restaurantnummer, productnaam)
      references product (restaurantnummer, productnaam)
         on update cascade
go

alter table kassaverkoopproduct_historie
   add constraint fk_hiss_bestellingproduct_bestelling foreign key (kassaverkoopnummer)
      references kassaverkoop_historie (kassaverkoopnummer)
         on update cascade on delete cascade
go

alter table kassaverkoop_historie
   add constraint fk_his_kassaver_reference_medewerk foreign key (medewerkerid)
      references medewerker (medewerkerid)
         on update cascade
go

alter table medewerkerrol
   add constraint fk_medewerkerrol_medewerker foreign key (medewerkerid)
      references medewerker (medewerkerid)
         on update cascade on delete cascade
go

alter table medewerkerrol
   add constraint fk_medewerkerrol_restaurant foreign key (restaurantnummer)
      references restaurant (restaurantnummer)
         on update cascade
go

alter table medewerkerrol
   add constraint fk_medewerkerrol_rol foreign key (rolnaam)
      references rol (rolnaam)
         on update cascade
go

alter table product
   add constraint fk_product_productcategorie foreign key (productcategorienaam)
      references productcategorie (productcategorienaam)
         on update cascade
go

alter table product
   add constraint fk_product_restaurant foreign key (restaurantnummer)
      references restaurant (restaurantnummer)
go

alter table productdieetcategorie
   add constraint fk_productdieetcategorie_product foreign key (restaurantnummer, productnaam)
      references product (restaurantnummer, productnaam)
         on update cascade on delete cascade
go

alter table productdieetcategorie
   add constraint fk_productdieetcategorie_dieetcategorie foreign key (dieetcategorienaam)
      references dieetcategorie (dieetcategorienaam)
         on update cascade
go

alter table productsamenstelling
   add constraint fk_productsamenstelling_artikel foreign key (artikelrestaurantnummer, artikelnaam)
      references artikel (restaurantnummer, artikelnaam)
go

alter table productsamenstelling
   add constraint fk_productsamenstelling_product foreign key (restaurantnummer, productnaam)
      references product (restaurantnummer, productnaam)
         on update cascade on delete cascade
go

alter table restaurant
   add constraint fk_restaurant_plaats foreign key (plaatsnaam)
      references plaats (plaatsnaam)
         on update cascade
go

alter table standaarddagmenu
   add constraint fk_standaarddagmenu_restaurant foreign key (restaurantnummer)
      references restaurant (restaurantnummer)
         on update cascade on delete cascade
go

alter table standaarddagmenuproduct
   add constraint fk_standaarddagmenuproduct_standaarddagmenu foreign key (restaurantnummer, standaarddagmenunaam)
      references standaarddagmenu (restaurantnummer, standaarddagmenunaam)
         on update cascade on delete cascade
go

alter table standaarddagmenuproduct
   add constraint fk_standaarddagmenuproduct_product foreign key (productrestaurantnummer, productnaam)
      references product (restaurantnummer, productnaam)
         on update cascade on delete cascade
go

