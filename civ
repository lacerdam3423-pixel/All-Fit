-- LocalScript (coloque em StarterPlayerScripts)
-- Vers茫o sem GUI, totalmente edit谩vel e otimizada.
-- N脙O cont茅m fun莽玫es para for莽ar pickups ou burlar limites do jogo.
wait("0.1")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- ========== CONFIGURA脟脙O (edite aqui) ==========
local SETTINGS = {
	-- C芒mera / Zoom / FOV
	MinZoom = 0,            -- Zoom m铆nimo (cliente)
	MaxZoom = 7,          -- Zoom m谩ximo (cliente)
	FOV = 220,              -- Campo de vis茫o (cliente)
	ThirdPerson = true,     -- for莽a Third Person no cliente (quando permitido)

	-- Bright mode / lighting
	BrightMode = true,
	Brightness = 2.7,
	Ambient = Color3.fromRGB(255,255,255),
	OutdoorAmbient = Color3.fromRGB(255,255,255),


	-- Anti-lag (seguro: n茫o altera texturas)
	AntiLag = true,         -- desativa efeitos caros (Bloom, Blur, SunRays, DoF, etc)
	EnvironmentDiffuseScale = 0,  -- n茫o obrigat贸rio, ajustar se quiser
	EnvironmentSpecularScale = 0, -- n茫o obrigat贸rio, ajustar se quiser

	-- Loop / performance
	LoopDelay = 0.01,       -- intervalo desejado entre reaplica莽玫es (segundos)
}
-- ================================================

-- estado interno para evitar escritas desnecess谩rias
local state = {
	camera = Workspace.CurrentCamera,
	applied = {
		minZoom = nil,
		maxZoom = nil,
		fov = nil,
		brightness = nil,
		ambient = nil,
		outdoorAmbient = nil,
		antilag = nil,
		thirdPerson = nil,
	},
}

-- safe pcall helper
local function safe(fn, ...)
	local ok, res = pcall(fn, ...)
	if not ok then
		-- opcional: comentar para DEBUG
		-- warn("UC_SAFE:", res)
	end
	return ok, res
end

-- Texture Optimizer + FPS Unlock

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")

-- FPS desbloqueado
settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01

-- Iluminação simples
Lighting.Technology = Enum.Technology.Future
Lighting.GlobalShadows = false
Lighting.Brightness = 3

-- Remover raios de sol se existir
for _,v in pairs(Lighting:GetChildren()) do
	if v:IsA("SunRaysEffect") then
		v:Destroy()
	end
end

-- Preload apenas de texturas
local assets = {}

for _,v in pairs(Workspace:GetDescendants()) do
	if v:IsA("Texture") or v:IsA("Decal") then
		if v.Texture and v.Texture ~= "" then
			table.insert(assets, v.Texture)
		end
	end
end

pcall(function()
	ContentProvider:PreloadAsync(assets)
end)

-- Anti-lag leve
task.spawn(function()
	while true do
		for _,v in pairs(Workspace:GetDescendants()) do
			if v:IsA("ParticleEmitter") and v.Rate > 120 then
				v.Rate = 120
			end
		end
		task.wait(2)
	end
end)

-- Manter FPS alto
RunService.RenderStepped:Connect(function()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
end)

wait ("0.1")
--// Auto Inventory Enable + Auto Reequip System
--// LuaU | LocalScript | FE Safe
--// Coloque em StarterPlayerScripts

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")

-- Força o inventário padrão ativado
pcall(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
end)

-- Tabela para salvar ferramentas
local savedTools = {}

-- Função para salvar itens
local function saveInventory()
	savedTools = {}
	for _, tool in ipairs(Backpack:GetChildren()) do
		if tool:IsA("Tool") then
			table.insert(savedTools, tool.Name)
		end
	end
	
	if player.Character then
		for _, tool in ipairs(player.Character:GetChildren()) do
			if tool:IsA("Tool") then
				table.insert(savedTools, tool.Name)
			end
		end
	end
end

