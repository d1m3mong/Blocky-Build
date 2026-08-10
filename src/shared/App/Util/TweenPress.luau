local TweenService = game:GetService "TweenService"

export type TweenGoals = { [string]: any }

export type PressConfig = {
	instance: GuiObject,
	pressGoals: TweenGoals?,
	hoverGoals: TweenGoals?,
	idleGoals: TweenGoals?,
	tweenInfo: TweenInfo?,
}

local DEFAULT_TWEEN_INFO = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local TweenPress = {}

local function play(instance: GuiObject, tweenInfo: TweenInfo, goals: TweenGoals?)
	if not goals then
		return
	end

	local tween = TweenService:Create(instance, tweenInfo, goals)
	tween:Play()
	return tween
end

function TweenPress.attach(config: PressConfig): () -> ()
	local instance = config.instance
	local tweenInfo = config.tweenInfo or DEFAULT_TWEEN_INFO

	local connections: { RBXScriptConnection } = {}

	if config.pressGoals then
		table.insert(
			connections,
			(instance :: any).Activated:Connect(function()
				play(instance, tweenInfo, config.pressGoals)
			end)
		)
	end

	if config.hoverGoals then
		table.insert(
			connections,
			(instance :: any).MouseEnter:Connect(function()
				play(instance, tweenInfo, config.hoverGoals)
			end)
		)
	end

	if config.idleGoals then
		table.insert(
			connections,
			(instance :: any).MouseLeave:Connect(function()
				play(instance, tweenInfo, config.idleGoals)
			end)
		)
	end

	return function()
		for _, connection in connections do
			connection:Disconnect()
		end
		table.clear(connections)
	end
end

function TweenPress.playOnce(instance: GuiObject, goals: TweenGoals, tweenInfo: TweenInfo?)
	return play(instance, tweenInfo or DEFAULT_TWEEN_INFO, goals)
end

return TweenPress
