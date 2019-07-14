-- ========== 2.1 NULL ===========
-- recenzje niepowiazane z książką (błędne wiersze)
SELECT * FROM recenzja  WHERE ksiazka_id IS NULL;

-- wszystkie recenzje gdzie jest ustawione id ksiazki
SELECT * FROM recenzja  WHERE ksiazka_id IS NOT NULL;

-- ============= 2.1 Ostrożnie z NULL ==============
SELECT * FROM recenzja;  -- 7 recenzji 
UPDATE recenzja SET ksiazka_id=NULL WHERE recenzja_id=1;

SELECT count(distinct ksiazka_id) FROM recenzja;  -- 5
SELECT count(distinct ksiazka_id) FROM recenzja WHERE ksiazka_id IS NOT NULL; -- mamy tyle samo wierszy co w poprzednim zapytaniu
SELECT distinct  ksiazka_id FROM recenzja; -- a tu niespodzianka o jeden wiecej wiersz! Count nie zlicza NULL



-- wynik takiego przyrównania jest też nullem
SELECT null =  10;
SELECT null = null  -- przyrównanie do NULL zawsze zwraca wartość nieznaną 
SELECT null OR true


SELECT * FROM recenzja
-- ================== 2.2 JOIN ================
-- wyświetlenie książek z recenzjami
SELECT * FROM ksiazka k, recenzja r WHERE k.ksiazka_id = r.ksiazka_id;
-- równoważne z 
SELECT * FROM ksiazka k INNER JOIN  recenzja r ON k.ksiazka_id = r.ksiazka_id;

-- natural
SELECT * FROM ksiazka k NATURAL JOIN recenzja   

-- USING
SELECT * FROM ksiazka k  JOIN recenzja  USING (ksiazka_id)

-- JOIN z dodatkowymi warunkami
SELECT * FROM ksiazka k INNER JOIN  recenzja r ON 
k.ksiazka_id = r.ksiazka_id WHERE min_wiek>3

-- albo, równoważny zapis
SELECT * FROM ksiazka k INNER JOIN  recenzja r 
ON k.ksiazka_id = r.ksiazka_id AND min_wiek>3

-- złączenie może być wielokrotne
SELECT kl.imie, kl.nazwisko, ks.autor_imie, ks.autor_nazwisko, ks.tytul, ok.ocena 
FROM klient kl JOIN ocena_ksiazki ok ON kl.klient_id=ok.klient_id
JOIN ksiazka ks ON ks.ksiazka_id = ok.ksiazka_id;

-- albo
SELECT kl.imie, kl.nazwisko, ks.autor_imie, ks.autor_nazwisko, ks.tytul, 
ok.ocena FROM klient kl NATURAL JOIN ocena_ksiazki ok 
NATURAL JOIN ksiazka ks;

-- Ćwiczenia
-- Wyświetlić recenzje stworzone prze klientów tak żeby były informacje o kliencie i sama treść recenzji
 R:  

-- Wyświetlić recenzje klienta ale również żeby była statystykę klienta (tablica ze statystyką) tak żeby były informacje o kliencie w wierszu
R: 

  
-- ============== 2.3 LEFT/RIGHT
-- Wyswietlenie książek z recenzjami (również tych z brakiem recenzji)
SELECT ksiazka.*, recenzja.*  FROM ksiazka LEFT JOIN recenzja USING (ksiazka_id);
-- albo
SELECT ksiazka.*, recenzja.*  FROM recenzja RIGHT JOIN ksiazka USING (ksiazka_id);

-- Ćwiczenia
-- Wyświetlić wszystkie recenzje wystawione przez klientów jeśli klient nie wystawił recenzji to powinnien być wiersz z danymi klienta
R: 

-- ================== 2.4 AGREGUJACE =============
-- wyświetlenie ile jest książek danego autora
SELECT autor_imie,autor_nazwisko,COUNT(*) FROM ksiazka
GROUP BY autor_imie,autor_nazwisko;

-- wyświetlenie ile jest książek danego autora, ale wyświetlaj tylko tych autorów którzy mają więcej niż jedną książke
SELECT autor_imie,autor_nazwisko,COUNT(*) FROM ksiazka
GROUP BY autor_imie,autor_nazwisko 
HAVING COUNT(*)>1;

-- średnia wszystkich ocen 
SELECT AVG(ocena) FROM ocena_ksiazki;

-- minimalna ocena 
SELECT MIN(ocena) FROM ocena_ksiazki;

-- maksymalna ocena 
SELECT MAX(ocena) FROM ocena_ksiazki;

-- ćwiczenia
-- wyświetlić ilość książek w dla każdego rodzaju 
R:

-- wyświetlić klientów z informacją o ilości wystawionych ocen
R:

