-- LocalScript (coloque em StarterPlayerScripts)
-- Versão sem GUI, totalmente editável e otimizada.
-- NÃO contém funções para forçar pickups ou burlar limites do jogo.
wait("0.1")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
if not player then return end

-- ========== CONFIGURAÇÃO (edite aqui) ==========
local SETTINGS = {
	-- Câmera / Zoom / FOV
	MinZoom = 2,            -- Zoom mínimo (cliente)
	MaxZoom = 500,          -- Zoom máximo (cliente)
	FOV = 110,              -- Campo de visão (cliente)
	ThirdPerson = true,     -- força Third Person no cliente (quando permitido)

	-- Bright mode / lighting
	BrightMode = true,
	Brightness = 2.5,
	Ambient = Color3.fromRGB(255,255,255),
	OutdoorAmbient = Color3.fromRGB(255,255,255),

	-- Anti-lag (seguro: não altera texturas)
	AntiLag = true,         -- desativa efeitos caros (Bloom, Blur, SunRays, DoF, etc)
	EnvironmentDiffuseScale = 0,  -- não obrigatório, ajustar se quiser
	EnvironmentSpecularScale = 0, -- não obrigatório, ajustar se quiser

	-- Loop / performance
	LoopDelay = 0.01,       -- intervalo desejado entre reaplicações (segundos)
}
-- ================================================

-- estado interno para evitar escritas desnecessárias
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

-- Aplica zoom, FOV e ThirdPerson (somente quando necessário)
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

		-- Third Person (cliente): não garante comportamento do servidor
		if SETTINGS.ThirdPerson then
			-- CameraMode é uma propriedade do Player (cliente)
			if player.CameraMode ~= Enum.CameraMode.Classic then
				player.CameraMode = Enum.CameraMode.Classic
				state.applied.thirdPerson = true
			end
		end
	end)
end

-- Tenta permitir câmera arrastável (somente cliente; jogos podem sobrescrever)
local function ensureCameraControl()
	safe(function()
		state.camera = Workspace.CurrentCamera or state.camera
		if state.camera and state.camera.CameraType ~= Enum.CameraType.Custom then
			-- tentativa local para permitir controle; jogos restritivos podem reescrever
			state.camera.CameraType = Enum.CameraType.Custom
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

-- Aplica tudo quando necessário (minimiza operações)
local function applyAllIfNeeded()
	-- câmera/zoom/fov
	applyCameraSettings()

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

	-- tenta garantir controle de câmera
	ensureCameraControl()
end

-- ========== Loop otimizado usando Heartbeat ==========
-- usa Heartbeat e executa no intervalo definido em SETTINGS.LoopDelay
do
	local last = 0
	RunService.Heartbeat:Connect(function(dt)
		local now = tick()
		-- se passou o delay, executa
		if now - last >= SETTINGS.LoopDelay then
			last = now
			safe(applyAllIfNeeded)
		end
	end)
end

-- ========== Handlers: respawn e troca de câmera ==========
player.CharacterAdded:Connect(function()
	-- pequeno delay para garantir camera/character prontos
	task.wait(0.08)
	safe(applyAllIfNeeded)
end)

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	-- atualiza referência quando o jogo trocar de câmera
	state.camera = Workspace.CurrentCamera
	-- aplica depois de curto delay
	task.wait(0.05)
	safe(applyAllIfNeeded)
end)

-- conexões para efeitos criados dinamicamente
if Lighting then
	Lighting.ChildAdded:Connect(onLightingChildAdded)
end

-- aplica imediato na carga
safe(applyAllIfNeeded)

-- fim do script
