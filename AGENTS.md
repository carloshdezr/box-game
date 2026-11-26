# Reglas del proyecto (para cualquier IA: Claude Code, Codex, etc.)

Este es un juego de Roblox que se construye en equipo de una sola persona, con una o varias IAs. Para no perder el hilo, todas las sesiones siguen este protocolo. La idea es que cualquier IA pueda retomar el trabajo sin preguntar nada.

## Al EMPEZAR cualquier sesión (en este orden)

1. `git pull origin main` antes de tocar nada.
2. Lee `docs/ESTADO.md` (fase actual, qué está hecho, qué sigue, qué está roto).
3. Lee las últimas 3 entradas de `docs/BITACORA.md`.
4. Si vas a tocar diseño o balance, lee `docs/DISENO_JUEGO.md` y `docs/DECISIONES.md`.
5. Revisa `graphify-out/GRAPH_REPORT.md` si existe (mapa del código).

## Durante el trabajo

- Trabaja solo en la fase indicada en `docs/ESTADO.md`. No adelantes fases.
- Todo el código vive en `src/` y se sincroniza a Studio con Rojo. **No edites scripts directamente en Studio**: lo que no está en el repo se pierde.
- La lógica importante va en el servidor (`src/ServerScriptService/`). El cliente solo muestra y pide; nunca decide dinero, resultados ni premios.
- Los valores de balance (precios, probabilidades, tiempos, cantidades) van en `src/ReplicatedStorage/Config/`, no escritos dentro de la lógica.
- Si tomas una decisión de diseño o técnica, anótala en `docs/DECISIONES.md` (qué y por qué).
- Si algo del diseño no está claro, no lo inventes: déjalo como pregunta en `docs/ESTADO.md`, sección "Preguntas pendientes".
- Cambios pequeños y commits frecuentes.

## Lugar de pruebas en Studio (regla obligatoria)

- Existe **un solo lugar de pruebas** en Studio. Se trabaja y se prueba solo ahí.
- **Prohibido crear copias**: nada de archivos `.rbxl`/`.rbxlx` en el repo ni lugares temporales.
- No publiques ni guardes el lugar en Roblox: eso lo hace la persona dueña del proyecto.
- Si el lugar no está abierto, no crees otro. Anota en la bitácora que la prueba en Studio quedó pendiente.

## Regla de pruebas

- La persona dueña del proyecto hace los recorridos completos a mano. Es la prueba que cuenta.
- Las IAs solo hacen validaciones rápidas: **máximo 2 minutos por revisión**, sin recorrer todo el juego.
- Si una revisión se traba, córtala y anótalo en la bitácora. No reintentes indefinidamente.
- Ninguna fase se da por terminada solo porque "pasó la prueba automática": hace falta la prueba manual anotada en `ESTADO.md`.

## Criterio de "terminado" por fase

Cada fase de `ESTADO.md` debe tener una frase de criterio, por ejemplo: "Un jugador puede comprar un item y verlo en su inventario tras reconectarse". Si no se cumple, la fase sigue abierta. No se pasa a la siguiente con pendientes sin anotar.

## Estructura de carpetas

| Carpeta | Qué va ahí |
|---|---|
| `src/ServerScriptService/` | Lógica del servidor. Los módulos van en `Services/`. |
| `src/ReplicatedStorage/Config/` | Configuración y balance compartidos (cliente y servidor). |
| `src/ReplicatedStorage/Remotes/` | Definición de comunicación cliente-servidor (RemoteEvents/Functions). |
| `src/StarterPlayer/StarterPlayerScripts/` | Interfaz y lógica del cliente. |
| `docs/` | Documentación viva: estado, bitácora, decisiones y diseño. |
| `tools/` | Scripts auxiliares que no son del juego. |

## Al TERMINAR (obligatorio, aunque la sesión sea corta)

1. Agrega una entrada NUEVA al inicio de `docs/BITACORA.md` con este formato:

```
## AAAA-MM-DD HH:MM · [claude] o [codex] · Fase N o Diseño
- Qué hice:
- Archivos tocados:
- Cómo probarlo:
- Qué quedó mal o pendiente:
- Siguiente paso recomendado:
```

2. Actualiza `docs/ESTADO.md` (fase actual, checklist, problemas conocidos, siguiente paso).
3. Si cambió la estructura del proyecto, regenera el grafo (graphify) y confirma que `graphify-out/` quedó actualizado.
4. `git add`, `git commit` con prefijo `[claude]` o `[codex]` y `git push`.

## Ramas y commits

- Nadie trabaja directo en `main`. Cada fase tiene su rama: `fase-N-tema` (por ejemplo `fase-1-inventario`).
- Al terminar la fase: sube la rama, abre un Pull Request a `main` y, si las validaciones rápidas pasan, júntalo y borra la rama.
- Prefijo del commit con la IA que lo hizo: `[claude]`, `[codex]`, etc.
- Si no puedes abrir el PR (sin `gh` o sin acceso), deja la rama subida, anótalo en la bitácora y avisa a la persona dueña.

## Reglas para no pisarnos

- Antes de empezar, lee la bitácora completa de las últimas entradas, no solo la tuya.
- No reescribas lo que hizo una sesión anterior sin motivo. Si algo está mal, anótalo y arréglalo con un commit aparte.
- Si al juntar hay conflicto en `docs/BITACORA.md` o `docs/ESTADO.md`, conserva las entradas de ambos.
