# 🚀 Requalify - Plataforma de Requalificação Profissional

![Java](https://img.shields.io/badge/Java-17-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.7-brightgreen)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-latest-blue)
![RabbitMQ](https://img.shields.io/badge/RabbitMQ-4.0-orange)
![OpenAI](https://img.shields.io/badge/OpenAI-GPT--4o--mini-412991)

## 📋 Sobre o Projeto

**Requalify** é uma plataforma inteligente de requalificação profissional que utiliza Inteligência Artificial para criar roadmaps de carreira personalizados. O sistema analisa o currículo do usuário e gera um plano de estudos sob medida com cursos, checkpoints e recursos educacionais relevantes para alcançar a profissão desejada.

### 🎯 Principais Funcionalidades

- **Gestão de Usuários**: Cadastro, autenticação JWT e gerenciamento de perfil
- **Currículos Inteligentes**: Criação e gerenciamento de currículos com experiências, formações e certificações
- **Roadmaps com IA**: Geração automática de planos de carreira personalizados usando GPT-4
- **Checkpoints**: Organização do aprendizado em etapas estruturadas
- **Catálogo de Cursos**: Sugestões de cursos reais de plataformas como Udemy, Coursera, LinkedIn Learning
- **Sistema de Cache**: Performance otimizada com Spring Cache
- **Processamento Assíncrono**: Fila de mensagens com RabbitMQ
- **Documentação Interativa**: API documentada com Swagger/OpenAPI

---

## 🎬 Demonstrações

### 🖥️ Vídeo Demonstração
> Demonstração completa das funcionalidades do sistema (10 min)

🔗 **[Assistir Demonstração no YouTube](https://youtube.com/seu-video-demo)**

---

## 🔗 Links de Deploy

### 🌐 Aplicação Backend (API)
- **URL**: `https://requalify.azurewebsites.net`
- **Swagger UI**: `https://requalify.azurewebsites.net/swagger-ui.html`
- **Health Check**: `https://requalify.azurewebsites.net/actuator/health`

### 💾 Banco de Dados
- **Host**: `seu-db-host.postgres.database.azure.com`
- **Porta**: `5432`
- **Database**: `requalify`
- **Usuário**: `requalify_admin`
- **Senha**: `[Fornecida separadamente]`

### 🔑 Credenciais de Teste

#### Usuário Demo
```json
{
  "username": "demo@requalify.com",
  "password": "demo123"
}
```

#### API Key OpenAI
> A chave da OpenAI está configurada nas variáveis de ambiente do servidor
- **Modelo**: `gpt-4o-mini`
- **Temperature**: `0.7`

---

## 🏗️ Arquitetura do Sistema
```
┌─────────────────┐
│   Cliente Web   │
└────────┬────────┘
         │ HTTPS/REST
         ▼
┌─────────────────┐      ┌──────────────┐
│  Spring Boot    │◄────►│  PostgreSQL  │
│     API         │      └──────────────┘
└────────┬────────┘
         │                ┌──────────────┐
         ├───────────────►│   RabbitMQ   │
         │                └──────────────┘
         │
         │                ┌──────────────┐
         └───────────────►│  OpenAI API  │
                          └──────────────┘
```

### 🛠️ Tecnologias Utilizadas

#### Backend
- **Java 17** - Linguagem principal
- **Spring Boot 3.5.7** - Framework base
- **Spring Security** - Autenticação e autorização
- **Spring Data JPA** - Persistência de dados
- **Spring AI** - Integração com OpenAI
- **Spring AMQP** - Mensageria com RabbitMQ
- **Spring Cache** - Sistema de cache

#### Banco de Dados
- **PostgreSQL** - Banco de dados relacional
- **Flyway** - Versionamento de schema

#### Infraestrutura
- **RabbitMQ** - Sistema de filas
- **Docker Compose** - Orquestração de containers
- **Lombok** - Redução de boilerplate

#### Segurança
- **JWT (Auth0)** - Tokens de autenticação
- **BCrypt** - Criptografia de senhas

#### Documentação
- **Swagger/OpenAPI 3** - Documentação interativa da API

---

## 🚀 Comandos Azure CLI
## 🔹 1. Criar Resource Group

```bash
az group create \
  --name rg-dev \
  --location canadacentral
```
## 🔹 2. Criar PostgreSQL Flexible Server

```bash
az postgres flexible-server create \
  --resource-group rg-dev \
  --name requalify-db \
  --location canadacentral \
  --version 17 \
  --tier Burstable \
  --sku-name Standard_B1ms \
  --storage-size 32 \
  --public-access 0.0.0.0 \
  --admin-user requalify \
  --admin-password "Password123$"
```
Regras de Firewall
```bash
az postgres flexible-server firewall-rule create \
  --resource-group rg-dev \
  --name requalify-db \
  --rule-name AllowAll \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 255.255.255.255

az postgres flexible-server firewall-rule create \
  --resource-group rg-dev \
  --name requalify-db \
  --rule-name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0
```
## 🔹 3. Registrar Providers Necessários

```bash
az provider register --namespace Microsoft.ContainerInstance
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.Web
az provider register --namespace Microsoft.DBforPostgreSQL
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.Storage
```
## 🔹 4. Criar Container RabbitMQ

```bash
az container create \
  --resource-group rg-dev \
  --name rabbitmq \
  --image rabbitmq:4.0-management \
  --cpu 1 \
  --memory 1 \
  --os-type Linux \
  --ports 5672 15672 \
  --dns-name-label rabbitmq-requalify-dev \
  --restart-policy Always \
  --environment-variables \
      RABBITMQ_DEFAULT_USER=guest \
      RABBITMQ_DEFAULT_PASS=guest
```
🔸 Obter IP do Container
```bash
az container show \
  --resource-group rg-dev \
  --name rabbitmq \
  --query ipAddress.ip \
  -o tsv
```

## 🔹 5. Criar App Service Plan

```bash
az appservice plan create \
  --name asp-requalify \
  --resource-group rg-dev \
  --location canadacentral \
  --sku B1 \
  --is-linux
```
## 🔹 6. Criar Web App

```bash
az webapp create \
  --resource-group rg-dev \
  --plan asp-requalify \
  --name requalify \
  --runtime "java:17-java17" \
  --deployment-container-image-name "" \
  --https-only false
```
---

## 📚 Endpoints Principais da API

### 🔐 Autenticação

#### Cadastrar Usuário
```http
POST /user
Content-Type: application/json

{
  "username": "usuario@email.com",
  "password": "senha123",
  "name": "Nome Completo"
}
```

#### Login
```http
POST /user/login
Content-Type: application/json

{
  "username": "usuario@email.com",
  "password": "senha123"
}
```

**Resposta:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "username": "usuario@email.com",
  "id": 1
}
```

### 📄 Currículos

#### Criar Currículo
```http
POST /resume/user/{userId}
Authorization: Bearer {token}
Content-Type: application/json

{
  "occupation": "Desenvolvedor Java",
  "summary": "Desenvolvedor com 5 anos de experiência...",
  "skills": ["Java", "Spring Boot", "PostgreSQL"],
  "educations": [
    {
      "institution": "FIAP",
      "course": "Análise e Desenvolvimento de Sistemas",
      "educationLevel": "Graduação",
      "startDate": "2020-02-01",
      "endDate": "2023-12-15",
      "inProgress": false
    }
  ],
  "experiences": [
    {
      "company": "Tech Corp",
      "position": "Desenvolvedor Backend",
      "startDate": "2021-06-01",
      "currentJob": true,
      "description": "Desenvolvimento de APIs REST"
    }
  ],
  "certifications": [
    {
      "name": "AWS Certified Developer",
      "issuingOrganization": "Amazon Web Services"
    }
  ]
}
```

#### Buscar Currículo por Usuário
```http
GET /resume/user/{userId}
Authorization: Bearer {token}
```

### 🗺️ Roadmaps

#### Criar Roadmap com IA
```http
POST /roadmap/user/{userId}
Authorization: Bearer {token}
Content-Type: application/json

{
  "targetOccupation": "Arquiteto de Soluções Cloud",
  "description": "Quero fazer transição de desenvolvedor Java para arquiteto cloud com foco em AWS"
}
```

**Resposta:** A IA gera automaticamente checkpoints e cursos personalizados

#### Buscar Roadmaps do Usuário
```http
GET /roadmap/user/{userId}
Authorization: Bearer {token}
```

#### Buscar Roadmap por ID
```http
GET /roadmap/{id}
Authorization: Bearer {token}
```

---

## 🗄️ Modelo de Dados

### Diagrama ER Simplificado
```
┌──────────┐         ┌──────────┐         ┌──────────┐
│  USERS   │1      1 │  RESUME  │1      * │ ROADMAP  │
│──────────│─────────│──────────│─────────│──────────│
│ id       │         │ id       │         │ id       │
│ username │         │ user_id  │         │ user_id  │
│ password │         │ occupation│        │ target_  │
│ name     │         │ summary  │         │ occupation│
└──────────┘         └────┬─────┘         └────┬─────┘
                          │                    │
                          │1                  1│
                          │*                   │
                          │                    │*
                     ┌────┴─────┐         ┌────┴──────┐
                     │EDUCATION │         │CHECKPOINT │
                     │EXPERIENCE│         │───────────│
                     │CERTIFICATION       │ id        │
                     └──────────┘         │ title     │
                                          │ order     │
                                          └────┬──────┘
                                              1│
                                               │*
                                          ┌────┴─────┐
                                          │ COURSE   │
                                          │──────────│
                                          │ name     │
                                          │ platform │
                                          │ url      │
                                          └──────────┘
```

---

## 🧪 Testando a API

### Usando cURL
```bash
# 1. Cadastrar usuário
curl -X POST https://requalify.azurewebsites.net/user \
  -H "Content-Type: application/json" \
  -d '{
    "username": "teste@email.com",
    "password": "senha123",
    "name": "Usuário Teste"
  }'

# 2. Fazer login e obter token
TOKEN=$(curl -X POST https://requalify.azurewebsites.net/user/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "teste@email.com",
    "password": "senha123"
  }' | jq -r '.token')

# 3. Criar currículo
curl -X POST https://requalify.azurewebsites.net/resume/user/1 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "occupation": "Desenvolvedor Java",
    "summary": "Desenvolvedor com experiência em Spring Boot e microsserviços...",
    "skills": ["Java", "Spring Boot", "PostgreSQL"]
  }'

# 4. Gerar roadmap com IA
curl -X POST https://requalify.azurewebsites.net/roadmap/user/1 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "targetOccupation": "Arquiteto de Soluções",
    "description": "Transição para arquitetura de software"
  }'
