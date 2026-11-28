-- Authored R15 keyframes. Animator performs interpolation; no per-frame joint writes.
local Settings=require(script.Parent.Config.Boxer)
local Sequences={}
local hierarchy={
 {"HumanoidRootPart",nil}, {"LowerTorso","HumanoidRootPart","Root"},
 {"UpperTorso","LowerTorso","Waist"}, {"Head","UpperTorso","Neck"},
 {"LeftUpperArm","UpperTorso","LeftShoulder"}, {"LeftLowerArm","LeftUpperArm","LeftElbow"},
 {"LeftHand","LeftLowerArm","LeftWrist"}, {"RightUpperArm","UpperTorso","RightShoulder"},
 {"RightLowerArm","RightUpperArm","RightElbow"}, {"RightHand","RightLowerArm","RightWrist"},
 {"LeftUpperLeg","LowerTorso","LeftHip"}, {"LeftLowerLeg","LeftUpperLeg","LeftKnee"},
 {"LeftFoot","LeftLowerLeg","LeftAnkle"}, {"RightUpperLeg","LowerTorso","RightHip"},
 {"RightLowerLeg","RightUpperLeg","RightKnee"}, {"RightFoot","RightLowerLeg","RightAnkle"},
}
local guard={
 Root={0,-12,0}, Waist={-5,8,0}, Neck={0,4,0},
 LeftShoulder={25,-8,-12}, RightShoulder={20,8,12}, LeftElbow={105,0,0},RightElbow={110,0,0},
 LeftHip={-8,0,-4},RightHip={8,0,4},LeftKnee={-12,0,0},RightKnee={-10,0,0},
 LeftAnkle={7,0,0},RightAnkle={5,0,0},
}
-- {normalized time, overrides, vertical root shift, marker}
local clips={
 Guardia={loop=true,frames={
  {0,{},0},{0.25,{LeftKnee={-17},RightKnee={-15},Waist={-6,10}},-0.07},
  {0.5,{},0},{0.75,{LeftKnee={-15},RightKnee={-17},Waist={-4,6}},-0.06},{1,{},0},
 }},
 Jab={frames={
  {0,{},0},{0.16,{Root={0,-18},Waist={-6,-2},LeftShoulder={18,-12,-15},LeftElbow={118}},-0.04,"Anticipacion"},
  {0.34,{Root={0,2},Waist={-9,18},LeftShoulder={87,-5,-3},LeftElbow={8},RightElbow={116},LeftHip={-14}},-0.02,"Impacto"},
  {0.44,{Root={0,4},Waist={-10,20},LeftShoulder={92,-5,-3},LeftElbow={5}},-0.01},
  {0.7,{Root={0,-6},Waist={-6,12},LeftShoulder={50,-8,-9},LeftElbow={72}},-0.03},
  {1,{},0,"Guardia"},
 }},
 Gancho={frames={
  {0,{},0},{0.2,{Root={0,8},Waist={-8,22},RightShoulder={35,25,45},RightElbow={95}},-0.1,"Anticipacion"},
  {0.42,{Root={0,-24},Waist={-5,-32},RightShoulder={85,-45,65},RightElbow={85},RightHip={18,-15}},-0.02,"Impacto"},
  {0.55,{Root={0,-30},Waist={-4,-38},RightShoulder={90,-60,55},RightElbow={95}},0},
  {0.78,{Root={0,-20},Waist={-5,-8},RightShoulder={42,-12,25},RightElbow={108}},-0.04},
  {1,{},0,"Guardia"},
 }},
 Uppercut={frames={
  {0,{},0},{0.23,{Root={0,8},Waist={-18,18},RightShoulder={-10,10,10},RightElbow={60},
    LeftKnee={-35},RightKnee={-30},LeftHip={15},RightHip={22}},-0.2,"Anticipacion"},
  {0.45,{Root={0,-24},Waist={8,-25},RightShoulder={105,-5,15},RightElbow={85},
    LeftKnee={-5},RightKnee={-4},RightHip={-5}},0.08,"Impacto"},
  {0.58,{Root={0,-28},Waist={5,-30},RightShoulder={130,-10,10},RightElbow={75}},0.1},
  {0.8,{Root={0,-18},Waist={-3,-5},RightShoulder={65,0,14},RightElbow={105}},-0.03},
  {1,{},0,"Guardia"},
 }},
 Correr={loop=true,base={
  Root={8,0,0},Waist={-5,0,0},Neck={-3,0,0},LeftElbow={75},RightElbow={75},
  LeftShoulder={-35,0,-5},RightShoulder={40,0,5},
  LeftHip={40},RightHip={-35},LeftKnee={-15},RightKnee={-65},LeftAnkle={5},RightAnkle={20},
 },frames={
  {0,{},0},{0.25,{Root={8,5},Waist={-5,-8},LeftHip={0},RightHip={5},LeftKnee={-65},RightKnee={-20},
   LeftShoulder={0,0,-5},RightShoulder={0,0,5}},0.1},
  {0.5,{Root={8,0},LeftHip={-35},RightHip={40},LeftKnee={-65},RightKnee={-15},
   LeftShoulder={40,0,-5},RightShoulder={-35,0,5},LeftAnkle={20},RightAnkle={5}},0},
  {0.75,{Root={8,-5},Waist={-5,8},LeftHip={5},RightHip={0},LeftKnee={-20},RightKnee={-65},
   LeftShoulder={0,0,-5},RightShoulder={0,0,5}},0.1},{1,{},0},
 }},
 Cansado={loop=true,base={
  Root={0,0,0},Waist={-32,0,0},Neck={15,0,0},
  LeftShoulder={22,0,-8},RightShoulder={22,0,8},LeftElbow={20},RightElbow={20},
  LeftHip={18,0,-5},RightHip={18,0,5},LeftKnee={-28},RightKnee={-28},LeftAnkle={10},RightAnkle={10},
 },frames={{0,{},-0.14},{0.45,{Waist={-35},Neck={18},LeftElbow={24},RightElbow={24}},-0.19},{1,{},-0.14}}},
}
Sequences.Names={"Guardia","Jab","Gancho","Uppercut","Correr","Cansado"}
function Sequences.Build(name)
 local clip=assert(clips[name],"Animación desconocida")
 local sequence=Instance.new("KeyframeSequence")
 sequence.Name,sequence.Loop=name,clip.loop or false
 sequence.Priority=Settings.PunchSeconds[name] and Enum.AnimationPriority.Action or Enum.AnimationPriority.Movement
 local duration=Settings.PunchSeconds[name] or Settings.AnimationSeconds[name]
 for _,frame in ipairs(clip.frames) do
  local keyframe=Instance.new("Keyframe")
  keyframe.Name,keyframe.Time=frame[4] or "Pose",frame[1]*duration
  local poses={}
  for _,bone in ipairs(hierarchy) do
   local pose=Instance.new("Pose")
   pose.Name=bone[1]
   local a=frame[2][bone[3]] or (clip.base or guard)[bone[3]] or {}
   pose.CFrame=CFrame.Angles(math.rad(a[1] or 0),math.rad(a[2] or 0),math.rad(a[3] or 0))
   if bone[3]=="Root" then pose.CFrame=CFrame.new(0,frame[3] or 0,0)*pose.CFrame end
   pose.EasingStyle,pose.EasingDirection=Enum.PoseEasingStyle.Cubic,Enum.PoseEasingDirection.InOut
   pose.Weight=bone[2] and 1 or 0
   pose.Parent=bone[2] and poses[bone[2]] or keyframe
   poses[bone[1]]=pose
  end
  if frame[4] then
   local marker=Instance.new("KeyframeMarker")
   marker.Name=frame[4]
   marker.Parent=keyframe
  end
  sequence:AddKeyframe(keyframe)
 end
 return sequence
end
function Sequences.Export(parent)
 local old=parent:FindFirstChild("BoxerAnimationSequences")
 if old then old:Destroy() end
 local folder=Instance.new("Folder")
 folder.Name="BoxerAnimationSequences"
 for _,name in ipairs(Sequences.Names) do Sequences.Build(name).Parent=folder end
 folder.Parent=parent
 return folder
end
return Sequences
