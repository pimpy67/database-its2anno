-- Studenti con la loro classe
SELECT s.nome, s.cognome, c.anno, c.sezione, c.indirizzo
FROM studenti s
JOIN classi c ON s.classe_id = c.id

-- Studenti con la loro classe, ordinati per classe e cognome
SELECT s.nome, s.cognome, c.anno, c.sezione, c.indirizzo
FROM studenti s
JOIN classi c ON s.classe_id = c.id
ORDER BY c.anno, c.sezione, s.cognome;