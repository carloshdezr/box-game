# Bitácora

## 2026-11-28 03:16 · [codex] · Fase 2
- Qué hice: git pull origin main trajo 27b9739; revisé reglas, estado, últimas entradas, diseño/decisiones, grafo e imagen objetivo. A–D descartadas. Monté dos propuestas R15 con HumanoidDescription y artículos de catálogo; capturas frente/lado, referencia al lado en HTML y Flaco/Bestia con la misma malla. Documenté 4 caras, 6 pelos, 4 colores, autores y respaldos. Parte B no iniciada.
- Archivos tocados: docs/ESTILO_BOXEADOR.md, docs/referencias/estilo-final/ (seis JPEG y comparación HTML), docs/{ESTADO,DECISIONES,BITACORA,CUERPOS_FASE_2}.md. Sin cambios en src ni configuración de Rojo. graphify-out actualizado al regenerar reporte; extracción code-only sin cambios de código.
- Cómo probarlo: abrir docs/referencias/estilo-final/comparacion.html y consultar las tablas de catálogo. Studio autorizado 111090309292395: revisión inicial detenida por visor negro; dueño trajo Studio al frente. Revisiones Play de 81 s y 54 s; se observaron cuerpo, cara explícita y diferencia de ancho entre Flaco/Bestia. Catálogo/autoría consultados por MCP.
- Qué quedó mal o pendiente: tenis deformados en capas y parcialmente ocultos tras ajuste rígido fallido; camiseta abultada, puños grandes y acentos azules pendientes. No afirmar parecido exacto ni combinación lista para producción. Tres caras, dos pelos y colores rojo/blanco solo tienen ficha verificada, no prueba puestos. No hubo edición de scripts ni cambios intencionales de stats/apariencia. Modelos temporales retirados y cámara restaurada; Studio en Edit, sin guardar/publicar ni crear copias.
- Siguiente paso recomendado: dueño revisa siluetas y propone ajustes; resolver calzado/ropa y obtener aprobación antes de Parte B. Fase 2 sigue abierta.

## 2026-11-28 03:05 · [claude] · Diseño
- Qué hice: guardé la imagen de referencia del estilo que quiere la persona dueña (`docs/referencias/estilo-objetivo.png`) y actualicé diseño y decisiones: Roblox clásico suavizado con toque anime. Las opciones A–D quedan descartadas.
- Archivos tocados: `docs/referencias/estilo-objetivo.png`, `docs/DISENO_JUEGO.md`, `docs/DECISIONES.md`, `docs/BITACORA.md`.
- Cómo probarlo: abrir la imagen de referencia.
- Qué quedó mal o pendiente: proponer cuerpo, caras, peinados, ropa y progresión con ese estilo (Parte A de nuevo).
- Siguiente paso recomendado: capturas de prueba comparadas con la referencia.

## 2026-11-28 02:53 · [codex] · Fase 2, Parte A
- Qué hice: git pull origin main trajo 9847fba; leí AGENTS, estado, últimas tres entradas, decisiones, sección 9b y grafo. Preparé cuatro opciones finales de cuerpo de catálogo con HumanoidDescription y capturas reales: A Glenn, B Athletic Muscle Man, C Athletic Muscle Body de adidas, D Superhero. Cabeza/cara y cabello Glenn comunes, shorts rojos de catálogo y cobertura blanca provisional en manos. Propuse un cuerpo distinto/escala para cada físico; quinto candidato Bestia aún sin prueba visual. Descarté Oliver (chaqueta), Action Figure (shorts deformados) y Man (cuadrado). No cambié código del juego ni empecé Parte B.
- Archivos tocados: docs/{CUERPOS_FASE_2,ESTADO,DECISIONES,BITACORA}.md y cuatro capturas en docs/referencias/fase2-a/. Sonda temporal src/ReplicatedStorage/RojoConnectionProbe.model.json creada y retirada para validar Rojo; no queda en el commit. Grafo regenerado code-only por incorporación de documentos/capturas; estructura del código sin cambios.
- Cómo probarlo: ver docs/CUERPOS_FASE_2.md y elegir A/B/C/D. En placeId 111090309292395, revisiones acotadas: primera menor a 1 min detenida por montaje incompatible con joints nuevos; segunda 61 s detenida por captura sin actualizar; Play 72 s cortado por visor negro. El dueño trajo Studio al frente; revisión final 98 s con cuatro capturas válidas y limpieza. Se resolvió montaje estático con AnimationConstraint y welds de accesorios en ambos sentidos. Ropa de vendas clásica no se mapea igual en todos los cuerpos, por eso manos con cobertura provisional de malla, documentada. Rojo: logs previos ConnectFail a localhost; HTTP 200 actual; dueño reconectó 127.0.0.1:34872, TCP establecido y sonda apareció/desapareció en Studio automáticamente. Sincronización funcional verificada, sin instalación manual de scripts.
- Qué quedó mal o pendiente: dueño debe elegir cuerpo y progresión antes de Parte B. Faltan rig definitivo, opciones compatibles de cabello/cara/ropa, KeyframeSequence y SUBIR_ANIMACIONES.md. El control de ventanas no estuvo disponible; se requirió traer Studio al frente para que las capturas renderizaran. La transferencia inicial de capturas superó el límite de tamaño de auto-review; se guardaron en fragmentos menores sin bloqueo pendiente. No se publicó/guardó el lugar ni se crearon copias; modelos temporales retirados, Studio en Edit y cámara/FOV restaurados. Progreso/apariencia del jugador sin cambios.
- Siguiente paso recomendado: el dueño elige A/B/C/D y confirma o ajusta la tabla de físicos. Solo después, implementar Parte B y su guía de publicación de animaciones. No iniciar Fase 3.

