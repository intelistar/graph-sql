USE master;
DROP DATABASE IF EXISTS BooksAndReaders;
CREATE DATABASE BooksAndReaders;
USE BooksAndReaders;

CREATE TABLE Reader
(
id INT NOT NULL PRIMARY KEY,
name NVARCHAR(50) NOT NULL
) AS NODE;

CREATE TABLE Book
(
id INT NOT NULL PRIMARY KEY,
name NVARCHAR(50) NOT NULL,
author NVARCHAR(50) NOT NULL
) AS NODE;

CREATE TABLE Genre
(
id INT NOT NULL PRIMARY KEY,
genre NVARCHAR(50) NOT NULL,
) AS NODE;

CREATE TABLE FriendOf AS EDGE;
CREATE TABLE Recommends AS EDGE;
CREATE TABLE BookGenre AS EDGE;

ALTER TABLE FriendOf
ADD CONSTRAINT EC_FriendOf CONNECTION (Reader TO Reader);
ALTER TABLE BookGenre
ADD CONSTRAINT EC_BookGenre CONNECTION (Book TO Genre);
ALTER TABLE Recommends
ADD CONSTRAINT EC_Recommends CONNECTION (Reader TO Book);
GO

INSERT INTO Reader (id, name)
VALUES 
(1, N'�������'),
(2, N'�����'),
(3, N'����'),
(4, N'�����'),
(5, N'�������'),
(6, N'����'),
(7, N'�������'),
(8, N'�����'),
(9, N'������'),
(10, N'��������');
GO

INSERT INTO Book (id, name, author)
VALUES 
(1, N'����� � ���', N'��� �������'),
(2, N'������������ � ���������', N'Ը��� �����������'),
(3, N'������ � ���������', N'������ ��������'),
(4, N'���� ��������', N'��� �������'),
(5, N'������� ������', N'��������� ������'),
(6, N'�����', N'Ը��� �����������'),
(7, N'����� ������ �������', N'������ ���������'),
(8, N'̸����� ����', N'������� ������'),
(9, N'���� � ����', N'���� ��������'),
(10, N'�������', N'���� ��������');
GO

INSERT INTO Genre (id, genre)
VALUES 
(1, N'�����'),
(2, N'�����'),
(3, N'����������'),
(4, N'������'),
(5, N'�����������'),
(6, N'������������'),
(7, N'���������'),
(8, N'���������'),
(9, N'������� ����������'),
(10, N'��������');
GO

INSERT INTO FriendOf ($from_id, $to_id)
VALUES 
((SELECT $node_id FROM Reader WHERE id = 1),
(SELECT $node_id FROM Reader WHERE id = 2)),
((SELECT $node_id FROM Reader WHERE id = 2),
(SELECT $node_id FROM Reader WHERE id = 6)),
((SELECT $node_id FROM Reader WHERE id = 3),
(SELECT $node_id FROM Reader WHERE id = 2)),
((SELECT $node_id FROM Reader WHERE id = 5),
(SELECT $node_id FROM Reader WHERE id = 8)),
((SELECT $node_id FROM Reader WHERE id = 6),
(SELECT $node_id FROM Reader WHERE id = 10)),
((SELECT $node_id FROM Reader WHERE id = 7),
(SELECT $node_id FROM Reader WHERE id = 5)),
((SELECT $node_id FROM Reader WHERE id = 8),
(SELECT $node_id FROM Reader WHERE id = 1)),
((SELECT $node_id FROM Reader WHERE id = 8),
(SELECT $node_id FROM Reader WHERE id = 6)),
((SELECT $node_id FROM Reader WHERE id = 9),
(SELECT $node_id FROM Reader WHERE id = 3)),
((SELECT $node_id FROM Reader WHERE id = 9),
(SELECT $node_id FROM Reader WHERE id = 4)),
((SELECT $node_id FROM Reader WHERE id = 10),
(SELECT $node_id FROM Reader WHERE id = 9));
GO

INSERT INTO BookGenre ($from_id, $to_id)
VALUES 
((SELECT $node_id FROM Book WHERE id = 1),
(SELECT $node_id FROM Genre WHERE id = 6)),
((SELECT $node_id FROM Book WHERE id = 2),
(SELECT $node_id FROM Genre WHERE id = 2)),
((SELECT $node_id FROM Book WHERE id = 3),
(SELECT $node_id FROM Genre WHERE id = 3)),
((SELECT $node_id FROM Book WHERE id = 4),
(SELECT $node_id FROM Genre WHERE id = 1)),
((SELECT $node_id FROM Book WHERE id = 5),
(SELECT $node_id FROM Genre WHERE id = 5)),
((SELECT $node_id FROM Book WHERE id = 6),
(SELECT $node_id FROM Genre WHERE id = 8)),
((SELECT $node_id FROM Book WHERE id = 7),
(SELECT $node_id FROM Genre WHERE id = 7)),
((SELECT $node_id FROM Book WHERE id = 8),
(SELECT $node_id FROM Genre WHERE id = 10)),
((SELECT $node_id FROM Book WHERE id = 9),
(SELECT $node_id FROM Genre WHERE id = 9)),
((SELECT $node_id FROM Book WHERE id = 10),
(SELECT $node_id FROM Genre WHERE id = 4));
GO

