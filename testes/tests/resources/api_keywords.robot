*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Library    JSONLibrary

*** Variables ***
${TOKEN}    ${EMPTY}

*** Keywords ***
Criar Sessão
    [Arguments]    ${base_url}
    Create Session    serve_rest    ${base_url}
    Set Global Variable    ${BASE_URL}    ${base_url}

Fazer Login Válido
    ${login_body}=    Create Dictionary    email=fulano@qa.com    password=teste
    ${response}=    POST On Session    serve_rest    /login    json=${login_body}
    Should Be Equal As Strings    ${response.status_code}    200
    ${token}=    Get Value From Json    ${response.json()}    authorization
    Set Global Variable    ${TOKEN}    ${token}[0]
    [Return]    ${response}

Criar Usuário Administrador Randomico
    ${nome}=    Generate Random String    8    [LOWERCASE]
    ${email}=    Generate Random String    5    [LOWERCASE]
    ${email}=    Catenate    SEPARATOR=@    ${email}    qa.com
    ${user_body}=    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=senha123
    ...    administrador=true
    ${response}=    POST On Session    serve_rest    /usuarios    json=${user_body}
    Should Be Equal As Strings    ${response.status_code}    201
    ${user_id}=    Get Value From Json    ${response.json()}    _id
    Set Global Variable    ${USER_ID}    ${user_id}[0]
    Set Global Variable    ${USER_EMAIL}    ${email}
    [Return]    ${response}

Criar Produto Randomico
    [Arguments]    ${token}
    ${nome}=    Generate Random String    10    [LOWERCASE]
    ${product_body}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=100
    ...    descricao=Produto Automação
    ...    quantidade=5
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    serve_rest    /produtos    json=${product_body}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    201
    ${product_id}=    Get Value From Json    ${response.json()}    _id
    Set Global Variable    ${PRODUCT_ID}    ${product_id}[0]
    Set Global Variable    ${PRODUCT_NAME}    ${nome}
    [Return]    ${response}

Excluir Produto
    [Arguments]    ${product_id}
    ${headers}=    Create Dictionary    Authorization=${TOKEN}
    ${response}=    DELETE On Session    serve_rest    /produtos/${product_id}    headers=${headers}
    [Return]    ${response}

Validar Status Code
    [Arguments]    ${response}    ${expected_code}
    Should Be Equal As Strings    ${response.status_code}    ${expected_code}

Validar Mensagem de Sucesso
    [Arguments]    ${response}    ${expected_message}
    ${message}=    Get Value From Json    ${response.json()}    message
    Should Be Equal    ${message}[0]    ${expected_message}