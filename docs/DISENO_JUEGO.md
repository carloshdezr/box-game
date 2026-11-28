# Diseño del juego: box-game

> Documento vivo. Lo que no esté claro se marca como **(pendiente)** en lugar de inventarlo. Los números reales viven en `src/ReplicatedStorage/Config/`; aquí solo se explica el porqué.

## 1. Idea en una frase
Un juego de boxeo estilo caricatura donde entrenas de verdad en el gym (corres, golpeas el saco, levantas pesas) mientras tu boxeador se pone más grande, para subir tus stats y luego peleas en el ring contra otros jugadores para subir de rango, de Novato a Campeón mundial.

## 2. Jugador y por qué vuelve
- **Quién lo juega:** jugadores de Roblox a los que les gustan los simuladores de gym y los juegos de pelea. Tiene que funcionar en PC y en celular.
- **Por qué vuelve:** siempre hay un rango siguiente, sus stats se guardan, y cada pelea ganada se siente como avance. Entrenar es rápido y divertido, no solo dar clics.

## 3. Mecánica central
Combina dos tipos de juego:
- **Simulador de gym:** entrenar sube tus stats.
- **Juego de pelea:** en el ring gana el que pega y esquiva mejor.

**Regla de oro:** los stats pesan mucho, pero entre dos jugadores de nivel parecido gana el que tiene mejor timing. Un jugador con muchos menos stats casi nunca le gana a uno mucho más fuerte; uno con stats parecidos sí puede ganar jugando mejor.

## 4. Bucle de juego
1. Entrenas en el gym con minijuegos y subes tus stats.
2. Llegas al tope de stats de tu rango (no puedes seguir subiendo hasta ascender).
3. Peleas en el ring para ganar puntos de rango.
4. Al ascender, se desbloquea un tope más alto y equipo de gym mejor.
5. Vuelves al gym, ahora con más fuerza. Y así.

El tope por rango obliga a pelear: no se puede llegar a Campeón solo entrenando sin salir del gym.

## 5. Stats

| Stat | Para qué sirve en la pelea | Dónde se entrena |
|---|---|---|
| Fuerza | Cuánto daño hace cada golpe | Pesas, saco |
| Velocidad | Qué tan rápido sale cada golpe y cuánto tarda en recuperarse | Saco, pera |
| Stamina | Cuántos golpes puedes tirar antes de cansarte, y qué tan rápido te recuperas | Caminadora |
| Defensa | Cuánto daño aguantas y qué tan amplio es el momento para esquivar | Pera (reflejos), pesas |

Todos empiezan en el mismo valor y se guardan entre sesiones.

## 6. Gym jugable (entrenamiento físico)
El gym no son minijuegos de "picarle al verde": tu personaje entrena de verdad y se ve. Lo que haces con las teclas es lo que hace tu boxeador.

### Energía (cansancio)
- Al entrenar aparece una barra de **Energía**. Cada golpe, cada repetición y correr rápido la gastan.
- Con la energía baja, el personaje se mueve más lento, los golpes salen débiles y lo que ganas baja mucho. Si se vacía, tiene que descansar unos segundos (animación de cansado, manos en las rodillas).
- La energía se recupera sola si dejas de entrenar.
- El stat **Stamina** sube tu energía máxima y qué tan rápido se recupera. Así entrenar caminadora te deja entrenar más tiempo lo demás.
- Lo que más rinde es entrenar con ritmo sin agotarte, no machacar el botón.

### Estaciones
| Estación | Cómo se juega | Da |
|---|---|---|
| Caminadora | Te subes y **mantienes W para correr** (en celular, el joystick hacia adelante). La cinta cambia de velocidad (lento, rápido, sprint). Si vas más lento que la cinta te vas hacia atrás y, si llegas al borde, te caes y termina la ronda. Correr al ritmo de la cinta da Stamina; los sprints dan más pero gastan más energía. | Stamina |
| Saco de box | **Clic (o botón) para golpear**. El personaje tira golpes con animación (jab y gancho alternados, uppercut con clic derecho o botón aparte). El saco se mueve con cada golpe. Cada golpe que conecta da stats; cada golpe gasta energía. Mientras más Velocidad, más rápido salen los golpes. | Fuerza y Velocidad |
| Pesas | **Clic por cada repetición**. El personaje levanta la mesa o la barra con animación. Hay que soltar el ritmo correcto: si das clic demasiado rápido la repetición sale mal y gasta energía sin dar nada. El peso sube con el rango. | Fuerza y Defensa |
| Pera de velocidad | Golpes alternados **izquierda y derecha** (clic izquierdo/derecho o dos botones) siguiendo el ritmo de la pera, con animación de golpes rápidos. Mantener la racha da más. | Velocidad y Defensa |