-- Função para restaurar itens
local function restoreInventory()
	for _, toolName in ipairs(savedTools) do
		local tool = Backpack:FindFirstChild(toolName)
		if tool then
			tool.Parent = Backpack
		else
			-- tenta pegar do StarterPack
			local sp = game:GetService("StarterPack"):FindFirstChild(toolName)
			if sp then
				local clone = sp:Clone()
				clone.Parent = Backpack
			end
		end
	end
end

-- Detecta morte
local function onCharacter(char)
	local humanoid = char:WaitForChild("Humanoid")

	-- salva antes de morrer
	humanoid.Died:Connect(function()
		saveInventory()
	end)
end

-- Detecta respawn
player.CharacterAdded:Connect(function(char)
	onCharacter(char)
	task.wait(0.01)
	restoreInventory()
end)

-- Inicialização
if player.Character then
	onCharacter(player.Character)
end

-- Garante que o inventário sempre fique ativo
task.spawn(function()
	while true do
		pcall(function()
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
		end)
		task.wait(0.01)
	end
end)

--// UNIVERSAL SPEED GUI COM MINIMIZAR
-- LocalScript

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- CONFIGURA脟脮ES EDIT脕VEIS
local LOOP_TIME = 0.01
local MIN_SPEED = 10
local MAX_SPEED = 200

local currentSpeed = 34

-- Aplicar velocidade continuamente
local function speedLoop()
	while true do
		task.wait(LOOP_TIME)
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.WalkSpeed = currentSpeed
		end
	end
end

-- Criar GUI principal
local gui = Instance.new("ScreenGui")
gui.Name = "Speed Gui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 140)
frame.Position = UDim2.new(0.5, -120, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- T铆tulo
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 5, 0, 0)
title.BackgroundTransparency = 1
title.Text = "馃憖"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.Parent = frame

-- Bot茫o minimizar
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Position = UDim2.new(1, -30, 0, 2)
minimize.Text = "-"
minimize.TextScaled = true
minimize.BackgroundColor3 = Color3.fromRGB(200,80,80)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Parent = frame

Instance.new("UICorner", minimize).CornerRadius = UDim.new(1,0)

-- Caixa de texto
local box = Instance.new("TextBox")
box.Size = UDim2.new(0.8, 0, 0, 40)
box.Position = UDim2.new(0.1, 0, 0.4, 0)
box.PlaceholderText = "Type Speed"
box.Text = ""
box.TextScaled = true
box.BackgroundColor3 = Color3.fromRGB(50,50,50)
box.TextColor3 = Color3.new(1,1,1)
box.ClearTextOnFocus = false
box.Parent = frame

Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)

-- Bot茫o aplicar
local apply = Instance.new("TextButton")
apply.Size = UDim2.new(0.8, 0, 0, 35)
apply.Position = UDim2.new(0.1, 0, 0.75, -5)
apply.Text = "Apply"
apply.TextScaled = true
apply.BackgroundColor3 = Color3.fromRGB(0,170,255)
apply.TextColor3 = Color3.new(1,1,1)
apply.Parent = frame

Instance.new("UICorner", apply).CornerRadius = UDim.new(0,8)

-- Bot茫o pequeno (abre novamente)
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(0, 20, 0.5, -25)
openButton.Text = "☢️"
openButton.TextScaled = true
openButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
openButton.TextColor3 = Color3.new(1,1,1)
openButton.Visible = false
openButton.Active = true
openButton.Draggable = true
openButton.Parent = gui

Instance.new("UICorner", openButton).CornerRadius = UDim.new(1,0)

-- Aplicar Speed
apply.MouseButton1Click:Connect(function()
	local value = tonumber(box.Text)
	if value then
		value = math.clamp(value, MIN_SPEED, MAX_SPEED)
		currentSpeed = value
		box.Text = tostring(value)
	end
end)

-- Minimizar
minimize.MouseButton1Click:Connect(function()
	frame.Visible = false
	openButton.Visible = true
end)

