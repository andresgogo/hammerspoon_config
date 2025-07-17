hs.loadSpoon("ShiftIt")
spoon.ShiftIt:bindHotkeys({})


-- ######## hyper-q close all floating/standard windows in current space ########

local hotkey = require("hs.hotkey")
local application = require "hs.application"
local window = require("hs.window")

-- Function to close all floating windows
local function closeAllFloatingWindows()
    local windows = window.filter.new():setCurrentSpace(true):getWindows()
    for _, win in ipairs(windows) do
        if win:isStandard() then
            win:close()
        end
    end
end



-- ######## FOSI TOGGLE - hyper-B ########

-- Bind hotkey
local mash = {"ctrl", "alt", "cmd"}
hotkey.bind(mash, "Q", closeAllFloatingWindows)

-- Name of the Bluetooth device
local deviceName = "FOSI AUDIO"

-- Function to toggle Bluetooth connection
local function toggleBluetoothConnection()
    -- Get a list of all devices
    local devices = bluetooth.devices()

    -- Look for the device with the given name
    for _, device in ipairs(devices) do
        if device.name == deviceName then
            -- If the device is connected, disconnect it
            if device.isConnected then
                bluetooth.disconnect(device.addr)
            -- If the device is not connected, connect it
            else
                bluetooth.connect(device.addr)
            end
            -- Only one device with the given name should exist, so break the loop
            break
        end
    end
end

-- Bind hotkey
local mash = {"ctrl", "alt", "cmd"}
hotkey.bind(mash, "B", toggleBluetoothConnection)




local function openURL(url, focus_on_existing)
    local chrome = application.get("Google Chrome")
    if not chrome then
        chrome = application.launchOrFocus("Google Chrome")
        chrome = application.get("Google Chrome")
        hs.timer.usleep(1000000)  -- Wait for 1 second to ensure Chrome launches
    end
    
    if chrome then
        -- Build the AppleScript with dynamic URL and focus behavior
        local script = string.format([[
            tell application "Google Chrome"
                if not (exists window 1) then
                    make new window
                end if

                set focusOnExisting to %s
                set urlArg to "%s"
                
                set foundTab to false
                if focusOnExisting then
                    set theURL to urlArg
                    repeat with w in windows
                        set i to 0
                        repeat with t in tabs of w
                            set i to i + 1
                            if URL of t starts with theURL then
                                set foundTab to true
                                set active tab index of w to i
                                set index of w to 1
                                exit repeat
                            end if
                        end repeat
                        if foundTab then
                            exit repeat
                        end if
                    end repeat
                end if
                
                if not foundTab then
                    set newTab to make new tab at end of tabs of window 1
                    set URL of newTab to urlArg
                end if
                
                activate
            end tell
        ]], tostring(focus_on_existing), url)
        local success, output, raw_output  = hs.osascript.applescript(script)
        print(string.format("%s, %s: %s : %s" ,"hello4", success,output, hs.inspect(raw_output)))
        return hs.osascript.applescript(script)
    end
    return false
end

-- Example usage:



-- Bind the hotkey to the function
hotkey.bind(mash, "o", function() openURL("https://chatgpt.com/", false) end)
hotkey.bind(mash, "p", function() openURL("https://claude.ai", true) end)
hotkey.bind(mash, "0", function() application.launchOrFocus("Warp") end)
hotkey.bind(mash, "c", function() application.launchOrFocus("Cursor") end)
hotkey.bind(mash, "i", function() application.launchOrFocus("iTerm") end)
hotkey.bind(mash, "r", function() application.launchOrFocus("Raycast") end)
hotkey.bind(mash, "6", function() application.launchOrFocus("Google Chrome") end)
hotkey.bind(mash, "5", function() application.launchOrFocus("Spotify") end)

hs.hotkey.bind({"cmd"}, "[", function()
    hs.eventtap.keyStroke({}, "escape")
  end)

