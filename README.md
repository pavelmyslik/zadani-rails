# RoR developer

## Intro
### Tvým úkolem je
- Připravit logiku pro periodické faktury.
- Připravit GraphQL query pro listování faktur, jak existujících, tak budoucích.

### Info
- Zadání je relativně složité a komplexní, ale budeme vědět, jaké máš schopnosti. Kdyby si měl pochybnosti, jestli zadání zvládneš, snaž se z úkolu vypracovat co nejvíc.
- Snažil jsem se připravit kód, aby se ti s ním dobře pracovalo a nemusel sis ztrácet čas s vymýšlením modelu a asociací.

## Zadání
- Forkni si tento projekt, pak začni pracovat. Jako výsledek tvé práce pošli odkaz na repozitář, kam pushnes své změny.
- Připrav logiku pro tvorbu periodických faktur. Uživatel má možnost nastavit si u faktury profil opakování, tzn. vytvoří se asociace na recurring_profile, který definuje frekvenci opakování, způsob ukončení (počet/datum).
- Dopln do ProcessRecurringInvoicesJob, který bude převádět drafty do reálných faktur (číslo další faktury musí mít číslo za poslední faktury + 1).
- Uživatel má možnost vylistovat faktury a zároveň vidět budoucí faktury (draft je Invoice bez attributu number), které vznikají na základě recurring_profile - Kazda Invoice muze mit maximalne jednu budouci faktur.
- Uživatel má možnost vytvořit fakturu pomocí GraphQL mutace. (OPTIONAL)
- V ideálním případě by měl být kód kompletně otestovaný, pokud nebudeš stíhat, tak otestuj alespoň core funkcionalitu.

## Shrnutí
- Na vypracování úkolu máš 8 hodin, více času úkolu prosím nevěnuj, potřebujeme vidět, co zvládneš za daný čas vytvořit.
- Je možný že za 8h nezvládneš zadání vypracovat, nejde nám o kompletní funkcionalitu, ale chcem vědět jak premejšlíš a co zvládneš napsat.

## Init projektu
Všichni používáme MacOS a projekt máme nainstalovány přímo v systému, ale pro rychlejší init projektu jsem připravil Docker.
Pokud máš MacOS, nejspíš nebudeš mít problém rozjet projekt mimo Docker.

## Docker

### Stažení a instalace Dockeru
https://www.docker.com/products/docker-desktop/

### Build a spuštění kontaineru
    docker-compose build
    docker-compose up

### Instalace chybejících baliků gems/packages
    docker-compose run --rm web bundle install
    docker-compose run --rm web yarn

### Migrace a naplnění db
    docker-compose run --rm web rails db:migrate
    docker-compose run --rm web rails db:seed
