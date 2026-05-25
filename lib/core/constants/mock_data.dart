/// Datos mock para mostrar en la UI cuando no hay datos en Firestore.
class MockData {
  MockData._();

  /// Cuidadores de ejemplo para la lista de servicios.
  static const List<Map<String, dynamic>> caregivers = [
    {
      'nombre': 'Laura',
      'apellido': 'Mendoza',
      'foto_url': '',
      'rating': 4.8,
      'reviews': 23,
      'precio': 240.0,
      'unidad': 'noche',
      'ofrece': ['Casa con jardín', 'Fotos diarias', 'Paseos incluidos'],
    },
    {
      'nombre': 'Carlos',
      'apellido': 'Rivera',
      'foto_url': '',
      'rating': 4.6,
      'reviews': 15,
      'precio': 180.0,
      'unidad': 'día',
      'ofrece': ['Sin otras mascotas', 'Actualizaciones en tiempo real', 'Actividades'],
    },
    {
      'nombre': 'Ana',
      'apellido': 'Gutierrez',
      'foto_url': '',
      'rating': 4.9,
      'reviews': 31,
      'precio': 120.0,
      'unidad': 'hora',
      'ofrece': ['Rutas seguras', 'GPS tracking', 'Entrenamiento básico'],
    },
  ];

  /// Reseñas de ejemplo para la vista de perfil de cuidador.
  static const List<Map<String, dynamic>> mockReviews = [
    {
      'nombre': 'María López',
      'rating': 5.0,
      'comentario': 'Excelente cuidado, mi perro regresó feliz. Muy recomendado.',
      'fecha': 'hace 2 semanas',
    },
    {
      'nombre': 'Pedro Sánchez',
      'rating': 4.5,
      'comentario': 'Muy buen servicio, fotos constantes y mucho cariño.',
      'fecha': 'hace 1 mes',
    },
    {
      'nombre': 'Sofía Torres',
      'rating': 5.0,
      'comentario': 'Mi mascota adoró quedarse ahí. Casa amplia y limpia.',
      'fecha': 'hace 2 meses',
    },
  ];
}
