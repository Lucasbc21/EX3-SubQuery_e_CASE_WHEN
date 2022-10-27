CREATE DATABASE projetos
GO

USE projetos
GO

CREATE TABLE projects(
id                      INT            IDENTITY(10001, 1)                      NOT NULL,
name                    VARCHAR(45)                                            NOT NULL,
description             VARCHAR(45)                                            NULL,
date                    DATE           CHECK(date > '01/09/2014')              NOT NULL
PRIMARY KEY(id)
)
GO

CREATE TABLE users(
id                      INT            IDENTITY(1, 1)                NOT NULL,
name                    VARCHAR(45)                                  NOT NULL,
username                VARCHAR(45)                                  NOT NULL,
password                VARCHAR(45)    DEFAULT('123mudar')                NOT NULL,
email                   VARCHAR(45)                                  NOT NULL
PRIMARY KEY(id),
)
GO

CREATE TABLE users_has_projects(
users_id                INT                          NOT NULL,
projects_id             INT                          NOT NULL
PRIMARY KEY (users_id, projects_id)
FOREIGN KEY (users_id)        REFERENCES   users(id),
FOREIGN KEY (projects_id)     REFERENCES   projects(id)
)
GO


ALTER TABLE users
ALTER COLUMN       username      VARCHAR(10)        NOT NULL
GO


ALTER TABLE users
ADD CONSTRAINT     AK_username      UNIQUE(username)
GO


ALTER TABLE users
ALTER COLUMN       password      VARCHAR(8)        NOT NULL
GO

DBCC CHECKIDENT('users', RESEED, 1)
GO

INSERT INTO users(name, username, email)
VALUES('Maria', 'Rh_maria', 'maria@empresa.com' )
GO

INSERT INTO users(name, username, password, email)
VALUES('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com')
GO

INSERT INTO users(name, username, email)
VALUES('Ana', 'Rh_ana', 'ana@empresa.com')
GO

INSERT INTO users(name, username, email)
VALUES('Clara', 'Ti_clara', 'clara@empresa.com')
GO

INSERT INTO users(name, username, password, email)
VALUES('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')
GO


DBCC CHECKIDENT ('projects', RESEED, 10001)
GO

INSERT INTO projects(name, description, date)
VALUES ('Re-folha', 'Refatoração das Folhas', '05/09/2014')
GO       

INSERT INTO projects(name, description, date)
VALUES ('Manutenção PCs', 'Manutenção PCs','06/09/2014')
GO   

INSERT INTO projects(name, date)
VALUES ('Auditoria' , '07/09/2014')
GO   



INSERT INTO users_has_projects(users_id, projects_id)
VALUES (1, 10001),
       (5, 10001),
	   (3, 10003),
	   (4, 10002),
	   (2, 10002)
GO

UPDATE projects
SET date = '12/09/2014'
WHERE name LIKE 'Manutenção%' 
GO

UPDATE users
SET username = 'Rh_cido'
WHERE name = 'Aparecido'
GO

UPDATE users
SET password = '888@'
WHERE username = 'Rh_maria' AND password = '123mudar'
GO

DELETE users_has_projects
WHERE users_id = 2
GO

--1)

SELECT id, 
       name,
	   email,
	   username,

	   CASE WHEN password = '123mudar'
	   THEN
	       password
	   
	   ELSE
	       '********'

       END AS password
	     
FROM users
WHERE LEN(password) <= 8
GO

--2)

SELECT name,
       description,
	   CONVERT(CHAR(10), date, 103) AS date, 
	   CONVERT(CHAR(10),DATEADD (DAY, 15, date), 103) AS data_final 

FROM projects
WHERE id IN 

(SELECT projects_id
FROM users_has_projects
WHERE users_id IN 

(SELECT id
FROM users 
WHERE email = 'aparecido@empresa.com')
)
GO

--3)

SELECT name, email
FROM users
WHERE id IN 

(SELECT users_id
FROM users_has_projects
WHERE  projects_id IN

(SELECT id
FROM projects
WHERE name = 'Auditoria')
)
GO

--4)

SELECT name,
       description,
	   CONVERT(CHAR(10), date, 103) AS date,
	   '16/09/2014' AS data_final,
	   79.85 AS custo_diario,
	   DATEDIFF(DAY, date, '16/09/2014') * 79.85 AS custo_total
FROM projects
WHERE name LIKE 'Manutenção%'
GO


SELECT * FROM projects
SELECT * FROM users
SELECT * FROM users_has_projects
GO

