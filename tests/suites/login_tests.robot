*** Settings ***
Resource    ../resources/login_keywords.robot
Resource    ../resources/api_keywords.robot
Resource    ../resources/user_keywords.robot
Resource    ../resources/variables.robot
Test Setup    Criar Sessao Com URL Base    serveRest    ${BASE_URL}

*** Test Cases ***
Cenario L-001 - Login Válido e Captura de Token (P1)
    ${email}    ${senha}    ${id_usuario}=    Cadastrar Usuario Novo Com Sucesso
    ${token_gerado}=    Fazer Login E Retornar Token    ${email}    ${senha}

    Deletar Usuario Pelo ID    ${id_usuario}

Cenario L-002 - Falha: Email Não Cadastrado (P3)
    ${email_nao_cadastrado}=    FakerLibrary.Email
    ${body}=    Create Dictionary    email=${email_nao_cadastrado}    password=${SENHA_VALIDA}
    ${response}=    POST On Session    serveRest    /login    json=${body}    expected_status=401
    Validar Status Code    ${response}    401
    Validar Mensagem Da Resposta    ${response}    Email Não Cadastrado

Cenario L-003 - Falha: Senha Incorreta (P3)
    ${email}    ${senha_correta}    ${id_usuario}=    Cadastrar Usuario Novo Com Sucesso
    ${senha_incorreta}=    Set Variable    123
    ${body}=    Create Dictionary    email=${email}    password=${senha_incorreta}
    ${response}=    POST On Session    serveRest    /login    json=${body}    expected_status=401
    Validar Status Code    ${response}    401
    Validar Mensagem Da Resposta    ${response}    Senha Incorreta

    Deletar Usuario Pelo ID    ${id_usuario}