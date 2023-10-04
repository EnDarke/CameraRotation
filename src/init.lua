-- !strict

-- Author: Alex/EnDarke
-- Description: Camera Rotation module used for rotating around parts

--\\ Services //--
local RunService = game:GetService("RunService")
local vector3 = Vector3.new
local cos = math.cos
local sin = math.sin

--\\ Local Utility Function //--
local function calcRingPosition(time, distance, speed, height, offset)
    return offset + vector3(cos(time * speed) * distance, height, sin(time * speed) * distance)
end

--\\ Module Code //--
local CameraRotation = {}
CameraRotation.__index = CameraRotation

function CameraRotation.new(camera, instance, args)
    local self = setmetatable({}, CameraRotation)

    -- Initiates Camera Rotation Data
    self.camera = camera
    self.instance = instance
    self.distance = args.Distance or 10
    self.speed = args.Speed or 1
    self.height = args.Height or 10
    self.onRenderStep = nil

    -- Starts the camera rotation
    self:Start()

    return self
end

function CameraRotation:ChangeObject(args)
    if not self.onRenderStep then return end

    self:End()

    -- Change looking instance
    self.instance = args.Instance or self.instance
    self.distance = args.Distance or self.distance
    self.speed = args.Speed or self.speed
    self.height = args.Height or self.height

    self:Start()
end

function CameraRotation:Start()
    if self.onRenderStep then return end

    local _time = 0
    local offset = self.instance.CFrame
    local distance = self.distance
    local speed = self.speed
    local height = self.height

    self.onRenderStep = RunService.RenderStepped:Connect(function(deltaTime)
        _time = _time + deltaTime
        self.camera.CFrame = calcRingPosition(_time, distance, speed, height, offset)
        self.camera.CFrame = CFrame.lookAt(self.camera.CFrame.Position, self.instance.Position)
    end)
end

function CameraRotation:End()
    if not self.onRenderStep then return end

    self.onRenderStep:Disconnect()
    self.onRenderStep = nil
end

function CameraRotation:Destroy()
    self:End()
    setmetatable(self, nil)
    for k in pairs(self) do
        self[k] = nil
    end
end

return CameraRotation
