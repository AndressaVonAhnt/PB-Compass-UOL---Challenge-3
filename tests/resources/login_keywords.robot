*** Settings ***
Library    FakerLibrary    locale=pt_BR
Resource    ./api_keywords.robot
Resource    ./variables.robot


*** Keywords ***
Gerar Usuario Aleatorio
    ${nome}=    FakerLibrary.Name
    ${email}=    FakerLibrary.Email
    ${senha}=    Set Variable       ${SENHA_VALIDA}
    ${administrador}=    Set Variable    true
    [Return]    ${nome}    ${email}    ${senha}    ${administrador}

Cadastrar Usuario Novo Com Sucesso
    ${nome}    ${email}    ${senha}    ${administrador}=    Gerar Usuario Aleatorio
    ${body}=    Create Dictionary    nome=${nome}    email=${email}    password=${senha}    administrador=${administrador}
    ${response}=    POST On Session    serveRest    /usuarios    json=${body}
    Validar Status Code    ${response}    201
    Validar Mensagem Da Resposta    ${response}    Cadastro realizado com sucesso
    ${id_usuario}=    Obter ID Da Resposta    ${response}
    [Return]    ${email}    ${senha}    ${id_usuario}

Fazer Login E Retornar Token
    [Arguments]    ${email}    ${senha}
    ${body}=    Create Dictionary    email=${email}    password=${senha}
    ${response}=    POST On Session    serveRest    /login    json=${body}
    Validar Status Code    ${response}    200
    Validar Mensagem Da Resposta    ${response}    Login realizado com sucesso
    ${token_gerado}=    Set Variable    ${response.json()}[authorization]
    Set Suite Variable    ${TOKEN}    ${token_gerado}
    [Return]    ${token_gerado}

Setup Login Suite
    Criar Sessao Com URL Base    serveRest    ${BASE_URL}
    ${email}    ${senha}    ${id_usuario}=    Cadastrar Usuario Novo Com Sucesso
    Fazer Login E Retornar Token    ${email}    ${senha}
    Set Suite Variable    ${ID_USUARIO_SETUP}    ${id_usuario}
    Set Suite Variable    ${EMAIL_USUARIO_SETUP}    ${email}
    Set Suite Variable    ${SENHA_USUARIO_SETUP}    ${senha}