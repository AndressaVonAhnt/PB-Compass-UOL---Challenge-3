*** Settings ***
Resource    ../resources/api_keywords.robot
Test Setup    Criar Sessão    ${BASE_URL}

*** Variables ***
${VALID_EMAIL}    testevalidacao@qa.com

*** Test Cases ***
Cenario U-009 - Deve Falhar ao Usar Senha com 4 Caracteres
    [Tags]    P2    Borda    Regressao
    ${body}=    Create Dictionary    nome=User Borda    email=${VALID_EMAIL}    password=1234    administrador=true
    ${response}=    POST On Session    serve_rest    /usuarios    json=${body}
    Validar Status Code    ${response}    400
    ${error_message}=    Get Value From Json    ${response.json()}    password

    Should Contain    ${error_message}[0]    mínimo 5 e no máximo 10 caracteres

Cenario U-008 - Deve Cadastrar com Senha de 5 Caracteres (Borda Válida)
    [Tags]    P2    Borda
    ${body}=    Create Dictionary    nome=User 5 Chars    email=borda5@qa.com    password=12345    administrador=true
    ${response}=    POST On Session    serve_rest    /usuarios    json=${body}
    Validar Status Code    ${response}    201
    Validar Mensagem de Sucesso    ${response}    Cadastro realizado com sucesso

Cenario U-007 - Deve Falhar com Email de Dominio Restrito
    [Tags]    P2    Regressao    Email
    ${body}=    Create Dictionary    nome=User Gmail    email=restrito@gmail.com    password=senha123    administrador=true
    ${response}=    POST On Session    serve_rest    /usuarios    json=${body}
    Validar Status Code    ${response}    400
    Validar Mensagem de Sucesso    ${response}    Email de provedor restrito

Cenario U-005 - Deve Falhar ao Usar Email Já Existente
    [Tags]    P2    Regra

    ${body}=    Create Dictionary    nome=User Duplicado    email=fulano@qa.com    password=testevalidado    administrador=true
    ${response}=    POST On Session    serve_rest    /usuarios    json=${body}
    Validar Status Code    ${response}    400
    Validar Mensagem de Sucesso    ${response}    Este email já está sendo usado