## 2026-11-28 02:45 · [claude] · Diseño
- Qué hice: la persona dueña probó la Fase 2 y el boxeador le pareció genérico. Actualicé diseño, criterio y decisiones: cuerpo de malla redondeado con artículos del catálogo (HumanoidDescription) y animaciones KeyframeSequence en lugar de código.
- Archivos tocados: `docs/DISENO_JUEGO.md`, `docs/ESTADO.md`, `docs/DECISIONES.md`, `docs/BITACORA.md`.
- Cómo probarlo: leer sección 9b del diseño.
- Qué quedó mal o pendiente: rehacer el rig y las animaciones de la Fase 2.
- Siguiente paso recomendado: proponer 3 o 4 cuerpos del catálogo con capturas para que elija la persona dueña, y rehacer las animaciones.

## 2026-11-28 02:32 · [codex] · Fase 2
- Qué hice: git pull origin main trajo el diseño 22651cf; leí protocolo, estado, últimas entradas, decisiones, diseño y grafo. Implementé R15 propio generado desde src (shorts, vendas, tenis, cara/cabello), creador con vista previa y elección única validada/persistida, crecimiento servidor por cinco niveles y Fuerza, módulo reutilizable de poses y golpes visuales con frecuencia/alternancia decididas por servidor. Umbrales de promedio 1/25/75/150/300 aprobados por el dueño. Minijuegos actuales intactos; energía y gym jugable quedan en Fase 3.
- Archivos tocados: Config/{Appearance,Physique,Boxer,Theme}, ReplicatedStorage/{BoxerRig,BoxerAnimations}, Remotes/{ChooseAppearance,BoxerPunch}, Services/{BoxerService,PlayerDataSchema,PlayerDataService,StudioDebug}, Main, clientes {Appearance,Boxer}, tools/check-data.{cjs,lua}, docs/{ESTADO,DECISIONES,BITACORA,PRUEBA_FASE_2,PRUEBA_GYM_ANTERIOR}, graphify-out/{GRAPH_REPORT.md,graph.json,graph.html}.
- Cómo probarlo: guía actual en docs/PRUEBA_FASE_2.md. Pasaron sintaxis de los 21 scripts, sourcemap, simulación de persistencia/entrenamiento y nuevas pruebas de apariencia (compatibilidad v1, validación, guardado inmediato, copia defensiva, reconexión, rechazo sin sobrescritura) y cinco umbrales. Rojo arrancado oculto; dueño confirmó Connect, pero Studio conservaba fuentes antiguas: se aplicaron fuentes exactas por MCP y comparación final de 21/21 sin diferencias. En placeId 111090309292395, revisión 1 de 50 s: creador visible, selección real por botones, R15 sano, Flaco→Marcado con StudioDebug (torso 1.53→2.14), clics y stats restaurados. Revisión 2 de 44 s: reconexión conserva apariencia y no pregunta; W mueve/anima; guardia/cansado y fotogramas de jab/gancho/uppercut verificados; reaparición conserva R15/apariencia; golpes duplicados e inválidos rechazados. Sin errores de juego; solo aviso previo de asset 203785492 del plugin Rojo. Graphify code-only regenerado: 112 nodos/157 enlaces; incluye árbol de trabajo, su referencia Git corresponde al commit base antes de guardar esta implementación.
- Qué quedó mal o pendiente: Fase 2 abierta hasta recorrido manual del dueño; falta prueba de dos clientes reales, toque real y valoración de proporciones/animaciones. Musculoso/Bestia tienen umbrales comprobados localmente, pero no revisión visual en sesión de jugador porque Novato no supera 100. La conexión Rojo requiere revisar por qué no aplicó el primer sync; código de Studio sí quedó idéntico al repo mediante MCP. No se guardó/publicó el lugar ni se crearon copias. Studio en Edit, stats en 1; cuenta de pruebas conserva piel Media, Cresta, Sonrisa y shorts Azules. Grabación temporal de 3.65 s solo para revisar golpes, fuera del repo.
- Siguiente paso recomendado: el dueño hace la guía de Fase 2 y registra resultados; cerrar solo con su confirmación. Después, Fase 3 del nuevo diseño, reutilizando rig/animaciones y base del gym. La prueba sin API Services sigue en Fase 8 tras la renumeración.

