# Prueba manual — Fase 2 provisional y KeyframeSequence

Solo **placeId 111090309292395**. La IA sincroniza con Rojo; el dueño no necesita terminal. No crear copias ni publicar el lugar. El modelo final, ropa y calzado definitivos pertenecen a Fase 7.

1. **Entrar:** Play y esperar EstadoDatos = Listo. Debe entrar el cuerpo provisional V2 con peinado en picos, cara, camiseta/shorts y guantes pequeños sujetos a cada mano. Nunca el avatar personal.
2. **Apariencia:** si el jugador no eligió, el creador permite tres tonos, seis pelos, cuatro caras y cuatro shorts. Confirmar una vez; Stop/Play conserva la elección y oculta el creador. Con un jugador que ya eligió no debe preguntar de nuevo. No borrar datos para forzar esta prueba: pedir a la IA una cuenta de prueba sin registro.
3. **Guardia y movimiento:** quieto rebota en guardia; caminar con WASD reproduce Correr. Saltar y reaparecer no deben romper el personaje. Las poses de salto/caída específicas quedan fuera de estas seis animaciones.
4. **Golpes:** clic izquierdo alterna jab/gancho; clic derecho hace uppercut. Hay anticipación, giro y vuelta a guardia. Los guantes siguen las manos sin quedarse en cintura ni tapar el cuerpo. No deben cambiar vida ni stats. En celular, usar Golpear/Uppercut. Durante el minijuego antiguo sus controles conservan prioridad.
5. **Físico:** pedir a la IA alternar Flaco/Bestia con StudioDebug. El modo visual de prueba no altera datos ni rango y permite ver Bestia siendo Novato. Hombros, brazos y torso de Bestia deben ser claramente más anchos; guantes conservan tamaño limitado.
6. **Cansado:** pedir a la IA activar y quitar Pose Cansado. Todavía no hay energía real; corresponde a Fase 3.
7. **Dos clientes:** verificar que ambos ven físico y golpes del otro. Cada cliente reproduce KeyframeSequence según atributos autorizados por el servidor. Probar además en dispositivo táctil real.
8. **Terminar:** quitar overrides visuales y Stop. No restaurar stats a 1 indiscriminadamente: conservar los valores previos del jugador. Anotar fecha/resultado del recorrido manual en ESTADO.

## Comandos que puede ejecutar la IA por MCP, contexto Server

```lua
local debug = game.ServerScriptService.StudioDebug
debug:Invoke("Physique", nil, "Flaco")
debug:Invoke("Physique", nil, "Bestia")
debug:Invoke("Physique", nil, nil) -- vuelve al físico de los stats guardados
debug:Invoke("Pose", nil, "Cansado")
debug:Invoke("Pose", nil, nil)
```

Para comprobar crecimiento real, usar SetStat dentro del tope del rango y restaurar el snapshot inicial. Physique es solo una ayuda visual de Studio: nunca modifica el DataStore. No alterar rangos para probar Bestia.

## Resultado rápido de IA — 2026-11-28

- Revisión 1, 35 s: apariencia guardada conservada (Media, Picos anime, Dientes brillantes, Azul); guantes con error de unión 0; Flaco → Bestia en vivo. Torso X 1.620 → 2.465 y brazo X 0.623 → 0.948, aproximadamente +52 %. Se encontró Animate estándar mezclándose y se corrigió.
- Revisión 2, 61 s: reconexión conserva apariencia y oculta creador; solo controlador propio. Guardia, Jab, Gancho, Uppercut, Correr y Cansado cargados; poses observadas, incluidos fotogramas detenidos de los golpes. Guantes siguen las manos con error 0. No se evaluó con captura la fluidez completa de todos los ciclos.
- Solo aviso previo del asset 203785492 del plugin Rojo, sin errores nuevos del juego.
- Stats previos y finales: Fuerza 1, Velocidad 2, Stamina 1, Defensa 2. No se cambió el progreso persistido.
- Pruebas locales: sintaxis, persistencia/validación de apariencia, opciones nuevas, límites, cinco umbrales y regresiones del entrenamiento. Rojo sincronizado y sourcemap correcto.
- Pendiente: aprobación manual del dueño, primera selección completa con jugador nuevo en esta versión, dos clientes reales, toque real y animaciones subidas para el juego publicado.
