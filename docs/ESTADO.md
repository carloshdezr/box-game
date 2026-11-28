# Estado actual del proyecto

## Fase actual
Fase 2: Parte B implementada con personaje PROVISIONAL V2 y KeyframeSequence. Validación rápida hecha el 2026-11-28; falta aprobación manual del dueño. Modelo definitivo y acabado visual pasan a Fase 7. No iniciar Fase 3 aún.

## Checklist de fases
Cada fase tiene su criterio de "terminado". No se pasa a la siguiente sin prueba manual de la persona dueña anotada aquí.

- [x] **Fase 0: idea y diseño.** Criterio: `DISENO_JUEGO.md` completo. Hecho el 2026-11-26.
- [x] **Fase 1: datos y stats.** Criterio: un jugador entra, ve sus 4 stats y su rango, y al salir y volver siguen igual. Cerrada el 2026-11-26: persistencia validada en Studio y dueño confirma que el panel se ve bien y autoriza cierre.
- [ ] **Fase 2: boxeador provisional funcional y animaciones.** Criterio: todos entran con el personaje provisional V2, apariencia elegida guardada, guantes unidos a las manos y diferencia clara Flaco/Bestia; guardia, jab, gancho, uppercut, correr y cansado son KeyframeSequence funcionales que el dueño confirma que se ven bien. No exige el modelo definitivo ni el acabado de arte.
- [ ] **Fase 3: gym jugable.** Criterio: caminadora con W y cinta que cambia de velocidad (te caes si te quedas atrás); saco con clic y golpes animados que mueven el saco; pesas con clic por repetición y ritmo; pera con golpes izquierda/derecha; barra de energía que se gasta y se recupera; stats suben según lo que haces, con límites del servidor y sin pasar el tope del rango. Se reutiliza el gym, la ocupación y el control de premios hechos antes.
- [ ] **Fase 4: combate contra NPC.** Criterio: en el ring puedes pelear 3 rounds contra un NPC con jab, gancho, uppercut, bloquear y esquivar, usando los mismos golpes del saco; las barras de vida y stamina funcionan y la pelea termina con un ganador.
- [ ] **Fase 5: rangos y rivales.** Criterio: ganar peleas da puntos de rango; subes de Novato a Amateur y a Semi-pro; cada rango tiene su rival NPC, su tope de stats y equipo de gym mejor.
- [ ] **Fase 6: PvP 1 contra 1.** Criterio: dos jugadores reales pueden retarse y pelear en el ring con las mismas reglas, y el ganador recibe puntos de rango si son de rangos parecidos.
- [ ] **Fase 7: interfaz y arte (ForgeGUI).** Criterio: modelo definitivo del boxeador mandado a hacer o generado en 3D, rig compatible y ajuste de ropa/calzado/guantes según referencia; HUD, creador y pantallas con arte final; texturas de físico y animaciones definitivas subidas por el dueño; funcionando en PC y celular.
- [ ] **Fase 8: prepublicación.** Criterio: los NPC ya no dan puntos de rango (solo el ring de práctica, sin puntos), el rango se sube solo con PvP; validaciones anti-trampas en servidor; prueba con dos clientes reales y en celular; lista para publicar.

Después de publicar (fuera de la v1): torneos, más rangos, cosméticos, monedas y tienda.

## Checklist adicional de Fase 8 (prepublicación)
- [ ] Desactivar API Services, comprobar «Tu progreso no se está guardando», rechazo de premios y ausencia de sobrescritura; reactivar y recuperar progreso. Trasladada desde Fase 1 por instrucción del dueño el 2026-11-26.

## Último en trabajar
[codex] · 2026-11-28 03:32. Parte B provisional implementada, Rojo sincronizado. Dos revisiones Studio de 35 s y 61 s; seis tracks y físico/guantes comprobados. Guías PRUEBA_FASE_2.md y SUBIR_ANIMACIONES.md actualizadas.

