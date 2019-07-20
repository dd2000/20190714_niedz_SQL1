-- ﻿Podstawowe zapytania

-- 1) Wyświetl stażnikow  którzy mają na nazwisji Jan
SELECT * FROM straznik WHERE imie='Jan'

-- 2) Wyswietl strazników z nazwiskiem Kowalski i zarabiajacych powyżej 1500
SELECT * FROM straznik WHERE nazwisko='Kowalski' AND pensja<1500

-- 3) Wyswietl staznikow którzy maja inny stopień niż 'Szeregowiec'
SELECT * FROM straznik WHERE stopien<>'Szeregowiec'

-- 4) Wyświetl srażników którzy zarabiaja w granicach (1500,2500)
SELECT * FROM straznik WHERE pensja>1500 AND pensja<2500

-- 5) Wyświetlenie wszystkich strażników z tym, że zamiast kolumna 'imie' 
--  chciałbym żeby była kolumna imie_strażnika a po tym wszystkie oryginalne kolumny.

SELECT imie AS imie_straznika, nazwisko, stopien, data_zatrudnienia,pensja,
skladka_na_ubezpieczenie 
FROM  straznik

-- 6) Wyświetlić strażników ale bez strażników o nazwisku Nowak i Kowalczyk

SELECT * FROM  straznik WHERE nazwisko<>'Nowak' AND nazwisko<>'Kowalczyk';
SELECT * FROM  straznik WHERE nazwisko NOT IN ('Nowak','Kowalczyk');

-- jest Nowak            0 AND 1 = 0
-- jest Kowalczyk        1 AND 0 = 0
-- pozsotale             1 AND 1 = 1 

-- 7) Wyświetlić strażników ale bez strażników o id 1,6,5 (z użyciem IN)

SELECT * FROM  straznik WHERE id NOT IN(1,6,5)

-- 8) Wyświetlić strazników i pensje które są większe od 1500 ale po odjęciu 
-- "skladka_na_ubezpieczenie"

SELECT *, (pensja-skladka_na_ubezpieczenie) AS po_odjeciu 
FROM  straznik WHERE (pensja-skladka_na_ubezpieczenie)>1500

-- 9) Wyświetlić pasażerów posortowanych po nazwisku i imieniu
-- (kolejnosci rosnaca)

SELECT * FROM  pasazer ORDER BY nazwisko ASC, imie ASC

-- 10) Wyświetlić strażników którzy mają nazwisko rozpoczynające się od "Kowal"

SELECT * FROM  straznik WHERE nazwisko LIKE 'Kowal%'

-- 11) Wyświetlic strażników którzy zatrudnili się miedzy 2017.01.01 a 2020.01.01
SELECT * FROM straznik data_zatrudnienia>'2017-01-01' AND data_zatrudnienia<'2020-01-01'

-- 12) Wyświetlić strażników o nazwisku Nowak i którzy zostali zatrudnieni od 
-- początku poprzedniego roku

SELECT * FROM  straznik WHERE nazwisko='Nowak' AND 
data_zatrudnienia>='2017-01-01';

SELECT * FROM  straznik WHERE nazwisko='Nowak' AND 
data_zatrudnienia>=STR_TO_DATE(YEAR(now())-1,'%Y')

-- albo 

SELECT DATE_FORMAT(DATE_ADD(now(), INTERVAL -12 MONTH),'%Y-01-01') ;

SELECT * FROM  straznik WHERE nazwisko='Nowak' AND 
data_zatrudnienia>=DATE_FORMAT(DATE_ADD(now(), INTERVAL -12 MONTH),'%Y-01-01') 


-- 13) Wyświetlić nazwisko+pensje strażników 
-- pomniejszone skladka_na_ubezpieczenie,  kolumna ma się nazywać pensja_do_wyplaty
 
SELECT imie,nazwisko, (pensja-skladka_na_ubezpieczenie)   AS pensja_do_wyplaty 
FROM  straznik

-- 14) Wyświetlić wszystkich strażników aktualnych i archiwalnych ( straznik_archiwum) 
-- w jednej tabeli

SELECT * FROM  straznik UNION SELECT * FROM  straznik_archiwum;  

SELECT * FROM 
(SELECT * FROM  straznik UNION SELECT * FROM  straznik_archiwum) wynikowa
 ORDER BY nazwisko; 

-- 15) Zadania to co poprzednio ale posortować strażników po nazwisku i mieniu w kolejności rosnącej

