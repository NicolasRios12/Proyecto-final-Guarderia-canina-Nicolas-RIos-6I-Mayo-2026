/// Cadenas de texto constantes usadas en la UI de Dog Club.
class AppStrings {
  AppStrings._();

  // Generales
  static const String appName = 'Dog Club';
  static const String appSubtitle = 'Guardería Canina';

  // Auth
  static const String login = 'Iniciar sesión';
  static const String register = 'Registrarse';
  static const String logout = 'Cerrar Sesión';
  static const String email = 'Correo electrónico';
  static const String password = 'Contraseña';
  static const String confirmPassword = 'Confirmar contraseña';
  static const String forgotPassword = '¿Olvidaste tu contraseña?';
  static const String noAccount = '¿No tienes cuenta?';
  static const String registerSuccess = '¡Registro exitoso! Inicia sesión.';

  // Campos de registro
  static const String nombre = 'Nombre';
  static const String apellido = 'Apellido';
  static const String telefono = 'Teléfono';
  static const String telefonoHint = '+52 656 123 4567';

  // Home
  static const String heroTitle = 'Cuidadores de mascotas de confianza cerca de ti';
  static const String heroSubtitle = 'Reserva espacios sin filas y paseos seguros para perros';
  static const String nuestrosServicios = 'Nuestros Servicios';
  static const String verOpciones = 'Ver opciones disponibles';

  // Servicios
  static const String hospedaje = 'Hospedaje';
  static const String guarderia = 'Guardería';
  static const String paseos = 'Paseos';
  static const String cuidadoresPopulares = 'Cuidadores Populares';
  static const String noCuidadores = 'No hay cuidadores disponibles';

  // Reservas
  static const String reservar = 'Reservar';
  static const String reservarAhora = 'Reservar ahora';
  static const String contactar = 'Contactar';
  static const String confirmarReserva = 'Confirmar reserva';
  static const String reservaConfirmada = '¡Reserva confirmada!';
  static const String reservaEnviada = 'Tu reserva ha sido enviada al cuidador';
  static const String reservaExitosa = '¡Reserva enviada exitosamente!';
  static const String irAlInicio = 'Ir al inicio';
  static const String verMisReservas = 'Ver mis reservas';
  static const String seleccionaParaContinuar = 'Selecciona fecha, hora y mascota para continuar';

  // Perfil
  static const String miPerfil = 'Mi Perfil';
  static const String editarPerfil = 'Editar Perfil';
  static const String miembroDesde = 'Miembro desde';

  // Mascotas
  static const String agregarMascota = 'Agregar Mascota';
  static const String mascotaAgregada = '¡Mascota agregada exitosamente!';
  static const String nombreMascota = 'Nombre de tu mascota';
  static const String raza = 'Raza';
  static const String edad = 'Edad';
  static const String edadHint = 'Ej: 2 años, 6 meses';
  static const String sexo = 'Sexo';
  static const String pesoKg = 'Peso (kg)';
  static const String tamanio = 'Tamaño';
  static const String notasMedicas = 'Notas médicas';

  // Chat
  static const String chats = 'Chats';
  static const String sinConversaciones = 'Sin conversaciones';
  static const String escribeMensaje = 'Escribe un mensaje...';

  // Cuidador
  static const String pendientes = 'Pendientes';
  static const String activasHoy = 'Activas Hoy';
  static const String gananciasMes = 'Ganancias';
  static const String aceptar = 'Aceptar';
  static const String rechazar = 'Rechazar';
  static const String reservaAceptada = '✓ Reserva aceptada';
  static const String solicitudRechazada = 'Solicitud rechazada';
  static const String rechazarSolicitud = 'Rechazar solicitud';
  static const String confirmarRechazo = '¿Estás seguro de rechazar esta solicitud?';
  static const String mascotasActivas = 'Mascotas Activas';

  // Admin
  static const String panelAdmin = 'Panel de Administración';
  static const String usuarios = 'Usuarios';
  static const String mascotas = 'Mascotas';
  static const String servicios = 'Servicios';
  static const String reservas = 'Reservas';
  static const String confirmarEliminacion = 'Confirmar eliminación';
  static const String mensajeEliminacion = '¿Estás seguro de eliminar este registro? Esta acción no se puede deshacer.';
  static const String cancelar = 'Cancelar';
  static const String eliminar = 'Eliminar';

  // Drawer
  static const String inicio = 'Inicio';
  static const String perfil = 'Perfil';

  // Errores
  static const String errorGeneral = 'Ha ocurrido un error. Intenta de nuevo.';
  static const String errorConexion = 'Error de conexión. Verifica tu internet.';
  static const String noSePuedeEliminar = 'No se puede eliminar: la mascota tiene reservas activas';
}
