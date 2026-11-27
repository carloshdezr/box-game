# Prueba manual — Fase 2

Solo placeId **111090309292395**. La IA sincroniza el repo con Rojo; no hace falta correr comandos. Entrar con Play y esperar la carga y los 5 s iniciales de descanso.

1. Recorrer el gym: entrada, piso/paredes, espacio vacío marcado para ring y **2 Saco, 2 Caminadora, 2 Pesas, 2 Pera**. Acercarse y mantener **E** o tocar el ProximityPrompt. El puesto dice OCUPADA durante la ronda y LIBRE al salir.
2. **Saco:** pulsar Espacio o GOLPE cuando el marcador cruce el centro verde. **Pera:** lo mismo, más rápido; observar la racha de aciertos. Daños/golpes de combate no existen todavía.
3. **Caminadora:** mantener Espacio o el botón para subir la barra y soltar para bajar; mantenerla en verde. **Pesas:** mantener y soltar en verde; cada repetición acelera.
4. Cada ronda dura **20 s**. Comprobar los premios: Saco → Fuerza/Velocidad; Caminadora → Stamina; Pesas → Fuerza/Defensa; Pera → Velocidad/Defensa. Máximo **+4 por stat**, según resultado. Fallar todo no debe dar premio.
5. Esperar **5 s después del final** para otra ronda. Intentar cancelar y cambiar de estación: el descanso original se conserva. Alejarse, morir o salir debe liberar el puesto sin premio. Con dos jugadores, uno ocupa un puesto y el otro solo puede usar su copia libre; una persona no puede ocupar dos.
6. Probar teclado y celular real/toque; verificar que el botón permita mantener y soltar incluso si se levanta el dedo fuera del botón. El panel debe quedar legible y el HUD de stats volver al cerrar.
7. Tope Novato: si se desea probar rápido, la IA puede poner los stats asociados en 99 mediante StudioDebug. Completar una ronda: nunca superar 100 y ver **«Llegaste al máximo de tu rango, pelea para subir»**. Si ambos stats están al máximo, la estación no abre otra ronda. Restaurar a 1 los valores de prueba si se usó StudioDebug.
8. Salir y entrar para comprobar que el progreso se conserva. Anotar fecha, resultados y cualquier problema en ESTADO; solo el dueño cierra Fase 2.

## Comprobaciones rápidas realizadas por la IA

- 13 scripts sincronizados y remotos presentes; mapa con dos puestos de cada tipo.
- Saco abierto mediante E/ProximityPrompt. Los cuatro paneles abiertos y premios de los cuatro tipos verificados con resultados simulados desde StudioDebug **después de los 20 s reales**, sin saltarse duración ni descanso. No equivale a completar los cuatro minijuegos a mano.
- Saco: +4 Fuerza/Velocidad; Caminadora: +4 Stamina; Pesas: +4 Fuerza/Defensa; Pera: 99→100 en Velocidad/Defensa incluso con resultado 999, y aviso de máximo correcto.
- Espacio mueve la barra de Caminadora; mantener/soltar puntuó una repetición de Pesas. Panel y botón inspeccionados en iPhone 17 Pro emulado; cancelar conservó el descanso. Pendiente recorrido completo con toque real y dos jugadores.
- Pruebas locales con servicios simulados: ocupación, duración, NaN/infinito/tipos inválidos, resultado limitado, duplicados, descanso, cancelación, distancia, error de datos, timeout y salida. Comando mantenido: `node tools/check-data.cjs <ruta-al-modulo-fengari>`.
- Todos los stats de prueba restaurados a 1. No se guardó/publicó el lugar. Error de asset 203785492 identificado como sonido de notificación de Rojo, sin modificar el plugin.
