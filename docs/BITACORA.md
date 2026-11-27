# Bitácora

## 2026-11-26 17:12 · [codex] · Fase 1
- Qué hice: el dueño confirmó placeId `111090309292395` (universeId `10779249165`) como único lugar de pruebas. Actualicé AGENTS y documentos vigentes para seleccionar por ID, no por nombre. Los nombres en entradas anteriores se conservan como historia. Ejecuté Play en ese ID y detuve la revisión al trabarse, en 40 segundos.
- Archivos tocados: `AGENTS.md`, `docs/ESTADO.md`, `docs/PRUEBA_FASE_1.md`, `docs/BITACORA.md`.
- Cómo probarlo: el 2026-11-26 a las 17:12, servidor y cliente mostraron Fuerza/Velocidad/Stamina/Defensa=1, Rango=Novato, PuntosRango=0 y EstadoDatos=Listo para el jugador 5033842342. SetStat(Fuerza,37) desde execute_luau Server devolvió false y el atributo permaneció en 1; GetSnapshot devolvió nil. Se verificó RunService:IsServer()=true y el Main sincronizado arranca PlayerDataService. No se alteraron scripts.
- Qué quedó mal o pendiente: no apareció StatsHUD en PlayerGui (solo Freecam); Output tuvo tres errores del asset 203785492 por tipo incorrecto. Pendiente diagnosticar el rechazo de SetStat desde MCP, sin atribuir causa aún. No se esperó autoguardado ni se probó Stop/Play con 37, tope 999→100, fallo con API deshabilitada ni HUD PC/celular. Fuerza siguió en 1; no hizo falta restaurarla. Se dejó Studio en Edit; sin copias ni publicación. Fase abierta, estructura sin cambios y Graphify pendiente anterior.
- Siguiente paso recomendado: diagnosticar contexto de la sesión y sincronización/ejecución del cliente en el repo; luego repetir los pasos pendientes en el mismo placeId, con máximo 2 minutos por revisión.

## 2026-11-26 17:05 · [codex] · Fase 1
- Qué hice: listé Studios con MCP. Ahora aparece un lugar guardado en modo Edit, «Lugar de zToT1x: 11262026_1», placeId 111090309292395, universeId 10779249165. Busqué set_active_studio: no está disponible; las herramientas seleccionan con studio_id. Intenté verificar el nombre de la experiencia mediante consulta pública, pero Roblox devuelve título oculto.
- Archivos tocados: `docs/ESTADO.md`, `docs/BITACORA.md`.
- Cómo probarlo: comprobación de disponibilidad e identidad en menos de 2 minutos. La conexión MCP funciona; el nombre no coincide con «box V1».
- Qué quedó mal o pendiente: no se inició Play ni se ejecutaron los cambios de stats, autoguardado/reconexión, tope ni restauración. Falta confirmar que el ID corresponde al único lugar autorizado. No se tocó Place1 ni se crearon copias. Fase abierta; sin cambios de estructura.
- Siguiente paso recomendado: confirmar con el dueño el placeId 111090309292395 y, si es «box V1», ejecutar la revisión solicitada usando studio_id.

## 2026-11-26 17:00 · [codex] · Fase 1
- Qué hice: corregí el nombre del único lugar autorizado a «box V1» en AGENTS, ESTADO y guía de prueba, prohibiendo explícitamente Place1. Intenté seleccionar el lugar mediante MCP; list_roblox_studios devolvió una instancia sin nombre en modo Unavailable y «Place is not open». get_studio_state confirmó el bloqueo; corté la revisión en menos de 2 minutos.
- Archivos tocados: `AGENTS.md`, `docs/ESTADO.md`, `docs/PRUEBA_FASE_1.md`, `docs/BITACORA.md`.
- Cómo probarlo: el 2026-11-26 a las 17:00 se comprobó disponibilidad del MCP; no fue posible iniciar Play. `git diff --check` sin errores. Revisar el nombre corregido en los tres documentos.
- Qué quedó mal o pendiente: no ejecutados los cinco pasos solicitados (stats iniciales/Listo/Output, cambio a 37, autoguardado y reconexión, tope 100, restauración a 1). No se cambiaron stats, no se tocó Place1, no se crearon copias ni se guardó/publicó ningún lugar. La confirmación del dueño sobre API Services/Rojo queda registrada, pero el MCP no expuso el lugar. Sin cambios de estructura; Graphify continúa pendiente como antes.
- Siguiente paso recomendado: restablecer la conexión MCP para que liste «box V1» y repetir la revisión de persistencia solicitada, con máximo 2 minutos por revisión. Fase 1 abierta.

## 2026-11-26 16:53 · [codex] · Fase 1
- Qué hice: corregí la carga con candado ajeno vigente: mantiene Cargando y reintenta cada 2 s hasta un plazo total de 30 s, configurables en Persistence. Si se libera, carga los datos originales; si agota el plazo, marca Error sin sobrescribir. Se cancelan reintentos al salir/cerrar. Anoté la decisión y actualicé la guía manual.
- Archivos tocados: `src/ServerScriptService/Services/PlayerDataService.lua`, `src/ReplicatedStorage/Config/Persistence.lua`, `tools/check-data.lua`, `docs/DECISIONES.md`, `docs/ESTADO.md`, `docs/PRUEBA_FASE_1.md`, `docs/BITACORA.md`.
- Cómo probarlo: el 2026-11-26 pasó `node tools/check-data.cjs` con Fengari temporal (menos de 2 minutos): intervalos de 2 s, liberación con progreso conservado, vencimiento del candado, Error a los 30 s sin escrituras ni reintentos posteriores, cancelación al salir/cerrar y regresiones anteriores. Se ajustó la prueba de carga/salida concurrente para aceptar adquisición cancelada sin registro. `git diff --check` pasó.
- Qué quedó mal o pendiente: prueba manual en «box-game pruebas» pendiente; no se usó Studio ni se crearon copias. Fase 1 sigue abierta. Sin cambios de estructura; continúa pendiente la extracción automática de Graphify anotada anteriormente.
- Siguiente paso recomendado: probar una reconexión rápida en el lugar autorizado y registrar el resultado manual en ESTADO.

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
