let
    // PARTE 1: DEFINIR AS DATAS DE INÍCIO E FIM //
    // Define a data de início fixa
    DataInicio = #date(2025, 1, 1),

    // Pega a data de hoje
    DataHoje = DateTime.Date(DateTime.LocalNow()),

    // Calcula a quantidade de dias entre DataInicio e DataHoje
    NumeroDias = Duration.Days(DataHoje - DataInicio) + 1,

    // PARTE 2: GERAR A LISTA DE DATAS E TRANSFORMAR EM TABELA //
    // Cria uma lista de datas
    ListaDeDatas = List.Dates(DataInicio, NumeroDias, #duration(1, 0, 0, 0)),

    // Converte a lista em tabela
    #"Tabela de Datas" = Table.FromList(ListaDeDatas, Splitter.SplitByNothing(), {"Date"}, null, ExtraValues.Error),

    // Garante que a coluna seja do tipo Data
    #"Tipo Alterado para Data" = Table.TransformColumnTypes(#"Tabela de Datas", {{"Date", type date}}),

    // PARTE 3: ADICIONAR AS COLUNAS PERSONALIZADAS (ANO, MÊS, DIA, ETC.) //
    #"Inserido Ano" = Table.AddColumn(#"Tipo Alterado para Data", "Ano", each Date.Year([Date]), Int64.Type),
    #"Inserido Mês" = Table.AddColumn(#"Inserido Ano", "Mês", each Date.Month([Date]), Int64.Type),
    #"Inserido Dia" = Table.AddColumn(#"Inserido Mês", "Dia", each Date.Day([Date]), Int64.Type),

    // Adiciona a coluna "Dia Útil" (Seg a Sex = 1, Sáb/Dom = 0)
    #"Inserido Dia Útil" = Table.AddColumn(#"Inserido Dia", "Dia Útil", each if Date.DayOfWeek([Date], Day.Monday) < 5 then 1 else 0, Int64.Type),

    // Adiciona o nome do mês em português
    #"Inserido Nome do Mês" = Table.AddColumn(#"Inserido Dia Útil", "NomeMês", each Date.ToText([Date], "MMMM", "pt-BR"), type text),

    // Coloca a primeira letra em maiúscula
    #"Primeira Letra Maiúscula" = Table.TransformColumns(#"Inserido Nome do Mês", {{"NomeMês", each Text.Proper(_), type text}})
in
    #"Primeira Letra Maiúscula"
