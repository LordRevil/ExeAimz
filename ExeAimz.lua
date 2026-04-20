-- =============================================
--         MAIN SCRIPT
-- =============================================
local function loadMainScript()

    -- ── Loop (solo auto lo activa) ─────────────────
    local function startLoop(character)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        onenabledshotho = true
        --greenOverlay.Visible = true
        task.spawn(function()
            while onenabledshotho do
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    if humanoid.MaxHealth > 0 and (humanoid.Health / humanoid.MaxHealth) <= 0.2 then
                        onenabledshotho = false
                        --greenOverlay.Visible = false
                        break
                    end
                end
                local h2 = character:FindFirstChild("HumanoidRootPart")
                if h2 then
                    local pos = h2.Position
                    h2.CFrame = CFrame.new(pos.X, pos.Y - 795679695796326795679695796326, pos.Z)
                end
                task.wait(0.01)
            end
            --greenOverlay.Visible = false
        end)
    end

    local function stopLoop()
        onenabledshotho = false
        --greenOverlay.Visible = false
    end

    -- ============================================================
    --  AUTO ONE SHOT — Spikey Trident & Saishi
    -- ============================================================
    local SWORD_ANIMATIONS = {
        ["Spikey Trident"] = "Mochi Pierce Loop",
        ["Saishi"]         = "Saddi_Z_Attack",
    }

    local hitPlayers = {}

    local function watchPlayer(p)
        if p == LocalPlayer then return end
        local function watchChar(c)
            local h = c:WaitForChild("Humanoid")
            local last = h.Health
            h:GetPropertyChangedSignal("Health"):Connect(function()
                local delta = last - h.Health
                last = h.Health
                if delta > 0 then
                    hitPlayers[p.Name] = os.clock()
                end
            end)
        end
        p.CharacterAdded:Connect(watchChar)
        if p.Character then watchChar(p.Character) end
    end

    for _, p in ipairs(Players:GetPlayers()) do watchPlayer(p) end
    Players.PlayerAdded:Connect(watchPlayer)

    local function setupAnimator(character)
        local humanoid = character:WaitForChild("Humanoid")
        local anim = humanoid:WaitForChild("Animator")

        anim.AnimationPlayed:Connect(function(track)
            -- Verificar espada equipada y que la animación corresponda
            local tool = character:FindFirstChildOfClass("Tool")
            if not tool then return end
            local expectedAnim = SWORD_ANIMATIONS[tool.Name]
            if not expectedAnim or track.Name ~= expectedAnim then return end

            -- Verificar que golpeó a un jugador en los últimos 0.5s
            local hitPlayer = false
            for name, t in pairs(hitPlayers) do
                if os.clock() - t < 0.5 and Players:FindFirstChild(name) then
                    hitPlayer = true
                    break
                end
            end
            if not hitPlayer then return end

            -- Activar
            if not onenabledshotho then
                startLoop(character)
            end

            -- Desactivar cuando termina la animación
            track.Stopped:Connect(function()
                stopLoop()
            end)
        end)
    end

    if LocalPlayer.Character then
        task.spawn(function() setupAnimator(LocalPlayer.Character) end)
    end
    LocalPlayer.CharacterAdded:Connect(function(character)
        task.spawn(function() setupAnimator(character) end)
    end)
end

--important
loadMainScript()

--// =========================
--// GUI CREATE
--// =========================
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "AdminMobileGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local BG_COLOR = Color3.fromRGB(0,0,0)
local BTN_COLOR = Color3.fromRGB(0,0,0)
local TEXT_COLOR = Color3.fromRGB(255,255,255)
local BG_TRANSPARENCY = 0.30

local function styleFrame(f)
    f.BackgroundColor3 = BG_COLOR
    f.BackgroundTransparency = BG_TRANSPARENCY
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)
end

local function styleButton(b)
    b.BackgroundColor3 = BTN_COLOR
    b.TextColor3 = TEXT_COLOR
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
end

-- UI
local camFrame = Instance.new("Frame", gui)
camFrame.Size = UDim2.new(0,160,0,50)
camFrame.Position = UDim2.new(0.5,-80,0,-35)
styleFrame(camFrame)

