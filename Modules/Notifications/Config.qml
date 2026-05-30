// Configuración del Notification Daemon
// Este archivo contiene constantes y valores que puedes personalizar

pragma Singleton

import QtQuick

QtObject {
    id: config

    // === POSICIÓN Y TAMAÑO ===
    // Opciones de anclaje: top, bottom, left, right
    readonly property string anchorVertical: "top"     // top o bottom
    readonly property string anchorHorizontal: "right"  // left o right

    // Márgenes desde los bordes (en píxeles)
    readonly property int marginTop: 50
    readonly property int marginBottom: 20
    readonly property int marginLeft: 20
    readonly property int marginRight: 20

    // Ancho de las notificaciones (en píxeles)
    readonly property int notificationWidth: 350
    readonly property int notificationSpacing: 12

    // === TIMEOUTS (en milisegundos) ===
    readonly property int timeoutLow: 4000       // Urgencia baja
    readonly property int timeoutNormal: 5000    // Urgencia normal
    readonly property int timeoutCritical: 7000  // Urgencia crítica (0 = nunca)

    // === ANIMACIONES ===
    readonly property int slideDuration: 200     // Duración de slide out (ms)
    readonly property int hideDuration: 300      // Duración de hide (ms)

    // === CAPACIDADES ===
    // Qué características del servidor de notificaciones activar
    readonly property bool supportActions: true          // Botones de acción
    readonly property bool supportImages: true          // Imágenes embebidas
    readonly property bool supportMarkup: false         // Markup HTML
    readonly property bool supportHyperlinks: false     // Enlaces
    readonly property bool supportPersistence: false    // Persistencia

    // === ESTILOS ===
    // Radios de las esquinas
    readonly property int borderRadius: 8

    // Máximo de líneas para el título
    readonly property int maxSummaryLines: 2

    // Máximo de líneas para el cuerpo
    readonly property int maxBodyLines: 3

    // Tamaño máximo de imagen incrustada (px)
    readonly property int maxImageHeight: 150

    // === DEBUG ===
    readonly property bool debug: false  // Mostrar logs detallados
}
