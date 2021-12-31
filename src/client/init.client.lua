local runService = game:GetService("RunService")
runService.Heartbeat:Wait()

local ReplicatedStorage = game:GetService("ReplicatedStorage").Common
-- Require audio player module
local AudioPlayer = require(ReplicatedStorage:WaitForChild("AudioPlayerModule"))

local player = game:GetService("Players").LocalPlayer


-- Set up audio tracks
AudioPlayer.setupAudio({
	["BirthDay"] = 1840552418,
	["Adventure"] = 1843639871
})

if game.PlaceId == 8338771649 then
	-- Maze
	player.CameraMode = Enum.CameraMode.LockFirstPerson

	-- Play a track by name
	AudioPlayer.playAudio("BirthDay")
elseif game.PlaceId == 8354626769 then
	-- Escape Room
	player.CameraMode = Enum.CameraMode.Classic
	player.CameraMaxZoomDistance = 70

	-- Play a track by name
	AudioPlayer.playAudio("Adventure")
end
