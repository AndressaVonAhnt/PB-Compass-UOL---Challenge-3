*** Settings ***
Resource    ../resources/login_keywords.robot
Resource    ../resources/product_keywords.robot
Resource    ../resources/user_keywords.robot
Suite Setup    Setup Login Suite

*** Test Cases ***
Cenario P-001 - Deve Cadastrar Produto com Sucesso (P2)
    ${id_produto}    ${nome_produto}=    Cadastrar Produto Valido E Retornar ID    ${TOKEN}

    Deletar Produto Pelo ID    ${id_produto}    ${TOKEN}

Cenario P-002 - Deve Falhar ao Usar Nome de Produto Já Existente (P2)
    ${id_produto_1}    ${nome_produto}=    Cadastrar Produto Valido E Retornar ID    ${TOKEN}

    ${nome_temp}    ${preco}    ${descricao}    ${quantidade}=    Gerar Produto Aleatorio
    ${body}=    Create Dictionary    nome=${nome_produto}    preco=${preco}    descricao=${descricao}    quantidade=${quantidade}
    ${headers}=    Create Dictionary    Authorization=${TOKEN}
    ${response}=    POST On Session    serveRest    /produtos    json=${body}    headers=${headers}    expected_status=400
    Validar Status Code    ${response}    400
    Validar Mensagem Da Resposta    ${response}    Já existe produto com esse nome

    Deletar Produto Pelo ID    ${id_produto_1}    ${TOKEN}

Cenario P-003 - Deve Falhar ao Atualizar com Nome Já Usado por Outro (P3)
    ${id_produto_A}    ${nome_produto_A}=    Cadastrar Produto Valido E Retornar ID    ${TOKEN}
    ${id_produto_B}    ${nome_produto_B}=    Cadastrar Produto Valido E Retornar ID    ${TOKEN}

    ${body}=    Create Dictionary    nome=${nome_produto_A}    preco=10    descricao=Nova Descricao    quantidade=1
    ${headers}=    Create Dictionary    Authorization=${TOKEN}
    ${response}=    PUT On Session    serveRest    /produtos/${id_produto_B}    json=${body}    headers=${headers}    expected_status=400
    Validar Status Code    ${response}    400
    Validar Mensagem Da Resposta    ${response}    Já existe produto com esse nome

    Deletar Produto Pelo ID    ${id_produto_A}    ${TOKEN}
    Deletar Produto Pelo ID    ${id_produto_B}    ${TOKEN}

Cenario P-OO4 - Deve poder excluir um produto (P3)
    ${id_produto}    ${nome_produto}=    Cadastrar Produto Valido E Retornar ID    ${TOKEN}
    ${headers}=    Create Dictionary    Authorization=${TOKEN}
    ${response}=    DELETE On Session    serveRest    /produtos/${id_produto}    headers=${headers}
    Validar Status Code    ${response}    200
    Validar Mensagem Da Resposta    ${response}    Registro excluído com sucesso

Cenario P-005 - Deve poder buscar por um produto existente e retornar as informações refentes corretas (P4)
    ${id_produto}    ${nome_produto}=    Cadastrar Produto Valido E Retornar ID    ${TOKEN}
    ${response}=    GET On Session    serveRest    /produtos/${id_produto}
    Validar Status Code    ${response}    200
    Should Be Equal As Strings    ${response.json()}[nome]    ${nome_produto}

    Deletar Produto Pelo ID    ${id_produto}    ${TOKEN}