-- ============ 2.5 SUBQUERY (WHERE) ================
-- Wyświetlenie klientów którzy przeczytali więcej niż 50 książek
SELECT * FROM klient 
WHERE klient_id IN 
     (SELECT  klient_id FROM statystyka_klienta WHERE liczba_przeczytanych_ksiazek>50);


-- Wyświetlenie klientów którzy przeczytali więcej niż 50 książek i wystawili chociaż jedną ocenę 
SELECT * FROM klient 
WHERE klient_id IN 
     (SELECT  klient_id FROM statystyka_klienta WHERE liczba_przeczytanych_ksiazek>50)
AND 
  klient_id IN (SELECT klient_id FROM ocena_ksiazki WHERE ocena>5);

-- ćwiczenia
-- wyświetlić książki które mają przynajmniej jedną recenzje z użyciem subquery
R:

-- wyświetlić książkę (jest jedna) które ma recenzję z tekstem 'Świetna!'
R:

-- ============ 2.6 SUBQUERY (w SELECT) ================
-- wyswietlenie dane klienta  i w dodatkowej kolumnie wyswietlenie ilosci przeczytanych ksiazek dla klienta o ID=2 (uzyc subquery)

SELECT *, (SELECT liczba_przeczytanych_ksiazek FROM statystyka_klienta WHERE klient_id=2)  FROM klient;

SELECT klient.* FROM klient;

-- wyswietlenie dane klienta  i w dodatkowej kolumnie wyswietlenie ilosc wystawionych ocen
SELECT k.*, (SELECT count(*) FROM ocena_ksiazki o WHERE k.klient_id=o.klient_id) FROM klient k;

-- ćwiczenia
-- wyświetlić imie,nazwisko autora i tytul a w ostatniej kolumnie ilość wystawionych recenzji (uzyc subquery)
R:


-- wyświetlić oceny ksiazki 'Powstanie Warszawskie' (w WHERE ma być wyszukanie po nazwie a nie po ID) 
-- w ostatniej kolumnie maksymalną ocenę jaka dostała książka  (zadanie trudniejsze)
-- czyli 'Powstanie Warszawskie', 5, 10 
R:

-- ================= Ćwiczenia - Podsumowanie SQL ======================

-- === Zadanie 1 ===
-- Przepisać poniższe zapytanie bez LEFT JOIN
SELECT autor_imie, autor_nazwisko,tytul, recenzja_tekst FROM ksiazka LEFT JOIN recenzja USING (ksiazka_id);

SELECT *, null as recenzja_id, null, null FROM ksiazka

R:

-- a jak to posortować po recenzji
SELECT t.autor_imie FROM (
SELECT autor_imie, autor_nazwisko,tytul, recenzja_tekst  FROM ksiazka k , recenzja r WHERE k.ksiazka_id=r.ksiazka_id
UNION 
SELECT autor_imie, autor_nazwisko,tytul, NULL AS recenzja_tekst  FROM ksiazka k WHERE k.ksiazka_id NOT IN 
(SELECT ksiazka_id FROM recenzja) 
) t ORDER BY recenzja_tekst;

-- === Zadanie Dodatkowe ===
-- A jak przepisać pytanie 
-- SELECT ksiazka.*, recenzja.*  FROM recenzja FULL JOIN ksiazka USING (ksiazka_id) żeby nie było JOIN
R: ?


-- === Zadanie 2 (nauka rozbudowy zapytania SQL) === 
-- Wyświetlić przy każdej książce średnią ocenę dla danej książki z 
-- informacją ile  było ocen
R: 

-- Wyświetlić średnią ocenę wszystkich książek
R: 

 
-- Wyświetlić wszystkie oceny dla książki dla których ocena jest większa od średniej oceny dla wszyskich książek 
--(nie pomylić ze średnia wszystkich ocen) 
R:

-- Wyświetlić wszystkie oceny dla ksiażek dla których ocena jest większa od średniej oceny dla wszyskich książek
-- (nie pomylić ze średnia wszystkich ocen) i przy ocenie wyświetlić średnią ocenę dla wszystkich książek
R:

 -- i nieco trudniejsze zadanie wyświetlić wszystkie ksiażki dla których średnia ocena jest większa od średniej oceny 
 -- dla wszyskich książek (nie pomylić ze średnia wszystkich ocen) i przy ocenie wyświetlić średnią ocenę dla książki 
 -- i dla wszystkich książek
R: 



-- Można to zrobić też na widokach albo dodać dodatkową tabelę ze statystykami - w zależności od sytuacji

-- Inny wynik jakbysmy wzieli srednia wszystkich ocen SELECT k.autor_imie, k.autor_nazwisko, k.tytul, ocena FROM ksiazka k JOIN ocena_ksiazki og USING (ksiazka_id) 
-- WHERE ocena>( SELECT AVG(ocena) FROM ocena_ksiazki)
 