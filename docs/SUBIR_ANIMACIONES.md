# Subir las seis animaciones del boxeador

Para **placeId 111090309292395**, universeId 10779249165. No hace falta subir nada para probar en Studio. La persona dueña realiza la publicación de animaciones; la IA no publicó assets ni guardó/publicó el lugar.

## Qué está preparado

La fuente está en `src/ReplicatedStorage/BoxerKeyframes.lua`: construye KeyframeSequence reales con jerarquía R15, poses, tiempos, easing y marcadores. `BoxerAnimations.lua` usa Animator/AnimationTrack; ya no escribe Transform de articulaciones en cada frame.

En Studio, cada cliente registra las secuencias con KeyframeSequenceProvider:RegisterKeyframeSequence. Esos IDs temporales **solo sirven en Studio**. En juego publicado se necesitan los seis IDs de `Config/Boxer.lua → AnimationIds`; actualmente son 0. No publicar el juego con esos ceros.

| Nombre sugerido | Clave de Config | Duración | Loop | Prioridad | Contenido |
|---|---|---:|---|---|---|
| Box_Guardia | Guardia | 1.20 s | Sí | Movement | Rebote, flexión y cambio de peso |
| Box_Jab | Jab | 0.45 s | No | Action | Preparación, extensión izquierda, retorno |
| Box_Gancho | Gancho | 0.60 s | No | Action | Carga derecha, giro de cadera/torso y arco |
| Box_Uppercut | Uppercut | 0.70 s | No | Action | Baja el peso, empuje ascendente y recuperación |
| Box_Correr | Correr | 0.65 s | Sí | Movement | Apoyos alternos, brazos, cadera y rebote |
| Box_Cansado | Cansado | 2.00 s | Sí | Movement | Torso inclinado y respiración |

Los golpes incluyen marcadores Anticipacion, Impacto y Guardia. Todavía no causan daño, gasto de energía ni premios; las fases siguientes reutilizarán estas secuencias.

## Pasos en Studio, sin terminal

1. Detén Play. La IA dejó `ServerStorage → BoxerAnimationExport` con el rig `BoxerAnimationPreview` y `BoxerAnimationSequences`. El rig contiene un ObjectValue `AnimSaves` que apunta a las seis secuencias. Si cerraste Studio sin guardar y ya no está, pide a la IA que ejecute **tools/prepare-animation-editor.lua** por MCP; se reconstruye desde el repo, sin subir nada.
2. Arrastra **solo BoxerAnimationPreview** desde esa carpeta a Workspace. Selecciónalo y abre **Avatar → Animation Editor**. No lo conviertas en StarterCharacter.
3. Abre el menú **⋯** del editor y carga una de las animaciones guardadas del rig (Guardia, Jab, etc.). Comprueba que aparecen los keyframes. Si el editor no reconoce AnimSaves en tu versión de Studio, detente y pide a la IA adaptar el enlace; no recrees la animación a mano ni subas una vacía.
4. Reproduce y revisa el movimiento. Conserva Loop y prioridad de la tabla. El dueño debe aprobar el aspecto antes de dar la fase por cerrada.
5. En **⋯ → Publish to Roblox**, usa el nombre sugerido. En **Creator** elige al propietario de la experiencia; si la experiencia es de un grupo, elige ese grupo. Publica la animación y copia su asset ID.
6. Repite para las seis y pásame los IDs con sus nombres. La IA los escribe en `Config/Boxer.lua`, sincroniza con Rojo y comprueba la carga. No necesitas editar archivos ni ejecutar comandos.
7. Retira el rig de exportación de Workspace al terminar. La carpeta de ServerStorage es material de edición generado, no contenido del juego. La IA también puede limpiar/regenerar esos objetos.

Subir una animación no publica el lugar. No cambies el propietario ni permisos del juego para este paso. Las secuencias deben estar disponibles para esta experiencia bajo su propietario/permisos de Roblox.

## Estado de esta entrega

- Las seis secuencias se crearon y reprodujeron en Studio; estructura de 16 poses R15 por keyframe comprobada.
- Exportación preparada en ServerStorage con seis secuencias y enlace AnimSaves.
- **No se han subido animaciones ni validado el flujo final del editor hasta publicar.** Los IDs permanentes y la prueba en juego publicado siguen pendientes.
- Creador y rig son provisionales. El modelo definitivo de Fase 7 deberá conservar un rig compatible o requerirá adaptar las animaciones.

Referencias oficiales consultadas: [KeyframeSequenceProvider y IDs temporales](https://create.roblox.com/docs/reference/engine/classes/KeyframeSequenceProvider), [guardar/exportar desde Animation Editor](https://create.roblox.com/docs/animation/editor#export-an-animation).
