# EasyBroker Challenge – Ruby Client

Este proyecto implementa un cliente en Ruby para consumir la API de EasyBroker y listar todas las propiedades del ambiente de pruebas, imprimiendo únicamente sus títulos.  
Tambien incluye un ejemplo de prueba unitaria con RSpec.

El objetivo es demostrar diseño orientado a objetos, buenas prácticas y manejo correcto de paginación de la API.

---

##  Requisitos

Antes de ejecutar el proyecto, asegúrate de tener instalado:

- **Ruby 3.0+**  
  Puedes verificarlo con:
  ```bash
  ruby -v
  ```

- **Bundler**
  ```bash
  gem install bundler
  ```

- Dependencias:
  - `faraday`
  - `json`
  - `rspec`

---

## Instalación

1. Clona el repositorio o descarga los archivos:

   ```bash
   git clone https://github.com/DocMX/easybroker-api-challange
   cd EasyBrokerChallenge
   ```

2. Instala dependencias:

   **Si usas Bundler:**
   ```bash
   bundle install
   ```


---

---

## Cómo ejecutar el script

Una vez configurado tu API Key, ejecuta:

```bash
ruby bin/run.rb
```

El script imprimirá la lista de títulos de todas las propiedades, paginando automáticamente hasta terminar, o donde te deje.


---

##  Ejecutar pruebas unitarias

Este proyecto incluye una prueba con RSpec.

Ejecuta:

```bash
rspec
```

---



##  Notas

- El cliente detecta automáticamente la estructura del JSON de EasyBroker y extrae títulos sin importar si vienen en claves como `title`, `name`, `public_title` o `headline`.
- Maneja paginación hasta que no existan más propiedades.
- Incluye manejo básico de errores HTTP y JSON.

---

##  Postulante

Jorge Vega