-- Reabrir
openButton.MouseButton1Click:Connect(function()
	frame.Visible = true
	openButton.Visible = false
end)

-- Reaplicar quando morrer
player.CharacterAdded:Connect(function(character)
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = currentSpeed
end)

-- Iniciar loop
task.spawn(speedLoop)

--[[ 
    HITBOX SYSTEM LEG脥TIMO
    Centro da tela + 脕rea exclusiva de arrastar
    Atualiza莽茫o 0.03
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ================= CONFIG =================
local UPDATE_LOOP = 0.01
local HITBOX_SIZE = Vector3.new(35,35,35)
local TARGET_PART_NAME = "HumanoidRootPart"
local TRANSPARENCY = 0.99
local COLOR = Color3.fromRGB(255,0,0)
-- ==========================================

local enabled = false
local modifiedParts = {}

-- SALVAR ORIGINAL
local function saveOriginal(part)
	if not modifiedParts[part] then
		modifiedParts[part] = {
			Size = part.Size,
			Transparency = part.Transparency,
			Color = part.Color,
			Material = part.Material
		}
	end
end

-- APLICAR HITBOX
local function applyHitbox(character)
	local part = character:FindFirstChild(TARGET_PART_NAME)
	if part then
		saveOriginal(part)
		part.Size = HITBOX_SIZE
		part.Transparency = TRANSPARENCY
		part.Color = COLOR
		part.Material = Enum.Material.Neon
	end
end

-- RESTAURAR
local function restoreAll()
	for part, original in pairs(modifiedParts) do
		if part and part.Parent then
			part.Size = original.Size
			part.Transparency = original.Transparency
			part.Color = original.Color
			part.Material = original.Material
		end
	end
	modifiedParts = {}
end

-- LOOP 0.03
task.spawn(function()
	while true do
		if enabled then
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= player and plr.Character then
					applyHitbox(plr.Character)
				end
			end
		end
		task.wait(UPDATE_LOOP)
	end
end)

-- AUTO REAPLICAR
local function setupPlayer(plr)
	plr.CharacterAdded:Connect(function(char)
		if enabled then
			task.wait(0.1)
			applyHitbox(char)
		end
	end)
end

for _, plr in pairs(Players:GetPlayers()) do
	if plr ~= player then
		setupPlayer(plr)
	end
end

Players.PlayerAdded:Connect(setupPlayer)

-- ================= GUI =================

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- FRAME PRINCIPAL (CENTRO DA TELA)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,200,0,100)
mainFrame.Position = UDim2.new(0.5,-100,0.5,-50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = false

-- 脕REA DE ARRASTAR (BARRA SUPERIOR)
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1,0,0,30)
dragBar.BackgroundColor3 = Color3.fromRGB(45,45,45)
dragBar.Parent = mainFrame

local dragLabel = Instance.new("TextLabel")
dragLabel.Size = UDim2.new(1,0,1,0)
dragLabel.BackgroundTransparency = 1
dragLabel.Text = "Dr"
dragLabel.TextColor3 = Color3.new(1,1,1)
dragLabel.TextScaled = true
dragLabel.Parent = dragBar

-- SISTEMA DE ARRASTAR (MOBILE)
local dragging = false
local dragInput
local dragStart
local startPos

dragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch 
	or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

dragBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch 
	or input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- BOT脙O TOGGLE
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.9,0,0,40)
toggleButton.Position = UDim2.new(0.05,0,0.5,-10)
toggleButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.TextScaled = true
toggleButton.Text = "OFF"
toggleButton.Parent = mainFrame

toggleButton.MouseButton1Click:Connect(function()
	enabled = not enabled
	
	if enabled then
		toggleButton.Text = "ON"
		toggleButton.BackgroundColor3 = Color3.fromRGB(0,170,0)
	else
		toggleButton.Text = "OFF"
		toggleButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
		restoreAll()
	end
end)

--// UNIVERSAL MOBILE - INFINITE JUMP + TOUCH DRAG ENABLE
--// Feito para juntar com outros scripts
--// LocalScript

