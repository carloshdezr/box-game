# Bitácora

## 2026-11-26 16:43 · [codex] · Fase 1
- Qué hice: implementé persistencia versionada de los 4 stats, rango y puntos con UpdateAsync, bloqueo de sesión, autoguardado, salida y cierre. Añadí atributos replicados, HUD con tema único y aviso de carga/guardado fallido sin sobrescribir progreso. El dueño aprobó inicial 1 y topes 100/250/500. Fase 1 sigue abierta.
- Archivos tocados: `src/ReplicatedStorage/Config/{Stats,Persistence,Theme}.lua`, `src/ServerScriptService/Services/{PlayerDataSchema,PlayerDataService}.lua`, `Main.server.lua`, `init.client.lua`, `tools/check-data.cjs`, `tools/check-data.lua`, `docs/{ESTADO,DECISIONES,BITACORA,PRUEBA_FASE_1}.md`, `graphify-out/GRAPH_REPORT.md`.
- Cómo probarlo: el 2026-11-26 pasaron comprobaciones locales de sintaxis y DataStore simulado: valores iniciales, topes, autoridad del servidor, autoguardado y recuperación, reconexión, salida/cierre, error de carga sin escrituras, registro incompatible, bloqueo ocupado/vencido, pérdida de propiedad y carga/salida/cierre concurrentes. Sourcemap Rojo 7.7.1 correcto; `git diff --check` limpio. Cada revisión tomó menos de 2 minutos. Prueba manual detallada en `docs/PRUEBA_FASE_1.md`.
- Qué quedó mal o pendiente: Studio solo exponía «Place1», no «box-game pruebas»; no se tocó ningún lugar ni se crearon copias. Pendientes prueba real de DataStore, HUD y recorrido manual del dueño. Graphify no instalado: resolución de dependencias atascada, interrumpida sin insistir; se dejó mapa manual claramente identificado, pendiente regeneración automática. El shim de Rojo en PATH carece de manifiesto Rokit; se usó el binario ya instalado directamente.
- Siguiente paso recomendado: abrir únicamente «box-game pruebas», sincronizar el repo, ejecutar la guía manual y registrar fecha/resultados en ESTADO antes de cerrar Fase 1. Regenerar Graphify cuando esté disponible.

## 2026-11-26 16:36 · [claude] · Diseño
- Qué hice: anoté dos decisiones aprobadas: ring de práctica contra NPC sin puntos de rango al publicar, y plan B de modelos si ForgeGUI no da 3D.
- Archivos tocados: `docs/DISENO_JUEGO.md`, `docs/ESTADO.md`, `docs/DECISIONES.md`, `docs/BITACORA.md`.
- Cómo probarlo: nada jugable todavía.
- Qué quedó mal o pendiente: jugadores por servidor y nombre del juego.
- Siguiente paso recomendado: Fase 1, datos y stats.

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
