# Decisiones

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
