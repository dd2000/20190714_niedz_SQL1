
Podstawowe zapytania
1) Wyświetlenie wszystkich strażników z tym, że zamiast kolumna 'imie' 
chciałbym żeby była kolumna imie_strażnika a po tym wszystkie oryginalne kolumny.


2) Wyświetlić strażników którzy mają pensje (bez uwzględniania składni na ubezpieczenia) większe niż 1500zł


3) Wyświetlić strażników z pensją większą od 1500zł ale mniejszą niż 2500zł


4) Wyświetlić strażników ale bez strażników o nazwisku Nowak i Kowalczyk


5) Wyświetlić strażników ale bez strażników o id 1,6,5 (z użyciem IN)


6) Wyświetlić strazników i pensje które są większe od 1500 ale po odjęciu "skladka_na_ubezpieczenie"


7) Wyświetlić pasażerów posortowanych po nazwisku i imieniu (kolejnosci rosnaca)


8) Wyświetlić strażników którzy mają nazwisko rozpoczynające się od "Kowal"


9) Wyświetlić strażników o nazwisku Nowak i którzy zostali zatrudnieni 
od początku poprzedniego roku


SELECT DATE_ADD(now(), INTERVAL -12 MONTH)
SELECT DATE_FORMAT(DATE_ADD(now(), INTERVAL -12 MONTH),'%Y-01-01') ;
albo lepiej
SELECT STR_TO_DATE(YEAR(now())-1,'%Y') 

10) Wyświetlić nazwisko+pensje strażników pomniejszone skladka_na_ubezpieczenie, kolumna ma się nazywać pensja_do_wyplaty
 

11) Wyświetlić wszystkich strażników aktualnych i archiwalnych 
( straznik_archiwum) w jednej tabeli


12) Wyświetlić strażnika który nie ma ustawionego pola skladka_na_ubezpieczenie (jest to NULL)


Używanie agregatów - Proszę 
---------------------------
13) Napisać zapytania które poda sumę  pensji (pola pensja) dla wszystkich strażników


14) Podać średnią pensję strażników 


15) Wyświetlić największą pensje


16) Podac liczbę  pasażerów w systemie


17) Podać liczbę strażników ale tych którzy mają uzupełnione pole skladka_na_ubezpieczenie



Zapytania z JOIN
-------------------
18) Wyświetlić wszystkie kontrole przeprowadzone na  lotnisku Gdańsk


19) Wyświetlić wszystkie kontrole przeprowadzone dla lotnisku Gdańsk przez strażnika/ów który ma nazwisko 
'Nowak'


20) Wyświetlić strażników i przeprowadzone przez nich kontrole jeśli strażnik nie ma kontroli to wyświetlamy informację o strażniku a w części kontrolu wyświetlamy nulle 


21) Wyświetlić wszystkie lotniska odwiedzone przez pasażera imie="Jan"  AND nazwisko="Brzechwa"  


PODZAPYTANIA
----------------
22) Wyświetlić wszystkie kontrole przeprowadzone dla lotniska Gdańsk 
przez strażnika który ma największe zarobki


23) Wyświetlić z użyciem podzapytania wszystkich 
pasażerów skontrolowanych przez strażnika o nazwisku "Nowak"

24) Wyświetlić strażników a w ostatniej kolumnie kwotę najwyższej 
pensji strażnika

25) Wyświetlić strażników a w ostatniej kolumnie informację o
 ile mniej/więcej zarabia dany strażnik od średniej  

Zlozone

SELECT * FROM pasazer ORDER BY nazwisko LIMIT 2 OFFSET 3

26) Wyświetlić pasażera który  nigdy nie był kontrolowany. 

27) Znaleźć pasażera który odwiedził największą ilość lotnisk (użyć LIMIT), 
wyświetlić jaką liczbę lotnisk odwiedzili (jeśli pasażer odwiedził dwa razy to samo lotnisko
to zliczamy to jako jedno odwiedzenie).

28) Znaleźć 2 strażników którzy skontrolowali największą ilość pasażerów
(ponowna kontrola pasażera zliczana jest jako dodatkowa kontrola)

29) Znaleźć lotnisko przez które poleciała najmniejsza ilość pasażerów 
(=liczba skontrolowanych pasazerow) ale większa od zera 


30) Znaleźć miesiac (w przeciagu całego okresu)  w którym był największy ruch na 
wszystkich lotniskach. Użyć	date_trunc('month', czas_kontroli)

SELECT DATE_FORMAT(now(),'%Y-%m-01'); 
	
31) Wyświetlić  ilość pasażerów w kolejnych latach dla każdego lotniska  (lotnisko sortujemy według nazwy rosnąco a póxniej według roku)
  Lotnisko ABC   2000   300
  Lotnisko ABC   2001   400
  Lotnisko BCD   2000   333
  Lotnisko CDE   2000   323
  Lotnisko CDE   2001   332


MODYFIKACJA DANYCH
32) Umieścić wiersz z swoimi danymi w tablicy pasażera i dodać kontrole na lotnisku Gdańsk przez strażnika id=1 w dniu dzisiejszym

   
33) Zmienić nazwisko strażników z 'Nowak' na 'Nowakowski' przy okazji zwiększając im pensje o 10%


34) Skasować wiersz  z swoim wpisem w tablicy pasażer.


35) Skasować strażnika który skontrolował największa liczbę pasażerów.

