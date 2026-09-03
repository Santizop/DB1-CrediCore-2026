BEGIN
    DECLARE @SqlScript NVARCHAR(MAX) = N'INSERT INTO Garantias.Vehiculos (Marca, Modelo, Color, NumTitulo, AnioVehiculo, NumPlaca) VALUES ';
    DECLARE @i INT = 1;

    WHILE @i <= 1500
    BEGIN
        SET @SqlScript = @SqlScript + 
            N'(''Toyota'', ''Corolla'', ''Gris'', ''TIT-' + CAST(@i AS VARCHAR(10)) + 
            N''', 2020, ''P-' + RIGHT('000000' + CAST(@i AS VARCHAR(10)), 6) + N''')';

        IF @i < 1500
            SET @SqlScript = @SqlScript + N', ';

        SET @i = @i + 1;
    END;

    EXEC sp_executesql @SqlScript;
END;

-- Continuan los 2 bloques para realizar la insercion de las 1500 filas

BEGIN
    -- Declaramos una tabla temporal con las combinaciones de marcas y modelos que quieras
    DECLARE @ModelosVehiculos TABLE (
        ID INT IDENTITY(1,1),
        Marca VARCHAR(50),
        Modelo VARCHAR(50)
    );

    -- Insertamos las opciones que deseas alternar
    INSERT INTO @ModelosVehiculos (Marca, Modelo) VALUES 
    ('Toyota', 'Corolla'),
    ('Honda', 'Civic'),
    ('Nissan', 'Sentra'),
    ('Mazda', 'Mazda3'),
    ('Hyundai', 'Elantra'),
    ('Kia', 'Cerato');

    DECLARE @TotalOpciones INT = @@ROWCOUNT;
    DECLARE @MarcaActual VARCHAR(50);
    DECLARE @ModeloActual VARCHAR(50);
    DECLARE @IndiceModelo INT;

    DECLARE @SqlScript1 NVARCHAR(MAX) = N'INSERT INTO Garantias.Vehiculos (Marca, Modelo, Color, NumTitulo, AnioVehiculo, NumPlaca) VALUES ';
    DECLARE @i INT = 1;

    WHILE @i <= 1000
    BEGIN
        -- Calculamos qué marca/modelo toca usar usando el módulo (%) para rotar entre las opciones
        SET @IndiceModelo = ((@i - 1) % @TotalOpciones) + 1;
        
        SELECT @MarcaActual = Marca, @ModeloActual = Modelo 
        FROM @ModelosVehiculos 
        WHERE ID = @IndiceModelo;

        SET @SqlScript1 = @SqlScript1 + 
            N'(''' + @MarcaActual + ''', ''' + @ModeloActual + ''', ''Gris'', ''TIT-' + CAST(@i AS VARCHAR(10)) + 
            N''', 2020, ''P-' + RIGHT('000000' + CAST(@i AS VARCHAR(10)), 6) + N''')';

        IF @i < 1000
            SET @SqlScript1 = @SqlScript1 + N', ';

        SET @i = @i + 1;
    END;

    EXEC sp_executesql @SqlScript1;

    DECLARE @SqlScript2 NVARCHAR(MAX) = N'INSERT INTO Garantias.Vehiculos (Marca, Modelo, Color, NumTitulo, AnioVehiculo, NumPlaca) VALUES ';
    
    WHILE @i <= 1500
    BEGIN
        -- El ciclo continúa desde 1001 hasta 1500 manteniendo la rotación fluida
        SET @IndiceModelo = ((@i - 1) % @TotalOpciones) + 1;
        
        SELECT @MarcaActual = Marca, @ModeloActual = Modelo 
        FROM @ModelosVehiculos 
        WHERE ID = @IndiceModelo;

        SET @SqlScript2 = @SqlScript2 + 
            N'(''' + @MarcaActual + ''', ''' + @ModeloActual + ''', ''Gris'', ''TIT-' + CAST(@i AS VARCHAR(10)) + 
            N''', 2020, ''P-' + RIGHT('000000' + CAST(@i AS VARCHAR(10)), 6) + N''')';

        IF @i < 1500
            SET @SqlScript2 = @SqlScript2 + N', ';

        SET @i = @i + 1;
    END;

    EXEC sp_executesql @SqlScript2;
END;

SELECT * FROM Garantias.Vehiculos;