## Fase 2 provisional: Parte B
- [x] Dueño elige V2 provisional con picos; suspende búsqueda de cuerpos/caras/ropa. Decisión del 2026-11-28.
- [x] BoxerRig con HumanoidDescription, catálogo fijo y opciones propuestas en Appearance. Registros existentes conservados; no se pide elegir otra vez.
- [x] Guantes propios provisionales unidos a Left/RightGripAttachment y tamaño limitado; sin capas de catálogo para los guantes.
- [x] Misma malla con cinco escalas; Bestia aproximadamente 52 % más ancho que Flaco en torso/brazos en la revisión. StudioDebug Physique permite prueba sin modificar datos.
- [x] Seis KeyframeSequence con jerarquía R15, marcadores y reproducción Animator. Sin escrituras Transform por frame. Controlador Animate estándar desactivado.
- [x] Guía de subida y rig de exportación generado en ServerStorage.BoxerAnimationExport. No hay assets publicados.
- [ ] Prueba manual del dueño de aspecto funcional, movimiento y golpes; primera elección con jugador nuevo, dos clientes y toque real.
- [ ] Subir seis animaciones y completar AnimationIds antes del juego publicado (arte/publicación, Fase 7). Studio funciona con IDs temporales.

## Avance de Fase 2: boxeador y animaciones
Histórico de la primera implementación: las comprobaciones siguientes no satisfacen el criterio nuevo de mallas y KeyframeSequence.
- [x] R15 propio generado desde el repo: shorts, vendas, tenis, cabello y cara de bloques; ningún avatar personal ni asset/animación subido.
- [x] Creador con vista previa y tres opciones por campo en Config/Appearance; servidor valida y PlayerDataService guarda inmediatamente y en sus guardados habituales. Registros v1 sin apariencia siguen siendo compatibles; no se sobrescriben registros inválidos.
- [x] Cinco niveles en Config/Physique: promedios 1/25/75/150/300 aprobados por el dueño; tamaño adicional de brazos/hombros por Fuerza. Cambios de tamaño en servidor replicados en vivo.
- [x] Módulo reutilizable de guardia, jab, gancho, uppercut, correr y cansado. Clic izquierdo alternado/clic derecho y botones táctiles; servidor controla frecuencia, sin daño ni premios. Cansado disponible para Fase 3 y mediante StudioDebug, todavía sin sistema de energía.
- [x] 2026-11-28: creador y selección por botones; Flaco→Marcado mediante StudioDebug; reconexión conserva apariencia y no vuelve a preguntar; W mueve/anima; golpes observados en fotogramas; cansado y reaparición correctos. Rechazo de duplicados/nombre inválido. Stats restaurados a 1, Studio en Edit.
- [x] Rojo arrancado en localhost:34872. Tras Connect confirmado, Studio seguía con fuentes antiguas; se aplicó alternativa MCP con las fuentes exactas del repo. No se guardó/publicó ni se crearon copias de lugar.
- [ ] Prueba manual del dueño: `docs/PRUEBA_FASE_2.md`; dos clientes reales y toque real. Musculoso/Bestia verificados por configuración/pruebas locales, aún sin revisión visual en sesión de jugador (Novato tiene tope 100).

## Base ya hecha (versión anterior del gym, se reutiliza en la Fase 3)
- [x] Gym generado desde src: entrada, piso, paredes, ring futuro marcado y ocho puestos (dos de cada tipo), con letreros de ocupación.
- [x] ProximityPrompts y reserva servidor: una persona por puesto, una ronda por jugador; liberación por fin/cancelación, alejamiento, muerte, salida o timeout.
- [x] Cuatro minijuegos con Espacio y botón de pantalla, Theme compartido y aviso de máximo de rango.
- [x] Balance aprobado: 20 s, 5 s de descanso y máximo +4 por stat; parámetros en Training.lua. El servidor limita score, duración, frecuencia y premio, usando PlayerDataService.
- [x] Validaciones locales y Studio: Saco/Fuerza+Velocidad, Caminadora/Stamina, Pesas/Fuerza+Defensa, Pera/Velocidad+Defensa; paneles y resultados correctos, 99→100 y aviso. Resultados simulados desde StudioDebug tras duración real; no se completaron manualmente todas las rondas.
- [x] Entrada real por prompt E, barra de Caminadora y repetición de Pesas con teclado; panel/botón en celular emulado, cancelación mantiene descanso. Stats de prueba restaurados a 1.
- [ ] Prueba manual del dueño con teclado, toque real, dos jugadores y persistencia de premios. Guía histórica: `docs/PRUEBA_GYM_ANTERIOR.md`; el nuevo entrenamiento corresponde a Fase 3.

