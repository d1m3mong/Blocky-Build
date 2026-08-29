local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SnippetService = game:GetService("SnippetService")
local troveModule = require(ReplicatedStorage.Packages.trove)
local WinnerTable = require(ReplicatedStorage.Shared.Game.WinnerTable)
local Packets = require(ReplicatedStorage.Shared.Packets)

local player = Players.LocalPlayer

local camera: Camera = workspace.CurrentCamera

local trove = troveModule.new()

local PodiumFolder = workspace:FindFirstChild("PodiumFolder")
if not PodiumFolder then
	PodiumFolder = trove:Add(Instance.new("Folder"))
	PodiumFolder.Name = "PodiumFolder"

	PodiumFolder.Parent = workspace
end

const PodiumOrigin = CFrame.new(0, 20, 0)
const PodiumSpacing = 4

const cameraTransitionTime = 2
const displayDuration = 6

const cameraOffset = Vector3.new(0, 6, 30)

type winnerData = { UserId: number, Votes: number }
type winnersData = { winnerData }

local function getSlotOffset(placement: number)
	if placement == 1 then
		return 0
	end

	local half = math.floor(placement / 2)

	if placement % 2 == 0 then
		return -half
	else
		return half
	end
end

local function getFacingDirection(offset: Vector3): Enum.NormalId
	if math.abs(offset.Z) >= math.abs(offset.X) then
		return offset.Z > 0 and Enum.NormalId.Back or Enum.NormalId.Front
	else
		return offset.X > 0 and Enum.NormalId.Right or Enum.NormalId.Left
	end
end

local function createSurface(block: Part, entry: winnerData, eventTrove: typeof(troveModule.new()))
	local success, playerName = pcall(Players.GetNameFromUserIdAsync, Players, entry.UserId)
	if not success or not playerName then
		playerName = "?"
	end

	local surfaceGui = eventTrove:Add(Instance.new("SurfaceGui"))
	surfaceGui.Name = "PodiumGui"
	surfaceGui.Face = getFacingDirection(cameraOffset)
	surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
	surfaceGui.PixelsPerStud = 50
	surfaceGui.CanvasSize = Vector2.new(200, 100)
	surfaceGui.AlwaysOnTop = true

	local nameLabel = eventTrove:Add(Instance.new("TextLabel"))
	nameLabel.Size = UDim2.fromScale(1, 0.5)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.Text = playerName
	nameLabel.Parent = surfaceGui
	nameLabel.Font = Enum.Font.FredokaOne

	local votesLabel = eventTrove:Add(Instance.new("TextLabel"))
	votesLabel.Size = UDim2.fromScale(1, 0.5)
	votesLabel.Position = UDim2.fromScale(0, 0.5)
	votesLabel.BackgroundTransparency = 1
	votesLabel.TextScaled = true
	votesLabel.Text = tostring(entry.Votes) .. " Votes"
	votesLabel.Parent = surfaceGui
	votesLabel.Font = Enum.Font.FredokaOne

	surfaceGui.Parent = block
end

local function createPodium(data: winnersData, eventTrove: typeof(troveModule.new())): ()
	-- block[1] smallest, block[2] highest, block[3] middle

	local blocks = {}

	for i = 1, #data do
		local height = math.max(1, math.ceil(data[i].Votes / #Players:GetPlayers()))

		local block = eventTrove:Add(Instance.new("Part"))
		block.Name = tostring(i)

		block.Size = Vector3.new(5, height, 5)

		local xOffset = getSlotOffset(i) * PodiumSpacing
		block.CFrame = PodiumOrigin * CFrame.new(xOffset, height / 2, 0)

		block.Anchored = true

		createSurface(block, data[i], eventTrove)

		block.Parent = PodiumFolder

		blocks[i] = block
	end

	return blocks
end

local function showWinnerCharacter(
	userId: number,
	placement: number,
	blocks: { Part },
	eventTrove: typeof(troveModule.new()),
	facingTarget: Vector3
)
	local success, PlayerInstance = pcall(Players.GetPlayerByUserId, Players, userId)
	if not success or not PlayerInstance then
		warn("[PodiumDisplay]: Couldnt get Player Instance! ")
		return
	end

	local character: Model? = PlayerInstance.Character
	if not character then
		return
	end

	local block = blocks[placement]
	if not block then
		return
	end

	local wasArchivable = character.Archivable
	character.Archivable = true

	local clone = eventTrove:Add(character:Clone())

	character.Archivable = wasArchivable

	if not clone then
		warn("[PodiumDisplay]: Character:Clone() failed for: ", userId)
		return
	end

	local _, cloneSize = clone:GetBoundingBox()
	local halfHeight = cloneSize.Y / 2

	local blockTop = block.Position.Y + block.Size.Y / 2
	local standPosition = Vector3.new(block.Position.X, blockTop + halfHeight + 0.5, block.Position.Z)

	local flatFacingTarget = Vector3.new(facingTarget.X, standPosition.Y, facingTarget.Z)
	local facingCFrame = CFrame.lookAt(standPosition, flatFacingTarget)

	clone:PivotTo(facingCFrame)

	local humanoid = clone:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.PlatformStand = true
	end

	local root: BasePart? = clone:FindFirstChild("HumanoidRootPart")
	if root then
		root.Anchored = true
	end

	clone.Parent = workspace
end

Packets.ShowWinners.OnClientEvent:Connect(function(winnersData: winnersData)
	if #winnersData <= 0 then
		return
	end

	local eventTrove = troveModule.new()

	local blocks = createPodium(winnersData, eventTrove)

	local startCFrame = camera.CFrame

	local middleIndex = math.ceil(#blocks / 2)
	local middlePart = blocks[middleIndex]

	local focusPoint = middlePart.Position + Vector3.new(0, middlePart.Size.Y * 0.5, 0)

	local cameraPos = focusPoint + cameraOffset

	for i, playerData in winnersData do
		showWinnerCharacter(playerData.UserId, i, blocks, eventTrove, cameraPos)
	end

	local targetCFrame = CFrame.lookAt(cameraPos, focusPoint)

	local elapsed = 0

	eventTrove:Connect(RunService.PreRender, function(dt: number)
		elapsed += dt

		local a = math.clamp(elapsed / cameraTransitionTime, 0, 1)

		local alpha = -(math.cos(math.pi * a) - 1) / 2

		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = startCFrame:Lerp(targetCFrame, alpha)
	end)

	task.delay(cameraTransitionTime + displayDuration + 50, function()
		camera.CameraType = Enum.CameraType.Custom
		eventTrove:Clean()
	end)
end)
