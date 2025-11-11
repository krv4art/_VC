// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Identificador de Peces';

  @override
  String get appTagline => 'Reconocimiento de Peces con IA';

  @override
  String get tabCamera => 'Cámara';

  @override
  String get tabHistory => 'Historial';

  @override
  String get tabCollection => 'Colección';

  @override
  String get tabChat => 'Chat';

  @override
  String get tabSettings => 'Ajustes';

  @override
  String get cameraTitle => 'Identificar Pez';

  @override
  String get cameraHint => 'Toma una foto o selecciona de la galería';

  @override
  String get takePhoto => 'Tomar Foto';

  @override
  String get selectFromGallery => 'Seleccionar de Galería';

  @override
  String get identifyingFish => 'Identificando pez...';

  @override
  String get fishName => 'Nombre del Pez';

  @override
  String get scientificName => 'Nombre Científico';

  @override
  String get habitat => 'Hábitat';

  @override
  String get diet => 'Dieta';

  @override
  String get funFacts => 'Datos Curiosos';

  @override
  String get confidence => 'Confianza';

  @override
  String get edibility => 'Comestibilidad';

  @override
  String get cookingTips => 'Consejos de Cocina';

  @override
  String get fishingTips => 'Consejos de Pesca';

  @override
  String get conservationStatus => 'Estado de Conservación';

  @override
  String get edible => 'Comestible';

  @override
  String get notRecommended => 'No Recomendado';

  @override
  String get toxic => 'Tóxico';

  @override
  String get addToCollection => 'Añadir a Colección';

  @override
  String get chatAboutFish => 'Preguntar sobre este pez';

  @override
  String get shareResult => 'Compartir Resultado';

  @override
  String get deleteResult => 'Eliminar';

  @override
  String get collectionTitle => 'Mi Colección';

  @override
  String get collectionEmpty => 'Aún no hay peces en tu colección';

  @override
  String get collectionHint => '¡Comienza a identificar peces para crear tu colección!';

  @override
  String get totalCatches => 'Capturas Totales';

  @override
  String get favoriteFish => 'Peces Favoritos';

  @override
  String get addNotes => 'Añadir Notas';

  @override
  String get catchDetails => 'Detalles de Captura';

  @override
  String get location => 'Ubicación';

  @override
  String get date => 'Fecha';

  @override
  String get weight => 'Peso';

  @override
  String get length => 'Longitud';

  @override
  String get baitUsed => 'Cebo Usado';

  @override
  String get weatherConditions => 'Clima';

  @override
  String get chatTitle => 'Asistente IA de Pesca';

  @override
  String get chatHint => '¡Pregúntame sobre peces, pesca o cocina!';

  @override
  String get chatPlaceholder => 'Escribe tu pregunta...';

  @override
  String get chatSend => 'Enviar';

  @override
  String get chatSampleQuestions => 'Preguntas de Ejemplo';

  @override
  String get chatClear => 'Limpiar Chat';

  @override
  String get historyTitle => 'Historial de Identificaciones';

  @override
  String get historyEmpty => 'Sin identificaciones aún';

  @override
  String get historyHint => 'Tus peces identificados aparecerán aquí';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeOcean => 'Azul Oceánico';

  @override
  String get settingsThemeDeep => 'Mar Profundo';

  @override
  String get settingsThemeTropical => 'Aguas Tropicales';

  @override
  String get settingsThemeKhaki => 'Camuflaje Caqui';

  @override
  String get settingsDarkMode => 'Modo Oscuro';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get settingsClearData => 'Borrar Todos los Datos';

  @override
  String get settingsRate => 'Calificar App';

  @override
  String get settingsShare => 'Compartir App';

  @override
  String get settingsFeedback => 'Enviar Comentarios';

  @override
  String get confirmClearData => '¿Borrar todos los datos?';

  @override
  String get confirmClearDataMessage => 'Esto eliminará todas las identificaciones, elementos de colección e historial de chat. Esta acción no se puede deshacer.';

  @override
  String get confirm => 'Confirmar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get errorTitle => 'Error';

  @override
  String get errorNetwork => 'Error de red. Verifica tu conexión.';

  @override
  String get errorServiceOverloaded => 'El servicio está temporalmente sobrecargado. Inténtalo en un momento.';

  @override
  String get errorRateLimit => 'Demasiadas solicitudes. Espera un momento.';

  @override
  String get errorInvalidResponse => 'No se pudo procesar la respuesta. Inténtalo de nuevo.';

  @override
  String get errorNotFish => 'Esto no parece ser un pez. Prueba con otra imagen.';

  @override
  String get errorGeneral => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get retry => 'Reintentar';

  @override
  String get close => 'Cerrar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get done => 'Hecho';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get feedback => 'Comentarios';

  @override
  String catchNumber(Object number) {
    return 'Captura #$number';
  }

  @override
  String get shareComingSoon => '¡Función de compartir próximamente!';

  @override
  String get dataCleared => 'Datos borrados exitosamente';

  @override
  String get openingAppStore => 'Abriendo tienda de aplicaciones...';

  @override
  String get ratingTitle => '¿Disfrutando Fish Identifier?';

  @override
  String get ratingMessage => '¡Tu opinión nos ayuda a mejorar la app!';

  @override
  String get rateNow => 'Calificar Ahora';

  @override
  String get maybeLater => 'Quizás Después';

  @override
  String get noThanks => 'No, Gracias';

  @override
  String get surveyTitle => '¡Ayúdanos a mejorar!';

  @override
  String get surveyQuestion => '¿Qué función te gustaría ver próximamente?';

  @override
  String get surveyOption1 => 'Feed social para compartir capturas';

  @override
  String get surveyOption2 => 'Recomendaciones de lugares de pesca';

  @override
  String get surveyOption3 => 'Predicciones basadas en el clima';

  @override
  String get surveyOption4 => 'Base de datos de recetas';

  @override
  String get surveySubmit => 'Enviar';

  @override
  String get surveyThankYou => '¡Gracias por tu opinión!';

  @override
  String get premiumTitle => 'Actualizar a Premium';

  @override
  String get premiumFeature1 => 'Identificaciones ilimitadas';

  @override
  String get premiumFeature2 => 'Chat IA ilimitado';

  @override
  String get premiumFeature3 => 'Seguimiento de ubicación GPS';

  @override
  String get premiumFeature4 => 'Estadísticas avanzadas';

  @override
  String get premiumFeature5 => 'Respaldo en la nube';

  @override
  String get premiumFeature6 => 'Experiencia sin anuncios';

  @override
  String get premiumPrice => '\$4.99/mes o \$29.99/año';

  @override
  String get premiumUpgrade => 'Actualizar Ahora';

  @override
  String get premiumRestore => 'Restaurar Compra';
}
