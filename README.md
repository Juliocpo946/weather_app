# Weather Simulator App

## Descripción General

Weather Simulator App es una aplicación visualmente rica y altamente interactiva, desarrollada con el framework Flutter. Su objetivo principal es ofrecer una simulación dinámica y estéticamente agradable de diversas condiciones climáticas y momentos del día. La aplicación combina animaciones fluidas, gestión de estado reactiva y una arquitectura modular para demostrar técnicas avanzadas de desarrollo en Flutter.

El proyecto consume datos de un servicio meteorológico externo para obtener información en tiempo real, la cual es traducida a una representación visual inmersiva. Los usuarios pueden observar desde un amanecer sereno hasta una noche con una tormenta torrencial, todo controlado a través de una interfaz de usuario limpia e intuitiva.

## Características Principales

* **Simulación Dinámica del Cielo**: Transiciones automáticas y suaves entre la mañana, el día, la tarde y la noche, cada una representada por gradientes de color atmosféricos únicos que cambian en tiempo real.
* **Condiciones Climáticas Variadas**: Capacidad para alternar instantáneamente entre un cielo despejado, nublado o condiciones de lluvia, afectando todos los elementos visuales de la escena.
* **Sistema de Partículas de Lluvia Realista**: Una animación de lluvia personalizable que simula diferentes intensidades (ligera, moderada, fuerte, torrencial). El sistema utiliza una simulación de profundidad para dar un efecto de perspectiva 3D.
* **Ciclo Día/Noche con Cuerpos Celestiales**: Animación continua de la órbita del sol y la luna, que se mueven por el cielo de acuerdo con un ciclo de 24 horas simulado.
* **Paisaje Vectorial**: Un fondo de montañas renderizado con `CustomPainter` para un rendimiento óptimo y una escalabilidad perfecta en cualquier resolución de pantalla.
* **Pronóstico del Tiempo Interactivo**: Muestra tarjetas con el pronóstico por hora y por día. Al seleccionar una tarjeta, la simulación principal se actualiza para reflejar las condiciones de ese pronóstico.
* **Controles de Simulación Manual**: Botones flotantes que permiten al usuario anular el estado actual y experimentar con diferentes combinaciones de hora del día, clima e intensidad de la lluvia.

## Arquitectura y Diseño Técnico

La aplicación está construida sobre una base sólida, siguiendo principios de diseño de software modernos para garantizar la mantenibilidad y escalabilidad.

* **Arquitectura MVVM (Model-View-ViewModel)**: La lógica de la interfaz de usuario está separada de la lógica de negocio.

    * **Model**: Representa los datos y el estado de la aplicación (ej. `WeatherState`, `RainLevel`).
    * **View**: Capa de UI puramente declarativa, compuesta por Widgets de Flutter que reaccionan a los cambios de estado (ej. `WeatherScreen`).
    * **ViewModel**: Orquesta la interacción entre la Vista y el Modelo, gestionando el estado y la lógica de negocio (`WeatherViewModel`).

* **Gestión de Estado con Provider**: Se utiliza el paquete `provider` para la inyección de dependencias y la propagación del estado a través del árbol de widgets. `ChangeNotifierProvider` inyecta el `WeatherViewModel`, y los widgets utilizan `context.watch` para escuchar los cambios de manera reactiva y `context.read` para invocar eventos.

* **Estructura de Proyecto por Features**: El código está organizado en módulos de funcionalidades (`features`), principalmente la funcionalidad `weather`. El directorio `core` contiene servicios compartidos, modelos de datos y utilidades utilizadas en toda la aplicación.

  ```
  lib/
  ├── core/
  │   ├── constants/
  │   ├── models/
  │   ├── services/
  │   └── utils/
  ├── features/
  │   └── weather/
  │       ├── model/
  │       ├── view/
  │       └── viewmodel/
  └── main.dart
  ```

* **Servicio de API Desacoplado**: La obtención de datos se realiza a través de una capa de servicio abstracta (`WeatherServiceInterface`), lo que permite que la implementación concreta (`ApiService`) pueda ser fácilmente sustituida para pruebas o cambios de API sin afectar el resto de la aplicación.

## Guía de Instalación y Ejecución

Para ejecutar este proyecto localmente, asegúrese de tener el SDK de Flutter instalado y configurado en su máquina.

1.  **Clonar el Repositorio**

    ```sh
    git clone https://github.com/juliocpo946/weather_app.git
    cd weather_app
    ```

2.  **Instalar Dependencias**
    Ejecute el siguiente comando para obtener todas las dependencias del proyecto listadas en `pubspec.yaml`.

    ```sh
    flutter pub get
    ```

3.  **Ejecutar la Aplicación**
    Conecte un dispositivo o inicie un emulador y ejecute el siguiente comando. La aplicación está configurada para ejecutarse en modo horizontal.

    ```sh
    flutter run
    ```

## Dependencias Clave

* **flutter**: Framework principal para el desarrollo de la UI.
* **provider**: Para la gestión de estado y la inyección de dependencias.
* **http**: Para realizar llamadas a la API REST del clima.
* **cupertino\_icons**: Para el uso de iconos de estilo iOS.