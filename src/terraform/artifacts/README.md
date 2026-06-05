# JAR Artifact

Este directorio está destinado a contener el archivo binario: `lambda.jar`

**Importante:**  

Este archivo **NO se versiona** en este repositorio y no debe subirse a Git.

---

## Origen del artefacto

El archivo `app.jar` se genera a partir del siguiente repositorio de código fuente:

> https://github.com/RaulJDlCRUZ/exact-number/tree/monolith-to-aws

---

## Cómo generar el JAR

Sigue estos pasos para construir el artefacto:

### 1. Clonar el repositorio de la aplicación

```bash
git clone https://github.com/RaulJDlCRUZ/exact-number.git
cd exact-number
git checkout -b monolith-to-aws
```

### 2. Construir el proyecto

```bash
mvn clean package
```

### 3. Generar el JAR para Lambda

```bash
mvn clean package -pl lambda -am
```

### 4. Copiar el artefacto

```bash
cp lambda/target/cyl-lambda-X.Y.Z-SNAPSHOT.jar /ruta/a/cloud-systems-services-aws-exact-number/src/terraform/artifacts/lambda.jar
```

## Notas importantes

Este repositorio contiene **únicamente** infraestructura (Terraform).

El .jar es un artefacto de build, no código fuente.

Mantener separación entre:

- Código → repositorio de aplicación
- Infraestructura → este repositorio