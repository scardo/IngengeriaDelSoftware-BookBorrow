CREATE FUNCTION isBookOwner(val VARCHAR) RETURNS integer AS $$
DECLARE res INTEGER;
BEGIN
	PERFORM COUNT(*) AS res
	FROM Book_User
	WHERE Book_User.Tipologia=1 AND
	Book_User.Email = $1;

	RETURN res;
END; 
$$ LANGUAGE PLPGSQL;

CREATE TABLE Admin (
	Email varchar(50) NOT NULL,
	Password varchar(10) NOT NULL,

	PRIMARY KEY(Email)
);

CREATE TABLE Book_User (
	Email varchar(50) NOT NULL,
	Password varchar(10) NOT NULL,
	Nome varchar(15) NOT NULL,
	Cognome varchar(15) NOT NULL,
	Sesso char NOT NULL,
	Data_nascita date NOT NULL,
	Foto_profilo bytea,
	Tipologia integer NOT NULL,

	PRIMARY KEY(Email),

	CHECK((Sesso='M' OR Sesso='m' OR Sesso='F' OR Sesso='f')AND(Tipologia=0 OR Tipologia=1))
);

CREATE TABLE Indirizzo (
	Coordinate_geografiche varchar(100) NOT NULL, 
	Book_User varchar(50) NOT NULL,
	Via varchar(30) NOT NULL,
	N_civico varchar(4) NOT NULL, 
	CAP varchar(5) NOT NULL,
	Citta varchar(20) NOT NULL,
	Provincia varchar(2) NOT NULL, 
	Paese varchar(30) NOT NULL,
	Principale integer NOT NULL,
	FOREIGN KEY(Book_User)
	REFERENCES Book_User(Email)
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	PRIMARY KEY(Coordinate_geografiche, Book_User),
	CHECK(Principale=0 OR Principale=1)
);

CREATE TABLE Libro (
	ID varchar(7) NOT NULL,
	Anno_pubblicazione numeric(4,0),
	N_pagine integer,
	Nome_autore varchar(15) NOT NULL, 
	Cognome_autore varchar(15) NOT NULL,
	Genere varchar(50) NOT NULL, 
	Copertina bytea,
	Disponibilita integer NOT NULL,
	Casa_ed varchar(40),
	Titolo varchar(80) NOT NULL,
	Coordinate_geografiche varchar(140) NOT NULL,
	Book_User varchar(50) NOT NULL,
	FOREIGN KEY (Coordinate_geografiche, Book_User) 
	REFERENCES Indirizzo(Coordinate_geografiche, Book_User)	
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	PRIMARY KEY(ID),
	CHECK(N_pagine>0 AND (Disponibilita=0 OR Disponibilita=1))
);

CREATE TABLE Prestito (
	Email_proprietario varchar(50) NOT NULL,
	Email_richiedente varchar(50) NOT NULL, 
	ID_libro varchar(7) NOT NULL, 
	Stato char NOT NULL,
	Data_richiesta date NOT NULL,
	FOREIGN KEY(Email_proprietario)
	REFERENCES Book_User(Email)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	FOREIGN KEY(Email_richiedente)
	REFERENCES Book_User(Email)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	FOREIGN KEY(ID_libro)
	REFERENCES Libro(ID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	PRIMARY KEY(Email_proprietario, Email_richiedente, ID_libro, Data_richiesta),
	CHECK(Stato='a' OR Stato='p' OR Stato='r' OR Stato='A' OR Stato='P' OR Stato='R')
);

CREATE TABLE BlackList (
	Email varchar(30) NOT NULL,

	PRIMARY KEY(Email)
);
