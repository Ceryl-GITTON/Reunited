// Stub pour web - version vide du WidgetService
// Ce fichier sera utilisé sur web où les widgets ne sont pas supportés

class WidgetService {
  static Future<void> initialize() async {
    // Ne fait rien sur web
  }

  static void startAutoUpdate() {
    // Ne fait rien sur web
  }

  static Future<void> updateWidget() async {
    // Ne fait rien sur web
  }

  static void stopAutoUpdate() {
    // Ne fait rien sur web
  }

  static Future<bool> isWidgetSupported() async {
    return false; // Toujours false sur web
  }
}
