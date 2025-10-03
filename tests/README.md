# Projeto de Testes Automatizados - API ServeRest

Este projeto contém testes automatizados para a API ServeRest utilizando Robot Framework. Os testes cobrem funcionalidades de login, cadastro de usuários, gerenciamento de produtos, carrinho de compras e validações de segurança.

---

## 🚀 Tecnologias Utilizadas  

![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)
![Markdown](https://img.shields.io/badge/Markdown-000000?style=for-the-badge&logo=markdown&logoColor=white)
![Postman](https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white)
![Jira](https://img.shields.io/badge/Jira-0052CC?style=for-the-badge&logo=jira&logoColor=white)
![Confluence](https://img.shields.io/badge/Confluence-172B4D?style=for-the-badge&logo=confluence&logoColor=white)
![TestRail](https://img.shields.io/badge/TestRail-0A0A0A?style=for-the-badge&logo=testrail&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Robot Framework](https://img.shields.io/badge/RobotFramework-000000?style=for-the-badge&logo=robot-framework&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=orange)

---


## Pré-requisitos

- Python 3.8 ou superior
- pip (gerenciador de pacotes do Python)

## Instalação

1. **Clone ou baixe o projeto**
   ```bash
   git clone <url-do-repositorio>
   cd testes
   ```

2. **Instale as dependências**
   ```bash
   pip install -r requirements.txt
   ```

## Estrutura do Projeto

```
testes/
├── tests/
│   ├── resources/           # Recursos compartilhados
│   │   ├── api_keywords.robot      # Keywords para operações de API
│   │   ├── cart_keywords.robot     # Keywords para carrinho
│   │   ├── login_keywords.robot    # Keywords para login
│   │   ├── product_keywords.robot  # Keywords para produtos
│   │   ├── user_keywords.robot     # Keywords para usuários
│   │   └── variables.robot         # Variáveis globais
│   └── suites/             # Suítes de teste
│       ├── login_tests.robot              # Testes de login
│       ├── mainly_flow.robot              # Fluxo principal E2E
│       ├── product_validation_tests.robot # Validações de produtos
│       ├── security_and_integrity.robot  # Testes de segurança
│       └── user_validation_tests.robot   # Validações de usuários
├── requirements.txt        # Dependências do projeto
└── README.md              # Este arquivo
```

## Suítes de Teste

### 1. Login Tests (`login_tests.robot`)
- **L-001**: Login válido e captura de token
- **L-002**: Falha com email não cadastrado
- **L-003**: Falha com senha incorreta

### 2. User Validation Tests (`user_validation_tests.robot`)
- **U-001**: Cadastro de usuário com email único
- **U-002**: Validação de senha com 4 caracteres
- **U-003**: Cadastro com senha de 5 caracteres
- **U-004**: Validação de senha com 11 caracteres
- **U-005**: Cadastro com senha de 10 caracteres
- **U-006**: Validação de email do Gmail
- **U-007**: Validação de email do Hotmail
- **U-008**: Falha ao usar email já existente
- **U-009**: Exclusão de usuário
- **U-010**: Busca de usuário por ID

### 3. Product Validation Tests (`product_validation_tests.robot`)
- **P-001**: Cadastro de produto com sucesso
- **P-002**: Falha ao usar nome de produto já existente
- **P-003**: Falha ao atualizar com nome já usado por outro
- **P-004**: Exclusão de produto
- **P-005**: Busca de produto existente

### 4. Security and Integrity (`security_and_integrity.robot`)
- **S-001**: Negação de POST /produtos sem token
- **S-002**: Negação de PUT /produtos sem token
- **S-003**: Negação de POST /carrinhos sem token
- **S-004**: Bloqueio de exclusão de usuário com carrinho ativo
- **S-005**: Bloqueio de exclusão de produto com carrinho ativo

### 5. Main Flow (`mainly_flow.robot`)
- **E2E-001**: Fluxo completo de compra (cadastro produto → carrinho → conclusão)

## Executando os Testes

### Executar todos os testes
```bash
robot tests/
```

### Executar uma suíte específica
```bash
robot tests/suites/login_tests.robot
robot tests/suites/user_validation_tests.robot
robot tests/suites/product_validation_tests.robot
robot tests/suites/security_and_integrity.robot
robot tests/suites/mainly_flow.robot
```

### Executar um teste específico
```bash
robot -t "Cenario L-001*" tests/suites/login_tests.robot
robot -t "Cenario U-001*" tests/suites/user_validation_tests.robot
```

### Executar com diferentes níveis de log
```bash
robot -L DEBUG tests/suites/login_tests.robot    # Log detalhado
robot -L INFO tests/suites/login_tests.robot     # Log padrão
```

### Executar múltiplos testes específicos
```bash
robot -t "Cenario L-001*" -t "Cenario L-002*" tests/suites/login_tests.robot
```

## Relatórios

Após a execução, os seguintes arquivos são gerados:
- `output.xml`: Dados de execução em XML
- `log.html`: Log detalhado da execução
- `report.html`: Relatório resumido dos resultados

## Configurações

### Variáveis Principais (`tests/resources/variables.robot`)
- `${BASE_URL}`: URL base da API ServeRest (https://serverest.dev)
- `${SENHA_VALIDA}`: Senha padrão para testes (12345)
- `${SENHA_INVALIDA_4}`: Senha com 4 caracteres (1234)
- `${SENHA_INVALIDA_11}`: Senha com 11 caracteres (12345678901)
- `${SENHA_VALIDA_10}`: Senha com 10 caracteres (1234567890)

### Headers HTTP
- `&{HEADER_DEFAULT}`: Content-Type=application/json

## Keywords Principais

### API Keywords
- `Criar Sessao Com URL Base`: Cria sessão HTTP
- `Validar Status Code`: Valida código de resposta
- `Validar Mensagem Da Resposta`: Valida mensagem específica
- `Obter ID Da Resposta`: Extrai ID da resposta

### Login Keywords
- `Gerar Usuario Aleatorio`: Gera dados de usuário aleatórios
- `Cadastrar Usuario Novo Com Sucesso`: Cadastra usuário e retorna dados
- `Fazer Login E Retornar Token`: Realiza login e retorna token
- `Setup Login Suite`: Configura usuário e token para a suíte

### Product Keywords
- `Gerar Produto Aleatorio`: Gera dados de produto aleatórios
- `Cadastrar Produto Valido E Retornar ID`: Cadastra produto e retorna ID
- `Deletar Produto Pelo ID`: Remove produto por ID

### Cart Keywords
- `Criar Carrinho Com Produto`: Cria carrinho com produto específico
- `Cancelar Compra`: Cancela compra ativa
- `Concluir Compra`: Finaliza compra
- `Cancelar Compra Se Existir`: Cancela compra sem falhar se não existir

### User Keywords
- `Deletar Usuario Pelo ID`: Remove usuário por ID
- `Buscar Usuario Por ID E Validar`: Busca e valida dados do usuário
- `Gerar Email Restrito Dinamico`: Gera email com domínio específico

## Notas Importantes

1. **API ServeRest**: Os testes são executados contra a API pública https://serverest.dev
2. **Dados Dinâmicos**: Todos os testes usam dados gerados dinamicamente para evitar conflitos
3. **Limpeza**: Os testes fazem limpeza automática dos dados criados
4. **Tokens**: Tokens de autenticação são gerenciados automaticamente
5. **Validações**: A API ServeRest não implementa todas as validações esperadas (ex: tamanho de senha, domínios restritos)

## Validações Implementadas pela API

**Funcionam**:
- Validação de email único
- Validação de nome de produto único
- Autenticação por token
- Integridade referencial (usuário/produto com carrinho)

**Não implementadas pela API**:
- Validação de tamanho mínimo/máximo de senha
- Restrição de domínios de email (Gmail, Hotmail)
- Mensagens de erro personalizadas

## Suporte

Para dúvidas ou problemas:
1. Verifique os logs em `log.html`
2. Consulte a documentação do Robot Framework
3. Verifique a documentação da API ServeRest em https://serverest.dev

---

## Autora  

**Andressa Von Ahnt**  

🔗 [LinkedIn](https://www.linkedin.com/in/andressa-von-ahnt-831556363) | 📧 andressavahnt@gmail.com  

---
