# Graph Report - box-game  (2026-11-28)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 112 nodes · 157 edges · 14 communities (8 shown, 6 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 16 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `22651cff`
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
- Community 12
- Community 13

## God Nodes (most connected - your core abstractions)
1. `load()` - 8 edges
2. `save()` - 8 edges
3. `task.wait()` - 7 edges
4. `Training.Start()` - 7 edges
5. `finish()` - 5 edges
6. `Training.Begin()` - 5 edges
7. `publish()` - 4 edges
8. `Service.SetAppearance()` - 4 edges
9. `Service.Start()` - 4 edges
10. `update()` - 4 edges

## Surprising Connections (you probably didn't know these)
- `setup()` --calls--> `load()`  [INFERRED]
  tools/check-data.lua → src/ServerScriptService/Services/PlayerDataService.lua
- `Service.Start()` --calls--> `task.spawn()`  [INFERRED]
  src/ServerScriptService/Services/PlayerDataService.lua → tools/check-training.lua
- `Training.Start()` --calls--> `task.wait()`  [INFERRED]
  src/ServerScriptService/Services/TrainingService.lua → tools/check-training.lua
- `Training.Start()` --calls--> `task.spawn()`  [INFERRED]
  src/ServerScriptService/Services/TrainingService.lua → tools/check-training.lua
- `finish()` --calls--> `task.wait()`  [INFERRED]
  src/ServerScriptService/Services/PlayerDataService.lua → tools/check-training.lua

## Import Cycles
- None detected.

## Communities (14 total, 6 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.32
Nodes (11): finish(), load(), publish(), save(), Service.SetAppearance(), Service.SetStat(), Service.Start(), status() (+3 more)

### Community 1 - "Community 1"
Cohesion: 0.18
Nodes (7): files, fs, L, { lua, lauxlib, lualib, to_luastring, to_jsstring }, path, root, scan()

### Community 2 - "Community 2"
Cohesion: 0.29
Nodes (7): held(), hudVisible(), press(), release(), rounded(), stop(), text()

### Community 3 - "Community 3"
Cohesion: 0.36
Nodes (8): allCapped(), near(), notify(), release(), Training.Begin(), Training.Cancel(), Training.Complete(), Training.Start()

### Community 4 - "Community 4"
Cohesion: 0.25
Nodes (4): Appearance.Validate(), Schema.New(), Schema.Validate(), validNumber()

### Community 8 - "Community 8"
Cohesion: 0.12
Nodes (9): joint(), ornament(), Rig.Create(), Rig.Dress(), Rig.Scale(), Physique.Resolve(), Boxer.Start(), updatePreview() (+1 more)

### Community 12 - "Community 12"
Cohesion: 0.60
Nodes (3): angle(), Animations.Bind(), Animations.Sample()

### Community 13 - "Community 13"
Cohesion: 0.67
Nodes (3): copy(), setup(), signal()

## Knowledge Gaps
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `task.wait()` connect `Community 0` to `Community 3`, `Community 5`?**
  _High betweenness centrality (0.167) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `load()` (e.g. with `Schema.New()` and `task.wait()`) actually correct?**
  _`load()` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Should `Community 8` be split into smaller, more focused modules?**
  _Cohesion score 0.11956521739130435 - nodes in this community are weakly interconnected._
- **Why does `Training.Start()` connect `Community 3` to `Community 0`, `Community 5`?**
  _High betweenness centrality (0.120) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `save()` (e.g. with `Schema.Validate()` and `task.wait()`) actually correct?**
  _`save()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Why does `load()` connect `Community 0` to `Community 4`, `Community 13`?**
  _High betweenness centrality (0.091) - this node is a cross-community bridge._
- **Are the 6 inferred relationships involving `task.wait()` (e.g. with `finish()` and `load()`) actually correct?**
  _`task.wait()` has 6 INFERRED edges - model-reasoned connections that need verification._