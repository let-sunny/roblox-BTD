local runService = game:GetService("RunService")
runService.Heartbeat:Wait()

local player = game:GetService("Players").LocalPlayer

player.CameraMode = Enum.CameraMode.LockFirstPerson