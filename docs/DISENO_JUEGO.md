# Diseño del juego: box-game

> Documento vivo. Lo que no esté claro se marca como **(pendiente)** en lugar de inventarlo. Los números reales viven en `src/ReplicatedStorage/Config/`; aquí solo se explica el porqué.

## 1. Idea en una frase
Un juego de boxeo estilo caricatura donde entrenas en el gym con minijuegos para subir tus stats y luego peleas en el ring contra otros jugadores para subir de rango, de Novato a Campeón mundial.

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

## 6. Gym y minijuegos
Cada estación es un minijuego corto (unos 15 a 30 segundos por ronda). Hacerlo bien da más stats que hacerlo mal. Esto evita el autoclicker y hace que entrenar sea divertido.

| Estación | Minijuego | Da |
|---|---|---|
| Saco de box | Aparecen golpes (flechas o teclas) al ritmo y hay que darlos a tiempo, tipo juego de ritmo | Fuerza y Velocidad |
| Caminadora | Mantener una barra dentro de la zona verde: si vas muy lento o muy rápido te sales | Stamina |
| Pesas | Una barra se mueve y hay que soltar en el punto exacto; cada repetición más rápida | Fuerza y Defensa |
| Pera de velocidad | Golpes rápidos con precisión: dar en el momento justo varias veces seguidas | Velocidad y Defensa |

- Todo debe poder jugarse con toque en celular, no solo con teclado.
- El servidor decide cuántos stats da cada ronda, según el resultado que valida él mismo. El cliente nunca manda "gané X de fuerza".
- Al subir de rango se desbloquean versiones mejores de cada estación, que dan más por ronda (gym de barrio → gym amateur → gym profesional).

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

## 10. Estilo visual
- Caricatura: colores vivos, personajes de Roblox normales con guantes y shorts, gym con ambiente divertido.
- Gráficos, interfaz e imágenes con **ForgeGUI**.
- Regla aprobada: si ForgeGUI no da modelos 3D o se acaban los créditos, los modelos del gym (saco, caminadora, pesas, ring) se hacen con bloques o se toman gratis del Creator Store (sin scripts), y ForgeGUI se usa para interfaz, íconos y texturas.
- La interfaz va hasta el final (Fase 6): primero que todo funcione con una interfaz simple, luego se pone bonito. Todo el estilo sale de un solo módulo de tema, para cambiar el look en un solo lugar.

## 11. Alcance de la v1
Entra:
- Un gym con las 4 estaciones y sus minijuegos.
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
No entra en la v1. Cuando entre, la idea es solo cosmética (guantes, shorts, entradas, efectos) y quizá un boost temporal de entrenamiento. Nada que haga ganar peleas por pagar.

## 13. Preguntas abiertas
- Número máximo de jugadores por servidor (provisional: 12).
- Nombre definitivo del juego.
