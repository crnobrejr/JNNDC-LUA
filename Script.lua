-- =========================================================
--               JNNDC HUB • DESIGN & FIX LOOPS
-- =========================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

if not game:IsLoaded() then game.Loaded:Wait() end

local pGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not pGui then return end

if pGui:FindFirstChild("JNNDC_RspyHub") then 
    pGui["JNNDC_RspyHub"]:Destroy() 
end

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)

-- Tabela para guardar e cancelar os loops ativados
local Tasks = {}

local function PararTarefa(nome)
    if Tasks[nome] then
        task.cancel(Tasks[nome])
        Tasks[nome] = nil
    end
end

-- Interface Gráfica
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local OpenBtn = Instance.new("TextButton")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "JNNDC_RspyHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = pGui

MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 270, 0, 240)
MainFrame.Position = UDim2.new(0.5, -135, 0.4, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

UIStroke.Parent = MainFrame
UIStroke.Thickness = 2.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

task.spawn(function()
    local hue = 0
    while MainFrame and MainFrame.Parent do
        hue = (hue + 0.005) % 1
        UIStroke.Color = Color3.fromHSV(hue, 1, 1)
        task.wait(0.03)
    end
end)

TitleFrame.Size = UDim2.new(1, 0, 0, 40)
TitleFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleFrame.Parent = MainFrame
Instance.new("UICorner", TitleFrame).CornerRadius = UDim.new(0, 10)

Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "JNNDC HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TitleFrame

MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -38, 0, 2)
MinimizeBtn.Text = "-"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Parent = TitleFrame

OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = ScreenGui
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OpenBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Text = "JN"
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 204)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 14
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 10)

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Parent = OpenBtn
OpenStroke.Thickness = 2
task.spawn(function()
    local hue = 0
    while OpenBtn and OpenBtn.Parent do
        hue = (hue + 0.005) % 1
        OpenStroke.Color = Color3.fromHSV(hue, 1, 1)
        task.wait(0.03)
    end
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- Criador de Linhas Simétricas e Perfeitamente Alinhadas
local function CriarLinhaOpcao(id, texto, posY, callback)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 0, 32)
    Label.Position = UDim2.new(0.06, 0, 0, posY)
    Label.Text = texto
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.BackgroundTransparency = 1
    Label.Parent = MainFrame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.20, 0, 0, 26)
    Btn.Position = UDim2.new(0.74, 0, 0, posY + 3)
    Btn.Text = "OFF"
    Btn.BackgroundColor3 = Color3.fromRGB(200, 30, 40)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.Parent = MainFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local estado = false
    Btn.MouseButton1Click:Connect(function()
        estado = not estado
        if estado then
            Btn.Text = "ON"
            Btn.BackgroundColor3 = Color3.fromRGB(30, 190, 70)
            callback(true, id)
        else
            Btn.Text = "OFF"
            Btn.BackgroundColor3 = Color3.fromRGB(200, 30, 40)
            PararTarefa(id)
            callback(false, id)
        end
    end)
end

-- =========================================================
--                    FUNÇÕES DO MAPA
-- =========================================================

-- 1. Auto Click
CriarLinhaOpcao("AutoClick", "⚡ Auto Click", 48, function(ativo, id)
    if ativo then
        Tasks[id] = task.spawn(function()
            local clickRemote = ReplicatedStorage:WaitForChild("KeyClickRequest", 3)
            while true do
                pcall(function()
                    if clickRemote then
                        clickRemote:FireServer()
                    else
                        ReplicatedStorage.KeyClickRequest:FireServer()
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

-- 2. Open Egg
CriarLinhaOpcao("OpenEgg", "🥚 Open Egg", 93, function(ativo, id)
    if ativo then
        Tasks[id] = task.spawn(function()
            while true do
                pcall(function()
                    if Remotes and Remotes:FindFirstChild("OpenEgg") then
                        Remotes.OpenEgg:InvokeServer("Overgrown", 1)
                    end
                end)
                task.wait(2)
            end
        end)
    end
end)

-- 3. Auto Rebirth
CriarLinhaOpcao("AutoRebirth", "🌟 Auto Rebirth", 138, function(ativo, id)
    if ativo then
        Tasks[id] = task.spawn(function()
            while true do
                pcall(function()
                    if Remotes and Remotes:FindFirstChild("RequestRebirth") then
                        Remotes.RequestRebirth:FireServer()
                    end
                end)
                task.wait(2)
            end
        end)
    end
end)

-- 4. Auto Win
CriarLinhaOpcao("AutoWin", "🏆 Auto Win", 183, function(ativo, id)
    if ativo then
        Tasks[id] = task.spawn(function()
            local posExata = CFrame.new(197, 1.20000148, 488.44223, -1, 0, 0, 0, 1, 0, 0, 0, -1)
            while true do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.CFrame = posExata
                        end
                    end
                end)
                task.wait(2)
            end
        end)
    end
end)

print("🔥 JNNDC HUB CORRIGIDO COM SUCESSO!")

