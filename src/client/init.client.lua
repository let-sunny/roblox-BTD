local runService = game:GetService("RunService")
runService.Heartbeat:Wait()

local player = game:GetService("Players").LocalPlayer

player.CameraMode = Enum.CameraMode.Classic
player.CameraMaxZoomDistance = 20
player.CameraMinZoomDistance = 2