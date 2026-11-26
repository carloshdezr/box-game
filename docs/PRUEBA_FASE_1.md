# Prueba manual pendiente: Fase 1

Usar únicamente **box-game pruebas**, sincronizado con `rojo serve default.project.json`. No crear copias ni guardar/publicar desde una IA. Para persistencia real, el lugar debe pertenecer a una experiencia y tener habilitado el acceso a API Services en Studio por su dueño.

1. Entrar: ver Fuerza, Velocidad, Stamina y Defensa en 1, y rango Novato. En el jugador del servidor revisar también `PuntosRango = 0` y `EstadoDatos = "Listo"`.
2. Para probar un cambio real antes de que exista el gym, ejecutar en la barra de comandos **del servidor durante Play**, sin editar scripts:

   ```lua
   local p = game:GetService("Players"):GetPlayers()[1]
   local data = require(game.ServerScriptService.Services.PlayerDataService)
   print(data.SetStat(p, "Fuerza", 37))
   ```

3. Ver Fuerza 37 en la interfaz. Esperar más de 60 segundos para el autoguardado, salir y volver: debe seguir en 37. Cambiar otro stat, detener Play antes del siguiente autoguardado y volver para comprobar el guardado al cerrar.
4. En el servidor, `SetStat(p, "Fuerza", 999)` debe mostrar 100 (tope Novato). Cambiar un atributo directamente no modifica los datos guardados. Restaurar el valor deseado mediante `SetStat`.
5. Con acceso a API Services deshabilitado por el dueño, entrar: aparece exactamente **Tu progreso no se está guardando**. No se permite modificar el progreso con `SetStat`; salir no guarda valores iniciales. Rehabilitar acceso y entrar: recuperar los datos anteriores.
6. Revisar que el panel no tape los controles y se lea en PC y celular. Anotar fecha y resultado en `ESTADO.md`; solo entonces cerrar la fase.

Si queda un bloqueo por un cierre abrupto, esperar hasta 180 segundos y reconectar. Un error de carga no se reintenta durante esa sesión después de los tres intentos iniciales. Los fallos de guardado posteriores sí se reintentan en el siguiente autoguardado; el aviso permanece hasta un guardado exitoso.

## Validación local rápida (sin Studio ni datos reales)

Instalar `fengari` en una carpeta temporal y ejecutar:

```powershell
npm.cmd install --prefix "$env:TEMP/box-game-check" fengari
node tools/check-data.cjs "$env:TEMP/box-game-check/node_modules/fengari"
rojo sourcemap default.project.json --output "$env:TEMP/box-game-sourcemap.json"
```

El simulador comprueba carga, valores iniciales, topes, atributos no autoritativos, autoguardado y recuperación, reconexión, fallos de carga sin escrituras, registros inválidos, bloqueo de otra sesión, lease vencido, pérdida de propiedad y superposición entre carga/salida/cierre. Es una comprobación rápida de lógica y sintaxis Lua compatible; no ejecuta el motor Luau ni valida DataStore real o el aspecto del HUD.
