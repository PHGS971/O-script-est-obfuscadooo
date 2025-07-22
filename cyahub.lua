local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/V5/Source.lua"))()
local brookhavenTool = loadstring(game:HttpGet("https://raw.githubusercontent.com/Laelmano24/brookhaven-tool/refs/heads/main/src/main.luau"))()

local Window = redzlib:MakeWindow({
    Title = "CYA HUB TROLL",
    SubTitle = "by PHGS⚡ and Laelmano24",
    SaveFolder = ""
})

Window:AddMinimizeButton({
  Button = {
    Image = redzlib:GetIcon("rbxassetid://102639810584213"),
    Size = UDim2.fromOffset(60, 60),
    BackgroundTransparency = 0
  },
  Corner = { CornerRadius = UDim.new(0, 6) }
})

-- Tabs
local TabHouse = Window:MakeTab({"House", "home"})
local TabAvatar = Window:MakeTab({"Avatar", "shirt"})
local TabCar = Window:MakeTab({"Carro", "car"})
local TabPlayer = Window:MakeTab({"Player", "user"})

-- Serviços
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local vehicles = workspace:WaitForChild("Vehicles")
local remoteAvatar = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Wear")

if shared.connectCharacter then shared.connectCharacter:Disconnect() end
shared.connectCharacter = LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)

---------------------------
-- TAB: House
---------------------------
TabHouse:AddSection({"Remover o seu banimento da casa"})

TabHouse:AddButton({"Remover o ban da casa", function()
  brookhavenTool:removeBanHouses()
end})

TabHouse:AddToggle({
  Name = "Auto remover ban",
  Flag = "AutoRemoverBan",
  Callback = function(value)
    brookhavenTool:autoRemoveBanHouses(value)
  end
})

---------------------------
-- TAB: Carro
---------------------------
TabCar:AddSection({"Puxar os carros dos jogadores"})

local pullCarValue = ""
local dropdownPullCar = TabCar:AddDropdown({
  Name = "Cars List",
  Options = {},
  Flag = "car_list",
  Callback = function(value)
    pullCarValue = value
  end
})

local function updatePullCars()
  local carNames = {}
  for _, car in ipairs(vehicles:GetChildren()) do
    table.insert(carNames, car.Name)
  end
  dropdownPullCar:Set(carNames)
end

updatePullCars()

TabCar:AddButton({"Atualizar lista", updatePullCars})

TabCar:AddButton({"Puxar o carro", function()
  if pullCarValue and pullCarValue ~= "" then
    brookhavenTool:pullCar(pullCarValue)
  end
end})

---------------------------
-- TAB: Player
---------------------------
TabPlayer:AddSection({"Spectar os jogadores"})

local spectarPlayerValue = ""
local dropdownSpectarPlayers = TabPlayer:AddDropdown({
  Name = "Players List",
  Options = {},
  Flag = "spectar_list",
  Callback = function(value)
    spectarPlayerValue = value
  end
})

local function updatePlayerSpectar()
  local playerNames = {}
  for _, player in ipairs(Players:GetPlayers()) do
    if player.Name ~= LocalPlayer.Name then
      table.insert(playerNames, player.Name)
    end
  end
  dropdownSpectarPlayers:Set(playerNames)
end

updatePlayerSpectar()

TabPlayer:AddButton({"Atualizar lista", updatePlayerSpectar})

TabPlayer:AddToggle({
  Name = "Spectar o jogador",
  Flag = "SpectarJogador",
  Callback = function(value)
    brookhavenTool:spectatePlayer({value, spectarPlayerValue})
  end
})

TabPlayer:AddSection({"Teleportar para os Jogadores"})

TabPlayer:AddToggle({
  Name = "Teleportar para o jogador",
  Flag = "TeleportarJogador",
  Callback = function(enabled)
    if enabled and spectarPlayerValue and spectarPlayerValue ~= "" then
      brookhavenTool:teleportToPlayer(spectarPlayerValue)
    end
  end
})

---------------------------
-- TAB: Avatar
---------------------------
TabAvatar:AddSection({"Copiar o acessório dos jogadores"})

local avatarPlayerValue = ""
local dropdownAvatarPlayers = TabAvatar:AddDropdown({
  Name = "Players List",
  Options = {},
  Flag = "avatar_list",
  Callback = function(value)
    avatarPlayerValue = value
  end
})

local function updatePlayerAvatar()
  local playerNames = {}
  for _, player in ipairs(Players:GetPlayers()) do
    if player.Name ~= LocalPlayer.Name then
      table.insert(playerNames, player.Name)
    end
  end
  dropdownAvatarPlayers:Set(playerNames)
end

updatePlayerAvatar()

TabAvatar:AddButton({"Atualizar lista", updatePlayerAvatar})

TabAvatar:AddButton({"Copiar acessório", function()
  local tabLocal = brookhavenTool:getIdAccessoriesPlayer(LocalPlayer.Name, "brookhaven")
  for _, id in pairs(tabLocal) do
    remoteAvatar:InvokeServer(tonumber(id))
  end

  task.wait(0.5)

  local tabTarget = brookhavenTool:getIdAccessoriesPlayer(avatarPlayerValue, "brookhaven")
  for _, id in pairs(tabTarget) do
    remoteAvatar:InvokeServer(tonumber(id))
  end
end})

---------------------------
-- Remotes RP Name e Bio
---------------------------
game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1RPNam1eTex1t"):FireServer("RolePlayName", "ᴄʏᴀ ʜᴜʙ")
game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1RPNam1eTex1t"):FireServer("RolePlayBio", "by PHGS and Rael")