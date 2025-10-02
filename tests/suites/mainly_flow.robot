*** Settings ***
Resource    ../resources/login_keywords.robot
Resource    ../resources/product_keywords.robot
Resource    ../resources/cart_keywords.robot
Resource    ../resources/user_keywords.robot
Suite Setup    Setup Login Suite

*** Test Cases ***
Cenario E2E-001 - Deve Criar e Concluir uma Compra com Sucesso (P2 - Fluxo Crítico)
    ${id_produto}    ${nome_produto}=    Cadastrar Produto Valido E Retornar ID    ${TOKEN}
    ${id_carrinho}=    Criar Carrinho Com Produto    ${TOKEN}    ${id_produto}
    Concluir Compra    ${TOKEN}

    Deletar Produto Pelo ID    ${id_produto}    ${TOKEN}
    Deletar Usuario Pelo ID    ${ID_USUARIO_SETUP}

    ${email}    ${senha}    ${id_usuario}=    Cadastrar Usuario Novo Com Sucesso
    Fazer Login E Retornar Token    ${email}    ${senha}
    Set Suite Variable    ${ID_USUARIO_SETUP}    ${id_usuario}