- El saco y la pera usan el **mismo sistema de golpes que el combate** (mismas animaciones y la misma velocidad según tus stats). Así entrenar también es practicar para pelear, y el código se reutiliza en el ring.
- Todo se puede jugar con teclado y mouse, y con botones en celular.
- El servidor controla todo: cuántos golpes o repeticiones caben por segundo según tu Velocidad, la distancia al aparato, la energía y el máximo que se puede ganar por minuto. El cliente nunca manda "gané X".
- Al subir de rango se desbloquea equipo mejor que da más por golpe o repetición (gym de barrio → gym amateur → gym profesional).

## 7. Combate

### Movimientos (v1)
- **Jab:** rápido, poco daño, gasta poca stamina.
- **Gancho:** daño medio, un poco más lento.
- **Uppercut:** mucho daño, lento y gasta mucha stamina; si fallas quedas expuesto.
- **Bloquear:** reduce mucho el daño mientras lo mantienes, pero gasta stamina poco a poco.
- **Esquivar:** si esquivas justo antes de recibir el golpe, no te pega y tu siguiente golpe hace daño extra (contraataque). Aquí está la habilidad.

### Barras durante la pelea
- **Vida:** si llega a cero, KO.
- **Stamina:** cada golpe gasta. Con la stamina vacía pegas más lento y más débil. Se recupera si no atacas.

### Rondas
- 3 rounds de 60 segundos (provisional).
- Gana por KO, o al final por quien hizo más daño.
- Al terminar, los dos quedan con vida completa de nuevo; perder no quita stats.

### Reglas técnicas
- El servidor valida cada golpe: distancia, tiempo entre golpes, stamina y si el otro estaba bloqueando o esquivando.
- Pocos movimientos al principio a propósito: el combate entre jugadores con lag es lo más difícil de hacer bien en Roblox.

## 8. Rangos

| Rango | Cómo se sube |
|---|---|
| Novato | Rango inicial |
| Amateur | Puntos de rango ganando peleas |
| Semi-pro | Puntos de rango |
| Profesional | Puntos de rango |
| Campeón nacional | Puntos de rango |
| Campeón mundial | Puntos de rango |

- Ganar da puntos de rango; perder quita unos pocos (nunca te baja del rango por debajo de cierto punto, para que no frustre).
- Cada rango tiene un tope de stats.
- En la v1 solo se construyen los primeros 3 rangos (Novato, Amateur, Semi-pro). Los demás se agregan después con el mismo sistema.

## 9. NPC y PvP
- **Durante el desarrollo:** se pelea contra boxeadores NPC en el ring, para que la persona dueña pueda practicar y probar solo. Cada rango tiene un rival NPC con estilo propio (uno pega duro, otro es muy rápido, otro se defiende mucho).
- **Antes de publicar:** los NPC dejan de dar puntos de rango. El rango solo se sube peleando contra jugadores reales.
- **Modo práctica (se queda al publicar):** en el juego publicado hay un ring de práctica contra un NPC que **no da puntos de rango**. Sirve para aprender a pelear y para que nadie se quede sin hacer nada en un servidor con poca gente.
- Por eso el código de pelea debe ser el mismo para NPC y jugador: el NPC solo "aprieta los botones" igual que un jugador, así al quitarlo no hay que rehacer nada.
- **PvP:** un jugador reta a otro en el ring (o entra a una fila del ring) y pelean 1 contra 1. Los puntos de rango solo cuentan si los dos son de rangos parecidos, para que nadie suba molestando a novatos.

