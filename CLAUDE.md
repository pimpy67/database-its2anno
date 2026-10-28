# Note per Claude — Database ITS 2° anno

## Come aiutarmi
- Rispondi in **italiano**, con passi semplici: sono alle prime armi con terminale, Docker, Git e SQL.
- Guidami **un passo alla volta** e aspetta la mia risposta prima di andare avanti.
- Negli esercizi in cui devo prevedere un risultato o scrivere io il codice, fammi provare prima, non dare subito la soluzione.
- Prima di dare un comando, ricordami dove va scritto: terminale `$` (docker, git, cat) oppure psql `esercizio1=#` (SQL e comandi `\d`, `\dt`, `\q`).
- Errori che faccio spesso: incollare comandi `docker` dentro psql o SQL nel terminale `$`; incollare anche l'output invece del solo comando; avere due terminali psql aperti; dimenticare il `;` o la `l` di `.sql`.

## Ambiente
- PostgreSQL 16 in Docker, container `postgres`, password `postgres`, database `esercizio1`.
- **A scuola**: GitHub Codespaces (il PC della scuola non ha diritti admin e Docker Desktop non parte).
- **A casa**: Mac con Docker Desktop, app Terminale.
- Prima volta: `docker run -d --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -v pgdata:/var/lib/postgresql/data postgres:16`
  poi `docker exec -it postgres psql -U postgres -c "CREATE DATABASE esercizio1;"`
- Le volte dopo: `docker start postgres`
- Entrare in psql: `docker exec -it postgres psql -U postgres -d esercizio1`
- Eseguire un file: `docker exec -i postgres psql -U postgres -d esercizio1 < esercizio1.sql`
- Vedere il codice SQLSTATE degli errori in psql: `\set VERBOSITY verbose`
- Inizio lavoro: `git pull`. Fine lavoro: `git add .` → `git commit -m "..."` → `git push`.

## File
- `esercizio1.sql` = **script di reset** del docente (SENZA classe_id). Non modificarlo: si rilancia per ripartire da zero.
- `esercizio1_query.sql` = query di prova con JOIN.
- `esercizio2.sql`, ... = appunti delle istruzioni eseguite negli esercizi, con risposte come commenti `--`.

## Lezione attuale: "Le relazioni tra tabelle"
Pagina del docente: https://andreagiachetto.notion.site/Le-relazioni-tra-tabelle-3fe959d86f978077b3d7e6feff3898da
(Notion: WebFetch non la legge; usare `POST https://andreagiachetto.notion.site/api/v3/loadPageChunk` con `pageId`, anche sugli id dei titoli 🛠️ per leggere gli esercizi.)

Esercizi 🛠️ in ordine:
1. **Reset del database**: eseguire `esercizio1.sql`.
2. **Collega gli studenti alle classi** (in psql, uno alla volta):
   `ALTER TABLE studenti ADD COLUMN classe_id INTEGER;` → UPDATE classe_id=3 per id 1,3,5; =1 per id 4; =99 per id 2 (errore voluto della segreteria; Nina resta NULL) → domanda: perché passa? → `ALTER TABLE studenti ADD CONSTRAINT fk_studenti_classe FOREIGN KEY (classe_id) REFERENCES classi (id);` fallisce → `UPDATE studenti SET classe_id = 2 WHERE id = 2;` e rifare l'ALTER.
3. **Il database dice no**: prevedere, eseguire e annotare lo SQLSTATE di: UPDATE classe_id=999 id=2; INSERT Teo Marino classe 7; DELETE classi id=3; DELETE classi id=4; INSERT Teo Marino classe 4.
4. **Cambia le regole**: classe di prova 5A (id 5) con studenti 'Uno'/'Due' Prova; DELETE con NO ACTION; vincolo ON DELETE SET NULL; ricreare 5A (id 6) con CASCADE; alla fine rimettere ON DELETE RESTRICT.
5. **Pensa alle relazioni**: individuare 1:N, N:M, 1:1 tra le tabelle.
6. **Arrivano i docenti**: scrivere io CREATE TABLE docenti (id identity, nome/cognome VARCHAR(50) NOT NULL, email VARCHAR(100) NOT NULL UNIQUE) e la tabella ponte docenti_classi (PK composta, fk_docenti_classi_docente / fk_docenti_classi_classe ON DELETE CASCADE, ore_settimanali SMALLINT NOT NULL > 0); poi coordinatore_id UNIQUE in classi con fk_classi_coordinatore ON DELETE SET NULL.

Per rifare velocemente gli esercizi 2 e 3 dopo un reset (ad esempio a casa):
```sql
ALTER TABLE studenti ADD COLUMN classe_id INTEGER;
UPDATE studenti SET classe_id = 3 WHERE id IN (1, 3, 5);
UPDATE studenti SET classe_id = 1 WHERE id = 4;
UPDATE studenti SET classe_id = 2 WHERE id = 2;
ALTER TABLE studenti ADD CONSTRAINT fk_studenti_classe FOREIGN KEY (classe_id) REFERENCES classi (id);
DELETE FROM classi WHERE id = 4;
```

## Avanzamento
- [x] 1. Reset
- [x] 2. Collega gli studenti alle classi
- [x] 3. Il database dice no — previsioni 5 su 5 corrette (errori 23503; la 3A, id 4, è stata cancellata)
- [ ] 4. Cambia le regole
- [ ] 5. Pensa alle relazioni
- [ ] 6. Arrivano i docenti
