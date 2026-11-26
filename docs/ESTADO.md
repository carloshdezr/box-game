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
[codex] · 2026-11-26. Corregida la carga ante candado ocupado: espera configurable de 30 s con reintentos cada 2 s. Fase abierta hasta prueba manual.

## Avance de Fase 1
- [x] DataStore con UpdateAsync, autoguardado cada 60 segundos, salida y cierre del servidor.
- [x] Bloqueo por sesión y rechazo de registros inválidos; carga fallida nunca guarda valores iniciales sobre datos existentes.
- [x] Candado ajeno vigente: conserva Cargando, reintenta cada 2 s hasta 30 s; pruebas locales de liberación, vencimiento, timeout sin escrituras y cancelación al salir/cerrar.
- [x] Fuerza, Velocidad, Stamina y Defensa iniciales en 1; topes Novato 100, Amateur 250, Semi-pro 500 (aprobados por el dueño el 2026-11-26).
- [x] Rango y puntos persistidos; atributos del jugador publicados por el servidor.
- [x] HUD simple con tema central y aviso «Tu progreso no se está guardando».
- [x] Validación rápida local con DataStore simulado y mapeo Rojo, sin crear archivos de lugar.
- [ ] Prueba manual del dueño: persistencia real, salida/cierre, fallo de carga y HUD en PC/celular. Guía: `docs/PRUEBA_FASE_1.md`.

## Problemas conocidos
- Studio solo tenía abierto «Place1», no «box-game pruebas»: no se tocó ni se probó otro lugar. Persistencia real y apariencia pendientes.
- Graphify no disponible; instalación temporal interrumpida al atascarse la resolución de dependencias. `graphify-out/GRAPH_REPORT.md` contiene un mapa manual actualizado, no una extracción automática. Pendiente regenerarlo con Graphify.
- El ejecutable `rojo` en PATH es un shim de Rokit sin manifiesto; el sourcemap pasó usando el binario instalado de Rojo 7.7.1 directamente.

## Siguiente paso
Abrir «box-game pruebas», sincronizar con Rojo y realizar la prueba de `docs/PRUEBA_FASE_1.md`. Anotar fecha y resultados aquí antes de cerrar Fase 1. Regenerar el grafo con Graphify cuando esté disponible. No iniciar Fase 2 todavía.

## Preguntas pendientes
- Jugadores por servidor (provisional 12).
- Nombre definitivo del juego.
