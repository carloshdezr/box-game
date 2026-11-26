# Decisiones

## 2026-11-26 · [claude] · Estructura del repo
- **Qué:** repo en Git con Rojo para sincronizar `src/` a Studio. El código vive en el repo; Studio solo sirve para probar.
- **Por qué:** en el proyecto de oaxacos, lo que se editaba directo en Studio se perdía o se desfasaba. Con el repo como fuente única, cualquier IA puede retomar el trabajo leyendo los archivos.
- **Qué:** una sola persona dueña del proyecto, con varias IAs posibles. Se conservan las reglas de bitácora, estado y ramas por fase, pero sin la división entre frontend y backend, porque no hay dos personas.
- **Por qué:** el protocolo de oaxacos evitó que las IAs se pisaran. Para un proyecto individual, lo que más se pierde es el hilo entre sesiones, así que eso se protege.
- **Qué:** cada fase tiene un criterio de "terminado" en una frase, y no pasa a la siguiente sin prueba manual anotada.
- **Por qué:** en oaxacos la mayoría de las fases quedaron con pendientes de prueba manual ("faltan dos clientes, celular y API"). Un criterio claro evita arrastrar pendientes.
- **Qué:** no se guardan archivos `.rbxl`/`.rbxlx` en el repo (ver `.gitignore`).
- **Por qué:** cada copia de lugar aparece en la lista de experiencias y confunde.