```

### Usando Postman/Insomnia

1. Importe a coleção disponível em `/docs/postman-collection.json`
2. Configure a variável de ambiente `BASE_URL` como `https://requalify.azurewebsites.net`
3. Execute os requests na ordem: Cadastro → Login → Criar Currículo → Gerar Roadmap

---

## 🤖 Como Funciona a Geração de Roadmaps com IA

### Fluxo de Processamento
```
1. Usuário cria currículo
   ↓
2. Usuário solicita roadmap com profissão objetivo
   ↓
3. Sistema analisa currículo (skills, experiências, formações)
   ↓
4. Prompt Builder constrói prompt personalizado
   ↓
5. OpenAI GPT-4 gera roadmap com checkpoints e cursos
   ↓
6. Sistema refina resposta (3 iterações)
   ↓
7. JSON é deserializado e validado
   ↓
8. Roadmap é salvo no banco de dados
   ↓
9. Usuário recebe roadmap completo
```

### Exemplo de Resposta da IA
```json
{
  "targetOccupation": "Arquiteto de Soluções Cloud",
  "description": "Roadmap para transição de desenvolvedor para arquiteto cloud",
  "checkpoints": [
    {
      "title": "Fundamentos de Cloud Computing",
      "description": "Conceitos essenciais de computação em nuvem",
      "order": 1,
      "courses": [
        {
          "name": "AWS Cloud Practitioner Essentials",
          "platform": "AWS Training",
          "url": "https://aws.amazon.com/training/",
          "description": "Fundamentos da AWS",
          "durationHours": 6
        }
      ]
    }
  ]
}
```