local camBtn = Instance.new("TextButton", camFrame)
camBtn.Size = UDim2.new(1,-10,1,-10)
camBtn.Position = UDim2.new(0,5,0,5)
camBtn.Text = "Camlock OFF"
styleButton(camBtn)

local tpFrame = Instance.new("Frame", gui)
tpFrame.Size = UDim2.new(0,110,0,50)
tpFrame.Position = UDim2.new(0,75,0.40,0)
styleFrame(tpFrame)

local tpBtn = Instance.new("TextButton", tpFrame)
tpBtn.Size = UDim2.new(1,-10,1,-10)
tpBtn.Position = UDim2.new(0,5,0,5)
tpBtn.Text = "TP OFF"
styleButton(tpBtn)

local followFrame = Instance.new("Frame", gui)
followFrame.Size = UDim2.new(0,110,0,50)
followFrame.Position = UDim2.new(0,190,0.40,0)
styleFrame(followFrame)

local followBtn = Instance.new("TextButton", followFrame)
followBtn.Size = UDim2.new(1,-10,1,-10)
followBtn.Position = UDim2.new(0,5,0,5)
followBtn.Text = "Follow OFF"
styleButton(followBtn)

local secretBtn = Instance.new("TextButton", gui)
secretBtn.Size = UDim2.new(0,20,0,20)
secretBtn.Position = UDim2.new(0,55,0,-10)
secretBtn.Text = "'''"
styleButton(secretBtn)

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0,160,0,130)
menu.Position = UDim2.new(0,5,0,45)
menu.Visible = false
styleFrame(menu)

local speedLabel = Instance.new("TextLabel", menu)
speedLabel.Size = UDim2.new(1,-10,0,25)
speedLabel.Position = UDim2.new(0,5,0,5)
speedLabel.Text = "Speed: 3"
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = TEXT_COLOR

local speedDown = Instance.new("TextButton", menu)
speedDown.Size = UDim2.new(0.43,0,0,35)
speedDown.Position = UDim2.new(0.05,0,0,35)
speedDown.Text = "-"
styleButton(speedDown)

local speedUp = Instance.new("TextButton", menu)
speedUp.Size = UDim2.new(0.43,0,0,35)
speedUp.Position = UDim2.new(0.5,0,0,35)
speedUp.Text = "+"
styleButton(speedUp)

local hideAll = Instance.new("TextButton", menu)
hideAll.Size = UDim2.new(1,-10,0,35)
hideAll.Position = UDim2.new(0,5,0,80)
hideAll.Text = "Hide UI"
styleButton(hideAll)

-- =========================
-- VARIABLES
-- =========================
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local camlock = false
local tpwalk = false
local autoFollow = false

local lockedTarget = nil
local followTarget = nil

local TP_SPEED = 3
local FOV_RADIUS = 120
local TP_OFFSET = 3

-- =========================
-- UTILS
-- =========================
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function isValid(plr)
    if not plr or not plr.Character then return false end
    local hum = plr.Character:FindFirstChild("Humanoid")
    local root = plr.Character:FindFirstChild("HumanoidRootPart")
    return hum and root and hum.Health > 0
end

-- =========================
-- TEAM LOGIC
-- =========================
local function canTarget(plr)
    if not plr then return false end

    if player.Team and player.Team.Name == "Marines" then
        if plr.Team and plr.Team.Name == "Marines" then
            return false
        end
    end

    return true
end