-- Servi莽os
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Vari谩veis
local InfiniteJumpEnabled = true

-- Fun莽茫o para pegar personagem
local function GetCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if not InfiniteJumpEnabled then return end
    
    local character = GetCharacter()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Sempre permitir arrastar tela (mobile)
if UserInputService.TouchEnabled then
    UserInputService.TouchMoved:Connect(function(touch, processed)
        if processed then return end
        -- N茫o bloqueia nenhum movimento de c芒mera
        -- Apenas garante que o toque continue funcionando
    end)
end

-- Reaplica ao respawn
player.CharacterAdded:Connect(function()
    task.wait(0.01)
end)

print("鉁? Infinite Jump Mobile Ativo")

--// UNIVERSAL BRIGHT MODE (SEM INTERFERIR NO CICLO PADR脙O)

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- CONFIGURA脟脙O (TOTALMENTE EDIT脕VEL)
local Config = {
	Brightness = 3, -- brilho geral
	Ambient = Color3.fromRGB(255, 255, 255),
	OutdoorAmbient = Color3.fromRGB(255, 255, 255),
	EnvironmentDiffuseScale = 0,
	EnvironmentSpecularScale = 0,
	RemoveGlobalShadows = true
}

-- Fun莽茫o que aplica o Bright Mode
local function ApplyBrightMode()
	if Config.RemoveGlobalShadows then
		Lighting.GlobalShadows = false
	end
	
	Lighting.Brightness = Config.Brightness
	Lighting.Ambient = Config.Ambient
	Lighting.OutdoorAmbient = Config.OutdoorAmbient
	Lighting.EnvironmentDiffuseScale = Config.EnvironmentDiffuseScale
	Lighting.EnvironmentSpecularScale = Config.EnvironmentSpecularScale
end

-- Aplicar ao iniciar
ApplyBrightMode()

-- Reaplicar constantemente sem afetar o ClockTime
RunService.RenderStepped:Connect(function()
	ApplyBrightMode()
end)

-- Caso o jogo tente mudar algo
Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function()
	if Config.RemoveGlobalShadows then
		Lighting.GlobalShadows = false
	end
end)

Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
	if Lighting.Brightness ~= Config.Brightness then
		Lighting.Brightness = Config.Brightness
	end
end)

-- NoFog Universal Permanente (LocalScript)

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- Valores desejados (sem fog)
local function applyNoFog()
	Lighting.FogStart = 1000000
	Lighting.FogEnd = 1000000
	Lighting.FogColor = Color3.fromRGB(255, 255, 255)
end

-- Aplicar imediatamente
applyNoFog()

-- Reaplicar constantemente (caso o jogo tente mudar)
RunService.RenderStepped:Connect(function()
	if Lighting.FogEnd < 999999 then
		applyNoFog()
	end
end)

-- Tamb茅m detectar quando algum valor mudar
Lighting:GetPropertyChangedSignal("FogEnd"):Connect(applyNoFog)
Lighting:GetPropertyChangedSignal("FogStart"):Connect(applyNoFog)

-- Desativa efeitos caros (idempotente)
local function cleanEffects()
	if not SETTINGS.AntiLag then return end
	safe(function()
		Lighting.GlobalShadows = false
		-- reduz escalas ambientais (seguros)
		if Lighting.EnvironmentDiffuseScale ~= nil then
			Lighting.EnvironmentDiffuseScale = SETTINGS.EnvironmentDiffuseScale
		end
		if Lighting.EnvironmentSpecularScale ~= nil then
			Lighting.EnvironmentSpecularScale = SETTINGS.EnvironmentSpecularScale
		end

		for _, v in ipairs(Lighting:GetChildren()) do
			-- desativar efeitos visuais pesados sem remover
			if v:IsA("BloomEffect")
			or v:IsA("BlurEffect")
			or v:IsA("SunRaysEffect")
			or v:IsA("DepthOfFieldEffect")
			or v:IsA("ColorCorrectionEffect")
			or v:IsA("SunRaysEffect")
			or v:IsA("Atmosphere") then
				-- alguns jogos esperam que existam esses objetos; apenas desativa se puder
				if pcall(function() v.Enabled = false end) then end
			end
		end
	end)