## 2026-11-28 02:20 · [claude] · Diseño
- Qué hice: actualicé el diseño con lo que pidió la persona dueña tras probar el gym: entrenamiento físico (W en caminadora, golpes con animación y cansancio) y boxeador propio que crece con los stats. Reordené las fases: nueva Fase 2 (boxeador y animaciones), Fase 3 (gym jugable) y las demás recorridas hasta la Fase 8.
- Archivos tocados: `docs/DISENO_JUEGO.md`, `docs/ESTADO.md`, `docs/DECISIONES.md`, `docs/BITACORA.md`.
- Cómo probarlo: leer las secciones 6 y 9b del diseño.
- Qué quedó mal o pendiente: el código del gym actual sigue con los minijuegos de barra hasta la Fase 3.
- Siguiente paso recomendado: Fase 2, boxeador propio y animaciones con código.

## 2026-11-26 17:48 · [codex] · Fase 2
- Qué hice: cerré Fase 1 con confirmación explícita del dueño y trasladé la prueba sin API Services a Fase 7. Implementé gym de bloques generado desde src, ocho puestos con prompts/ocupación, cuatro minijuegos con teclado y botón de pantalla, premios y tiempos validados por servidor, límites de rango y aviso de máximo. El dueño aprobó 20 s, 5 s de descanso y hasta +4 por stat. Identifiqué el asset 203785492 como `Sounds.Notification` del plugin RojoManagedPlugin; no lo modifiqué. Rojo sincronizó los 13 scripts; fuentes finales verificadas en el placeId autorizado.
- Archivos tocados: `.gitignore`, `src/ReplicatedStorage/Config/{Training,Theme}.lua`, `src/ReplicatedStorage/Remotes/Training{State,Result,Cancel}.model.json`, `src/ServerScriptService/Main.server.lua`, `Services/{GymService,TrainingService,StudioDebug}.lua`, `src/StarterPlayer/StarterPlayerScripts/Training.client.lua`, `tools/{check-data.cjs,check-training.lua,find-plugin-asset.py}`, `docs/{ESTADO,DECISIONES,BITACORA,PRUEBA_FASE_1,PRUEBA_FASE_2}.md`, `graphify-out/{GRAPH_REPORT.md,graph.json,graph.html}`.
- Cómo probarlo: ver `docs/PRUEBA_FASE_2.md`. El 2026-11-26 pasaron simulación local de persistencia y seguridad de entrenamiento, sintaxis y sourcemap Rojo. Studio: ocho puestos, prompt E abre Saco, cuatro paneles abren; con resultados simulados por StudioDebug tras 20 s reales, Saco +4 Fuerza/Velocidad, Caminadora +4 Stamina, Pesas +4 Fuerza/Defensa y Pera 99→100 Velocidad/Defensa con aviso. Se rechazó resultado anticipado y se conservó descanso tras cancelar. Espacio controló Caminadora y puntuó una repetición de Pesas; panel/botón revisados en iPhone 17 Pro emulado. Stats restaurados a 1, personaje desanclado, Studio detenido y viewport normal.
- Qué quedó mal o pendiente: Fase 2 pendiente de recorrido manual, toque en celular real, dos jugadores y persistencia de premios. Los premios de las cuatro estaciones se verificaron con scores simulados; no se recorrió cada minijuego completo a mano. Desviación del límite: las dos primeras revisiones registraron 121 s y 128 s incluyendo cierre, excediendo brevemente los 120 s; se detuvieron y la última se redujo a 29 s. El error del sonido de Rojo puede persistir porque es del plugin. No se crearon copias ni se guardó/publicó el lugar. Graphify ya funciona con Python nativo temporal: extracción code-only, 80 nodos/110 enlaces, reporte/JSON/HTML actualizados (incluyen el árbol de trabajo de esta implementación; la referencia Git generada indica el commit anterior a guardarla).
- Siguiente paso recomendado: el dueño prueba la guía de Fase 2 y anota fecha/resultados antes de cerrarla. No iniciar Fase 3; el aviso sin API Services queda en Fase 7.

