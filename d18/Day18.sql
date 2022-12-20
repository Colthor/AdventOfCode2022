if OBJECT_ID('tempdb..#Day18') is not null DROP TABLE #Day18
if OBJECT_ID('tempdb..#Day18Ext') is not null DROP TABLE #Day18Ext

CREATE TABLE #Day18 (
	x INT,
	y INT,
	z INT
);

-- Make sure input file has CRLF line endings.
BULK INSERT #Day18 FROM "C:\Users\Michael\Documents\GitHub\AdventOfCode2022\d18\Day18.txt"
	WITH (FIELDTERMINATOR = ',', ROWTERMINATOR= '\n' )

DECLARE @XAdj INT = 0;
DECLARE @YAdj INT = 0;
DECLARE @ZAdj INT = 0;

SELECT @Xadj = count(1) FROM #Day18 AS a INNER JOIN #Day18 AS b ON a.y = b.y AND a.z = b.z AND a.x = b.x-1
SELECT @Yadj = count(1) FROM #Day18 AS a INNER JOIN #Day18 AS b ON a.x = b.x AND a.z = b.z AND a.y = b.y-1
SELECT @Zadj = count(1) FROM #Day18 AS a INNER JOIN #Day18 AS b ON a.y = b.y AND a.x = b.x AND a.z = b.z-1

SELECT count(1) * 6 - 2 * (@XAdj + @YAdj + @ZAdj) AS Answer FROM #Day18


--Part 2:

CREATE TABLE #Day18Ext (
	x INT,
	y INT,
	z INT,
	ext bit
);

DECLARE @XMin INT = 0;DECLARE @YMin INT = 0;DECLARE @ZMin INT = 0;
DECLARE @XMax INT = 0;DECLARE @YMax INT = 0;DECLARE @ZMax INT = 0;

SELECT @XMin = min(x) - 1, @XMax = max(x) + 1,
	   @YMin = min(y) - 1, @YMax = max(y) + 1,
	   @ZMin = min(z) - 1, @ZMax = max(z) + 1 FROM #Day18

DECLARE @X INT = @XMin; DECLARE @Y INT = @YMin; DECLARE @Z INT= @ZMin;

--Populate the external cubes table
WHILE @X <= @XMax
BEGIN
	SELECT @Y = @YMin;
	WHILE @Y <= @YMax
	BEGIN
		SELECT @Z = @ZMin;
		WHILE @Z <= @ZMax
		BEGIN
			IF 0 = (SELECT COUNT(1) FROM #Day18 WHERE x = @X AND y = @Y AND z = @Z)
			BEGIN
				INSERT INTO #Day18Ext (x, y, z, ext) VALUES (@X, @Y, @Z, 
					(CASE WHEN @X = @XMin OR @Y = @XMin OR @Z = @XMin OR @X = @XMax OR @Y = @YMax OR @Z = @ZMax THEN 1 ELSE 0 END));
			END --if
			SELECT @Z = @Z+1;
		END --Z
		SELECT @Y = @Y+1;
	END --Y
	SELECT @X = @X+1;
END --X


DECLARE @DONESOMETHING INT = 1

WHILE @DONESOMETHING > 0
BEGIN
	SELECT @DONESOMETHING = 0

	UPDATE a --z
	SET ext=1, @DONESOMETHING = 1
	FROM #Day18Ext AS a
		INNER JOIN #Day18Ext AS b
			ON b.ext = 1 AND a.ext = 0 AND (a.x = b.x AND a.y = b.y AND ABS(a.z - b.z) = 1)

	UPDATE a --y
	SET ext=1, @DONESOMETHING = 1
	FROM #Day18Ext AS a
		INNER JOIN #Day18Ext AS b
			ON b.ext = 1 AND a.ext = 0 AND
			(a.x = b.x AND a.z = b.z AND ABS(a.y - b.y) = 1)

	UPDATE a --x
	SET ext=1, @DONESOMETHING = 1
	FROM #Day18Ext AS a
		INNER JOIN #Day18Ext AS b
			ON b.ext = 1 AND a.ext = 0 AND
			(a.y = b.y AND a.z = b.z AND ABS(a.x - b.x) = 1)

END


SELECT COUNT(1) AS ContainedAir FROM #Day18Ext WHERE ext=0

INSERT INTO #Day18
	(x, y, z)
	SELECT x, y, z FROM #Day18Ext WHERE ext=0

SELECT @Xadj = count(1) FROM #Day18 AS a INNER JOIN #Day18 AS b ON a.y = b.y AND a.z = b.z AND a.x = b.x-1
SELECT @Yadj = count(1) FROM #Day18 AS a INNER JOIN #Day18 AS b ON a.x = b.x AND a.z = b.z AND a.y = b.y-1
SELECT @Zadj = count(1) FROM #Day18 AS a INNER JOIN #Day18 AS b ON a.y = b.y AND a.x = b.x AND a.z = b.z-1

SELECT count(1) * 6 - 2 * (@XAdj + @YAdj + @ZAdj) AS AnswerPart2 FROM #Day18


DROP TABLE #Day18
DROP TABLE #Day18Ext