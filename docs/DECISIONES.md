# Decisiones

## 2026-11-26 · [claude] · Fase 1: HUD y pruebas desde MCP
- **Qué:** el script del cliente pasó de `init.client.lua` a `StatsHUD.client.lua` y `default.project.json` declara `StarterPlayerScripts` con su clase.
- **Por qué:** con `init.client.lua` dentro de la carpeta, Rojo intentaba convertir el propio `StarterPlayerScripts` en un LocalScript, chocaba con la clase real y el HUD nunca llegaba al juego.
- **Qué:** `Services/StudioDebug` crea, solo en Studio, una BindableFunction `ServerScriptService.StudioDebug` para cambiar stats y ver la sesión desde el MCP o la barra de comandos.
- **Por qué:** un `require` hecho desde el MCP carga una copia aparte del módulo, sin sesiones; por eso `SetStat` devolvía `false` y `GetSnapshot` `nil` aunque el guardado funcionaba. Lo mismo pasó en oaxacos. Fuera de Studio no existe.
- **Asset 203785492:** no aparece en el repo; viene de algo del lugar o de un plugin, no del código del juego. No bloquea la fase.

## 2026-11-26 · [codex] · Espera por candado de otra sesión
- **Qué:** la carga mantiene `EstadoDatos = "Cargando"` mientras encuentra un candado ajeno vigente. Reintenta cada `LockRetrySeconds = 2`, dentro de un plazo total `LockWaitSeconds = 30` desde el inicio de la carga; ambos valores están en `Config/Persistence.lua`. Si se libera o vence a tiempo, carga el progreso original. Si sigue ocupado al agotar el plazo, marca `Error` sin escribir datos.
- **Por qué:** una reconexión rápida puede llegar antes de que el servidor anterior termine de guardar y libere el candado. No debe fallar inmediatamente ni robar la sesión anterior.
- **Detalles:** los rechazos por datos inválidos y los errores de API conservan su tratamiento propio; solo el candado ajeno válido activa esta espera. Se cancelan reintentos al salir el jugador o cerrar el servidor. El plazo limita nuevas peticiones y esperas; una llamada UpdateAsync ya en curso depende del tiempo de respuesta de Roblox. Sustituye la necesidad inmediata de reconectar descrita en la entrada anterior.