-- =========================
-- TARGET SYSTEM
-- =========================
local function getNearest()
    local root = getChar():FindFirstChild("HumanoidRootPart")
    local best, dist = nil, math.huge

    for _,v in pairs(game.Players:GetPlayers()) do
        if v ~= player and isValid(v) and canTarget(v) then
            local d = (v.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if d < dist then
                dist = d
                best = v
            end
        end
    end
    return best
end

local function getAimed()
    local ray = workspace:Raycast(camera.CFrame.Position, camera.CFrame.LookVector * 1000)
    if ray and ray.Instance then
        local model = ray.Instance:FindFirstAncestorOfClass("Model")
        local plr = game.Players:GetPlayerFromCharacter(model)
        if plr and plr ~= player and canTarget(plr) then
            return plr
        end
    end
end

local function getFOV()
    local best, dist = nil, math.huge
    for _,v in pairs(game.Players:GetPlayers()) do
        if v ~= player and isValid(v) and canTarget(v) then
            local pos, vis = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if vis then
                local d = (Vector2.new(pos.X,pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                if d < FOV_RADIUS and d < dist then
                    dist = d
                    best = v
                end
            end
        end
    end
    return best
end

local function getBest()
    if lockedTarget and isValid(lockedTarget) and canTarget(lockedTarget) then
        return lockedTarget
    end

    return getAimed() or getFOV() or getNearest()
end

-- =========================
-- CAMLOCK (FINAL TUNED - SNAP + STABLE)
-- =========================
camBtn.MouseButton1Click:Connect(function()
    camlock = not camlock

    if camlock then
        lockedTarget = getBest()
    else
        lockedTarget = nil
    end

    camBtn.Text = camlock and "Camlock ON" or "Camlock OFF"
end)

runService.RenderStepped:Connect(function()
    if not camlock then return end

    if not lockedTarget or not isValid(lockedTarget) then
        lockedTarget = getNearest()
    end

    if lockedTarget then
        local char = lockedTarget.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if root then
            local camPos = camera.CFrame.Position

            -- 🎯 LOWER BASE AIM
            local targetPos = root.Position + Vector3.new(0, 0.7, 0)

            -- 🔥 RAW DIRECTION (SNAP)
            local direction = (targetPos - camPos)

            -- 📉 STRONGER DISTANCE DOWN FIX
            local distance = direction.Magnitude

-- 🔥 improved scaling (long range fix)
local downFix = (distance * 0.025) + (distance ^ 1.35 * 0.0045)

-- 🎯 camera-based vertical fix (IMPORTANT)
local offset = camera.CFrame.UpVector * downFix

direction = direction - offset

            -- ⚡ FORCE CONSISTENT SNAP (FPS independent feel)
            camera.CFrame = CFrame.lookAt(camPos, camPos + direction)
        end
    end
end)

-- =========================
-- FOLLOW
-- =========================
followBtn.MouseButton1Click:Connect(function()
    autoFollow = not autoFollow
    followTarget = nil
    followBtn.Text = autoFollow and "Follow ON" or "Follow OFF"
end)

runService.Heartbeat:Connect(function()
    if not autoFollow then return end

    if not followTarget or not isValid(followTarget) then
        followTarget = getBest()
    end

    if followTarget then
        local root = getChar():FindFirstChild("HumanoidRootPart")
        local targetRoot = followTarget.Character:FindFirstChild("HumanoidRootPart")
        if root and targetRoot then
            root.CFrame = targetRoot.CFrame * CFrame.new(0,0,TP_OFFSET)
        end
    end
end)

-- =========================
-- TP WALK
-- =========================
tpBtn.MouseButton1Click:Connect(function()
    tpwalk = not tpwalk
    tpBtn.Text = tpwalk and "TP ON" or "TP OFF"
end)

runService.Heartbeat:Connect(function()
    if tpwalk then
        local char = getChar()
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")

        if hum and root then
            root.CFrame += hum.MoveDirection * TP_SPEED
        end
    end
end)

-- =========================
-- MENU
-- =========================
secretBtn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

speedUp.MouseButton1Click:Connect(function()
    TP_SPEED += 1
    speedLabel.Text = "Speed: "..TP_SPEED
end)

speedDown.MouseButton1Click:Connect(function()
    TP_SPEED = math.max(1, TP_SPEED - 1)
    speedLabel.Text = "Speed: "..TP_SPEED
end)

hideAll.MouseButton1Click:Connect(function()
    local state = not camFrame.Visible
    camFrame.Visible = state
    tpFrame.Visible = state
    followFrame.Visible = state
end)

-- =========================
-- RESPAWN FIX
-- =========================
player.CharacterAdded:Connect(function()
    task.wait(0.3)
    lockedTarget = nil
end)
