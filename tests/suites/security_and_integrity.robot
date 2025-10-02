*** Settings ***
Resource    ../resources/login_keywords.robot
Resource    ../resources/product_keywords.robot
Resource    ../resources/cart_keywords.robot
Resource    ../resources/user_keywords.robot
Suite Setup    Setup Login Suite

*** Test Cases ***
Cenario S-001 - Deve Negar POST /produtos Sem Token (P1 - Segurança)
    Criar Sessao Com URL Base    serveRest_sem_token    ${BASE_URL}
    ${nome}    ${preco}    ${descricao}    ${quantidade}=    Gerar Produto Aleatorio
    ${body}=    Create Dictionary    nome=${nome}    preco=${preco}    descricao=${descricao}    quantidade=${quantidade}
    ${response}=    POST On Session    serveRest_sem_token    /produtos    json=${body}    expected_status=401
    Validar Status Code    ${response}    401
    Validar Mensagem Da Resposta    ${response}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais


Cenario S-002 - Deve Negar PUT /produtos Sem Token (P1 - Segurança)
    ${id_produto}    ${nome_produto}=    Cadastrar Produto Valido E Retornar ID    ${TOKEN}
    Criar Sessao Com URL Base    serveRest_sem_token    ${BASE_URL}
    ${body}=    Create Dictionary    nome=Novo Nome    preco=10    descricao=Nova Descricao    quantidade=1
    ${response}=    PUT On Session    serveRest_sem_token    /produtos/${id_produto}    json=${body}    expected_status=401
    Validar Status Code    ${response}    401
    Validar Mensagem Da Resposta    ${response}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

    Deletar Produto Pelo ID    ${id_produto}    ${TOKEN}

Cenario S-003 - Deve Negar POST /carrinhos Sem Token (P1 - Segurança)
    ${id_produto}    ${nome_produto}=    Cadastrar Produto Valido E Retornar ID    ${TOKEN}
    Criar Sessao Com URL Base    serveRest_sem_token    ${BASE_URL}
    ${produto_dict}=    Create Dictionary    idProduto=${id_produto}    quantidade=1
    ${produtos_list}=    Create List    ${produto_dict}
    ${body}=    Create Dictionary    produtos=${produtos_list}
    ${response}=    POST On Session    serveRest_sem_token    /carrinhos    json=${body}    expected_status=401
    Validar Status Code    ${response}    401
    Validar Mensagem Da Resposta    ${response}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

    Deletar Produto Pelo ID    ${id_produto}    ${TOKEN}

Cenario S-004 - Deve Bloquear Exclusão de Usuario com Carrinho Ativo (P2 - Integridade)
    # Cancelar carrinho anterior se existir
    Cancelar Compra Se Existir    ${TOKEN}
    ${id_produto}    ${nome_produto}=    Cadastrar Produto Valido E Retornar ID    ${TOKEN}
    Criar Carrinho Com Produto    ${TOKEN}    ${id_produto}

    ${headers}=    Create Dictionary    Authorization=${TOKEN}
    ${response}=    DELETE On Session    serveRest    /usuarios/${ID_USUARIO_SETUP}    headers=${headers}    expected_status=400
    Validar Status Code    ${response}    400
    Validar Que Mensagem Contem Texto    ${response}    Não é permitido excluir usuário com carrinho

Cenario S-005 - Deve Bloquear Exclusão de Produto com Carrinho Ativo (P2 - Integridade)
    # Cancelar carrinho anterior se existir
    Cancelar Compra Se Existir    ${TOKEN}
    ${id_produto}    ${nome_produto}=    Cadastrar Produto Valido E Retornar ID    ${TOKEN}
    Criar Carrinho Com Produto    ${TOKEN}    ${id_produto}

    ${headers}=    Create Dictionary    Authorization=${TOKEN}
    ${response}=    DELETE On Session    serveRest    /produtos/${id_produto}    headers=${headers}    expected_status=400
    Validar Status Code    ${response}    400
    Validar Que Mensagem Contem Texto    ${response}    Não é permitido excluir produto que faz parte de carrinho