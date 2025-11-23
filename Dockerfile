# Etapa 1: Build e Teste
FROM gradle:8.10-jdk17 AS builder
WORKDIR /app

# Copia os arquivos de build e dependências primeiro para cache
COPY build.gradle settings.gradle /app/

# Copia o código da aplicação
COPY src /app/src

# Roda os testes JUnit específicos antes do build
RUN gradle test

# Gera o .jar (só se os testes passarem)
RUN gradle clean build -x test

# Etapa 2: Runtime
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copia o .jar da etapa anterior
COPY --from=builder /app/build/libs/*.jar app.jar

# Expõe a porta padrão da aplicação
EXPOSE 8080

# Inicia a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]