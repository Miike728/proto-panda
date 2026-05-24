local expressions = require("expressions")
local models = require("models")
local scripts = require("scripts")
local generic = require("generic")
local menu = require("menu")
local boop = require("boop")
local configloader = require("configloader")
local drivers = require("drivers")
local input = require("input")
local json = require("json")

function onSetup()

    dictLoad()

    local seed = tonumber(dictGet("random_seed")) or millis()
    seed = seed + millis()
    math.randomseed(seed)
    print("Random seed is "..seed)
    dictSet("random_seed", tostring(seed))
    if dictGet("created") ~= "1" then
        menu.setDictDefaultValues()
    end
    dictSave()

    configloader.Load()
    input.Load()
    models.Load()
    expressions.Load()
    scripts.Load()
    boop.Load()

    -- Load LED config from hardware.json
    local ledCfg = {}
    local fp = io.open("/hardware.json", "r")
    if fp then
        local content = fp:read("*a")
        fp:close()
        local hw = json.decode(content) or {}
        ledCfg = hw.leds or {}
    end
    local led1Count  = ledCfg.count_1     or 6
    local led2Count  = ledCfg.count_2     or 6
    local defaultHue = ledCfg.default_hue or 15   -- #e75b12 naranja
    local defaultSat = ledCfg.default_sat or 235
    local defaultVal = ledCfg.default_val or 231

    -- On first run set default hue from hardware.json
    if dictGet("led_hue") == nil or dictGet("led_hue") == "" then
        dictSet("led_hue", tostring(defaultHue))
        dictSet("led_effect", tostring(BEHAVIOR_STATIC_HSV))
        dictSave()
    end

    local savedHue    = tonumber(dictGet("led_hue"))    or defaultHue
    local savedEffect = tonumber(dictGet("led_effect")) or BEHAVIOR_STATIC_HSV

    generic.displaySplashMessage("Starting:\nLeds")
    ledsBeginDual(led1Count, led2Count, 0)
    ledsDisplay()
    ledsSegmentRange(0, 0, led1Count - 1)
    ledsSegmentRange(1, led1Count, led1Count + led2Count - 1)

    if savedEffect == BEHAVIOR_STATIC_HSV then
        ledsSegmentBehavior(0, BEHAVIOR_STATIC_HSV, savedHue, defaultSat, defaultVal)
        ledsSegmentBehavior(1, BEHAVIOR_STATIC_HSV, savedHue, defaultSat, defaultVal)
    else
        ledsSegmentBehavior(0, savedEffect, 0, 0, 0)
        ledsSegmentBehavior(1, savedEffect, 0, 0, 0)
    end

    generic.displaySplashMessage("Starting:\nMenu")
    menu.setup()
end

function onPreflight()
    ledsSetManaged(true)
    setPanelManaged(true)
    expressions.Next()
    if not configloader.Get().starting_animation then
        expressions.SetExpression(configloader.Get().starting_animation)
    end

    input.Start()
    setPoweringMode(BUILT_IN_POWER_MODE)
    ledsGentlySeBrightness(tonumber(dictGet("led_brightness")) or 64)
    gentlySetPanelBrightness(tonumber(dictGet("panel_brightness")) or 64)
end

function onLoop(dt)
    drivers.update()
    input.update()
    expressions.update()
    if not scripts.Handle(dt) then
        return
    end
    menu.handleMenu(dt)
end
