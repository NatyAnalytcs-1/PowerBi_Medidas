# 📘 Coleção de Medidas DAX - Power BI

## 🧾 Gerais / Utilitários

🔹 **Contagem de Linhas**

```
Total Contagem Linhas = COUNTROWS(Tabela)

```

🔹 **Filtro com CALCULATE**

```
TotalAlgo =
CALCULATE(
    [Medida],
    Tabela[Coluna] = "Texto"
)

```

🔹 **SWITCH – Classificação de Jornadas**

```
Carga Horário de Trabalho =
SWITCH(
    TRUE(),
    'Fabsenteismo'[Qtd. Horas] >= 4.1 && 'Fabsenteismo'[Qtd. Horas] < 5, "Jornada mensal acima 100 hs",
    'Fabsenteismo'[Qtd. Horas] >= 5   && 'Fabsenteismo'[Qtd. Horas] < 5.5, "Jornada mensal acima 120 hs",
    'Fabsenteismo'[Qtd. Horas] >= 5.5 && 'Fabsenteismo'[Qtd. Horas] < 6.966, "Jornada mensal acima 130 hs",
    'Fabsenteismo'[Qtd. Horas] >= 6.1, "Jornada mensal acima de 150 hs",
    "100% Ausente"
)

```

---

## 👥 Absenteísmo / Recursos Humanos

🔹 **% Absenteísmo**

```
% Absenteísmo =
COALESCE(
    DIVIDE([TotalH_Ausentes], [TotalqtdHoras], 0),
    0
)

```

🔹 **% Absenteísmo Médio por Setor**

```
% Absenteísmo Médio por Setor =
AVERAGEX(
    VALUES(Tabela[Colaborador]),
    [% Absenteísmo]
)

```

🔹 **Total Qtd. Horas (Formatado em hh:mm:ss)**

```
Total Qtd. Horas (Formatado) =
VAR ValorDaMedida = COALESCE([TotalqtdHoras], 0)
VAR TotalSegundos = ValorDaMedida * 86400
VAR Horas = INT(TotalSegundos / 3600)
VAR MinutosRestantes = MOD(TotalSegundos, 3600)
VAR Minutos = INT(MinutosRestantes / 60)
VAR Segundos = ROUND(MOD(MinutosRestantes, 60), 0)

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

---

## 💰 Financeiro

🔹 **Total Vendas**

```
Total Vendas = SUM(Tabela[Vendas])

```

🔹 **Vendas Acumuladas (YTD)**

```
Vendas Acumuladas =
CALCULATE(
    [Total Vendas],
    DATESYTD(Datas[Data])
)

```

🔹 **% do Total de Vendas**

```
% Total Vendas =
DIVIDE(
    [Total Vendas],
    CALCULATE([Total Vendas], ALL(Tabela))
)

```

🔹 **Ticket Médio**

```
Ticket Médio =
DIVIDE([Total Vendas], DISTINCTCOUNT(Tabela[PedidoID]))

```

🔹 **Margem de Lucro**

```
Margem Lucro =
DIVIDE(
    SUM(Tabela[Lucro]),
    [Total Vendas]
)

```

🔹 **% Meta Atingida**

```
% Meta Atingida =
DIVIDE([Total Vendas], [Meta]) - 1
```

🔹 **variação comece no dia 30/05/2025**, com base **exclusivamente** no valor fixo de **R$ 6.914.580,46** como saldo de referência de 29/05.

```
Lucro/Prej. Bem =
VAR DataAtual = MAX('Calendario'[Date])
VAR SaldoHoje = [.Saldo Final Bemp]

VAR SaldoAnterior =
SWITCH(
TRUE(),
DataAtual = DATE(2025,5,30), 6914580.46,  -- Valor fixo em 29/05
DataAtual > DATE(2025,5,30),
CALCULATE(
[.Saldo Final Bemp],
PREVIOUSDAY('Calendario'[Date])
),
BLANK()
)

RETURN
IF(
DataAtual >= DATE(2025,5,30),
SaldoHoje - SaldoAnterior
)
```

---

## 👤 Clientes

🔹 **Clientes Ativos**

```
Clientes Ativos = DISTINCTCOUNT(Tabela[ClienteID])

