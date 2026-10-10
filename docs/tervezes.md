# Elosztott feldolgozó rendszer – tervezési dokumentum

Ez a dokumentum a projekt kiinduló leírása és munkaszabályzata. Minden fejlesztési lépés ehhez igazodik; ha egy döntés változik, előbb itt kell módosítani.

**Következő lépés:** a projektstruktúra létrehozása (lásd 7. és 11. fejezet).

## 1. Cél

Egy Java nyelven írt, legalább két gépre telepített rendszer, amely bemutatja:

- adatbázis-kezelést,
- üzenetsoron keresztüli aszinkron kommunikációt,
- párhuzamos, horizontálisan skálázható feldolgozást,
- hibatűrést (node- és folyamatkiesés kezelése),
- webes frontendet.

## 2. Alapelvek

- **A saját logika Spring Bootban, az infrastruktúra kész image-ekből.** Az adatbázist és az üzenetsort nem megírjuk, hanem hivatalos Docker image-ekből konfiguráljuk.
- **A szolgáltatások csak hálózaton kommunikálnak.** Nincs közös memória, nincs közös fájlrendszer; minden állapot az adatbázisban vagy üzenetekben él.
- **A „hol fut” csak konfiguráció.** Minden cím és hitelesítő adat környezeti változóból jön, így ugyanaz az image fut lokálisan és bármelyik szerveren.
- **A telepítés egysége a Docker image,** nem a repo és nem a mappa. Egy repóból több, egymástól függetlenül telepíthető image készül.
- **Egyszerűség.** Kubernetes, replikált adatbázis és broker-fürt nincs, hacsak a tárgy kifejezetten nem kéri.

## 3. Fejlesztési elvek

### 3.1 Kódminőség

A kódnak tisztának, átláthatónak és olvashatónak kell lennie (clean code):

- Beszédes nevek osztályoknak, metódusoknak, változóknak; rövidítések és általános nevek (`data`, `manager`, `helper`, `util`) kerülendők.
- Rövid metódusok, amelyek egy dolgot csinálnak, egy absztrakciós szinten.
- Nincs halott kód, nincs kikommentezett kód, nincs nem használt import vagy függőség.
- Megjegyzés csak ott, ahol a *miért* nem derül ki a kódból. A *mit* a kódnak kell elmondania.
- Egységes formázás az egész projektben (az IntelliJ alapértelmezett Java stílusa).
- Hibakezelés: kivételek nem nyelhetők el csendben; a hibák naplózva vagy továbbítva vannak.

### 3.2 SOLID

- **S – Single Responsibility:** minden osztálynak egy oka legyen a változásra. A controller csak a HTTP-réteget kezeli, az üzleti logika service-ben van, az adatelérés repositoryban, az üzenetküldés külön publisher osztályban.
- **O – Open/Closed:** új feldolgozási típus hozzáadása új osztállyal történjen, ne meglévő `if`/`switch` láncok bővítésével.
- **L – Liskov Substitution:** egy interfész minden implementációja felcserélhető legyen a hívó oldal módosítása nélkül.
- **I – Interface Segregation:** kicsi, célzott interfészek; egy osztály ne függjön olyan metódustól, amit nem használ.
- **D – Dependency Inversion:** az üzleti logika interfészektől függ (pl. `TaskPublisher`), nem konkrét RabbitMQ- vagy JPA-osztályoktól. Függőségek konstruktoron keresztül injektálva, mezőinjektálás (`@Autowired` mezőn) nincs.

### 3.3 További szabályok

- **Kompozíció öröklődés helyett.** Viselkedés megosztása kompozícióval és interfészekkel, nem osztályhierarchiával.
- **Egyszerű megoldások.** Nincs előre megírt általánosítás olyan igényre, ami még nem létezik.
- **Rétegek:** `controller` → `service` → `repository` / `messaging`. A rétegek csak lefelé hívnak.
- **DTO és entitás külön.** JPA entitás nem megy ki REST válaszban és nem kerül üzenetbe.
- **Tesztek:** a service-réteg logikája unit tesztekkel lefedett; a kritikus folyamatokra (publikálás, fogyasztás, idempotencia) integrációs teszt.