-- 16) Wyświetlić strażnika który nie ma ustawionego pola skladka_na_ubezpieczenie 
-- (jest to NULL)

SELECT * FROM  straznik WHERE skladka_na_ubezpieczenie IS NULL

-- Używanie agregatów -  
-- ---------------------------
-- 17) Napisać zapytania które poda sumę  pensji (pola pensja) dla wszystkich strażników

SELECT sum(pensja) FROM  straznik

-- 18) Podać średnią, minimalną, maksymalną pensję strażników

SELECT avg(pensja),min(pensja),max(pensja) FROM  straznik

-- 19) Podac liczbę  pasażerów w systemie

SELECT  count(*) FROM  pasazer 

-- 20) Podac liczbe pasazerow ktorych nazwisko rozpoczynają się od K
SELECT count(*) FROM pasazer WHERE nazwisko LIKE 'K%'

-- 21) Podać liczbę strażników ale tych którzy mają uzupełnione 
-- pole skladka_na_ubezpieczenie

SELECT  count(*) FROM  straznik  WHERE skladka_na_ubezpieczenie IS NOT NULL;
UPDATE  straznik SET  skladka_na_ubezpieczenie=NULL WHERE id=7;

-- 22) Wyświetlic zestawienie informujące ile jest strażników z określonymi stopniami
SELECT stopien, coount(*) FROM straznik GROUP BY stopien

-- Zapytania z JOIN
-- -----------------
-- 23) Wyświetlić wszystkie kontrole przeprowadzone na  lotnisku Gdańsk

SELECT * FROM  kontrola k JOIN  numer_stanowiska ns ON k.id_numer_stanowiska=ns.id
 WHERE ns.nazwa_portu='Gdańsk';

-- albo

SELECT * FROM  kontrola k JOIN  numer_stanowiska ns ON k.id_numer_stanowiska=ns.id
JOIN  port_lotniczy pl ON ns.nazwa_portu=pl.nazwa_portu
 WHERE pl.nazwa_portu='Gdańsk';

-- 24) Wyświetlić wszystkie kontrole przeprowadzone dla lotnisku Gdańsk przez strażnika/ów który ma nazwisko 
-- 'Nowak'

SELECT * FROM  straznik s JOIN  kontrola k ON s.id=k.id_straznik 
JOIN  numer_stanowiska ns ON  ns.id=k.id_numer_stanowiska 
WHERE  ns.nazwa_portu='Gdańsk' AND s.nazwisko='Nowak';


-- 25) Wyświetlić strażników i przeprowadzone przez nich kontrole jeśli strażnik 
-- nie ma kontroli to wyświetlamy informację o strażniku a w części kontrolu 
-- wyświetlamy nulle 

SELECT  *
FROM  straznik s  LEFT JOIN  kontrola k ON k.id_straznik=s.id; 

-- 26) Wyświetlić wszystkie lotniska odwiedzone przez pasażera imie="Jan"  

SELECT  DISTINCT s.nazwa_portu FROM  pasazer p  JOIN  kontrola k 
ON k.id_pasazer=p.id  
JOIN  numer_stanowiska s ON k.id_numer_stanowiska=s.id
WHERE p.imie='Jan' AND p.nazwisko='Brzechwa';

SELECT  * FROM  pasazer p  JOIN  kontrola k ON k.id_pasazer=p.id  
JOIN  numer_stanowiska s ON k.id_numer_stanowiska=s.id
WHERE p.imie='Jan' AND p.nazwisko='Brzechwa';
  
-- Tworzenie tabel
-- 27) Dodaj dodatkowa kolumne 'plec' do tablicy 'pasazer' tak zeby nie kasowac danych. 
-- Uzyj polecenie ALTER TABLE

-- 28) Dodac kolumnę 'Naz_dyrektora_portu' w tabeli 'port_lotniczy'

-- 29) Zmien nazwe kolumny 'Naz_dyrektora_portu' w tabeli 'port_lotniczy na 'Dyrektor_portu' uzyj do tego polecanie
-- ALTER TABLE ..

-- 30) Stwórz tabelę "Poszukiwane_osoby", tablica powinna zawierać pola imie, nazwisko, date poszukiwanego

-- 31) Stwórz tabele 'Osoby_schwytane' która będzie informowała ktory strażnik schwytał którego poszukiwanego. 
-- Stworz niezbędne ograniczenia.

