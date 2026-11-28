# Prueba manual — Fase 2: boxeador y animaciones

Solo **placeId 111090309292395**. La IA sincroniza; el dueño no necesita terminal. No guardar/publicar ni crear copias. El gym anterior sigue intacto y se rehace en Fase 3; su guía histórica está en `PRUEBA_GYM_ANTERIOR.md`.

1. **Entrar:** Play; esperar `EstadoDatos = Listo`. Debe aparecer un boxeador R15 con shorts, vendas y tenis, sin accesorios del avatar personal. Si nunca elegiste apariencia, verás el creador con vista previa. Pulsar cada opción cambia piel, cabello, cara y shorts; confirmar una vez.
2. **Persistencia:** Stop y Play. Debe conservar la apariencia y no preguntar de nuevo. La IA dejó piel Media, Cresta, Sonrisa y shorts Azules en la cuenta de pruebas. Para recorrer otra vez la primera elección, usar otro jugador de prueba sin registro; no borrar datos existentes. La IA puede preparar ese paso.
3. **Movimiento y poses:** caminar con WASD y saltar; quieto levanta los puños en guardia. Clic izquierdo alterna jab/gancho; clic derecho hace uppercut. Esperar a que termine el golpe anterior. No cambian vida ni stats. En celular hay botones Golpear/Uppercut; probar toque real. Durante un minijuego antiguo, sus controles conservan prioridad.
4. **Crecimiento:** pedir a la IA que use StudioDebug, o desde la barra de comandos **Server** ejecutar el bloque siguiente. Cambiar `valor` de 1 a 25 y luego 75 o 100: Flaco → Atlético → Marcado. Hombros, brazos, torso y piernas crecen en vivo. Comparar también subiendo solo Fuerza. Con dos clientes, confirmar que el otro ve físico y golpes.

```lua
local valor = 75
local debug = game.ServerScriptService.StudioDebug
for _, stat in ipairs({"Fuerza", "Velocidad", "Stamina", "Defensa"}) do
    assert(debug:Invoke("SetStat", nil, stat, valor))
end
```

5. **Cansado y reaparición:** la energía pertenece a Fase 3. Para ver la pose sin cambiar stats: `game.ServerScriptService.StudioDebug:Invoke("Pose", nil, "Cansado")`. Quitarla con `:Invoke("Pose", nil, nil)`. Reset Character debe reaparecer como boxeador y conservar apariencia.
6. **Cerrar:** restaurar los cuatro stats con el bloque anterior y `valor = 1`, quitar PoseDebug y Stop. Anotar fecha y resultados en ESTADO; la Fase 2 solo se cierra con la prueba manual del dueño.

## Físicos y límites

Promedio de los cuatro stats: Flaco 1, Atlético 25, Marcado 75, Musculoso 150, Bestia 300. Fuerza agrega hasta 0.2 al multiplicador de anchura del torso y brazos. Tamaños/umbrales en `Config/Physique.lua`, opciones en `Appearance.lua` y tiempos en `Boxer.lua`.

Novato no pasa de 100. Musculoso/Bestia están implementados y sus umbrales se verificaron localmente, pero no son alcanzables por un jugador Novato; los ascensos se implementan después. No cambiar rangos ni saltarse topes para esta prueba.

## Revisión rápida de IA — 2026-11-28

- **50 s:** creador visible, R15 sano, selección mediante botones, guardado inmediato, crecimiento Flaco→Marcado con StudioDebug (torso X 1.53→2.14), clics y restauración a 1.
- **44 s:** reconexión conserva las cuatro elecciones y oculta creador; W mueve a 16 studs/s y anima piernas; guardia, jab, gancho, uppercut y cansado observados. Captura breve de 3.65 s y fotogramas revisados para distinguir los tres golpes. Reaparición conserva R15/apariencia; servidor rechaza golpe duplicado y nombre inválido. Stats terminaron en 1 y Studio en Edit.
- Sin errores de scripts del juego. Persiste el aviso del asset 203785492 del plugin Rojo, ya identificado anteriormente.
- Pruebas locales: registros v1 sin apariencia conservados, elección válida guardada, rechazo de entradas inválidas, elección inmutable, copia defensiva del snapshot, reconexión y datos corruptos sin sobrescritura; cinco umbrales y regresiones de persistencia/entrenamiento.
- Pendiente: recorrido manual del dueño, dos clientes reales, toque real y valoración visual de proporciones/animaciones. No se verificó automáticamente el aspecto de Musculoso/Bestia en una sesión de jugador.