### 3.4 Git-szabályok

- Kis, egy témájú, inkrementális commitok; minden commit után a projekt fordul.
- Commit üzenet: rövid, felszólító módú összefoglaló sor (max. ~72 karakter), szükség esetén üres sor után rövid indoklás. Egy nyelv következetesen az egész projektben.
- A commitok nem tartalmazhatnak AI-asszisztenciára utaló jelölést: nincs `Co-authored-by` AI-sor, nincs „Generated with …” vagy hasonló szöveg.
- A repóba nem kerülhet AI-eszközhöz tartozó fájl vagy mappa (pl. `CLAUDE.md`, `AGENTS.md`, `.claude/`, `.cursor/`, prompt-fájlok). Ezek a `.gitignore`-ban szerepelnek.
- Ez a tervezési dokumentum munkadokumentum, nem kerül a repóba. A repóban a `README.md` írja le a projektet.
- A kódban és a dokumentációban nincs emoji, nincs túlmagyarázó, oktató jellegű megjegyzés, nincs sablonos, töltelék szöveg.
- Titkos adat (`.env`, jelszavak, kulcsok) soha nem kerül a repóba; csak a `.env.example` minta.

## 4. Architektúra

```
                ┌──────────────┐
  Böngésző ───▶ │    Nginx     │  statikus frontend + reverse proxy
                └──────┬───────┘
                       │ /api/*
                ┌──────▼───────┐
                │  API service │  Spring Boot, REST
                │              │  kérést fogad, feladatot sorba tesz
                └──┬────────┬──┘
                   │        │ olvasás
          publish  │        │
            ┌──────▼─────┐  │
            │  RabbitMQ  │  │
            └──┬──┬──┬───┘  │
       consume │  │  │      │
          ┌────▼┐┌▼──┐┌▼───┐│
          │ W1  ││ W2││ W3 ││  Worker service (Spring Boot), N példány
          └──┬──┘└─┬─┘└─┬──┘│  párhuzamos feldolgozás
             └─────┼────┘   │
                ┌──▼────────▼──┐
                │  PostgreSQL  │
                └──────────────┘
```

### 4.1 Komponensek

| Komponens | Technológia | Felelősség |
|---|---|---|
| Frontend | HTML + JS (vagy React / Thymeleaf) | Feladatok beküldése, státuszok és eredmények megjelenítése |
| Nginx | `nginx:alpine` alapú saját image | Statikus fájlok kiszolgálása, `/api/*` továbbítása az API felé |
| API service | Spring Boot (Web, Data JPA, AMQP, Flyway) | REST endpointok, feladat létrehozása `PENDING` státusszal, üzenet publikálása, sémamigráció |
| RabbitMQ | hivatalos `rabbitmq:management` image | Feladatsor, dead letter queue |
| Worker service | Spring Boot (AMQP, Data JPA) | Feladatok fogyasztása, feldolgozás, eredmény visszaírása |
| PostgreSQL | hivatalos `postgres` image | Közös, tartós állapot |

### 4.2 Miért RabbitMQ és nem Kafka

Feladatsorhoz (competing consumers, ack, újrakézbesítés, DLQ) a RabbitMQ a természetes választás, és egyszerűbb üzemeltetni. A Kafka eseményfolyamokra és nagy áteresztőképességre való, ehhez a projekthez túl nehéz.

### 4.3 Frontend

Ha a tárgy megengedi, egyszerű statikus HTML + JavaScript, amit az Nginx szolgál ki. Ha szigorúan csak Java engedett, a frontend Thymeleaf sablonokkal az API service-ben is renderelhető; ekkor az Nginx csak reverse proxy.

## 5. Feldolgozási folyamat

