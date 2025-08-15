# PowerBi_Medidas


Contagem de linhas
```
TotalContagemLinhas= COUNTROWS(tabela)

```

```
% Absenteísmo = 
COALESCE(
    DIVIDE(
        [TotalH_Ausentes],
        [TotalqtdHoras],
        0 ), 0
        )
```


```
Total Qtd. Horas (Formatado) = 
VAR ValorDaMedida = COALESCE([TotalqtdHoras], 0)

// Converte o resultado da medida (que é uma fração de dia) para segundos
VAR TotalSegundos = ValorDaMedida * 86400

VAR Horas = INT(TotalSegundos / 3600)
VAR MinutosRestantes = MOD(TotalSegundos, 3600)
VAR Minutos = INT(MinutosRestantes / 60)
VAR Segundos = ROUND(MOD(MinutosRestantes, 60), 0)

// Lógica para corrigir o segundo "60"
RETURN
IF(
    ValorDaMedida = 0, 
    "00:00:00",
    IF(
        Segundos = 60,
        FORMAT(Horas, "00") & ":" & FORMAT(Minutos + 1, "00") & ":00",
        FORMAT(Horas, "00") & ":" & FORMAT(Minutos, "00") & ":" & FORMAT(Segundos, "00")
    )
)

```
### SWITCH 
```
Carga horário de trabalho = 
SWITCH(
    TRUE(),
    'Fabsenteismo'[Qtd. Horas] >= 4.1&& 'Fabsenteismo'[Qtd. Horas] < 5, "Jornada mensal acima 100 hs",
    'Fabsenteismo'[Qtd. Horas] >= 5 && 'Fabsenteismo'[Qtd. Horas] < 5.5, "Jornada mensal acima 120 hs",
    'Fabsenteismo'[Qtd. Horas] >= 5.5 && 'Fabsenteismo'[Qtd. Horas] < 6.966, "Jornada mensal acima 130 hs",
    'Fabsenteismo'[Qtd. Horas] >= 6.1, "Jornada mensal acima de 150 hs",
    "100% Ausente"
)

````
```
% Absenteísmo Médio por Setor = 
AVERAGEX(
    VALUES(Tabela[Colaborador]),
    [% Absenteísmo]
)
```

### Filtro com calculate
````
Filtro
TotalAlgo = CALCULATE(
                    [medida],
                    tabela[coluna] = "texto")
````
