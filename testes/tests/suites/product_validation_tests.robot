*** Settings ***
Resource    ../resources/api_keywords.robot
Test Setup    Criar Sessão    ${BASE_URL}
Test Teardown    Run Keywords    Excluir Produto ${PRODUCT_ID}
Force Tags    P2    Regressao    Produto

*** Variables ***
${NOME_EXISTENTE}    Produto Teste 1

*** Test Cases ***
Cenario P-002 - Deve Cadastrar Produto com Sucesso
    Fazer Login Válido
    ${response}=    Criar Produto Randomico    ${TOKEN}
    Validar Status Code    ${response}    201
    Validar Mensagem de Sucesso    ${response}    Cadastro realizado com sucesso

Cenario P-004 - Deve Falhar ao Usar Nome de Produto Já Existente (POST)
    Fazer Login Válido
    Criar Produto Randomico    ${TOKEN}
    
    ${product_body}=    Create Dictionary
    ...    nome=${PRODUCT_NAME}
    ...    preco=50
    ...    descricao=Outra descrição
    ...    quantidade=1
    ${headers}=    Create Dictionary    Authorization=${TOKEN}
    ${response}=    POST On Session    serve_rest    /produtos    json=${product_body}    headers=${headers}
    
    Validar Status Code    ${response}    400
    Validar Mensagem de Sucesso    ${response}    Já existe produto com esse nome

Cenario P-006 - Deve Falhar ao Atualizar com Nome Já Usado por Outro
    Fazer Login Válido
    Criar Produto Randomico    ${TOKEN}
    ${ProdutoA_ID}=    Set Variable    ${PRODUCT_ID}
    
    ${response_B}=    Criar Produto Randomico    ${TOKEN}
    
    ${update_body}=    Create Dictionary
    ...    nome=${PRODUCT_NAME}
    ...    preco=200
    ...    descricao=Tentativa de Duplicacao
    ...    quantidade=1
    ${headers}=    Create Dictionary    Authorization=${TOKEN}
    ${response_update}=    PUT On Session    serve_rest    /produtos/${ProdutoA_ID}    json=${update_body}    headers=${headers}
    
    Validar Status Code    ${response_update}    400
    Validar Mensagem de Sucesso    ${response_update}    Já existe produto com esse nome
    
    Run Keywords    Excluir Produto    ${ProdutoA_ID}
    ...    AND    Excluir Produto    ${PRODUCT_ID}