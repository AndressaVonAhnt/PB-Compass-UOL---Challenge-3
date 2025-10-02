*** Settings ***
Resource    ./api_keywords.robot
Resource    ./variables.robot

*** Keywords ***
Criar Carrinho Com Produto
    [Arguments]    ${token}    ${id_produto}    ${quantidade_produto}=1
    ${produto_dict}=    Create Dictionary    idProduto=${id_produto}    quantidade=${quantidade_produto}
    ${produtos_list}=    Create List    ${produto_dict}
    ${body}=    Create Dictionary    produtos=${produtos_list}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    serveRest    /carrinhos    json=${body}    headers=${headers}
    Validar Status Code    ${response}    201
    Validar Mensagem Da Resposta    ${response}    Cadastro realizado com sucesso
    ${id_carrinho}=    Obter ID Da Resposta    ${response}
    [Return]    ${id_carrinho}

Cancelar Compra
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE On Session    serveRest    /carrinhos/cancelar-compra    headers=${headers}
    Validar Status Code    ${response}    200
    Validar Que Mensagem Contem Texto    ${response}    cancelada

Concluir Compra
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE On Session    serveRest    /carrinhos/concluir-compra    headers=${headers}
    Validar Status Code    ${response}    200
    Validar Que Mensagem Contem Texto    ${response}    excluído

Cancelar Compra Se Existir
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE On Session    serveRest    /carrinhos/cancelar-compra    headers=${headers}    expected_status=any
    # Não valida o status, pois pode ser 200 (sucesso) ou 400 (sem carrinho)