---

## 🔒 Segurança

- **Autenticação JWT**: Todos os endpoints (exceto cadastro/login) requerem token
- **Senha Criptografada**: BCrypt com salt automático
- **CORS Configurado**: Proteção contra requisições de origens não autorizadas
- **CSRF Desabilitado**: API stateless com tokens JWT
- **Validação de Dados**: Bean Validation em todos os DTOs

---

## 📊 Monitoramento e Logs

### Logs da Aplicação

Os logs são categorizados por níveis:
- **INFO**: Operações normais (criação de roadmap, login, etc)
- **ERROR**: Erros de negócio ou técnicos
- **DEBUG**: Informações detalhadas (JSON da IA, etc)
```bash
# Ver logs em tempo real
docker-compose logs -f
```

### RabbitMQ Management

Acesse `http://rabbitmq-requalify-dev.canadacentral.azurecontainer.io:15672/` para monitorar:
- Filas ativas
- Mensagens processadas
- Taxa de consumo
- Conexões ativas

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Para contribuir:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

---

## 👥 Equipe

-  **Guilherme Alves Pedroso** - RM555357
-  **João Vitor Silva Nascimento** - RM554694
-  **Rafael Souza Bezerra** - RM557888

---

## 🙏 Agradecimentos

- FIAP - Formação em Análise e Desenvolvimento de Sistemas
- Todos os contribuidores do projeto

---

**⭐ Se este projeto foi útil, considere dar uma estrela no GitHub!**
