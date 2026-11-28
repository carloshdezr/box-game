# Estado actual del proyecto

## Fase actual
Fase 2 abierta. Estilo definitivo de la referencia Roblox + anime; A–D descartadas. Parte A: dos variantes nuevas, frente/lado y Flaco/Bestia en docs/ESTILO_BOXEADOR.md. Calzado y detalles de ropa pendientes; no hay aprobación visual. Parte B no iniciada.

## Checklist de fases
Cada fase tiene su criterio de "terminado". No se pasa a la siguiente sin prueba manual de la persona dueña anotada aquí.

- [x] **Fase 0: idea y diseño.** Criterio: `DISENO_JUEGO.md` completo. Hecho el 2026-11-26.
- [x] **Fase 1: datos y stats.** Criterio: un jugador entra, ve sus 4 stats y su rango, y al salir y volver siguen igual. Cerrada el 2026-11-26: persistencia validada en Studio y dueño confirma que el panel se ve bien y autoriza cierre.
- [ ] **Fase 2: boxeador propio y animaciones.** Criterio: todos entran con el boxeador del juego (no su avatar), con cuerpo clásico Roblox suavizado, robusto y chaparrito, cara caricaturesca, pelo anime, camiseta sin mangas, shorts, guantes grandes y tenis altos según la referencia definitiva; la primera vez eligen tono de piel, cabello, cara y color de shorts y se guarda; el cuerpo crece visiblemente con los stats (niveles de físico); hay animaciones KeyframeSequence (no movidas con código) de guardia, jab, gancho, uppercut, correr y cansado, con peso y giro de cadera; la persona dueña aprueba cómo se ven.
- [ ] **Fase 3: gym jugable.** Criterio: caminadora con W y cinta que cambia de velocidad (te caes si te quedas atrás); saco con clic y golpes animados que mueven el saco; pesas con clic por repetición y ritmo; pera con golpes izquierda/derecha; barra de energía que se gasta y se recupera; stats suben según lo que haces, con límites del servidor y sin pasar el tope del rango. Se reutiliza el gym, la ocupación y el control de premios hechos antes.
- [ ] **Fase 4: combate contra NPC.** Criterio: en el ring puedes pelear 3 rounds contra un NPC con jab, gancho, uppercut, bloquear y esquivar, usando los mismos golpes del saco; las barras de vida y stamina funcionan y la pelea termina con un ganador.
- [ ] **Fase 5: rangos y rivales.** Criterio: ganar peleas da puntos de rango; subes de Novato a Amateur y a Semi-pro; cada rango tiene su rival NPC, su tope de stats y equipo de gym mejor.
- [ ] **Fase 6: PvP 1 contra 1.** Criterio: dos jugadores reales pueden retarse y pelear en el ring con las mismas reglas, y el ganador recibe puntos de rango si son de rangos parecidos.
- [ ] **Fase 7: interfaz y arte (ForgeGUI).** Criterio: HUD, barras, pantallas de rango y creador de personaje con el estilo final; animaciones definitivas subidas por el dueño; texturas de físico por nivel; funcionando en PC y celular.
- [ ] **Fase 8: prepublicación.** Criterio: los NPC ya no dan puntos de rango (solo el ring de práctica, sin puntos), el rango se sube solo con PvP; validaciones anti-trampas en servidor; prueba con dos clientes reales y en celular; lista para publicar.

Después de publicar (fuera de la v1): torneos, más rangos, cosméticos, monedas y tienda.

## Checklist adicional de Fase 8 (prepublicación)
- [ ] Desactivar API Services, comprobar «Tu progreso no se está guardando», rechazo de premios y ausencia de sobrescritura; reactivar y recuperar progreso. Trasladada desde Fase 1 por instrucción del dueño el 2026-11-26.

## Último en trabajar
[codex] · 2026-11-28 03:16. Dos propuestas nuevas con capturas reales y catálogo de 4 caras, 6 peinados y 4 colores, autores y respaldos. Revisiones Play 81 s y 54 s. Ajuste de tenis fallido; fase abierta.

## Rehacer Fase 2: estilo definitivo Roblox + anime
- [x] A–D descartadas por el dueño; comparación anterior conservada como histórica.
- [x] Dos cuerpos de catálogo con HumanoidDescription, capturas de frente/lado junto a la referencia: docs/ESTILO_BOXEADOR.md y su comparación HTML.
- [x] Propuesta de cinco niveles con el mismo cuerpo; capturas de Flaco y Bestia. Cuatro caras, seis peinados, cuatro colores y autoría/respaldo documentados.
- [ ] Resolver tenis deformados/ocultos, camiseta abultada, puños demasiado abiertos y acentos de la referencia. Las capturas no certifican compatibilidad final.
- [ ] Dueño aprueba estilo y escalas. No avanzar a Parte B todavía.
- [ ] Parte B: BoxerRig con HumanoidDescription, apariencia persistida compatible, seis KeyframeSequence y docs/SUBIR_ANIMACIONES.md.
- [ ] Prueba manual y aprobación visual antes de cerrar Fase 2.

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
Revisar docs/ESTILO_BOXEADOR.md y la comparación visual. Resolver el calzado y acordar ajustes de la variante preferida antes de Parte B. Studio quedó en Edit, sin modelos temporales y cámara restaurada; no se guardó/publicó el lugar. Scripts y minijuegos intactos. No iniciar Fase 3.

## Preguntas pendientes
- Preferencia entre las nuevas siluetas V1/V2 y escalas; ¿qué ajustes visuales pide el dueño? No hay aprobación de ninguna. Tenis y detalles de ropa siguen pendientes.
- Jugadores por servidor (provisional 12).
- Nombre definitivo del juego.
