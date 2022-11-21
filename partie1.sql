-- Partie 1.

DROP TABLE IF EXISTS DetailLivraison;
DROP TABLE IF EXISTS LigneCommande ;
DROP TABLE IF EXISTS Livraison ;
DROP TABLE IF EXISTS Article ;
DROP TABLE IF EXISTS Commande ;
DROP TABLE IF EXISTS Client ;

CREATE TABLE Client(
    noClient int  ,
    nomClient varchar(128),
    noTelephone varchar(128),
    primary key (noClient)
    
);
    
CREATE TABLE Commande(
    noCommande int,
    dateCommande date,
    noClient int,
    primary key (noCommande),
    foreign key(noClient) references Client(noClient)
);
    
CREATE TABLE Article(
    noArticle int,
    description varchar(128),
    prixUnitaire decimal,
    quantiteEnStock int,
    primary key (noArticle)
);

CREATE TABLE LigneCommande(
    noCommande int,
    noArticle int,
    quantite int,
    primary key (noCommande,noArticle),
	constraint unique1 Unique(noCommande),
	constraint unique2 Unique(noArticle),
    foreign key(noCommande) references 		  Commande(noCommande),
    foreign key(noArticle) references Article(noArticle)
    );

CREATE TABLE Livraison(
    noLivraison int,
    dateLivraison date,
    primary key (noLivraison)
    
    );

CREATE TABLE DetailLivraison(
    noLivraison int,
    noCommande int,
    noArticle int,
    quantiteLivree int,
    primary key(noLivraison,noCommande,noArticle),
    foreign key(noLivraison) references Livraison(noLivraison),
    foreign key(noCommande) references LigneCommande(noCommande),
    foreign key(noArticle) references LigneCommande(noArticle)
);

INSERT INTO Client (noClient, nomClient, noTelephone)
VALUES (1, 'John Smith', '514-111-1111'),
(2,'Bob Marley','514-222-2222'),
(3,'Jean Pierre','514-333-3333'),
(10,'George White','514-444-4444')
;

INSERT INTO Commande (noCommande, dateCommande, noClient)
VALUES (1, '2006-05-01', 1),
(2,'2006-05-01',2),
(3,'2006-07-01',10),
(4,'2006-07-01',10)
;

INSERT INTO Article (noArticle, description, prixUnitaire,quantiteEnStock)
VALUES (1, 'Plante', 20.63,23),
(2,'Aspirateur',100.63,33),
(3,'Velo',200.65,44),
(4,'Casque',68.97,55)
;

INSERT INTO LigneCommande (noCommande, noArticle, quantite)
VALUES (1, 1, 23),
(2,2,33),
(3,3,43),
(4,4,53)
;

INSERT INTO Livraison (noLivraison, dateLivraison)
VALUES (1, '2006-08-01'),
(2,'2006-08-01'),
(3,'2006-08-01'),
(4,'2006-08-01')
;

INSERT INTO  DetailLivraison (noLivraison,noCommande,noArticle,quantiteLivree )
VALUES (1, 1,1,13),
(2,2,2,23),
(2,3,3,24)

;

With 
   rr1 as  (select Article.noArticle,LigneCommande.noCommande from Article inner join LigneCommande on Article.noArticle=LigneCommande.noArticle),
   rr2 as (select Commande.dateCommande,Commande.noCommande,Client.noClient from Commande inner join Client on Client.noClient=Commande.noClient),
   rr3 as (select rr1.noArticle,rr1.noCommande,rr2.dateCommande,rr2.noClient from rr1 inner join rr2 on rr1.noCommande=rr2.noCommande) 
SELECT rr3.noArticle from rr3
where  rr3.dateCommande > '2006-06-01' and rr3.noClient =10;

With
   r1 as (select Commande.noCommande, Commande.dateCommande  from Commande where Commande.noCommande=2)
select Commande.noCommande from (r1 inner join Commande on r1.dateCommande=Commande.dateCommande);

with 
   r1 as (select Commande.noCommande from Commande inner join LigneCommande on Commande.noCommande=LigneCommande.noCommande)
select r1.noCommande,DetailLivraison.noLivraison from (r1 left join DetailLivraison on r1.noCommande=DetailLivraison.noCommande);

with
   r1 as (select Client.noClient,Client.nomClient,Commande.dateCommande from Client inner join Commande on Client.noClient=Commande.noClient)
select r1.noClient,r1.nomClient from r1 where r1.dateCommande < '2000-03-01' or r1.dateCommande > '2000-03-31';

with 
   r1 as (select Commande.noClient,LigneCommande.noArticle from Commande inner join LigneCommande on Commande.noCommande=LigneCommande.noCommande)
select r1.noArticle from r1 where r1.noClient=10;

select Article.noArticle,Article.prixUnitaire from Article 
group by Article.noArticle
having Article.prixUnitaire < avg(Article.prixUnitaire);

with
   r1 as (select LigneCommande.noCommande,LigneCommande.quantite,DetailLivraison.quantiteLivree 
		  from LigneCommande inner join DetailLivraison on LigneCommande.noCommande=DetailLivraison.noCommande)
select r1.noCommande,r1.quantite,(r1.quantite - r1.quantiteLivree) as quantiteAttente from r1 where r1.quantite>r1.quantiteLivree;