```

🔹 **Receita por Cliente**

```
Receita por Cliente =
DIVIDE([Total Vendas], DISTINCTCOUNT(Tabela[ClienteID]))

```

🔹 **Clientes Perdidos (Churn)**

```
Clientes Perdidos =
CALCULATE(
    DISTINCTCOUNT(Tabela[ClienteID]),
    EXCEPT(
        VALUES(Tabela[ClienteID]),
        CALCULATETABLE(VALUES(Tabela[ClienteID]), PREVIOUSMONTH(Datas[Data]))
    )
)

```

---

## 📦 Produtos / Pedidos

🔹 **Ranking Produto**

```
Ranking Produto =
RANKX(
    ALL(Tabela[Produto]),
    [Total Vendas],
    ,
    DESC
)

```

🔹 **Top 5 Produtos**

```
Top 5 Produtos =
IF([Ranking Produto] <= 5, [Total Vendas])

```

🔹 **Quantidade de Pedidos**

```
Qtd Pedidos = DISTINCTCOUNT(Tabela[PedidoID])

```

🔹 **Produtos Ativos (com pelo menos 1 venda)**

```
Produtos Ativos = DISTINCTCOUNT(Tabela[Produto])

```

---

## ⏳ Tempo / Comparativos

🔹 **Crescimento Ano sobre Ano (YoY)**

```
Crescimento YoY =
DIVIDE(
    [Total Vendas] - CALCULATE([Total Vendas], SAMEPERIODLASTYEAR(Datas[Data])),
    CALCULATE([Total Vendas], SAMEPERIODLASTYEAR(Datas[Data]))
)

```

🔹 **Crescimento Mês sobre Mês (MoM)**

```
Crescimento MoM =
DIVIDE(
    [Total Vendas] - CALCULATE([Total Vendas], PREVIOUSMONTH(Datas[Data])),
    CALCULATE([Total Vendas], PREVIOUSMONTH(Datas[Data]))
)

```

🔹 **% Crescimento Acumulado (comparado ao ano anterior)**

```
% Crescimento Acumulado =
DIVIDE(
    [Vendas Acumuladas] - CALCULATE([Vendas Acumuladas], SAMEPERIODLASTYEAR(Datas[Data])),
    CALCULATE([Vendas Acumuladas], SAMEPERIODLASTYEAR(Datas[Data]))
)

```

🔹 **Dias Desde Última Venda**

```
Dias Desde Última Venda =
DATEDIFF(
    MAX(Tabela[DataVenda]),
    TODAY(),
    DAY
)

```

---

## 🆕 Exemplos Extras (muito usados)

🔹 **Vendas MTD (Month-to-Date)**

```
Vendas MTD =
CALCULATE(
    [Total Vendas],
    DATESMTD(Datas[Data])
)

```

🔹 **Vendas no Último Ano Completo**

```
Vendas Ano Passado =
CALCULATE(
    [Total Vendas],
    DATESINPERIOD(Datas[Data], MAX(Datas[Data]), -1, YEAR)
)

```

🔹 **TOPN Dinâmico (seleção pelo slicer)**

```
TopN Dinamico =
IF([Ranking Produto] <= SELECTEDVALUE(Parametros[TopN]), [Total Vendas])
```
🔹 **Tirar acento com função de PARAMETRO**
```
1 - Clicar com botão direito ( consulta nula)
2 - Clicar no (Editor avançado)
3 - Colar o codigo abaixo
4 - Renomeie a consulta
5 - Retone na sua tabela
6 - Adicionar coluna
7 - Invocar função personalizada
8 - Insira o nome da nova coluna
9 - Consulta de função ( insira a função criada)
10- Escolha a coluna de referencia



(texto as text) =>
let
    ComAcento = Text.ToList("ŠŽšžŸÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝàáâãäåçèéêëìíîïðñòóôõöùúûüýÿ"),
    SemAcento = Text.ToList("SZszYAAAAAACEEEEIIIIDNOOOOOUUUUYaaaaaaceeeeiiiidnooooouuuuyy") ,
    Palavras = List.Zip({ComAcento,SemAcento}),
    TextoAjustado = Text.ToList(texto),
    Subistituicao = List.ReplaceMatchingItems(TextoAjustado,Palavras),
    Resultado = Text.Combine(Subistituicao)
in
    Resultado
```
