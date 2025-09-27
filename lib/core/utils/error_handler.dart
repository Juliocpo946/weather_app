import 'dart:io';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (error is SocketException) {
      return 'Sin conexión a internet';
    } else if (errorString.contains('timeoutexception')) {
      return 'Tiempo de espera agotado';
    } else if (errorString.contains('404')) {
      return 'Localidad no encontrada';
    } else if (errorString.contains('502')) {
      return 'Servidor temporalmente no disponible';
    } else if (errorString.contains('500') || errorString.contains('503')) {
      return 'Error del servidor, intente más tarde';
    } else if (errorString.contains('network error')) {
      return 'Error de red, verifique su conexión';
    } else {
      return 'Error de conexión';
    }
  }
}