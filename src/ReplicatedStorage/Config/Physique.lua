local Physique = {
 Stats={"Fuerza","Velocidad","Stamina","Defensa"},
 StrengthMaximum=500, StrengthWidthBonus=0.08,
 Levels={
  {Name="Flaco",Minimum=1,Width=0.82,Depth=0.85,Height=0.85},
  {Name="Atlético",Minimum=25,Width=0.94,Depth=0.94,Height=0.86},
  {Name="Marcado",Minimum=75,Width=1,Depth=1,Height=0.87},
  {Name="Musculoso",Minimum=150,Width=1.1,Depth=1.08,Height=0.89},
  {Name="Bestia",Minimum=300,Width=1.2,Depth=1.15,Height=0.92},
 },
}
function Physique.Resolve(data)
 local total=0
 for _,name in ipairs(Physique.Stats) do total=total+(data[name] or 1) end
 local level=Physique.Levels[1]
 for _,candidate in ipairs(Physique.Levels) do
  if total/#Physique.Stats>=candidate.Minimum then level=candidate end
 end
 return level,math.clamp(((data.Fuerza or 1)-1)/(Physique.StrengthMaximum-1),0,1)*Physique.StrengthWidthBonus
end
return Physique