## 9b. Personaje propio que evoluciona
- **Decisión 2026-11-28:** primero funcional. Fase 2 usa V2 con picos como personaje PROVISIONAL; guantes sujetos a manos, físico visible y KeyframeSequence. El modelo definitivo (encargado o generado en 3D), ropa/calzado y acabado pasan a Fase 7. No buscar más artículos en esta fase.
- No se usan los avatares de Roblox. Todos juegan con un **boxeador del juego** (shorts, vendas o guantes, tenis).
- Al entrar por primera vez, el jugador elige lo básico para no verse igual a todos: tono de piel, cabello, cara y color de shorts.
- **El cuerpo crece con lo que entrenas:** más ancho de hombros y brazos con Fuerza, más definido con el total de stats. Se hace por niveles de físico (por ejemplo flaco → atlético → marcado → musculoso → bestia) ligados a los stats, para que el cambio se note.
- **Aspecto:** ver estilo objetivo en la sección 10. El boxeador se arma con HumanoidDescription y artículos del catálogo de Roblox (cuerpo, cabello, cara, ropa), no con piezas de bloque sueltas.
- **Físico por niveles:** el mismo cuerpo estilo Roblox crece con escala (hombros, brazos y torso más anchos) y, si hay piezas del mismo estilo, con brazos y torso más musculosos por nivel. Debe sentirse el mismo personaje creciendo.
- Los demás jugadores ven tu físico: es la forma de presumir cuánto has entrenado.

### Animaciones
- Golpes (jab, gancho, uppercut), guardia, esquive, correr en la caminadora, levantar pesas, golpes rápidos en la pera, cansado y KO.
- **Plan (cambio del 2026-11-28):** las animaciones moviendo articulaciones con código se ven genéricas, así que se reemplazan ya por animaciones de verdad (KeyframeSequence) con varios cuadros, anticipación, giro de cadera y hombro, peso y regreso a la guardia. La IA las arma en Studio y se prueban ahí mismo. Para usarlas en el juego publicado **la persona dueña tiene que subirlas** con su cuenta (Roblox solo deja usar animaciones del dueño del juego); es un paso corto por animación.
- Opción extra: grabarse a sí mismo haciendo los movimientos y usar la función de animación desde video del editor de animación de Studio, si está disponible, y que la IA la limpie.

## 10. Estilo visual
- **Estilo objetivo (2026-11-28): Roblox con toque anime.** Referencia: `docs/referencias/estilo-objetivo.png`. Cuerpo de Roblox clásico pero suavizado (orillas redondeadas, proporciones chaparritas y robustas, manos y guantes grandes), cara de caricatura expresiva, peinado anime en picos, camiseta sin mangas, shorts de box, guantes de verdad y tenis altos de bota. Colores vivos. No es realista ni de malla con anatomía detallada.
- Gráficos, interfaz e imágenes con **ForgeGUI**.
- Regla aprobada: si ForgeGUI no da modelos 3D o se acaban los créditos, los modelos del gym (saco, caminadora, pesas, ring) se hacen con bloques o se toman gratis del Creator Store (sin scripts), y ForgeGUI se usa para interfaz, íconos y texturas.
- La interfaz va hasta el final (Fase 7): primero que todo funcione con una interfaz simple, luego se pone bonito. Todo el estilo sale de un solo módulo de tema, para cambiar el look en un solo lugar.

## 11. Alcance de la v1
Entra:
- Boxeador propio con elección básica de apariencia y cuerpo que crece con los stats.
- Un gym jugable con las 4 estaciones, energía y animaciones.
- Los 4 stats guardados.
- Ring con combate (5 movimientos, vida, stamina, rounds).
- 3 rangos con tope de stats.
- Peleas contra NPC para probar; PvP 1 contra 1 en el ring.
- Al publicar: rango solo por PvP y un ring de práctica contra NPC sin puntos.

No entra en la v1 (ideas para después, aquí para no perderlas):
- Modo torneo (eliminatoria de 4 u 8 jugadores cada cierto tiempo).
- Rangos Profesional, Campeón nacional y Campeón mundial.
- Cinturones de campeón y cosméticos (guantes, shorts, entradas al ring).
- Monedas del juego y tienda.
- Monetización con Robux (solo cosméticos, nada que dé ventaja en la pelea).
- Recompensa diaria, misiones, ranking.
- Más movimientos (combinaciones, golpe al cuerpo).

## 12. Monetización
No entra en la v1. Cuando entre, la idea es solo cosmética para el boxeador (guantes, shorts, cabello, tatuajes, entradas, efectos) y quizá un boost temporal de entrenamiento. Nada que haga ganar peleas por pagar.

## 13. Preguntas abiertas
- Número máximo de jugadores por servidor (provisional: 12).
- Nombre definitivo del juego.
