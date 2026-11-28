# Graph Report - box-game  (2026-11-28)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 122 nodes · 170 edges · 17 communities (9 shown, 8 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 19 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f6eacd46`
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
- Community 14

## God Nodes (most connected - your core abstractions)
1. `load()` - 8 edges
2. `save()` - 8 edges
3. `task.wait()` - 7 edges
4. `Training.Start()` - 7 edges
5. `finish()` - 5 edges
6. `Training.Begin()` - 5 edges
7. `Rig.Scale()` - 5 edges
8. `publish()` - 4 edges
9. `Service.SetAppearance()` - 4 edges
10. `Service.Start()` - 4 edges

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

## Communities (17 total, 8 thin omitted)

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

### Community 5 - "Community 5"
Cohesion: 0.22
Nodes (3): Rig.AssemblePreview(), updatePreview(), task.spawn()

### Community 12 - "Community 12"
Cohesion: 0.36
Nodes (4): Animations.Bind(), asset(), Sequences.Build(), Sequences.Export()

### Community 13 - "Community 13"
Cohesion: 0.40
Nodes (7): key(), Rig.Create(), Rig.Description(), Rig.Dress(), Rig.Gloves(), Rig.Scale(), Physique.Resolve()

### Community 14 - "Community 14"
Cohesion: 0.67
Nodes (3): copy(), setup(), signal()

## Knowledge Gaps
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `task.spawn()` connect `Community 5` to `Community 0`, `Community 3`?**
  _High betweenness centrality (0.135) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `load()` (e.g. with `Schema.New()` and `task.wait()`) actually correct?**
  _`load()` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Why does `updatePreview()` connect `Community 5` to `Community 8`?**
  _High betweenness centrality (0.125) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `save()` (e.g. with `Schema.Validate()` and `task.wait()`) actually correct?**
  _`save()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Why does `Training.Start()` connect `Community 3` to `Community 0`, `Community 5`?**
  _High betweenness centrality (0.110) - this node is a cross-community bridge._
- **Are the 6 inferred relationships involving `task.wait()` (e.g. with `finish()` and `load()`) actually correct?**
  _`task.wait()` has 6 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `Training.Start()` (e.g. with `task.spawn()` and `task.wait()`) actually correct?**
  _`Training.Start()` has 2 INFERRED edges - model-reasoned connections that need verification._