-- 32) Dodac 3 osoby do tablicy poszukiwane osoby oraz dodac jeden wiersz 'schwytane osoby'

-- 33) Stwórz tabelę 'Lot' opisującą przelot między dwoma lotniskami, posiadajaca informacje o lotnisku startowym
-- i docelowym, numerze lotu i godzinie startu.
 
-- 34) Stworz tabele 'Przelot' pozwalającą przechować informacje o przelotach pasażera (musi być powiazana do tablicy 'Lot')

-- 35) Dodac 3 wiersze w tabeli Lot dla 2 roznych lotnisk

-- 36) Dodac 3 wiersze w tabeli przelot

-- MODYFIKACJA DANYCH
-- 37) Umieścić wiersz z swoimi danymi w tablicy pasażera i dodać 
-- kontrole na lotnisku Gdańsk przez strażnika id=1 w dniu dzisiejszym

   INSERT INTO  pasazer(imie, nazwisko) VALUES ('Michal','Szymanski')
   INSERT INTO  kontrola(id_pasazer,id_straznik, id_numer_stanowiska,  
     wynik_kontroli, czas_kontroli) VALUES 
     ( (SELECT id FROM pasazer WHERE imie='Michal' AND nazwisko='Szymanski'),
        1, (SELECT id FROM numer_stanowiska WHERE nazwa_portu='Gdańsk' LIMIT 1), 
        true, now())
   
   select * from kontrola order by czas_kontroli
    
-- 38) Zmienić nazwisko strażników z 'Nowak' na 'Nowakowski' przy okazji 
-- zwiększając im pensje o 10%

   UPDATE  straznik SET nazwisko='Nowakowski', pensja=pensja+pensja*0.1 
   WHERE nazwisko='Nowak'

-- 39) Skasować wiersz  z swoim wpisem w tablicy pasażer.

    DELETE FROM  pasazer WHERE imie='Michal' AND nazwisko='Szymanski'

-- 40) Skasować strażnika który skontrolował największa liczbę pasażerów.

DELETE FROM straznik WHERE id=(
SELECT najlepszy_id FROM (
SELECT count(*),s.id AS najlepszy_id FROM  straznik s JOIN 
 kontrola k ON s.id=k.id_straznik 
GROUP BY s.id ORDER BY 1 DESC LIMIT 1) T)

SELECT najlepszy_id FROM (
SELECT count(*),s.id AS najlepszy_id FROM  straznik s JOIN 
 kontrola k ON s.id=k.id_straznik 
GROUP BY s.id ORDER BY 1 DESC LIMIT 1) T;

-- sprawdzam
SELECT * FROM  kontrola WHERE id_straznik=3


DELETE FROM  przyznane_nagrody WHERE straznik_id=3;
DELETE FROM  kontrola wHERE id_straznik=3;


DELETE FROM  straznik WHERE id=(SELECT najlepszy_id FROM (
SELECT count(*),s.id AS najlepszy_id FROM  straznik s JOIN  kontrola k ON s.id=k.id_straznik 
GROUP BY s.id ORDER BY 1 DESC LIMIT 1) T)


-- PODZAPYTANIA
-- 41) Wyświetlić wszystkie kontrole przeprowadzone dla lotniksa Gdańsk przez strażnika
-- który ma największe zarobki

SELECT * FROM  kontrola k  
JOIN  numer_stanowiska ns ON  ns.id=k.id_numer_stanowiska 
JOIN  straznik s ON s.id=k.id_straznik 
WHERE s.pensja= (SELECT max(pensja) FROM  straznik) AND ns.nazwa_portu='Gdańsk';

-- 42) Wyświetlić z użyciem podzapytania wszystkich pasażerów skontrolowanych 
-- przez strażników o nazwisku "Nowak"

SELECT  DISTINCT p.imie, p.nazwisko FROM  kontrola k JOIN 
pasazer p ON k.id_pasazer=p.id
WHERE id_straznik IN (SELECT id FROM  straznik WHERE nazwisko='Nowak');

-- 43) Wyświetlić strażników a w ostatniej kolumnie kwotę najwyższej pensji 
-- strażnika

SELECT *,(SELECT max(pensja)FROM  straznik) AS max_pensja  FROM  straznik

-- 44) Wyświetlić strażników a w ostatniej kolumnie informację o ile mniej/więcej zarabia dany strażnik od średniej  
SELECT *, pensja -(SELECT avg(pensja) FROM  straznik) AS wiecej_mniej  
FROM  straznik;