end

-- Aplica Bright Mode (sem quebrar ciclo)
local function applyBright()
	if not SETTINGS.BrightMode then return end
	safe(function()
		Lighting.Brightness = SETTINGS.Brightness
		Lighting.Ambient = SETTINGS.Ambient
		Lighting.OutdoorAmbient = SETTINGS.OutdoorAmbient
	end)
end

-- Aplica zoom, FOV e ThirdPerson (somente quando necess谩rio)
local function applyCameraSettings()
	if not player then return end
	safe(function()
		-- garante camera atual
		state.camera = Workspace.CurrentCamera or state.camera

		-- Zoom (cliente)
		if player.CameraMinZoomDistance ~= SETTINGS.MinZoom then
			player.CameraMinZoomDistance = SETTINGS.MinZoom
			state.applied.minZoom = SETTINGS.MinZoom
		end
		if player.CameraMaxZoomDistance ~= SETTINGS.MaxZoom then
			player.CameraMaxZoomDistance = SETTINGS.MaxZoom
			state.applied.maxZoom = SETTINGS.MaxZoom
		end

		-- FOV
		if state.camera and state.camera.FieldOfView ~= SETTINGS.FOV then
			state.camera.FieldOfView = SETTINGS.FOV
			state.applied.fov = SETTINGS.FOV
		end

		-- Third Person (cliente): n茫o garante comportamento do servidor
		if SETTINGS.ThirdPerson then
			-- CameraMode 茅 uma propriedade do Player (cliente)
			if player.CameraMode ~= Enum.CameraMode.Classic then
				player.CameraMode = Enum.CameraMode.Classic
				state.applied.thirdPerson = true
			end
		end
	end)
end

-- Handler para efeitos criados dinamicamente (desativa efeitos que aparecem depois)
local function onLightingChildAdded(child)
	-- desativa imediatamente se for um efeito considerado pesado
	if not SETTINGS.AntiLag then return end
	if child:IsA("BloomEffect")
	or child:IsA("BlurEffect")
	or child:IsA("SunRaysEffect")
	or child:IsA("DepthOfFieldEffect")
	or child:IsA("ColorCorrectionEffect")
	or child:IsA("Atmosphere") then
		safe(function() child.Enabled = false end)
	end
end

-- Aplica tudo quando necess谩rio (minimiza opera莽玫es)
local function applyAllIfNeeded()
	-- c芒mera/zoom/fov
	applyCameraSettings()

-- Remover C茅u Universal (LocalScript)

local function removeSky()
	for _, v in pairs(Lighting:GetChildren()) do
		if v:IsA("Sky") then
			v:Destroy()
		end
	end
end

-- Remove o c茅u atual
removeSky()

-- Detecta se adicionarem outro Sky e remove automaticamente
Lighting.ChildAdded:Connect(function(child)
	if child:IsA("Sky") then
		task.wait()
		child:Destroy()
	end
end)

	-- bright + anti-lag
	if SETTINGS.BrightMode then
		if state.applied.brightness ~= SETTINGS.Brightness
		or state.applied.ambient ~= SETTINGS.Ambient
		or state.applied.outdoorAmbient ~= SETTINGS.OutdoorAmbient then
			applyBright()
			state.applied.brightness = SETTINGS.Brightness
			state.applied.ambient = SETTINGS.Ambient
			state.applied.outdoorAmbient = SETTINGS.OutdoorAmbient
		end
	end

	if SETTINGS.AntiLag and state.applied.antilag ~= true then
		cleanEffects()
		state.applied.antilag = true
	end

	-- tenta garantir controle de c芒mera
	ensureCameraControl()
end

-- ========== Loop otimizado usando Heartbeat ==========
-- usa Heartbeat e executa no intervalo definido em SETTINGS.LoopDelay
do
	local last = 0
	RunSe
