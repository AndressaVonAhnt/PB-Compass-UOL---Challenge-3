*** Settings ***
Library    RequestsLibrary
Resource    ./variables.robot

*** Keywords ***
Criar Sessao Com URL Base
    [Arguments]    ${session_alias}    ${base_url}
    Create Session    ${session_alias}    ${base_url}    headers=${HEADER_DEFAULT}


Validar Status Code
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Strings    ${response.status_code}    ${expected_status}

Validar Mensagem Da Resposta
    [Arguments]    ${response}    ${expected_message}
    Should Be Equal As Strings    ${response.json()}[message]    ${expected_message}

Validar Que Mensagem Contem Texto
    [Arguments]    ${response}    ${expected_text}
    ${message}=    Set Variable    ${response.json()}[message]
    Should Contain    ${message}    ${expected_text}

Obter ID Da Resposta
    [Arguments]    ${response}
    ${id}=    Set Variable    ${response.json()}[_id]
    RETURN    ${id}