1. A felhasználó a frontenden beküld egy feladatot.
2. Az API service létrehoz egy sort a `task` táblában `PENDING` státusszal, majd üzenetet publikál a feladat azonosítójával.
3. Egy szabad worker kiveszi az üzenetet, a státuszt `PROCESSING`-re állítja, és elmenti a saját azonosítóját (hostname).
4. Feldolgozás után az eredményt és a `DONE` státuszt visszaírja, majd ackolja az üzenetet.
5. Hiba esetén újrapróbálkozás; többszöri hiba után az üzenet a dead letter queue-ba kerül, a státusz `FAILED`.
6. A frontend pollozással (vagy SSE-vel) frissíti a státuszokat.

### 5.1 Adatmodell (vázlat)

```
task
├── id            UUID, PK
├── status        PENDING | PROCESSING | DONE | FAILED
├── payload       bemeneti adat
├── result        eredmény (nullable)
├── processed_by  worker hostname (nullable)
├── attempts      próbálkozások száma
├── version       optimista zároláshoz (@Version)
├── created_at
└── updated_at
```

A séma Flyway migrációkkal jön létre az API service-ből (`db/migration/V1__create_task.sql` stb.), nem init-scripttel.

### 5.2 Üzenetformátum

A `common` modulban definiált DTO, JSON-ként szerializálva:

```json
{ "taskId": "…", "createdAt": "…" }
```

Az üzenet csak az azonosítót hordozza; az adat az adatbázisban van. Így az üzenet kicsi, és a worker mindig a friss állapotot olvassa.

## 6. Bemutatandó elosztott és párhuzamos viselkedés

| Jelenség | Megvalósítás | Demo |
|---|---|---|
| Competing consumers | Több worker példány ugyanazon a soron, két gépen | A feladatok eloszlanak; a frontenden látszik, melyik példány dolgozta fel |
| Hibatűrés | Kézi ack, újrakézbesítés | Worker leállítása feldolgozás közben → az üzenetet egy másik worker kapja meg |
| Idempotencia | Státuszellenőrzés a feldolgozás előtt | Duplán kézbesített üzenet nem okoz dupla feldolgozást |
| Konkurens írás | Optimista zárolás (`@Version`) | Két példány egyszerre módosítja ugyanazt a sort → az egyik `OptimisticLockException`-t kap és újrapróbál |
| Hibás üzenetek | Dead letter queue | Szándékosan hibás feladat a DLQ-ba kerül |
| Szálszintű párhuzamosság | `@RabbitListener` concurrency | Egy példányon belül több szál fogyaszt |
| Node-kiesés | Egy gép leállítása (Swarm esetén újraütemezés) | A másik gépen futó workerek tovább dolgoznak |
| Hálózati hibák (opcionális) | `tc netem` vagy Toxiproxy | Késleltetés, partíció hatása |

## 7. Projektstruktúra

Egy GitHub repó, benne multi-module Maven projekt (monorepo). Indoklás:

- a `common` modult mindkét szolgáltatás használja, így egyszerű függőség marad;
- üzenetformátum-változásnál az API és a worker módosítása egy commitba kerül;
- a független telepítést nem a repo felosztása, hanem a külön image-ek biztosítják.

```
distributed-project/
├── pom.xml                      # parent POM: modulok, közös verziók
├── common/
│   ├── pom.xml
│   └── src/main/java/...        # DTO-k, üzenetek, konstansok (sornevek)
├── api-service/
│   ├── pom.xml
│   ├── Dockerfile
│   └── src/
│       ├── main/
│       │   ├── java/...
│       │   └── resources/
│       │       ├── application.yml
│       │       └── db/migration/    # Flyway SQL migrációk
│       └── test/java/...
├── worker-service/
│   ├── pom.xml
│   ├── Dockerfile
│   └── src/
│       ├── main/...
│       └── test/...
├── frontend/
│   ├── Dockerfile               # Nginx + statikus fájlok
│   ├── nginx.conf
│   └── public/                  # index.html, app.js, style.css
├── deploy/
│   ├── docker-compose.yml       # lokális fejlesztés: minden egy gépen
│   ├── host-a.compose.yml       # A gép
│   ├── host-b.compose.yml       # B gép
│   └── .env.example             # változók mintája
├── .github/workflows/build.yml  # opcionális: image-ek buildje és pusholása
├── .gitignore
└── README.md
```

