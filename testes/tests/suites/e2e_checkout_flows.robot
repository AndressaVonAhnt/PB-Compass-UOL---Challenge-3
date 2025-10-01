*** Settings ***
Resource    ../resources/api_keywords.robot
Test Setup    Criar Sessão    ${BASE_URL}
Test Teardown    Run Keywords    Excluir Produto ${PRODUCT_ID}

*** Test Cases ***
Cenario E2E-001 - Deve Criar e Concluir uma Compra com Sucesso
    [Tags]    P2    E2E    Critico

    Fazer Login Válido
    Criar Produto Randomico    ${TOKEN}

    ${cart_body}=    Create Dictionary    idProduto=${PRODUCT_ID}    quantidade=1
    ${cart_list}=    Create List    ${cart_body}
    ${final_cart_body}=    Create Dictionary    produtos=${cart_list}
    ${headers}=    Create Dictionary    Authorization=${TOKEN}

    ${response_create}=    POST On Session    serve_rest    /carrinhos    json=${final_cart_body}    headers=${headers}
    Validar Status Code    ${response_create}    201
    Validar Mensagem de Sucesso    ${response_create}    Cadastro realizado com sucesso

    ${response_checkout}=    DELETE On Session    serve_rest    /carrinhos/concluir-compra    headers=${headers}
    Validar Status Code    ${response_checkout}    200
    Validar Mensagem de Sucesso    ${response_checkout}    Registro excluído com sucesso