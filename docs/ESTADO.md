# Estado actual del proyecto

## Fase actual
Fase 1: datos y stats. Diseño aprobado en `docs/DISENO_JUEGO.md`.

## Checklist de fases
Cada fase tiene su criterio de "terminado". No se pasa a la siguiente sin prueba manual de la persona dueña anotada aquí.

- [x] **Fase 0: idea y diseño.** Criterio: `DISENO_JUEGO.md` completo. Hecho el 2026-11-26.
- [ ] **Fase 1: datos y stats.** Criterio: un jugador entra, ve sus 4 stats y su rango, y al salir y volver siguen igual.
- [ ] **Fase 2: gym y minijuegos.** Criterio: un mapa de gym estilo caricatura con las 4 estaciones; cada minijuego se puede jugar con teclado y con toque, y sube su stat según qué tan bien lo hiciste, sin pasar el tope del rango.
- [ ] **Fase 3: combate contra NPC.** Criterio: en el ring puedes pelear 3 rounds contra un NPC con jab, gancho, uppercut, bloquear y esquivar; las barras de vida y stamina funcionan y la pelea termina con un ganador.
- [ ] **Fase 4: rangos y rivales.** Criterio: ganar peleas da puntos de rango; al juntar los puntos subes de Novato a Amateur y luego a Semi-pro; cada rango tiene su rival NPC y su tope de stats.
- [ ] **Fase 5: PvP 1 contra 1.** Criterio: dos jugadores reales pueden retarse y pelear en el ring con las mismas reglas, y el ganador recibe puntos de rango si son de rangos parecidos.
- [ ] **Fase 6: interfaz y arte (ForgeGUI).** Criterio: HUD, minijuegos, barras de pelea y pantallas de rango con el estilo final, funcionando en PC y celular.
- [ ] **Fase 7: prepublicación.** Criterio: los NPC ya no dan puntos de rango (solo el ring de práctica, sin puntos), el rango se sube solo con PvP; validaciones anti-trampas en servidor; prueba con dos clientes reales y en celular; lista para publicar.

Después de publicar (fuera de la v1): torneos, más rangos, cosméticos, monedas y tienda.

## Último en trabajar
[codex] · 2026-11-26 17:12. Lugar identificado por ID y revisión MCP ejecutada; carga inicial correcta, SetStat desde MCP rechazado y HUD ausente. Fase 1 sigue abierta.

## Avance de Fase 1
- [x] DataStore con UpdateAsync, autoguardado cada 60 segundos, salida y cierre del servidor.
- [x] Bloqueo por sesión y rechazo de registros inválidos; carga fallida nunca guarda valores iniciales sobre datos existentes.
- [x] Candado ajeno vigente: conserva Cargando, reintenta cada 2 s hasta 30 s; pruebas locales de liberación, vencimiento, timeout sin escrituras y cancelación al salir/cerrar.
- [x] Fuerza, Velocidad, Stamina y Defensa iniciales en 1; topes Novato 100, Amateur 250, Semi-pro 500 (aprobados por el dueño el 2026-11-26).
- [x] Rango y puntos persistidos; atributos del jugador publicados por el servidor.
- [x] HUD simple con tema central y aviso «Tu progreso no se está guardando».
- [x] Validación rápida local con DataStore simulado y mapeo Rojo, sin crear archivos de lugar.
- [x] 2026-11-26 17:12: Play mediante MCP en placeId `111090309292395`; atributos servidor y cliente: cuatro stats en 1, Novato, PuntosRango 0, EstadoDatos Listo.
- [ ] Revisión MCP de persistencia/tope: bloqueada por SetStat devolviendo false; ver resultado abajo.
- [ ] Prueba manual del dueño: persistencia real, salida/cierre, fallo de carga y HUD en PC/celular. Guía: `docs/PRUEBA_FASE_1.md`.

## Problemas conocidos
- Revisión MCP 2026-11-26 17:12 (40 s): `SetStat(p, "Fuerza", 37)` devolvió false y Fuerza quedó en 1. `GetSnapshot(p)` desde ese contexto devolvió nil pese a EstadoDatos Listo. Causa pendiente de diagnóstico; no se da por demostrado un fallo de persistencia ni un aislamiento del contexto MCP.
- En el cliente, `PlayerGui` no contenía StatsHUD; solo se observó Freecam. No se confirmó el HUD visual.
- Output reportó tres veces `rbxassetid://203785492: Asset type does not match requested type`; no pasó el requisito de Output sin errores. Origen pendiente.
- Identidad resuelta: el dueño confirmó el único lugar autorizado, placeId `111090309292395`, universeId `10779249165`. El nombre visible es irrelevante; seleccionar el studio_id cuya entrada MCP tenga ese placeId. No usar otro ID ni un Place1 sin guardar.
- Graphify no disponible; instalación temporal interrumpida al atascarse la resolución de dependencias. `graphify-out/GRAPH_REPORT.md` contiene un mapa manual actualizado, no una extracción automática. Pendiente regenerarlo con Graphify.
- El ejecutable `rojo` en PATH es un shim de Rokit sin manifiesto; el sourcemap pasó usando el binario instalado de Rojo 7.7.1 directamente.

## Siguiente paso
Diagnosticar por qué SetStat/GetSnapshot desde MCP no acceden a la sesión cargada y por qué falta StatsHUD, sin editar scripts en Studio. Después repetir en placeId `111090309292395` la parte pendiente: Fuerza 37, autoguardado, Stop/Play y persistencia en 37, tope 999→100 y restauración a 1. Esta revisión se detuvo a los 40 s, con Fuerza todavía en 1 y Studio en Edit; no se esperó autoguardado ni se probó reconexión/tope. Fallo de carga con API deshabilitada y HUD PC/celular también pendientes. Mantener la prueba manual del dueño y Graphify pendientes. No iniciar Fase 2.

## Preguntas pendientes
- Jugadores por servidor (provisional 12).
- Nombre definitivo del juego.