### 7.1 Java csomagstruktúra (szolgáltatásonként)

```
hu.<projekt>.api
├── controller/    # REST endpointok, csak HTTP-réteg
├── service/       # üzleti logika
├── repository/    # Spring Data JPA repositoryk
├── messaging/     # publisher / listener
├── domain/        # JPA entitások
├── dto/           # REST kérés/válasz objektumok
└── config/        # Spring konfiguráció (RabbitMQ, stb.)
```

### 7.2 Dockerfile-ok

Három saját image készül, ezért három Dockerfile van:

| Komponens | Dockerfile | Megjegyzés |
|---|---|---|
| api-service | igen | multi-stage build |
| worker-service | igen | multi-stage build |
| frontend (Nginx) | igen | a config és a statikus fájlok az image-ben vannak |
| PostgreSQL | nem | hivatalos image, környezeti változók + volume |
| RabbitMQ | nem | hivatalos image, környezeti változók |

A Java Dockerfile-ok build contextje a **repo gyökere**, mert a szolgáltatásnak szüksége van a `common` modulra:

```dockerfile
# api-service/Dockerfile
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /src
COPY . .
RUN mvn -pl api-service -am -DskipTests package

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /src/api-service/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```

A `-pl api-service -am` csak az adott modult és a függőségeit (`common`) buildeli. A worker Dockerfile-ja ugyanez más modulnévvel.

```bash
docker build -f api-service/Dockerfile -t api-service .
```

```dockerfile
# frontend/Dockerfile
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/
```

### 7.3 Konfiguráció környezeti változókból

```
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/tasks
SPRING_DATASOURCE_USERNAME=…
SPRING_DATASOURCE_PASSWORD=…
SPRING_RABBITMQ_HOST=rabbitmq
SPRING_RABBITMQ_USERNAME=…
SPRING_RABBITMQ_PASSWORD=…
```

Semmilyen cím nincs beégetve a kódba vagy az image-be. A valódi `.env` nincs a repóban.

## 8. Telepítés

### 8.1 Logikai vs. fizikai elosztottság

Egy gépen, konténerekben futtatva a rendszer **logikailag** már elosztott: a folyamatok függetlenek, és csak hálózaton keresztül kommunikálnak. **Fizikailag** viszont egy gépen hiányzik:

- a független hiba (a gép egyetlen hibapont),
- a valódi hálózati késleltetés, csomagvesztés és partíció,
- az eltérő órák.

Ezért a végleges telepítés legalább két gépre történik.

### 8.2 Folyamat

```
GitHub repo ──build──▶ 3 image ──push──▶ registry (ghcr.io) ◀──pull── A gép
                                                            ◀──pull── B gép
```

1. **Lokális fejlesztés:** `deploy/docker-compose.yml`, minden egy gépen; skálázás: `docker compose up --scale worker=3`.
2. **Image-ek publikálása:** GitHub Container Registry (`ghcr.io`), kézzel (`docker push`) vagy GitHub Actions workflow-val.
3. **Több gépes telepítés:** gépenként egy compose fájl, amely csak az ott futó szolgáltatásokat tartalmazza és a registryből húzza az image-eket:
   ```bash
   docker compose -f host-a.compose.yml pull
   docker compose -f host-a.compose.yml up -d
   ```
4. **Opcionálisan Swarm:** ha marad idő és a node-kiesés automatikus újraütemezését is be kell mutatni, ugyanazokból az image-ekből egy stack-fájllal (`docker stack deploy`). Az overlay hálózat miatt a szolgáltatásnevek a gépek között is feloldódnak, és nem kell portot nyitni.

### 8.3 Javasolt elosztás

```
A gép: Nginx + frontend + API service + worker
B gép: PostgreSQL + RabbitMQ + worker × N
```

A két gépen futó workerek ugyanarról a sorról fogyasztanak, így a feldolgozás valóban több gépen párhuzamos. Az A gépen a szolgáltatások a B gép címét kapják környezeti változóban (`HOST_B`), a B gépen a helyi szolgáltatásneveket (`postgres`, `rabbitmq`).

