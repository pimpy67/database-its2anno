DROP TABLE IF EXISTS prova, insegnamenti, materie, docenti_classi, studenti, docenti, classi CASCADE;

CREATE TABLE classi (
    id              INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    anno            SMALLINT    NOT NULL CHECK (anno BETWEEN 1 AND 5),
    sezione         CHAR(1)     NOT NULL,
    indirizzo       VARCHAR(60),
    anno_scolastico VARCHAR(9)  NOT NULL,
    UNIQUE (anno, sezione, anno_scolastico)
);

CREATE TABLE studenti (
    id            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome          VARCHAR(50)  NOT NULL,
    cognome       VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    data_nascita  DATE,
    attivo        BOOLEAN      NOT NULL DEFAULT TRUE,
    registrato_il TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    classe_id     INTEGER      REFERENCES classi(id)
);

INSERT INTO classi (anno, sezione, indirizzo, anno_scolastico) VALUES
    (1, 'A', 'Informatica', '2026/2027'),
    (2, 'A', 'Informatica', '2026/2027'),
    (2, 'B', 'Informatica', '2026/2027'),
    (3, 'A', 'Elettronica', '2026/2027');

INSERT INTO studenti (nome, cognome, email, data_nascita, classe_id) VALUES
    ('Mario',  'Rossi',   'mario.rossi@scuolachill.it',  '2009-03-14', 2),
    ('Giulia', 'Verdi',   'giulia.verdi@scuolachill.it', '2009-11-02', 2),
    ('Mario',  'Rossi',   'm.rossi2@scuolachill.it',     '2010-01-27', 1),
    ('Aisha',  'Diallo',  'aisha.diallo@scuolachill.it', '2010-06-09', 1),
    ('Luca',   'Ferrari', 'luca.ferrari@scuolachill.it', '2009-08-21', 3),
    ('Nina',   'Russo',   'nina.russo@scuolachill.it',   NULL,         4);
