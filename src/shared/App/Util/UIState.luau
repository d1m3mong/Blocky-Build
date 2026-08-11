local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)

local source = vide.source

local UIState = {}

local activeGui: () -> string? = source(nil)

function UIState.open(name: string): ()
	activeGui(name)
end

function UIState.close(name: string): ()
	if activeGui() == name then
		activeGui(nil)
	end
end

function UIState.isOpen(name: string): () -> boolean
	return function()
		return activeGui() == name
	end
end

return UIState
