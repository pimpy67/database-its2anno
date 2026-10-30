-- ScuolaChill, script di reset per la lezione sulle JOIN
-- Esegui tutto lo script dall'inizio alla fine.
-- DBeaver: Alt+X. pgAdmin: F5 senza selezionare niente.
-- Puoi rilanciarlo ogni volta che qualcosa va storto.

-- Cancella tutte le tabelle, comprese quelle delle esercitazioni precedenti
DROP TABLE IF EXISTS prova, insegnamenti, materie, sostituzioni,
                     docenti_classi, studenti, classi, docenti CASCADE;

-- Docenti
CREATE TABLE docenti (
    id      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome    VARCHAR(50)  NOT NULL,
    cognome VARCHAR(50)  NOT NULL,
    email   VARCHAR(100) NOT NULL UNIQUE
);

-- Classi, con il coordinatore della lezione sulle relazioni
CREATE TABLE classi (
    id              INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    anno            SMALLINT    NOT NULL CHECK (anno BETWEEN 1 AND 5),
    sezione         CHAR(1)     NOT NULL,
    indirizzo       VARCHAR(60),
    anno_scolastico VARCHAR(9)  NOT NULL,
    coordinatore_id INTEGER     UNIQUE,
    UNIQUE (anno, sezione, anno_scolastico),
    CONSTRAINT fk_classi_coordinatore
        FOREIGN KEY (coordinatore_id) REFERENCES docenti (id)
        ON DELETE SET NULL
);

-- Studenti, con la chiave esterna verso le classi
CREATE TABLE studenti (
    id            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome          VARCHAR(50)  NOT NULL,
    cognome       VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    data_nascita  DATE,
    attivo        BOOLEAN      NOT NULL DEFAULT TRUE,
    registrato_il TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    classe_id     INTEGER,
    CONSTRAINT fk_studenti_classe
        FOREIGN KEY (classe_id) REFERENCES classi (id)
        ON DELETE RESTRICT
);

-- Tabella ponte tra docenti e classi
CREATE TABLE docenti_classi (
    docente_id      INTEGER  NOT NULL,
    classe_id       INTEGER  NOT NULL,
    ore_settimanali SMALLINT NOT NULL CHECK (ore_settimanali > 0),
    PRIMARY KEY (docente_id, classe_id),
    CONSTRAINT fk_docenti_classi_docente
        FOREIGN KEY (docente_id) REFERENCES docenti (id) ON DELETE CASCADE,
    CONSTRAINT fk_docenti_classi_classe
        FOREIGN KEY (classe_id) REFERENCES classi (id) ON DELETE CASCADE
);

-- Dati
INSERT INTO docenti (nome, cognome, email) VALUES
    ('Laura',  'Bianchi',  'laura.bianchi@scuolachill.it'),
    ('Marco',  'Esposito', 'marco.esposito@scuolachill.it'),
    ('Chiara', 'Romano',   'chiara.romano@scuolachill.it');

INSERT INTO classi (anno, sezione, indirizzo, anno_scolastico, coordinatore_id) VALUES
    (1, 'A', 'Informatica', '2026/2027', 2),
    (2, 'A', 'Informatica', '2026/2027', NULL),
    (2, 'B', 'Informatica', '2026/2027', 1),
    (3, 'A', 'Elettronica', '2026/2027', NULL);

INSERT INTO studenti (nome, cognome, email, data_nascita, classe_id) VALUES
    ('Mario',  'Rossi',   'mario.rossi@scuolachill.it',  '2009-03-14', 3),
    ('Giulia', 'Verdi',   'giulia.verdi@scuolachill.it', '2009-11-02', 2),
    ('Mario',  'Rossi',   'm.rossi2@scuolachill.it',     '2010-01-27', 3),
    ('Aisha',  'Diallo',  'aisha.diallo@scuolachill.it', '2010-06-09', 1),
    ('Luca',   'Ferrari', 'luca.ferrari@scuolachill.it', '2009-08-21', 3),
    ('Nina',   'Russo',   'nina.russo@scuolachill.it',   NULL,         NULL);

INSERT INTO docenti_classi (docente_id, classe_id, ore_settimanali) VALUES
    (1, 2, 4), (1, 3, 4), (1, 4, 3),
    (2, 1, 5), (2, 3, 5),
    (3, 3, 3);

-- Controllo finale: deve restituire 3, 4, 6, 6
SELECT (SELECT COUNT(*) FROM docenti)        AS docenti,
       (SELECT COUNT(*) FROM classi)         AS classi,
       (SELECT COUNT(*) FROM studenti)       AS studenti,
       (SELECT COUNT(*) FROM docenti_classi) AS docenti_classi;
