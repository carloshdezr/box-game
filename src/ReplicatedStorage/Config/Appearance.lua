local Appearance = {
 Fields = {"Piel", "Cabello", "Cara", "Shorts"},
 Piel = {
  {Name="Clara",Color={244,201,163}}, {Name="Media",Color={190,128,85}}, {Name="Oscura",Color={105,66,48}},
 },
 -- Numeric slots remain compatible with existing saved choices.
 Cabello = {
  {Name="Anime negro",Asset=7963401282}, {Name="Picos cortos",Asset=3814450142},
  {Name="Picos anime",Asset=15364595}, {Name="Negro y azul",Asset=85512507380840},
  {Name="Anime rojo",Asset=8030528948}, {Name="Anime blanco",Asset=14282316652},
 },
 Cara = {
  {Name="Dientes brillantes",Asset=20722130}, {Name="Tranqui",Asset=7074764},
  {Name="Risa tonta",Asset=7699174}, {Name="Sonrisa vencedora",Asset=616380929},
 },
 Shorts = {
  {Name="Rojo",Color={232,66,76},Asset=9726891755}, {Name="Azul",Color={52,121,232},Asset=9726887631},
  {Name="Negro",Color={30,32,38},Asset=9726894557}, {Name="Blanco",Color={235,235,235},Asset=9726900805},
 },
 Default = {Piel=2,Cabello=3,Cara=1,Shorts=3},
}
function Appearance.Validate(value)
 if type(value)~="table" then return false end
 local count=0
 for key,index in pairs(value) do
  count=count+1
  if not table.find(Appearance.Fields,key) or type(index)~="number"
   or index%1~=0 or not Appearance[key][index] then return false end
 end
 return count==#Appearance.Fields
end
return Appearance
