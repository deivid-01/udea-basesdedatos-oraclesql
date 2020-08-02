--Taller avanzado
--Punto 1
SELECT SUM(cantidad)
FROM COSECHAS c
WHERE c.nvin=20;

--Punto 2

SELECT nombre, nvin, sum(cantidad)
FROM VINOS , COSECHAS 
WHERE num=nvin
GROUP BY nvin, nombre
ORDER BY nombre;

-- Punto 3

SELECT v.nombre,c.nvin, COUNT(c.nprod)AS cantidadProductores
FROM VINOS v , COSECHAS c
WHERE v.num=c.nvin
GROUP BY c.nvin, v.nombre
ORDER BY v.nombre;

-- Punto 4
SELECT p.num, p.nombre, p.apellido, COUNT(c.nvin)
FROM PRODUCTORES p, COSECHAS  c
WHERE p.num=c.nprod 
GROUP BY p.num, p.nombre, p.apellido
HAVING COUNT(c.nvin)>=3;

-- Punto 5
-- LA VISTA
create or replace view cproductivas as (
SELECT p.num as productor,p.nombre, v.nombre as vino, c.cantidad
FROM VINOS v, COSECHAS c, PRODUCTORES p
WHERE v.num =c.nvin AND c.cantidad >200 AND p.num=c.nprod);

SELECT productor , nombre, COUNT(*) 
FROM cproductivas
GROUP BY productor , nombre ;
 
-- CREO QUE SERIA LA B
SELECT p.num,p.nombre, count(*)
FROM VINOS v, COSECHAS c, PRODUCTORES p
WHERE v.num =c.nvin AND c.cantidad >200 AND p.num=c.nprod
GROUP BY p.num,p.nombre;

SELECT p.num,p.nombre, c.cantidad
FROM VINOS v, COSECHAS c, PRODUCTORES p
WHERE v.num =c.nvin AND c.cantidad >200 AND p.num=c.nprod
GROUP BY p.num,p.nombre,c.cantidad;
--´PRUEBA
SELECT p.nombre,v.nombre, c.cantidad
FROM VINOS v, COSECHAS c, PRODUCTORES p
WHERE v.num =c.nvin AND c.cantidad >200 AND p.num=c.nprod;

--Punto 6 
SELECT p.num, p.nombre, p.apellido, COUNT(c.nvin)
FROM PRODUCTORES p, COSECHAS  c
WHERE p.num=c.nprod 
GROUP BY p.num, p.nombre, p.apellido
HAVING COUNT( DISTINCT (c.nvin))=(SELECT COUNT (*) FROM  VINOS v);
---

-- sin el DISTINCT
SELECT p.num, p.nombre, p.apellido, COUNT(c.nvin)
FROM PRODUCTORES p, COSECHAS  c
WHERE p.num=c.nprod 
GROUP BY p.num, p.nombre, p.apellido
HAVING COUNT (c.nvin)=(SELECT COUNT (*) FROM  VINOS v);
--CON EL EXIST
SELECT p.num, p.nombre, p.apellido FROM PRODUCTORES p
WHERE NOT EXISTS (
    SELECT 1 FROM VINOS v
     WHERE NOT EXISTS (
     SELECT 1 FROM COSECHAS c
     WHERE c.nprod=p.num AND 
     v.num=c.nvin 
)
);
-- Punto 7
create or replace view VINOS6 as(
SELECT v.num as VINOS
FROM VINOS v, COSECHAS c
WHERE v.num=c.nvin AND c.nprod=6);


--
SELECT p.num, p.nombre, p.apellido, c.nvin
FROM PRODUCTORES p, COSECHAS  c
WHERE p.num=c.nprod AND c.nprod=9;
--
--PUNTO 7 CON  EXISTS
SELECT p.num, p.nombre, p.apellido FROM PRODUCTORES p
WHERE NOT EXISTS (
    SELECT 1 FROM VINOS6 v
     WHERE NOT EXISTS (
     SELECT 1 FROM COSECHAS c
     WHERE c.nprod=p.num AND 
     v.vinos=c.nvin  AND c.nprod<>6
)
);
-- COUNT
SELECT  p.num, p.nombre, p.apellido 
FROM PRODUCTORES p JOIN COSECHAS c ON c.nprod=p.num  JOIN (SELECT  DISTINCT c.nvin FROM COSECHAS c WHERE c.nprod=1) v 
ON c.nvin=v.nvin
where p.num!=1
group by p.num, p.nombre,p.apellido
having count(*)=(SELECT count(*) from (SELECT DISTINCT c.nvin FROM COSECHAS c WHERE c.nprod=1));


