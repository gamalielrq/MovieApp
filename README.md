# MovieApp
Prueba Tecnica iOS

📽️ MovieApp - Documentación General
📌 Descripción del Proyecto
MovieApp es una aplicación móvil desarrollada en Swift que permite a los usuarios explorar y gestionar información sobre películas. La aplicación consume datos desde The Movie Database (TMDB) API, permitiendo a los usuarios visualizar las películas más populares, mejor calificadas y recomendadas. También integra Firebase Firestore y Firebase Storage para la gestión de ubicaciones y almacenamiento de imágenes.

🎯 Funcionalidades Implementadas

Pantalla de Peliculas (HomeViewController)
Películas más populares, ⭐ Mejor calificadas, 🎯 Mejores recomendaciones.
Uso de SnapKit para la construcción de la UI con Auto Layout.
Interfaz limpia y secciones separadas para cada categoría de películas.
Consumo de API usando MovieService con URLSession y Combine.
MockDataLoader para pruebas offline con datos de ejemplo.

Pantalla de Perfil (ProfileViewController)
Visualización de datos del usuario (nombre, imagen de perfil y reseñas).
Edición de perfil con opción para actualizar el nombre y la foto.
Captura o selección de foto desde la galería.
Persistencia en Core Data para almacenar los cambios en el perfil.
Visualización de reseñas con imágenes y texto, cargadas desde MockDataLoader.

Pantalla de Mapas (MapViewController)
Consumo de Firebase Firestore para obtener ubicaciones almacenadas.
Mostrar las ubicaciones en un mapa con MapKit.
Mostrar la fecha de almacenamiento de cada ubicación.
Guardar la ubicación del usuario cada 5 minutos en Firebase Firestore.
Notificación local con NotificationCenter al registrar una nueva ubicación.

Pantalla de Carga de Imágenes (UploadViewController)
Captura o selección de imágenes desde la galería.
Subida de imágenes a Firebase Storage con progreso de carga.
Opción para eliminar la imagen antes de subirla.
Alertas de error y éxito al subir imágenes.

🛠️ Tecnologías Utilizadas
📱 Lenguaje: Swift
🎨 Interfaz de usuario: UIKit + SnapKit
🔗 Consumo de API: URLSession + Combine
🔄 Persistencia de datos: Core Data
☁️ Servicios en la nube: Firebase Firestore & Firebase Storage
🌍 Mapas y Ubicaciones: MapKit + CoreLocation
📷 Manejo de imágenes: UIImagePickerController & PHPickerViewController
🔔 Notificaciones: NotificationCenter


📈 Puntos de Mejora para un Próximo Alcance
Mejoras en UI/UX
Modo oscuro para una mejor experiencia de usuario.
Soporte para iPads con layouts responsivos.
Detalle de películas con trailers y descripción ampliada.
Mejoras en el Perfil del Usuario
Sistema de favoritos para guardar películas favoritas.
Sincronización de perfil con Firebase Authentication.
Panel de estadísticas con películas vistas y tiempo de uso.
Mejoras en el Módulo de Mapas
Ubicación en tiempo real con WebSockets.
Historial de ubicaciones del usuario con filtros por fecha.
Notificación Push cuando el usuario llega a una ubicación guardada.
Mejoras en la Carga de Imágenes
Subida de múltiples imágenes a Firebase Storage.
Editor de imágenes integrado (recorte, filtro, ajuste de brillo).
Vista previa de imágenes antes de subirlas.
Optimización y Seguridad
Mejor manejo de errores en las peticiones a Firebase.
Optimización de caché para mejorar la velocidad de carga.
Migración a SwiftData para una mejor persistencia de datos.


📌 Conclusión
MovieApp ha sido desarrollada con un enfoque modular y escalable, permitiendo futuras mejoras y nuevas funcionalidades sin afectar la arquitectura actual. Con la integración de Firebase y TMDB, la app ya ofrece una experiencia completa de consumo de contenido, pero aún existen mejoras clave que pueden llevarla al siguiente nivel.

📌 Próximo paso: Implementar Firebase Authentication para que los usuarios puedan iniciar sesión y sincronizar su información entre dispositivos. 🚀🔥


Imágenes de la app 








