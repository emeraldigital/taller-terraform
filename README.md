# Terraform - Infraestructura como código

## Índice de contenido

- [1. ¿Qué es Terraform?](#1-qu-es-terraform)
- [2. Requisitos previos](#2-requisitos-previos)
- [3. Comandos básicos de Terraform](#3-comandos-bsicos-de-terraform)
- [4. Tipos de backend](#4-tipos-de-backend)
- [5. Tipos de variables](#5-tipos-de-variables)
- [6. Elementos de Terraform](#6-elementos-de-terraform)
- [7. Modulos](#7-modulos)

## 1. ¿Qué es Terraform?

Terraform es un software de infraestructura como código (infrastructure as code) desarrollado por HashiCorp.

Permite construir, cambiar y versionar infraestructura de forma segura y eficiente.

En esencia, nos permitirá llevar las buenas prácticas que ya se siguen para versionar el código fuente de las
aplicaciones a la infraestructura.

## 2. Requisitos previos

### Instalación de Terraform

Instrucciones de instalación: https://learn.hashicorp.com/tutorials/terraform/install-cli

### Google Cloud Setup

* Cuenta en GCP: https://cloud.google.com
* Google Cloud CLI: https://cloud.google.com/sdk/docs/install

Configurar las credenciales

```shell
gcloud init
```

Hacer las credenciales accesibles para Terraform

```shell
gcloud auth application-default login
```

### 3. Comandos básicos de Terraform

Para el ejemplo, debemos activar la API de Compute Engine

```shell
gcloud services enable compute.googleapis.com
```

* ``terraform init``: Se utiliza para inicializar un directorio de trabajo que contiene
  archivos de configuración de Terraform. Este es el primer comando que debe ejecutarse después de escribir una nueva
  configuración de Terraform o clonar una existente desde el control de versiones. Es seguro ejecutar este comando
  varias veces.

* ``terraform plan``. Crea un plan de ejecución, que le permite previsualizar los cambios que
  Terraform planea realizar en su infraestructura.

* ``terraform apply``. Ejecuta las acciones propuestas en un plan Terraform.

* ``terraform destroy``. Elimina todos los recursos creados con Terraform.

Cada comando ``apply`` o ``destroy`` lanzará un prompt para confirmar la operación, en caso de querer evitar este prompt
se puede agregar la bandera ``-auto-approve``.

### 4. Tipos de backend

* ``local backend``: Es el backend que Terraform usará por defecto si no se le especifica lo contrario. En este backend,
  los archivos de estado son almacenados en un directorio local de la máquina donde se ejecutan los comandos.
* ``cloud backend``: Podemos utilizar un proveedor remoto para almacenar los archivos de estado de Terraform, en este
  caso el mismo proveedor de nube. Para reconfigurar un backed debemos usar ``terraform init -reconfigure``
* ``terraform cloud``: HashiCorp ofrece un servicio para gestionar y orquestar la configuración de backend remoto por
  nosotros: https://cloud.hashicorp.com/products/terraform

### 5. Tipos de variables

* ``entrada``: Las variables de entrada nos permiten ingresar valores a nuestra configuración.
* ``locales``: Las variables locales nos permiten asignar valores que planeamos reutilizar dentro de la configuración.
* ``salida``: Las variables de salida nos permiten imprimir por pantalla los valores asignados.

#### 5.1 Entrada

* Si no se especifica un valor por defecto entonces tendremos que especificarle un valor de la siguiente forma:

```shell
terraform apply -var PROJECT_ID=emeraldigital-terraform-demo -auto-aprove
```

#### 5.2 Salida

Existen casos donde nos interesa que una variable de salida no se muestre por la salida estándar ``stdout`` (por ejemplo
en un flujo de CI/CD), en esos casos haremos uso del atributo ``sensitive = true``

#### 5.3 Tipos de datos

Los tipos de datos que se pueden asignar a las variables: https://www.terraform.io/language/expressions/types

### 6. Elementos de Terraform

#### 6.1 Strings

* String simple ``"Hello World"``
* Template string ``"Hello ${var.NAME}"``
* Heredoc's

```
<<-EOT
  Hello World
  This is a multi-line string
EOT
```

#### 6.2 Condicionales

**sintaxis:** ``condición ? verdadero : falso``

#### 6.3 Meta Argumentos

Argumentos especiales para controlar el comportamiento de los recursos y/o módulos

* ``depends_on``: Permite especificar la dependencia de un recurso con otro

* ``count``: Permite crear múltiples recursos usando un contador con índice. ``count.index`` hace referencia al índice
  actual recurso.

* ``for_each``: También permite crear múltiples recursos. ``each.key`` hace referencia al valor actual del recurso.

* Los meta-argumentos de ciclo de vida controlan cómo Terraform trata determinados recursos.
    * ``create_before_destroy = true`` indica que si el recurso necesita ser destruido, Terraform debe primero
      aprovisionar su reemplazo antes de destruir el recurso obsoleto, útil para cosas como los
      despliegues zero downtime.
    * ``ignore_changes`` Si un cambio se realiza fuera de Terraform, este modificará automáticamente el recurso
      revirtiéndolo al estado en el ``terraform.tfstate`. El argumento ignore_changes permite evitar que esto pase.
    * ``prevent_destroy`` proporciona una protección adicional contra la destrucción accidental de recursos con
      Terraform. Si se establece en **true**, Terraform rechazará cualquier intento de destruir ese recurso.

#### 7. Modulos

Un módulo es un contenedor para múltiples recursos que se utilizan conjuntamente. Los módulos pueden usarse para
crear abstracciones ligeras, de modo que puedas describir tu infraestructura en términos de su arquitectura, en lugar de
hacerlo directamente en términos de objetos físicos.

### 8. Entornos

Lista de espacios de trabajo

```shell
terraform workspace list
```

Crear un nuevo espacio de trabajo

```shell
terraform workspace new <workspace_name>
```

Seleccionar un espacio de trabajo

```shell
terraform workspace select <workspace_name>
```

Ejemplo

```shell
terraform apply -var PROJECT_ID=emeraldigital-terraform-demo -auto-approve

terraform workspace new dev
terraform apply -var PROJECT_ID=emeraldigital-terraform-demo -auto-approve
```