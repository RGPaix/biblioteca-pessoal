FROM eclipse-temurin:17-jdk-alpine AS build

WORKDIR /app

# Copiar arquivos do Maven
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Dar permissão de execução ao mvnw
RUN chmod +x ./mvnw

# Baixar dependências
RUN ./mvnw dependency:go-offline

# Copiar código fonte
COPY src ./src

# Compilar e gerar o JAR
RUN ./mvnw clean package -DskipTests

# Estágio 2: Runtime
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copiar o JAR do estágio de build
COPY --from=build /app/target/*.jar app.jar

# Expor a porta 8080
EXPOSE 8080

# Comando para executar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]