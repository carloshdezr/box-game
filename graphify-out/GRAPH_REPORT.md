# Graph Report - box-game  (2026-11-26)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 80 nodes · 110 edges · 12 communities (6 shown, 6 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 11 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `c5329972`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Community 0
- Community 1
- Community 2
- Community 3
- Community 4
- Community 5
- Community 8

## God Nodes (most connected - your core abstractions)
1. `load()` - 8 edges
2. `save()` - 7 edges
3. `Training.Start()` - 7 edges
4. `task.wait()` - 7 edges
5. `finish()` - 5 edges
6. `Training.Begin()` - 5 edges
7. `Service.Start()` - 4 edges
8. `update()` - 4 edges
9. `near()` - 4 edges
10. `release()` - 4 edges

## Surprising Connections (you probably didn't know these)
- `setup()` --calls--> `load()`  [INFERRED]
  tools/check-data.lua → src/ServerScriptService/Services/PlayerDataService.lua
- `Service.Start()` --calls--> `task.spawn()`  [INFERRED]
  src/ServerScriptService/Services/PlayerDataService.lua → tools/check-training.lua
- `Training.Start()` --calls--> `task.spawn()`  [INFERRED]
  src/ServerScriptService/Services/TrainingService.lua → tools/check-training.lua
- `Training.Start()` --calls--> `task.wait()`  [INFERRED]
  src/ServerScriptService/Services/TrainingService.lua → tools/check-training.lua
- `finish()` --calls--> `task.wait()`  [INFERRED]
  src/ServerScriptService/Services/PlayerDataService.lua → tools/check-training.lua

## Import Cycles
- None detected.

## Communities (12 total, 6 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.33
Nodes (10): finish(), load(), publish(), save(), Service.SetStat(), Service.Start(), status(), update() (+2 more)

### Community 1 - "Community 1"
Cohesion: 0.18
Nodes (7): files, fs, L, { lua, lauxlib, lualib, to_luastring, to_jsstring }, path, root, scan()

### Community 2 - "Community 2"
Cohesion: 0.25
Nodes (7): held(), hudVisible(), press(), release(), rounded(), stop(), text()

### Community 3 - "Community 3"
Cohesion: 0.36
Nodes (8): allCapped(), near(), notify(), release(), Training.Begin(), Training.Cancel(), Training.Complete(), Training.Start()

### Community 4 - "Community 4"
Cohesion: 0.22
Nodes (3): Schema.New(), Schema.Validate(), validNumber()

### Community 8 - "Community 8"
Cohesion: 0.67
Nodes (3): copy(), setup(), signal()

## Knowledge Gaps
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `task.wait()` connect `Community 0` to `Community 3`, `Community 5`?**
  _High betweenness centrality (0.097) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `load()` (e.g. with `Schema.New()` and `task.wait()`) actually correct?**
  _`load()` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Why does `load()` connect `Community 0` to `Community 8`, `Community 4`?**
  _High betweenness centrality (0.075) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `save()` (e.g. with `Schema.Validate()` and `task.wait()`) actually correct?**
  _`save()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Why does `Training.Start()` connect `Community 3` to `Community 0`, `Community 5`?**
  _High betweenness centrality (0.062) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Training.Start()` (e.g. with `task.spawn()` and `task.wait()`) actually correct?**
  _`Training.Start()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 6 inferred relationships involving `task.wait()` (e.g. with `finish()` and `load()`) actually correct?**
  _`task.wait()` has 6 INFERRED edges - model-reasoned connections that need verification._