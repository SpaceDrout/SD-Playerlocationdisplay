-- Function to draw text on the screen
function DrawTextOnScreen(text, x, y, scale, r, g, b, a)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Function to draw a black background rectangle
function DrawBackground(x, y, width, height, r, g, b, a)
    DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

-- Function to determine the player's compass direction (single letter)
function GetDirectionFromHeading(heading)
    if (heading >= 315 or heading < 45) then
        return "N"
    elseif (heading >= 45 and heading < 135) then
        return "E"
    elseif (heading >= 135 and heading < 225) then
        return "S"
    else
        return "W"
    end
end

-- Main thread to display the player's street, area, and direction
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Wait for a frame

        -- Get player data
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)
        local direction = GetDirectionFromHeading(heading)

        -- Get street name and area
        local streetHash, crossingHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
        local streetName = GetStreetNameFromHashKey(streetHash)
        local areaName = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z)) -- Fetches the area/zone name

        -- Define text and background parameters
        local directionScale = 0.833 -- Larger text scale for direction
        local textScale = 0.4 -- Standard text scale for other text

        -- Independent positions for direction and other text
        local directionX, directionY = 0.16, 0.94 -- Direction text position
        local textX, textY = 0.163, 0.910 -- Other text position
        local textWidth, textHeight = 0.12, 0.08 -- Background dimensions

        -- Draw the black background
        DrawBackground(textX, textY + 0.02, textWidth, textHeight, 0, 0, 0, 250) -- Semi-transparent black background

        -- Draw the direction with a larger scale at its own position
        DrawTextOnScreen(" ~y~" .. direction, directionX, directionY, directionScale, 255, 255, 255, 255)

        -- Draw the street name and area with a smaller scale at its own position
        local infoText = string.format("         ~w~%s\n~y~        ~w~ %s", streetName, areaName)
        DrawTextOnScreen(infoText, textX, textY + 0.03, textScale, 255, 255, 255, 255)
    end
end)
