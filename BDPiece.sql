 
drop sequence if exists  numpiece;
drop table if exists representation;
drop table if exists lieu;
drop table if exists piece;
drop table if exists auteur;

create sequence numpiece minvalue 101;

create table auteur
(nom varchar(30) primary key,
nomcomplet varchar(100),
naissance int,
deces int);

create table piece
(numero int primary key,
titrecourt varchar(50),
titreoriginal varchar(100),
langue varchar(20),
annee int,
nom_auteur varchar(30),
foreign key (nom_auteur) references auteur(nom),
constraint lalangue check (langue in ('français','anglais','italien','allemand','arabe')));

create table lieu
(nomlieu varchar(50) primary key,
nbplaces int,
acceshandi char(3),
constraint lelieu check(nomlieu in ('Grand Théâtre', 'Chabada', 'Chanzy', 'Le Quai')),
constraint lacces check(acceshandi in ('OUI', 'NON')));

create table representation
(numero int references piece,
nomlieu varchar(50) references lieu,
daterep date,
moment varchar(20),
primary key (numero, nomlieu, daterep, moment),
constraint lemoment check(moment in ('après-midi', 'début de soirée', 'fin de soirée'))
);


insert into auteur(nom,nomcomplet,naissance,deces) values
('Beckett', 'Beckett (Samuel)',1906,1989),
('Feydeau','Feydeau (Georges)',1862,1921),
('Wilde', 'Wilde (Oscar)',1854,1900),
('Diderot', 'Diderot (Denis)',1713,1784),
('Rostand', 'Rostand (Edmond)',1868,1918),
('Brecht', 'Brecht (Bertolt)',1898,1956),
('Genet', 'Genet (Jean)',1910,1986),
('Camus', 'Camus (Albert)',1913,1960),
('Musset', 'Musset (Alfred de)',1810,1857),
('Ionesco', 'Ionesco (Eugène)',1909,1994),
('Beaumarchais', 'Beaumarchais (Pierre-Augustin Caron de)',1732,1799),
('Corneille', 'Corneille (Pierre)',1606,1684),
('Jarry', 'Jarry (Alfred)',1873,1907),
('Pagnol', 'Pagnol (Marcel)',1895,1974),
('Racine','Racine (Jean)',1639,1699),
('Molière', 'Molière (Jean-Baptiste Poquelin, dit)',1622,1673),
('Hugo', 'Hugo (Victor)',1802,1885),
('Shakespeare', 'Shakespeare (William)',1564,1616),
('Saint-Exupéry','Saint-Exupéry (Antoine de)',1900,1944)
;