## 2026-11-26 17:22 · [codex] · Fase 1
- Qué hice: traje los cambios f098766 y leí la regla nueva. Arranqué Rojo 7.7.1 en segundo plano, localhost:34872; el dueño conectó el plugin. Studio tenía dos objetos llamados StarterPlayerScripts: un LocalScript antiguo vacío y el contenedor correcto. Retiré el duplicado antiguo por MCP y apliqué/verifiqué los nueve scripts exactos del repo en placeId 111090309292395. Confirmé StatsHUD LocalScript y Services.StudioDebug ModuleScript, y el puente BindableFunction durante Play. Actualicé el mapa manual para los scripts nuevos de la sesión anterior; no es extracción Graphify.
- Archivos tocados: `docs/ESTADO.md`, `docs/PRUEBA_FASE_1.md`, `docs/BITACORA.md`, `graphify-out/GRAPH_REPORT.md`. Código del juego sin cambios en el repo; fuentes de Studio sincronizadas desde src según autorización.
- Cómo probarlo: el 2026-11-26, revisión MCP de 104 s: cuatro stats 1, Novato, PuntosRango 0 y Listo; StudioDebug SetStat Fuerza 37 devolvió true, atributo/HUD 37; espera >60 s, Stop/Play y Fuerza 37 conservada; 999 limitado a 100; Fuerza restaurada a 1. Se cambió Defensa a 12 y se cerró antes del autoguardado. Segunda revisión de 6 s: Defensa 12 persistida y Fuerza 1; Defensa restaurada a 1 y Stop. HUD legible en PC y iPhone 17 Pro emulado horizontal/vertical, sin tapar joystick/salto. Simulador restablecido. También pasaron simulación local y sourcemap Rojo.
- Qué quedó mal o pendiente: Output sigue con tres mensajes del asset 203785492 (tipo incorrecto); no se observaron errores de PlayerData. El dueño eligió dejar pendiente el paso de API Services deshabilitado; configuración intacta. Falta recorrido manual del dueño para cerrar fase. Graphify automático sigue pendiente. No se publicaron/guardaron lugares ni se crearon copias. Studio quedó en Edit, viewport normal, todos los stats en 1 y Rojo corriendo.
- Siguiente paso recomendado: recorrido manual del dueño y, cuando decida retomarlo, paso 5 de fallo de carga. No avanzar a Fase 2 hasta registrar cierre de Fase 1.

## 2026-11-26 17:25 · [claude] · Reglas
- Qué hice: agregué a AGENTS.md que sincronizar con Studio (Rojo o MCP) lo hace la IA; la persona dueña no corre comandos en la terminal, como en oaxacos.
- Archivos tocados: `AGENTS.md`, `docs/BITACORA.md`.
- Cómo probarlo: la siguiente IA arranca Rojo sola antes de la prueba de Fase 1.
- Qué quedó mal o pendiente: la prueba de Fase 1 (ver entrada de las 17:20).
- Siguiente paso recomendado: arrancar o reiniciar Rojo, comprobar que StatsHUD está en Studio y repetir `docs/PRUEBA_FASE_1.md`.

## 2026-11-26 17:20 · [claude] · Fase 1
- Qué hice: corregí las dos fallas de la revisión de las 17:12. El HUD no aparecía porque `init.client.lua` hacía que Rojo convirtiera `StarterPlayerScripts` en un LocalScript; ahora es `StatsHUD.client.lua` y el proyecto declara la clase. `SetStat` devolvía `false` porque el `require` desde el MCP carga otra copia del módulo; agregué `Services/StudioDebug` (BindableFunction solo en Studio) y actualicé la guía.
- Archivos tocados: `default.project.json`, `src/StarterPlayer/StarterPlayerScripts/StatsHUD.client.lua` (renombrado), `src/ServerScriptService/Main.server.lua`, `src/ServerScriptService/Services/StudioDebug.lua`, `docs/PRUEBA_FASE_1.md`, `docs/DECISIONES.md`, `docs/BITACORA.md`.
- Cómo probarlo: reiniciar `rojo serve` (cambió el proyecto) y reconectar el plugin. En Play debe verse el panel de stats y existir `StarterPlayer.StarterPlayerScripts.StatsHUD`. Desde Server: `game.ServerScriptService.StudioDebug:Invoke("SetStat", nil, "Fuerza", 37)` devuelve `true`.
- Qué quedó mal o pendiente: no probado en Studio desde este entorno. Pendientes los pasos de la guía (37, autoguardado/reconexión, tope 100, HUD en PC y celular). El error del asset 203785492 no viene del repo.
- Siguiente paso recomendado: repetir la prueba de `docs/PRUEBA_FASE_1.md` en el placeId `111090309292395`.

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
