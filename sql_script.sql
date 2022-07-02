USE biblio;

# 3 nombre de tuples
#adherents 30
select count(*) from adherents;

#emprunter
select count(*) from emprunter;

#livres 
select count(*) from livres;

#oeuvres
select count(*) from oeuvres;

# 4 Attributs
# adherents
select * from adherents limit 5;

#emprunter
select * from emprunter limit 5;

#livres 
select * from livres limit 5;

#oeuvres 
select * from oeuvres limit 5;

## interactions avec la base de donnees

# 9 livres actuellement empruntes
select * from livres where NL in ( select NL from emprunter);

# 10 livres empruntés par Jeannette Lecoeur
select l.*,concat(a.prenom,' ',a.nom) as nom from livres l join emprunter e on e.NL=l.NL join adherents a on e.NA=a.NA where a.nom='Lecoeur' and a.prenom='Jeanette';

# 11 livres empruntes em Septembre 2009 
select l.*,e.dateEmp as date_emprunt from livres l join emprunter e on e.NL=l.NL where e.dateEmp like ('2009-09%');

#12 les adherents ayant empruntes un livre de Fedor Dostoievski.
select a.*,o.titre,o.auteur from adherents a inner join emprunter e on a.NA=e.NA inner join oeuvres o on o.NO=e.NL where o.auteur='Fedor DOSTOIEVSKI';

#13 inscription d'un nouvel adherent
insert into adherents (nom,prenom,adr,tel) values ('Dupond','Olivier','76, quai de la Loire,75019 Paris','0102030405');

#14 Martine CROZIER vient d’emprunter « Au coeur des ténèbres » que vous venez d’ajouter et « Le rouge et le noir » chez Hachette, livre n°23.
select * from emprunter limit 5;

DELIMITER $$
create procedure p_emprunter( in v_adherent varchar(45),in v_titre varchar(45),in v_editeur varchar(45))
BEGIN
	declare v_id_adherent int;
    declare v_id_NL int;
    
    select `NO` into v_id_NL from oeuvres where titre=v_titre;
    select a.NA into v_id_adherent from adherents a where concat(a.prenom,' ',upper(a.nom))=v_adherent;
	
    insert into emprunter(NL,dateEmp,dureeMax,dateRet,NA) values(v_id_NL,DATE_FORMAT(SYSDATE(), '%y-%m-%d'),14,DATE_FORMAT(SYSDATE(), '%y-%m-%d')+14,v_id_adherent);
    
END$$
DELIMITER ;

call p_emprunter('Martine CORZIER','Au coeur des ténèbres','HACHETTE');
call p_emprunter('Martine CORZIER','Le rouge et le noir','HACHETTE');

# 15 remise de livre

DELIMITER $$
create procedure p_remettre(in v_adherent varchar(45))
BEGIN
	declare v_id_adherent int;
    select NA into v_id_adherent from adherents where concat(prenom,' ',upper(nom))=v_adherent;
    delete from emprunter where NA=v_id_adherent;
END$$
DELIMITER ;

call p_remettre('Cyril FREDERIC');

