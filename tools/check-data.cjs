// Run with: node tools/check-data.cjs <path to installed fengari module>
// Isolated Lua simulation: no Roblox API calls and no real player data.
const fs = require('fs');
const path = require('path');
const { lua, lauxlib, lualib, to_luastring, to_jsstring } = require(process.argv[2] || 'fengari');
const root = path.resolve(__dirname, '..');
const source = file => fs.readFileSync(path.join(root, file), 'utf8');
const L = lauxlib.luaL_newstate();
lualib.luaL_openlibs(L);
// Syntax-check every game script (the project deliberately uses portable Lua syntax).
function scan(dir) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const file = path.join(dir, entry.name);
    if (entry.isDirectory()) scan(file);
    else if (file.endsWith('.lua')) {
      if (lauxlib.luaL_loadstring(L, to_luastring(fs.readFileSync(file, 'utf8'))) !== lua.LUA_OK)
        throw new Error(to_jsstring(lua.lua_tostring(L, -1)));
      lua.lua_pop(L, 1);
    }
  }
}
scan(path.join(root, 'src'));
const files = {
  statsSource: 'src/ReplicatedStorage/Config/Stats.lua',
  appearanceSource: 'src/ReplicatedStorage/Config/Appearance.lua',
  physiqueSource: 'src/ReplicatedStorage/Config/Physique.lua',
  configSource: 'src/ReplicatedStorage/Config/Persistence.lua',
  schemaSource: 'src/ServerScriptService/Services/PlayerDataSchema.lua',
  serviceSource: 'src/ServerScriptService/Services/PlayerDataService.lua',
  trainingSource: 'src/ServerScriptService/Services/TrainingService.lua',
  trainingConfigSource: 'src/ReplicatedStorage/Config/Training.lua',
};
const program = Object.entries(files).map(([key, file]) => `${key} = [====[${source(file)}]====]`).join('\n')
  + '\n' + source('tools/check-data.lua') + '\n' + source('tools/check-training.lua');
if (lauxlib.luaL_dostring(L, to_luastring(program)) !== lua.LUA_OK)
  throw new Error(to_jsstring(lua.lua_tostring(L, -1)));
