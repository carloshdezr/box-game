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
- [ ] **Fase 7: prepublicación.** Criterio: NPC quitados, solo PvP; validaciones anti-trampas en servidor; prueba con dos clientes reales y en celular; lista para publicar.

Después de publicar (fuera de la v1): torneos, más rangos, cosméticos, monedas y tienda.

## Último en trabajar
[claude] · 2026-11-26. Documento de diseño y fases.

## Problemas conocidos
- Ninguno todavía.

## Siguiente paso
Fase 1: guardar datos del jugador (4 stats, rango y puntos de rango) con DataStore y mostrarlos en una interfaz simple. Valores iniciales y topes en `src/ReplicatedStorage/Config/`.

## Preguntas pendientes
- Riesgo de quitar los NPC: con pocos jugadores conectados alguien puede no tener con quién pelear. ¿Modo de práctica sin puntos o solo PvP? (Hoy: solo PvP.)
- Jugadores por servidor (provisional 12).
- Nombre definitivo del juego.
