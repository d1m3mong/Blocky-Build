local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)

local source = vide.source

local UIState = {}

local activeGui: () -> string? = source(nil)
local previousGui: string? = nil

function UIState.open(name: string)
	if activeGui() ~= name then
		previousGui = activeGui()
	end

	activeGui(name)
end

function UIState.close(name: string)
	if activeGui() ~= name then
		return
	end

	if previousGui then
		local gui = previousGui
		previousGui = nil
		activeGui(gui)
	else
		activeGui(nil)
	end
end

function UIState.isOpen(name: string): () -> boolean
	return function()
		return activeGui() == name
	end
end

function UIState.getActive()
	return activeGui
end

return UIState
