PRAGMA foreign_keys = ON;

--DROP TABLE IF EXISTS med_hist;
--DROP TABLE IF EXISTS condition;
--DROP TABLE IF EXISTS diagnosis;
--DROP TABLE IF EXISTS lab_result;
--DROP TABLE IF EXISTS laboratory;

--DROP TABLE IF EXISTS rx_form;
--DROP TABLE IF EXISTS rx_drug;
--DROP TABLE IF EXISTS hc_facility;
--DROP TABLE IF EXISTS patient;
--DROP TABLE IF EXISTS doctor;

CREATE TABLE IF NOT EXISTS patient (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  first_name TEXT,
  last_name TEXT,
  middle_name TEXT,
  birthdate TEXT,
  sex TINYINT,
  contact TEXT,
  addr TEXT,
  er_name TEXT,
  er_rel TEXT,
  er_contact TEXT,
  er_addr TEXT
);

CREATE TABLE IF NOT EXISTS doctor (
  id INTEGER PRIMARY KEY,
  license_id TEXT,
  first_name TEXT,
  last_name TEXT,
  middle_name TEXT,
  title TEXT,
  specialty TEXT,
  contact TEXT,
  email TEXT
);

CREATE TABLE IF NOT EXISTS clinic (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  clinic_name TEXT,
  clinic_addr TEXT,
  contact TEXT,
  email TEXT
);

CREATE TABLE IF NOT EXISTS clinic_hours (
  clinic_id INTEGER,
  days TEXT,
  opening_time TEXT,
  closing_time TEXT,
  FOREIGN KEY (clinic_id) REFERENCES clinic (id)
);

CREATE TABLE IF NOT EXISTS condition (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  question TEXT UNIQUE
);

CREATE TABLE IF NOT EXISTS med_hist (
  patient_id INTEGER,
  condition_id INTEGER,
  FOREIGN KEY (patient_id) REFERENCES patient (id),
  FOREIGN KEY (condition_id) REFERENCES condition (id)
);

CREATE TABLE IF NOT EXISTS diagnosis (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  patient_id INTEGER,
  date_diagnosed TEXT,
  summary TEXT,
  notes TEXT,
  FOREIGN KEY (patient_id) REFERENCES patient (id)
);

CREATE TABLE IF NOT EXISTS dgnss_attachment (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  diagnosis_id INTEGER,
  encoded_image TEXT,
  FOREIGN KEY (diagnosis_id) REFERENCES diagnosis (id)
);

CREATE TABLE IF NOT EXISTS laboratory (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  patient_id INTEGER,
  date_tested TEXT,
  FOREIGN KEY (patient_id) REFERENCES patient (id)
);

CREATE TABLE IF NOT EXISTS lab_result (
  lab_id INTEGER,
  label TEXT,
  result TEXT,
  FOREIGN KEY (lab_id) REFERENCES laboratory (id)
);

--CREATE TABLE IF NOT EXISTS rx_form (
--  id INTEGER PRIMARY KEY AUTOINCREMENT,
--  date_prescribed TEXT,
--  followup_date TEXT,
--  clinic_id INTEGER,
--  doctor_id INTEGER,
--  patient_id INTEGER,
--  FOREIGN KEY (clinic_id) REFERENCES clinic (id),
--  FOREIGN KEY (doctor_id) REFERENCES doctor (id),
--  FOREIGN KEY (patient_id) REFERENCES patient (id)
--);
--
--CREATE TABLE IF NOT EXISTS rx_drug (
--  drug TEXT,
--  rx_form_id INTEGER,
--  FOREIGN KEY (rx_form_id) REFERENCES rx_form (id)
--);