insert into piece(numero, titrecourt, nom_auteur, titreoriginal, langue, annee) values
(nextval('numpiece'),'Hamlet','Shakespeare','Tragedy (The) of Hamlet, Prince of Denmark','anglais',1603),
(nextval('numpiece'),'Richard III','Shakespeare','Life (The) and Death of Richard the Third','anglais',1592),
(nextval('numpiece'),'Roméo et Juliette','Shakespeare','Romeo and Juliet','anglais',1597),
(nextval('numpiece'),'Macbeth','Shakespeare','Tragedy (The) of Macbeth','anglais',1611),
(nextval('numpiece'),'Othello','Shakespeare','Othello, the Moor of Venice','anglais',1604),
(nextval('numpiece'),'Joyeuses Commères de Windsor (Les)','Shakespeare','Merry (The) Wives of Windsor','anglais',1602),
(nextval('numpiece'),'Roi Lear (Le)','Shakespeare','King Lear','anglais',1606),
(nextval('numpiece'),'Beaucoup de bruit pour rien','Shakespeare','Much Ado About Nothing','anglais',1600),
(nextval('numpiece'),'Comme il vous plaira','Shakespeare','As You Like it','anglais',1623),
(nextval('numpiece'),'Marchand de Venise (Le)','Shakespeare','Merchant (The) of Venice','anglais',1600),
(nextval('numpiece'),'Nuit des rois (La)','Shakespeare','Twelfth Night, Or What You Will','anglais',1602),
(nextval('numpiece'),'Songe d''une nuit d''été (Le)','Shakespeare','Midsummer (A) Night''s Dream','anglais',1600),
(nextval('numpiece'),'Ruy Blas','Hugo','Ruy Blas','français',1838),
(nextval('numpiece'),'Hernani','Hugo','Hernani ou l Honneur castillan','français',1830),
(nextval('numpiece'),'Lucrèce Borgia','Hugo','Lucrèce Borgia','français',1833),
(nextval('numpiece'),'Roi s''amuse (Le)','Hugo','Roi s''amuse (Le)','français',1832),
(nextval('numpiece'),'Amy Robsart','Hugo','Amy Robsart','français',1828),
(nextval('numpiece'),'Marion de Lorme','Hugo','Marion de Lorme','français',1831),
(nextval('numpiece'),'Marie Tudor','Hugo','Marie Tudor','français',1833),
(nextval('numpiece'),'Angelo tyran de Padoue','Hugo','Angelo tyran de Padoue','français',1835),
(nextval('numpiece'),'Dom Juan','Molière','Dom Juan ou Le Festin de Pierre','français',1665),
(nextval('numpiece'),'Misanthrope (Le)','Molière','Misanthrope (Le)','français',1666),
(nextval('numpiece'),'Tartuffe','Molière','Tartuffe ou l''Imposteur','français',1669),
(nextval('numpiece'),'Fourberies de Scapin (Les)','Molière','Fourberies de Scapin (Les)','français',1671),
(nextval('numpiece'),'Bourgeois gentilhomme (Le)','Molière','Bourgeois gentilhomme (Le)','français',1670),
(nextval('numpiece'),'Avare (L'')','Molière','Avare (L'')','français',1668),
(nextval('numpiece'),'Britannicus','Racine','Britannicus','français',1669),
(nextval('numpiece'),'Andromaque','Racine','Andromaque','français',1667),
(nextval('numpiece'),'Phèdre','Racine','Phèdre','français',1677),
(nextval('numpiece'),'Plaideurs (Les)','Racine','Plaideurs (Les)','français',1668),
(nextval('numpiece'),'Thébaïde (La)','Racine','Thébaïde (La) ou les Frères ennemis','français',1664),
(nextval('numpiece'),'Marius','Pagnol','Marius','français',1929),
(nextval('numpiece'),'Fanny','Pagnol','Fanny','français',1931),
(nextval('numpiece'),'César','Pagnol','César','français',1946),
(nextval('numpiece'),'Topaze','Pagnol','Topaze','français',1928),
(nextval('numpiece'),'Ubu roi','Jarry','Ubu roi','français',1896),
(nextval('numpiece'),'Ubu cocu','Jarry','Ubu cocu','français',1944),
(nextval('numpiece'),'Ubu sur la butte','Jarry','Ubu sur la butte','français',1906),
(nextval('numpiece'),'Ubu enchaîné','Jarry','Ubu enchaîné','français',1899),
(nextval('numpiece'),'Cantrice chauve (La)','Ionesco','Cantrice chauve (La)','français',1950),
(nextval('numpiece'),'Leçon (La)','Ionesco','Leçon (La)','français',1951),
(nextval('numpiece'),'Rhinocéros','Ionesco','Rhinocéros','français',1959),
(nextval('numpiece'),'Barbier de Séville (Le)','Beaumarchais','Barbier (Le) de Séville ou la Précaution inutile','français',1775),
(nextval('numpiece'),'Mariage de Figaro (Le)','Beaumarchais','Folle (La) Journée ou le Mariage de Figaro','français',1778),
(nextval('numpiece'),'Mère coupable (La)','Beaumarchais','Autre (L'') Tartuffe ou la Mère coupable','français',1792),
(nextval('numpiece'),'Cid (Le)','Corneille','Cid (Le)','français',1637),
(nextval('numpiece'),'Horace','Corneille','Horace','français',1640),
(nextval('numpiece'),'Polyeucte','Corneille','Polyeucte martyr','français',1642),
(nextval('numpiece'),'Caprices de Marianne (Les)','Musset','Caprices de Marianne (Les)','français',1833),
(nextval('numpiece'),'Lorenzaccio','Musset','Lorenzaccio','français',1834),
(nextval('numpiece'),'Résistible Ascension d''Arturo Ui (La)','Brecht','Der aufhaltsame Aufstieg des Arturo Ui','allemand',1941),
(nextval('numpiece'),'En attendant Godot','Beckett','En attendant Godot','français',1952),
(nextval('numpiece'),'Justes (Les)','Camus','Justes (Les)','français',1949),
(nextval('numpiece'),'Bonnes (Les)','Genet','Bonnes (Les)','français',1947),
(nextval('numpiece'),'Cyrano de Bergerac','Rostand','Cyrano de Bergerac','français',1897),
(nextval('numpiece'),'Importance d''être Constant (L'')','Wilde','','anglais',1895),
(nextval('numpiece'),'Alexandre le Grand','Racine','Alexandre le Grand','français',1665),
(nextval('numpiece'),'Bérénice','Racine','Bérénice','français',1670),
(nextval('numpiece'),'Bajazet','Racine','Bajazet','français',1672),
(nextval('numpiece'),'Est-il bon ? Est-il méchant ?','Diderot','Est-il bon ? Est-il méchant ?','français',1834),
(nextval('numpiece'),'Un fil à la patte','Feydeau','Un fil à la patte','français',1894),
(nextval('numpiece'),'Le Dindon','Feydeau','Le Dindon','français',1896),
(nextval('numpiece'),'On purge Bébé !','Feydeau','On purge Bébé !','français',1910),
(nextval('numpiece'),'La Puce à l''oreille','Feydeau','La Puce à l''oreille','français',1907),
(nextval('numpiece'),'L''Hotel du libre échange','Feydeau','L''Hotel du libre échange','français',1894)
;

insert into lieu values
('Grand Théâtre',2000,'OUI'),
('Chabada',500,'OUI'),
('Chanzy',500,'NON'),
('Le Quai',900,'OUI');

insert into representation values
(102,'Le Quai','23-09-2018','début de soirée'),
(102,'Chanzy','23-10-2018','fin de soirée'),
(110,'Grand Théâtre','12-10-2018','début de soirée'),
(108,'Le Quai','28-11-2018','fin de soirée'),
(125,'Grand Théâtre','09-11-2018','début de soirée'),
(108,'Le Quai','29-11-2018','début de soirée'),
(150,'Chanzy','04-12-2018','fin de soirée'),
(108,'Chanzy','30-11-2018','début de soirée'),
(110,'Grand Théâtre','14-10-2018','après-midi'),
(108,'Chabada','27-11-2018','après-midi'),
(108,'Grand Théâtre','01-12-2018','début de soirée')
;

