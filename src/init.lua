-- !strict

-- Author: Alex/EnDarke
-- Description: Camera Rotation module used for rotating around parts

--\\ Services //--
local RunService = game:GetService("RunService")

--\\ Variables //--
local vector3 = Vector3.new

local pi = math.pi

--\\ Local Utility Function //--
local function calcRingPosition(args: {}, offset)
    -- Prohibit continuation without necessary information.
    if not ( args ) then return end

    -- Prep variables
    local _time = args.time
    local distance = args.distance
    local speed = args.speed
    local height = args.height

    if not ( _time and distance and speed ) then return end

    return offset + vector3(math.cos(_time * speed) * distance, height, math.sin(_time * speed) * distance)
end

--\\ Module Code //--
local CameraRotation = {}
CameraRotation.__index = CameraRotation

function CameraRotation.new(camera: Camera, instance: Instance, args: {})
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

function CameraRotation:ChangeObject(args: {})
    -- Prohibit continuation without necessary information
    if not ( self.onRenderStep ) then return end

    -- End previous rotation
    self:End()

    -- Change looking instance
    self.instance = args.Instance or self.instance
    self.distance = args.Distance or self.distance
    self.speed = args.Speed or self.speed
    self.height = args.Height or self.height

    -- Start new rotation
    self:Start()

    return true
end

function CameraRotation:Start()
    -- Prohibit continuation without necessary information.
    if ( self.onRenderStep ) then return end
    if not ( self.distance and self.speed ) then return end

    -- Initiate Start
    local _time = 0

    local offset = self.instance.CFrame
    local distance = self.distance
    local speed = self.speed
    local height = self.height

    -- RenderStep Event
    self.onRenderStep = RunService.RenderStepped:Connect(function(deltaTime)
        _time += deltaTime
        self.camera.CFrame = calcRingPosition({ time = _time, distance = distance, speed = speed, height = height }, offset)
        self.camera.CFrame = CFrame.lookAt(self.camera.CFrame.Position, self.instance.Position)
    end)
end

function CameraRotation:End()
    -- Prohibit continuation without necessary information.
    if not ( self.onRenderStep ) then return end

    self.onRenderStep:Disconnect()
    self.onRenderStep = nil

    return true
end

function CameraRotation:Destroy()
    -- End Rotation Instance
    self:End()

    -- Clear metatables
    setmetatable(self, nil)
    table.clear(self)
end

return CameraRotation