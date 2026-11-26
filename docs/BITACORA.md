# Bitácora

## 2026-11-26 16:30 · [claude] · Diseño
- Qué hice: escribí el documento de diseño del juego de boxeo (stats, gym con minijuegos, combate, rangos, NPC solo para desarrollo, PvP, estilo caricatura con ForgeGUI, alcance de la v1) y armé las fases 1 a 7 con su criterio de terminado.
- Archivos tocados: `docs/DISENO_JUEGO.md`, `docs/ESTADO.md`, `docs/DECISIONES.md`, `docs/BITACORA.md`, `src/ReplicatedStorage/Config/Game.lua`.
- Cómo probarlo: no hay nada jugable todavía; leer el diseño y confirmar que es lo que se quiere.
- Qué quedó mal o pendiente: preguntas abiertas en `ESTADO.md` (riesgo de quitar NPC, jugadores por servidor, nombre).
- Siguiente paso recomendado: Fase 1, datos y stats con DataStore.

## 2026-11-26 16:10 · [claude] · Estructura inicial
- Qué hice: creé el repo con reglas (AGENTS.md, CLAUDE.md), documentos vivos (ESTADO, BITACORA, DECISIONES, DISENO_JUEGO), configuración de Rojo y carpetas de `src/` según la estructura del proyecto oaxacos, adaptada a una sola persona.
- Archivos tocados: todos (primera versión).
- Cómo probarlo: `rojo serve default.project.json` con el plugin de Rojo abierto en el lugar de pruebas de Studio; el lugar debe mostrar el script de servidor en la salida sin errores.
- Qué quedó mal o pendiente: la idea del juego, el diseño y la prueba en Studio.
- Siguiente paso recomendado: completar `docs/DISENO_JUEGO.md` con la idea del juego.