## Avance de Fase 1
- [x] DataStore con UpdateAsync, autoguardado cada 60 segundos, salida y cierre del servidor.
- [x] Bloqueo por sesión y rechazo de registros inválidos; carga fallida nunca guarda valores iniciales sobre datos existentes.
- [x] Candado ajeno vigente: conserva Cargando, reintenta cada 2 s hasta 30 s; pruebas locales de liberación, vencimiento, timeout sin escrituras y cancelación al salir/cerrar.
- [x] Fuerza, Velocidad, Stamina y Defensa iniciales en 1; topes Novato 100, Amateur 250, Semi-pro 500 (aprobados por el dueño el 2026-11-26).
- [x] Rango y puntos persistidos; atributos del jugador publicados por el servidor.
- [x] HUD simple con tema central y aviso «Tu progreso no se está guardando».
- [x] Validación rápida local con DataStore simulado y mapeo Rojo, sin crear archivos de lugar.
- [x] 2026-11-26 17:12: Play mediante MCP en placeId `111090309292395`; atributos servidor y cliente: cuatro stats en 1, Novato, PuntosRango 0, EstadoDatos Listo.
- [x] 2026-11-26 17:22: MCP confirmó los nueve scripts idénticos al repo, StatsHUD LocalScript y Services.StudioDebug ModuleScript. En Play, StudioDebug BindableFunction funcionó.
- [x] Revisión MCP (104 s): stats iniciales 1/Novato/Listo; Fuerza 37 reflejada en HUD; espera de más de 60 s, Stop/Play y Fuerza 37 conservada; 999 limitado a 100; Fuerza restaurada a 1.
- [x] Revisión MCP de cierre (6 s): Defensa 12 conservada tras Stop inmediato antes de autoguardado; restaurada a 1 y Stop. Todos los stats terminaron en 1.
- [x] HUD inspeccionado visualmente en PC e iPhone 17 Pro emulado, horizontal y vertical: texto legible y sin superposición con los controles táctiles. Simulador devuelto al viewport normal.
- [x] Dueño confirma panel y cierre de Fase 1 el 2026-11-26; prueba del aviso sin API Services trasladada a Fase 7. Guía conservada: `docs/PRUEBA_FASE_1.md`.

## Problemas conocidos
- Resueltos los bloqueos de las 17:12: se usa StudioDebug para acceder a la sesión activa. Studio tenía DOS objetos llamados StarterPlayerScripts (un LocalScript antiguo vacío y el contenedor correcto); se retiró por MCP el duplicado antiguo y se sincronizaron las fuentes exactas del repo. StatsHUD ahora existe y funciona.
- Asset 203785492 localizado en `Plugins/RojoManagedPlugin.rbxm`, `Sounds.Notification`. Es del plugin Rojo; no se encontró en propiedades/scripts del lugar ni en src. Plugin intacto según instrucción del dueño; sus avisos pueden seguir en Output.
- Identidad resuelta: el dueño confirmó el único lugar autorizado, placeId `111090309292395`, universeId `10779249165`. El nombre visible es irrelevante; seleccionar el studio_id cuya entrada MCP tenga ese placeId. No usar otro ID ni un Place1 sin guardar.
- Graphify resuelto el 2026-11-26: instalado temporalmente con Python nativo 3.12 (el Python MSYS causaba incompatibilidad de dependencias). Grafo automático code-only en `graphify-out/GRAPH_REPORT.md`, `graph.json` y `graph.html`; no usa modelos externos. Las tablas de configuración pueden no generar símbolos AST propios.
- El ejecutable `rojo` en PATH es un shim de Rokit sin manifiesto; el sourcemap pasó usando el binario instalado de Rojo 7.7.1 directamente.

## Siguiente paso
Dueño recorre docs/PRUEBA_FASE_2.md y confirma si los golpes se ven bien. Fase 2 sigue abierta hasta esa prueba manual. Para publicar animaciones: docs/SUBIR_ANIMACIONES.md. Modelo/ropa/calzado definitivos en Fase 7; no seguir buscando artículos. Studio quedó en Edit, con material de exportación en ServerStorage, sin guardar/publicar el lugar. No iniciar Fase 3 aún.

## Preguntas pendientes
- Aprobación manual de los movimientos del personaje provisional; V2 ya fue elegido. Arte final no bloquea esta revisión funcional.
- Jugadores por servidor (provisional 12).
- Nombre definitivo del juego.
