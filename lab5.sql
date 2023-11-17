CREATE DATABASE lab5;
CREATE EXTENSION postigs;

--zad1
CREATE TABLE obiekty (id SERIAL PRIMARY KEY, geometry GEOMETRY, name VARCHAR(50));
--1a
INSERT INTO obiekty(name, geometry) VALUES 
('obiekt1',ST_Collect(ARRAY['LINESTRING(0 1, 1 1)', 'CIRCULARSTRING(1 1, 2 0, 3 1)', 'CIRCULARSTRING(3 1, 4 2, 5 1)', 'LINESTRING(5 1, 6 1)']));
--1b
INSERT INTO obiekty(name, geometry) VALUES 
('obiekt2',ST_Collect(ARRAY['LINESTRING(10 6, 14 6)', 'CIRCULARSTRING(14 6, 16 4, 14 2)', 'CIRCULARSTRING(14 2, 12 0, 10 2)', 'LINESTRING(10 2, 10 6)', 'CIRCULARSTRING(11 2, 12 1, 13 2, 12 3, 11 2)']));
--1c
INSERT INTO obiekty(name, geometry) VALUES
('obiekt3', 'POLYGON((7 15, 12 13, 10 17, 7 15))');
--1d
INSERT INTO obiekty(name, geometry) VALUES
('obiekt4', 'LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)');
--1e
INSERT INTO obiekty(name, geometry) VALUES
('obiekt5', ST_Collect(ARRAY['POINT(30 30 59)', 'POINT(38 32 234)']));
--1f
INSERT INTO obiekty(name, geometry) VALUES
('obiekt6', ST_Collect(ARRAY['POINT(4 2)','LINESTRING(1 1, 3 2)']));

--zad2
SELECT ST_Area(ST_Buffer(ST_ShortestLine(obiekt3.geometry, obiekt4.geometry), 5)) AS pole_buforu
FROM obiekty AS obiekt3 
CROSS JOIN obiekty AS obiekt4 
WHERE obiekt3.id = 3 AND obiekt4.id = 4;

--zad3
WITH polygon_obiekt4 AS (
	SELECT ST_MakePolygon(ST_AddPoint(geometry, ST_StartPoint(geometry)))
	FROM obiekty
	WHERE id='4'
)
UPDATE obiekty
SET geometry = (SELECT * FROM polygon_obiekt4)
WHERE id='4';

--zad4
INSERT INTO obiekty(name, geometry) VALUES
('obiekt7',(SELECT ST_Collect(obiekt3.geometry, obiekt4.geometry)
FROM obiekty AS obiekt3 
CROSS JOIN obiekty AS obiekt4 
WHERE obiekt3.id = 3 AND obiekt4.id = 4));

--zad5
SELECT SUM(ST_Area(ST_Buffer(geometry, 5))) AS pole_powierzchni
FROM obiekty
WHERE ST_HasArc(geometry) = false;

