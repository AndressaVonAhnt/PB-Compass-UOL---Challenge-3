*** Settings ***
Library    DateTime
Resource    ./api_keywords.robot
Resource    ./variables.robot

*** Keywords ***
Deletar Usuario Pelo ID
    [Arguments]    ${id_usuario}
    ${response}=    DELETE On Session    serveRest    /usuarios/${id_usuario}
    # Não valida o status, pois pode ser 200 (sucesso) ou 400 (com carrinho)
    # ou 404 (inexistente). A limpeza deve ser robusta.

Buscar Usuario Por ID E Validar
    [Arguments]    ${id_usuario}    ${nome_esperado}    ${email_esperado}
    ${response}=    GET On Session    serveRest    /usuarios/${id_usuario}
    Validar Status Code    ${response}    200
    Should Be Equal As Strings    ${response.json()}[nome]    ${nome_esperado}
    Should Be Equal As Strings    ${response.json()}[email]    ${email_esperado}

Gerar Email Restrito Dinamico
    [Arguments]    ${dominio}
    # NOVO: Usa a biblioteca DateTime (padrão do Robot) para obter o timestamp.
    # O format é YYYYMMDDHHMMSS, garantindo a unicidade.
    ${current_date}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${timestamp}=    Convert Date    ${current_date}    result_format=%Y%m%d%H%M%S
    # Concatena a string, o timestamp e o domínio fornecido (ex: @gmail.com)
    ${email}=    Set Variable    robot.test.${timestamp}${dominio}
    [Return]    ${email}