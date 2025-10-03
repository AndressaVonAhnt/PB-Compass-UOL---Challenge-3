*** Settings ***
Library    DateTime
Resource    ./api_keywords.robot
Resource    ./variables.robot

*** Keywords ***
Deletar Usuario Pelo ID
    [Arguments]    ${id_usuario}
    ${response}=    DELETE On Session    serveRest    /usuarios/${id_usuario}

Buscar Usuario Por ID E Validar
    [Arguments]    ${id_usuario}    ${nome_esperado}    ${email_esperado}
    ${response}=    GET On Session    serveRest    /usuarios/${id_usuario}
    Validar Status Code    ${response}    200
    Should Be Equal As Strings    ${response.json()}[nome]    ${nome_esperado}
    Should Be Equal As Strings    ${response.json()}[email]    ${email_esperado}

Gerar Email Restrito Dinamico
    [Arguments]    ${dominio}

    ${current_date}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${timestamp}=    Convert Date    ${current_date}    result_format=%Y%m%d%H%M%S
    # Concatena a string, o timestamp e o domínio fornecido (ex: @gmail.com)
    ${email}=    Set Variable    robot.test.${timestamp}${dominio}
    RETURN    ${email}