-- Zlozone
-- 45) Wyświetlić pasażera który  nigdy nie był kontrolowany. 

SELECT * FROM  pasazer p LEFT JOIN  kontrola k ON p.id=k.id_pasazer
 WHERE k.id_pasazer IS NULL

-- 46) Znaleźć pasażera który odwiedził największą ilość lotnisk (użyć LIMIT), 
-- wyświetlić jaką liczbę lotnisk odwiedzili (jeśli pasażer odwiedził dwa razy to samo lotnisko
-- to zliczamy to jako jedno odwiedzenie)
SELECT id, imie,nazwisko, count(*) AS ilosc_lotnisk FROM (
  SELECT  DISTINCT p.id,p.imie, p.nazwisko, ns.nazwa_portu FROM  pasazer p 
  JOIN  kontrola k ON (k.id_pasazer=p.id) 
  JOIN  numer_stanowiska ns ON (k.id_numer_stanowiska=ns.id)
) T
GROUP BY id, imie,nazwisko
  ORDER BY  ilosc_lotnisk DESC LIMIT 1

SELECT DISTINCT p.id,p.imie, p.nazwisko, ns.nazwa_portu FROM  pasazer p 
  JOIN  kontrola k ON (k.id_pasazer=p.id) 
  JOIN  numer_stanowiska ns ON (k.id_numer_stanowiska=ns.id)

SELECT * FROM kontrola JOIN straznik

-- 47) Znaleźć 2 strażników którzy skontrolowali największą ilość pasażerów
-- (ponowna kontrola pasażera zliczana jest jako dodatkowa kontrola)

SELECT count(*) AS ilosc,id_straznik, imie, nazwisko  
FROM  kontrola  k JOIN  straznik s 
ON k.id_straznik=s.id
group BY id_straznik,imie, nazwisko
ORDER BY 1 DESC 
LIMIT 2

-- 48) Znaleźć lotnisko na którym poleciała najmniejsza ilość pasażer
--  (ale większa od 0)

SELECT ns.nazwa_portu, count(*) AS liczba_kontroli FROM  kontrola k 
 JOIN  numer_stanowiska ns ON ns.id=k.id_numer_stanowiska 
   WHERE   wynik_kontroli=true
 GROUP BY ns.nazwa_portu ORDER BY liczba_kontroli ASC LIMIT 1


-- 49) Znaleźć miesiac (w przeciagu całego okresu)  w którym był największy ruch na 
-- wszystkich lotniskach. Użyć	date_format()

SELECT DATE_FORMAT(czas_kontroli,'%Y-%m-01'),czas_kontroli FROM kontrola

SELECT DATE_FORMAT(czas_kontroli,'%Y-%m-01'),count(*)  
FROM  kontrola GROUP BY DATE_FORMAT(czas_kontroli,'%Y-%m-01') 
ORDER BY 2 DESC LIMIT 1 ;

SELECT *,DATE_FORMAT(czas_kontroli,'%Y-%m-01')   FROM  kontrola ;

	
-- 50) Wyświetlić  ilość pasażerów w kolejnych latach dla każdego lotniska  
-- (lotnisko sortujemy według nazwy rosnąco a póxniej według roku)
  Lotnisko ABC   2000   300
  Lotnisko ABC   2001   400
  Lotnisko BCD   2000   333
  Lotnisko CDE   2000   323
  Lotnisko CDE   2001   332

SELECT count(*), ns.nazwa_portu,DATE_FORMAT(k.czas_kontroli,'%Y-01-01') AS rok
  FROM  kontrola  k 
 JOIN  numer_stanowiska ns ON ns.id=k.id_numer_stanowiska
GROUP BY ns.nazwa_portu,DATE_FORMAT(k.czas_kontroli,'%Y-01-01')
ORDER BY ns.nazwa_portu,rok;

-- to jesli bylaby mowa o unikalnych pasazerach
SELECT count(*),nazwa_portu,rok FROM (
SELECT DISTINCT ns.nazwa_portu,p.imie, p.nazwisko, DATE_FORMAT(k.czas_kontroli,'%Y-01-01') AS rok  FROM  kontrola  k JOIN  pasazer p ON k.id_straznik=p.id
 JOIN  numer_stanowiska ns ON ns.id=k.id_numer_stanowiska
) T  GROUP BY nazwa_portu,rok ORDER BY nazwa_portu,rok;

