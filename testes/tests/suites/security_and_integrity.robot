*** Settings ***
Resource    ../resources/api_keywords.robot
Test Setup    Criar Sessão    ${BASE_URL}
Force Tags    P1    P2    Critico    Seguranca

*** Variables ***
${DUMMY_ID}    dummyID12345

*** Test Cases ***
Cenario P-003 - Deve Negar POST /produtos Sem Token (P1)
    [Tags]    Token
    ${product_body}=    Create Dictionary    nome=Produto Sem Token    preco=10    descricao=sem token    quantidade=1
    ${response}=    POST On Session    serve_rest    /produtos    json=${product_body}
    Validar Status Code    ${response}    401
    Validar Mensagem de Sucesso    ${response}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Cenario P-008 - Deve Negar PUT /produtos Sem Token (P1)
    [Tags]    Token
    ${update_body}=    Create Dictionary    nome=Produto Sem Token    preco=150    descricao=sem token    quantidade=8
    ${response}=    PUT On Session    serve_rest    /produtos/${DUMMY_ID}    json=${update_body}
    Validar Status Code    ${response}    401
    Validar Mensagem de Sucesso    ${response}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Cenario C-003 - Deve Negar POST /carrinhos Sem Token (P1)
    [Tags]    Token
    ${cart_body}=    Create Dictionary    idProduto=${DUMMY_ID}    quantidade=1
    ${cart_list}=    Create List    ${cart_body}
    ${final_cart_body}=    Create Dictionary    produtos=${cart_list}
    ${response}=    POST On Session    serve_rest    /carrinhos    json=${final_cart_body}
    Validar Status Code    ${response}    401
    Validar Mensagem de Sucesso    ${response}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Cenario U-018 - Deve Bloquear Exclusão de Usuario com Carrinho Ativo (P2)
    [Tags]    Integridade    Bloqueio
    Fazer Login Válido
    Criar Produto Randomico    ${TOKEN}
    
    ${cart_body}=    Create Dictionary    idProduto=${PRODUCT_ID}    quantidade=1
    ${cart_list}=    Create List    ${cart_body}
    ${final_cart_body}=    Create Dictionary    produtos=${cart_list}
    ${headers}=    Create Dictionary    Authorization=${TOKEN}
    ${response_create_cart}=    POST On Session    serve_rest    /carrinhos    json=${final_cart_body}    headers=${headers}
    
    ${response_delete}=    DELETE On Session    serve_rest    /usuarios/admin    headers=${headers}
    
    Validar Status Code    ${response_delete}    400
    Validar Mensagem de Sucesso    ${response_delete}    Não é possível excluir usuário com carrinho cadastrado
    
    DELETE On Session    serve_rest    /carrinhos/concluir-compra    headers=${headers}

Cenario P-012 - Deve Bloquear Exclusão de Produto com Carrinho Ativo (P2)
    [Tags]    Integridade    Bloqueio
    Fazer Login Válido
    Criar Produto Randomico    ${TOKEN}
    ${Produto_Bloqueado_ID}=    Set Variable    ${PRODUCT_ID}
    
    ${cart_body}=    Create Dictionary    idProduto=${Produto_Bloqueado_ID}    quantidade=1
    ${cart_list}=    Create List    ${cart_body}
    ${final_cart_body}=    Create Dictionary    produtos=${cart_list}
    ${headers}=    Create Dictionary    Authorization=${TOKEN}
    ${response_create_cart}=    POST On Session    serve_rest    /carrinhos    json=${final_cart_body}    headers=${headers}

    ${response_delete}=    DELETE On Session    serve_rest    /produtos/${Produto_Bloqueado_ID}    headers=${headers}
    
    Validar Status Code    ${response_delete}    400
    Validar Mensagem de Sucesso    ${response_delete}    Não é possível excluir produto que faça parte de carrinho
    
    DELETE On Session    serve_rest    /carrinhos/concluir-compra    headers=${headers}