Példa (B gép):

```yaml
services:
  postgres:
    image: postgres:17
    environment:
      POSTGRES_DB: tasks
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes: [pgdata:/var/lib/postgresql/data]
    ports: ["5432:5432"]
  rabbitmq:
    image: rabbitmq:4-management
    environment:
      RABBITMQ_DEFAULT_USER: ${MQ_USER}
      RABBITMQ_DEFAULT_PASS: ${MQ_PASSWORD}
    ports: ["5672:5672", "15672:15672"]
  worker:
    image: ghcr.io/<felhasznalo>/worker-service:latest
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/tasks
      SPRING_RABBITMQ_HOST: rabbitmq
    deploy:
      replicas: 2
volumes:
  pgdata:
```

### 8.4 Biztonság

- A PostgreSQL és a RabbitMQ portja nem lehet nyitva az internet felé: a gépek a szolgáltató privát hálózatán kommunikálnak, vagy a tűzfal csak a másik gép IP-címét engedi be.
- Erős, egyedi jelszavak, csak `.env`-ben.
- A RabbitMQ management felülete (15672) csak a privát hálózatról vagy SSH-tunnelen keresztül érhető el.

### 8.5 Hosting lehetőségek

- **Oracle Cloud Always Free:** ARM-os VM-ek ingyen; a keret több VM-re osztható (regisztráció előtt ellenőrizni a jelenlegi feltételeket).
- **Olcsó VPS-ek:** Hetzner, Contabo, DigitalOcean, havi néhány euró gépenként.
- **PaaS (Render, Railway):** nem javasolt; több összekapcsolt szolgáltatásra és message brokerre körülményes.

### 8.6 Szándékos egyszerűsítések

- PostgreSQL és RabbitMQ egy-egy példányban fut; a replikáció külön projektnyi munka lenne.
- Kubernetes nincs; gépenkénti compose, opcionálisan Swarm.

## 9. Nyitott kérdések

- [ ] Pontosan mit ír elő a tárgy? (replikáció, konzisztencia-modell, gépek száma)
- [ ] Domain: mit dolgoznak fel a workerek? Ettől függ a `payload`, az eredmény és a feldolgozás ideje.
- [ ] Frontend: statikus HTML/JS, React vagy Thymeleaf?
- [ ] Státuszfrissítés: polling vagy SSE?
- [ ] Hosting szolgáltató kiválasztása.
- [ ] Java csomagnév (`hu.<projekt>`) és projektnév.

## 10. Ütemterv

1. **Projektstruktúra:** parent POM, `common` / `api-service` / `worker-service` modulok, `frontend` és `deploy` mappák, `.gitignore`, `README.md`, lokális compose PostgreSQL + RabbitMQ-val.
2. API service: entitás, Flyway migráció, REST endpoint, publikálás.
3. Worker service: fogyasztás, feldolgozás, visszaírás, kézi ack.
4. Frontend és Nginx.
5. Hibatűrés: idempotencia, optimista zárolás, retry, DLQ.
6. Dockerfile-ok, skálázás lokálisan, demo forgatókönyvek kipróbálása.
7. Image-ek publikálása, telepítés két gépre.
8. Opcionálisan Swarm, node-kiesés demo.
9. README, dokumentáció és bemutató.

## 11. Első lépés: projektstruktúra

A projektstruktúra létrehozásának elvárt eredménye:

- a 7. fejezet szerinti mappák és modulok létrejönnek;
- a parent POM kezeli a Spring Boot verziót és a modulokat; `mvn package` hiba nélkül lefut;
- mindkét szolgáltatás egy minimális, induló Spring Boot alkalmazás, üzleti logika nélkül;
- a `common` modul üres csomagstruktúrával, a két szolgáltatás függőségeként;
- `deploy/docker-compose.yml` PostgreSQL-lel és RabbitMQ-val, `deploy/.env.example`;
- `.gitignore` (Maven, IntelliJ, `.env`, AI-eszközök fájljai);
- rövid `README.md` a projekt céljával és a lokális indítással;
- az egész egy vagy néhány kis, tiszta commitban.
