*** Settings ***
Library    FakerLibrary    locale=pt_BR
Resource    ./api_keywords.robot
Resource    ./variables.robot

*** Keywords ***
Gerar Produto Aleatorio
    ${nome_produto}=    FakerLibrary.Word
    ${preco}=    FakerLibrary.Random Int    min=1    max=999
    ${descricao}=    FakerLibrary.Text
    ${quantidade}=    FakerLibrary.Random Int    min=1    max=10
    RETURN    ${nome_produto}    ${preco}    ${descricao}    ${quantidade}

Cadastrar Produto Valido E Retornar ID
    [Arguments]    ${token}
    ${nome}    ${preco}    ${descricao}    ${quantidade}=    Gerar Produto Aleatorio
    ${body}=    Create Dictionary    nome=${nome}    preco=${preco}    descricao=${descricao}    quantidade=${quantidade}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    serveRest    /produtos    json=${body}    headers=${headers}
    Validar Status Code    ${response}    201
    ${id_produto}=    Obter ID Da Resposta    ${response}
    RETURN    ${id_produto}    ${nome}

Deletar Produto Pelo ID
    [Arguments]    ${id_produto}    ${token}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE On Session    serveRest    /produtos/${id_produto}    headers=${headers}
    # Não valida o status, pois pode ser 200 (sucesso) ou 400 (com carrinho)
    # ou 404 (inexistente). A limpeza deve ser robusta.