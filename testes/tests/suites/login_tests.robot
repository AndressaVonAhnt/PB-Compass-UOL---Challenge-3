*** Settings ***
Resource    ../resources/api_keywords.robot
Test Setup    Criar Sessão    ${BASE_URL}

*** Test Cases ***
Cenario L-001 - Deve Logar com Sucesso e Capturar Token
    [Tags]    P1    Critico    Login
    ${response}=    Fazer Login Válido
    Validar Mensagem de Sucesso    ${response}    Login realizado com sucesso
    Should Not Be Empty    ${TOKEN}

Cenario L-002 - Deve Retornar Erro com Email Não Cadastrado 
    [Tags]    P3    Qualidade
    ${unique_id}=    Generate Random String    10    [NUMBERS]
    
    ${email_nao_cadastrado}=    Catenate    SEPARATOR=@    naocadastrado_${unique_id}    qa.com
    
    ${login_body}=    Create Dictionary    email=${email_nao_cadastrado}    password=teste 
    ${response}=    POST On Session    serve_rest    /login    json=${login_body}
    Validar Status Code    ${response}    401
    Validar Mensagem de Sucesso    ${response}    Email não cadastrado

Cenario L-003 - Deve Retornar Erro com Senha Incorreta
    [Tags]    P3    Qualidade
    ${login_body}=    Create Dictionary    email=fulano@qa.com    password=senha_errada
    ${response}=    POST On Session    serve_rest    /login    json=${login_body}
    Validar Status Code    ${response}    401
    Validar Mensagem de Sucesso    ${response}    Senha incorreta