PRAGMA foreign_keys = ON;

--DROP TABLE IF EXISTS patient;

CREATE TABLE IF NOT EXISTS patient (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  first_name TEXT,
  last_name TEXT,
  middle_name TEXT,
  birthdate TEXT,
  sex TINYINT,
  mobile TEXT,
  addr TEXT,
  er_name TEXT,
  er_rel TEXT,
  er_mobile TEXT,
  er_addr TEXT
);

--DROP TABLE IF EXISTS hc_facility;

CREATE TABLE IF NOT EXISTS hc_facility (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  facility_name TEXT,
  facility_addr TEXT,
  contact TEXT,
  email TEXT
);

CREATE TABLE IF NOT EXISTS med_hist (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  question TEXT
);

INSERT INTO med_hist (question) VALUES
('Hypertension'),
('Diabetes'),
('Heart problem'),
('Stroke'),
('Allergy'),
('Asthma');

CREATE TABLE IF NOT EXISTS diagnosis (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  patient_id INTEGER,
  summary TEXT,
  FOREIGN KEY (patient_id) REFERENCES patient (id)
);

--DROP TABLE IF EXISTS doctor;

CREATE TABLE IF NOT EXISTS doctor (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  first_name TEXT,
  last_name TEXT,
  middle_name TEXT,
  title TEXT,
  specialty TEXT,
  contact TEXT
);

--DROP TABLE rx_form;

CREATE TABLE IF NOT EXISTS rx_form (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date_prescribed TEXT,
  hc_facility_id INTEGER,
  doctor_id INTEGER,
  patient_id INTEGER,
  FOREIGN KEY (hc_facility_id) REFERENCES hc_facility (id),
  FOREIGN KEY (doctor_id) REFERENCES doctor (id),
  FOREIGN KEY (patient_id) REFERENCES patient (id)
);

CREATE TABLE IF NOT EXISTS rx_drug (
  drug TEXT,
  rx_form_id INTEGER,
  FOREIGN KEY (rx_form_id) REFERENCES rx_form (id)
);