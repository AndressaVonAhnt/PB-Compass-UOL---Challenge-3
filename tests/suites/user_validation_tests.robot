*** Settings ***
Resource    ../resources/login_keywords.robot
Resource    ../resources/user_keywords.robot
Resource    ../resources/variables.robot
Test Setup    Criar Sessao Com URL Base    serveRest    ${BASE_URL}

*** Test Cases ***
Cenario U-001 - Cadastrar Usuario com email não repetido (U-004 - P1)
    ${email}    ${senha}    ${id_usuario}=    Cadastrar Usuario Novo Com Sucesso
    Deletar Usuario Pelo ID    ${id_usuario}

Cenario U-002 - Deve Cadastrar Usuario com Senha de 4 Caracteres (P2)
    ${nome}    ${email}    ${senha}    ${administrador}=    Gerar Usuario Aleatorio
    ${body}=    Create Dictionary    nome=${nome}    email=${email}    password=${SENHA_INVALIDA_4}    administrador=true
    ${response}=    POST On Session    serveRest    /usuarios    json=${body}
    Validar Status Code    ${response}    201
    ${id_usuario}=    Obter ID Da Resposta    ${response}
    Deletar Usuario Pelo ID    ${id_usuario}

Cenario U-003 - Deve Cadastrar com Senha de 5 Caracteres (Borda Válida - P2)
    ${nome}    ${email}    ${senha}    ${administrador}=    Gerar Usuario Aleatorio
    ${body}=    Create Dictionary    nome=${nome}    email=${email}    password=${SENHA_VALIDA}    administrador=true
    ${response}=    POST On Session    serveRest    /usuarios    json=${body}
    Validar Status Code    ${response}    201
    ${id_usuario}=    Obter ID Da Resposta    ${response}
    Deletar Usuario Pelo ID    ${id_usuario}

Cenario U-004 - Deve Cadastrar Usuario com Senha de 11 Caracteres (P2)
    ${nome}    ${email}    ${senha}    ${administrador}=    Gerar Usuario Aleatorio
    ${body}=    Create Dictionary    nome=${nome}    email=${email}    password=${SENHA_INVALIDA_11}    administrador=true
    ${response}=    POST On Session    serveRest    /usuarios    json=${body}
    Validar Status Code    ${response}    201
    ${id_usuario}=    Obter ID Da Resposta    ${response}
    Deletar Usuario Pelo ID    ${id_usuario}

Cenario U-005 - Deve Cadastrar com Senha de 10 Caracteres (Borda Válida - P2)
    ${nome}    ${email}    ${senha}    ${administrador}=    Gerar Usuario Aleatorio
    ${body}=    Create Dictionary    nome=${nome}    email=${email}    password=${SENHA_VALIDA_10}    administrador=true
    ${response}=    POST On Session    serveRest    /usuarios    json=${body}
    Validar Status Code    ${response}    201
    ${id_usuario}=    Obter ID Da Resposta    ${response}
    Deletar Usuario Pelo ID    ${id_usuario}

Cenario U-006 - Deve Cadastrar Usuario com Email do Gmail (P2)
    ${email}=    Gerar Email Restrito Dinamico    @gmail.com
    ${nome}=    FakerLibrary.Name
    ${body}=    Create Dictionary    nome=${nome}    email=${email}    password=${SENHA_VALIDA}    administrador=true
    ${response}=    POST On Session    serveRest    /usuarios    json=${body}
    Validar Status Code    ${response}    201
    ${id_usuario}=    Obter ID Da Resposta    ${response}
    Deletar Usuario Pelo ID    ${id_usuario}

Cenario U-007 - Deve Cadastrar Usuario com Email do Hotmail (P2)
    ${email}=    Gerar Email Restrito Dinamico    @hotmail.com
    ${nome}=    FakerLibrary.Name
    ${body}=    Create Dictionary    nome=${nome}    email=${email}    password=${SENHA_VALIDA}    administrador=true
    ${response}=    POST On Session    serveRest    /usuarios    json=${body}
    Validar Status Code    ${response}    201
    ${id_usuario}=    Obter ID Da Resposta    ${response}
    Deletar Usuario Pelo ID    ${id_usuario}

Cenario U-008 - Deve Falhar ao Usar Email Já Existente (P2)
    ${email}    ${senha}    ${id_usuario}=    Cadastrar Usuario Novo Com Sucesso
    ${nome_2}=    FakerLibrary.Name
    ${body_2}=    Create Dictionary    nome=${nome_2}    email=${email}    password=${SENHA_VALIDA}    administrador=true
    ${response_2}=    POST On Session    serveRest    /usuarios    json=${body_2}    expected_status=400
    Validar Status Code    ${response_2}    400
    Validar Mensagem Da Resposta    ${response_2}    Este email já está sendo usado
    Deletar Usuario Pelo ID    ${id_usuario}

Cenario U-009 - Deve poder excluir um usuario corretamente (U-016 - P3)
    ${email}    ${senha}    ${id_usuario}=    Cadastrar Usuario Novo Com Sucesso
    ${response}=    DELETE On Session    serveRest    /usuarios/${id_usuario}
    Validar Status Code    ${response}    200
    Validar Mensagem Da Resposta    ${response}    Registro excluído com sucesso

Cenario U-010 - Deve buscar usuario existente e retornar as informações corretas (U-002 - P4)
    ${nome}    ${email}    ${senha}    ${administrador}=    Gerar Usuario Aleatorio
    ${body}=    Create Dictionary    nome=${nome}    email=${email}    password=${senha}    administrador=${administrador}
    ${response}=    POST On Session    serveRest    /usuarios    json=${body}
    ${id_usuario}=    Obter ID Da Resposta    ${response}
    Buscar Usuario Por ID E Validar    ${id_usuario}    ${nome}    ${email}
    Deletar Usuario Pelo ID    ${id_usuario}