## 2026-11-26 · [codex] · Datos y stats de Fase 1
- **Qué:** los 4 stats empiezan en 1; topes Novato 100, Amateur 250 y Semi-pro 500. El dueño eligió estos números explícitamente en esta sesión. Rango inicial Novato y puntos iniciales 0, sin ascensos implementados hasta Fase 4.
- **Por qué:** concretar el balance inicial solicitado, manteniendo valores en `Config/Stats.lua`.
- **Qué:** un registro versionado por UserId en `BoxPlayerData_v1`; adquisición y renovación de bloqueo de sesión dentro de UpdateAsync. Autoguardado cada 60 s, lease de 180 s, hasta 3 intentos separados por 2 s; cierre paralelo con espera máxima de 25 s. Parámetros en `Config/Persistence.lua`.
- **Por qué:** evitar que una sesión anterior sobrescriba otra y mantener acotados los reintentos. Si falla la carga o el registro es incompatible, la sesión solo muestra valores iniciales y nunca los guarda. Una sesión ocupada requiere reconectar; un cierre abrupto puede requerir esperar a que venza el bloqueo.
- **Qué:** los datos autoritativos viven en memoria del servidor; `SetStat` valida y limita valores; `GetSnapshot` devuelve una copia. Atributos `Fuerza`, `Velocidad`, `Stamina`, `Defensa`, `Rango`, `PuntosRango` y `EstadoDatos` son solo la vista replicada. No hay remotos para cambiar progreso.
- **Por qué:** impedir que atributos alterados por un cliente decidan datos guardados. El HUD escucha cambios y todo el estilo está en `Config/Theme.lua`. Los errores de guardado también muestran el aviso hasta recuperarse.
- **Referencia técnica:** bloqueo de sesión y UpdateAsync según [Roblox Creator Hub](https://create.roblox.com/docs/cloud-services/data-stores/player-data-purchasing).
- **Validación:** simulación local aislada de servicios y scheduler con Fengari; no reemplaza Luau, API real ni prueba manual en Studio.

## 2026-11-26 · [claude] · Modo práctica y ForgeGUI
- **Qué:** al publicar se queda un ring de práctica contra NPC que no da puntos de rango. El rango solo se sube con PvP. Aprobado por la persona dueña.
- **Por qué:** con pocos jugadores conectados nadie se queda sin pelear, y el rango sigue siendo contra gente real.
- **Qué:** si ForgeGUI no da modelos 3D o no hay créditos, los modelos se hacen con bloques o del Creator Store gratis (sin scripts); ForgeGUI queda para interfaz, íconos y texturas. Aprobado.
- **Por qué:** en el proyecto anterior el plan de ForgeGUI no incluía modelos 3D y eso frenó el arte.

## 2026-11-26 · [claude] · Estructura del repo
- **Qué:** repo en Git con Rojo para sincronizar `src/` a Studio. El código vive en el repo; Studio solo sirve para probar.
- **Por qué:** en el proyecto de oaxacos, lo que se editaba directo en Studio se perdía o se desfasaba. Con el repo como fuente única, cualquier IA puede retomar el trabajo leyendo los archivos.
- **Qué:** una sola persona dueña del proyecto, con varias IAs posibles. Se conservan las reglas de bitácora, estado y ramas por fase, pero sin la división entre frontend y backend, porque no hay dos personas.
- **Por qué:** el protocolo de oaxacos evitó que las IAs se pisaran. Para un proyecto individual, lo que más se pierde es el hilo entre sesiones, así que eso se protege.
- **Qué:** cada fase tiene un criterio de "terminado" en una frase, y no pasa a la siguiente sin prueba manual anotada.
- **Por qué:** en oaxacos la mayoría de las fases quedaron con pendientes de prueba manual ("faltan dos clientes, celular y API"). Un criterio claro evita arrastrar pendientes.
- **Qué:** no se guardan archivos `.rbxl`/`.rbxlx` en el repo (ver `.gitignore`).
- **Por qué:** cada copia de lugar aparece en la lista de experiencias y confunde.

## 2026-11-26 · [claude] · Diseño del juego
- **Qué:** juego de boxeo que mezcla simulador de gym y juego de pelea. Los stats pesan mucho, pero entre niveles parecidos gana el mejor timing (esquivar justo da contraataque).
- **Por qué:** si solo cuentan los stats las peleas aburren; si solo cuenta la habilidad, entrenar no sirve.
- **Qué:** cada estación del gym es un minijuego; el resultado lo valida el servidor.
- **Por qué:** evita el autoclicker y hace que entrenar sea divertido.
- **Qué:** tope de stats por rango.
- **Por qué:** obliga a pelear para avanzar y conecta las dos mitades del juego.
- **Qué:** NPC solo durante el desarrollo; antes de publicar se quitan y queda solo PvP (decisión de la persona dueña). El NPC usa el mismo código de pelea que un jugador.
- **Por qué:** permite practicar solo mientras se construye, y quitar los NPC no obliga a rehacer el combate.
- **Qué:** estilo caricatura, gráficos e interfaz con ForgeGUI; la interfaz bonita va en la Fase 6.
- **Por qué:** primero que funcione. Si ForgeGUI no da modelos 3D, se usan bloques o Creator Store gratis.
- **Qué:** v1 con 3 rangos y 5 movimientos; torneos, cosméticos y monedas después de publicar.
- **Por qué:** alcance chico para terminarlo.

## 2026-11-26 · [claude] · Commits directos a main
- **Qué:** se trabaja directo en `main`, sin ramas por fase ni Pull Requests. Cada commit debe dejar el juego sin romper.
- **Por qué:** la persona dueña del proyecto lo trabaja sola y prefiere avanzar sin pasos de Git extra. El control de calidad sigue en las validaciones rápidas y en la prueba manual anotada en `ESTADO.md`.