INSERT INTO Recommends ($from_id, $to_id)
VALUES 
((SELECT $node_id FROM Reader WHERE id = 1),
(SELECT $node_id FROM Book WHERE id = 4)),
((SELECT $node_id FROM Reader WHERE id = 2),
(SELECT $node_id FROM Book WHERE id = 5)),
((SELECT $node_id FROM Reader WHERE id = 2),
(SELECT $node_id FROM Book WHERE id = 6)),
((SELECT $node_id FROM Reader WHERE id = 3),
(SELECT $node_id FROM Book WHERE id = 3)),
((SELECT $node_id FROM Reader WHERE id = 4),
(SELECT $node_id FROM Book WHERE id = 9)),
((SELECT $node_id FROM Reader WHERE id = 5),
(SELECT $node_id FROM Book WHERE id = 8)),
((SELECT $node_id FROM Reader WHERE id = 5),
(SELECT $node_id FROM Book WHERE id = 5)),
((SELECT $node_id FROM Reader WHERE id = 6),
(SELECT $node_id FROM Book WHERE id = 2)),
((SELECT $node_id FROM Reader WHERE id = 6),
(SELECT $node_id FROM Book WHERE id = 5)),
((SELECT $node_id FROM Reader WHERE id = 7),
(SELECT $node_id FROM Book WHERE id = 6)),
((SELECT $node_id FROM Reader WHERE id = 8),
(SELECT $node_id FROM Book WHERE id = 7)),
((SELECT $node_id FROM Reader WHERE id = 8),
(SELECT $node_id FROM Book WHERE id = 4)),
((SELECT $node_id FROM Reader WHERE id = 9),
(SELECT $node_id FROM Book WHERE id = 9)),
((SELECT $node_id FROM Reader WHERE id = 9),
(SELECT $node_id FROM Book WHERE id = 10)),
((SELECT $node_id FROM Reader WHERE id = 10),
(SELECT $node_id FROM Book WHERE id = 1));
GO

SELECT Reader1.name
, Reader2.name AS [friend name]
FROM Reader AS Reader1
, FriendOf
, Reader AS Reader2
WHERE MATCH(Reader1-(FriendOf)->Reader2)
AND Reader1.name = N'�����';

SELECT Reader1.name + N' ������ � ' + Reader2.name AS Level1
, Reader2.name + N' ������ � ' + Reader3.name AS Level2
FROM Reader AS Reader1
, FriendOf AS friend1
, Reader AS Reader2
, FriendOf AS friend2
, Reader AS Reader3
WHERE MATCH(Reader1-(friend1)->Reader2-(friend2)->Reader3)
AND Reader1.name = N'�����';
GO

SELECT Reader2.name AS person
, Book.name AS book
FROM Reader AS Reader1
, Reader AS Reader2
, Recommends
, FriendOf
, Book
WHERE MATCH(Reader1-(FriendOf)->Reader2-(Recommends)->Book)
AND Reader1.name = N'�����';
GO

SELECT Reader3.name AS person
, Book.name AS book
FROM Reader AS Reader1
, Reader AS Reader2
, Reader AS Reader3
, Recommends
, FriendOf AS FriendOf1
, FriendOf AS FriendOf2
, Book
WHERE MATCH(Reader1-(FriendOf1)->Reader2-(FriendOf2)->Reader3-(Recommends)->Book)
AND Reader1.name = N'�����';
GO

SELECT Reader2.name AS person
, Book.name AS book
, Genre.genre AS genre
FROM Reader AS Reader1
, Reader AS Reader2
, Recommends
, FriendOf
, Book
, BookGenre
, Genre
WHERE MATCH(Reader1-(FriendOf)->Reader2-(Recommends)->Book-(BookGenre)->Genre)
AND Reader1.name = N'�����';
GO

SELECT Reader1.name AS ReaderName
, STRING_AGG(Reader2.name, N'->') WITHIN GROUP (GRAPH PATH) AS Friends
FROM Reader AS Reader1
, FriendOf FOR PATH AS fo
, Reader FOR PATH AS Reader2
WHERE MATCH(SHORTEST_PATH(Reader1(-(fo)->Reader2)+))
AND Reader1.name = N'�����';
GO

SELECT Reader1.name AS ReaderName
, STRING_AGG(Reader2.name, N'->') WITHIN GROUP (GRAPH PATH) AS Friends
FROM Reader AS Reader1
, FriendOf FOR PATH AS fo
, Reader FOR PATH AS Reader2
WHERE MATCH(SHORTEST_PATH(Reader1(-(fo)->Reader2){1,3}))
AND Reader1.name = N'�����';
GO

SELECT @@SERVERNAME
-- DESKTOP-FC09JS0\SQLEXPRESS01
-- BooksAndReaders
SELECT R1.id AS IdFirst
, R1.name AS First
, CONCAT(N'reader', R1.id) AS [First image name]
, R2.id AS IdSecond
, R2.name AS Second
, CONCAT(N'reader', R2.id) AS [Second image name]
FROM dbo.Reader AS R1
, dbo.FriendOf AS F
, dbo.Reader AS R2
WHERE MATCH (R1-(F)->R2);
GO

SELECT R1.id AS IdReader
, R1.name AS Reader
, CONCAT(N'reader', R1.id) AS [Reader image name]
, B.id AS IdBook
, B.name AS Book
, CONCAT(N'book', B.id) AS [Book image name]
FROM dbo.Reader AS R1
, Recommends AS Rec
, Book AS B
WHERE MATCH (R1-(Rec)->B);
GO


