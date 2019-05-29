--[[

SpectraAccumulator.lua is the current code of the STBattery(Spectra Accumulator).

Features
    Implemented= [+] // Not implemented [ ]

Battery
    [+]Energy charge
    [+]Energy discharge

Heat
    [x]Heat Production
    [ ]100% heat radius when charging
    [ ]80% radius when fully charged
    [ ]100% radius when Discharging

UI Stuff
    [ ] Display current Heat % at Infopannel
    [ ] Display Heat Range on Ground while Selected

]]

DefineClass.ZSpectraAccumulator = {
    __parents = {
        "ElectricityStorage",
        "BaseHeater"
        -- "SubsurfaceHeater"

    },

    heat = 2*const.MaxHeat,
    utime = const.HourDuration, --Do i need this?
    mode = "charging", -- "empty", "full", "charging", "discharging"

}

function ZSpectraAccumulator:GetHeatRange()--~do i need (time)?

    --We get the radius and add our own value "DeltaHeatRadius" to change it.
    -- print(DeltaHeatRadius.." Current Heat Range")--debug
    -- return const.MoholeMineHeatRadius * 1 * self.DeltaHeatRadius(5) * guim -- original value 10

    -- deltaRadius = 10 * self.BuildingUpdate(DeltaHeatRadius) * guim
    --
    -- print(deltaRadius.." Current Heat Range")--debug
    -- -- print(ElectricityStorage:Getui_mode()))--how can i access another template reference as reference?
    -- RebuildInfopanel(self)
    -- return deltaRadius
    return FinalHeat

end

function ZSpectraAccumulator:GetHeatBorder()--gets heatrange?
    return const.SubsurfaceHeaterFrameRange
end

function ZSpectraAccumulator:GetSelectionRadiusScale() --gets Mmineradius
    return const.MoholeMineHeatRadius
end

function OnMsg.NewHour()
        SpectraCurrentHour = UICity.hour -- SpectraCurrentHour gets UICity.Hour
end
------------------------------------------------
--Work in progress function
--Logic is Working?
--Not self updating radius yet, game bug?
------------------------------------------------

-- We want to check the charge status of the battery and return a value to
-- update DeltaHeatRadius. How do we get the charge status?

-- function ZSpectraAccumulator:DeltaHeatRadius()
--
--         if mode == "full" then
--                 DeltaHeatRadius = 10
--         elseif mode == "charging" or "discharging" then
--                 DeltaHeatRadius = 15
--         else end
--         return DeltaHeatRadius
-- end


-- function ZSpectraAccumulator:DeltaHeatRadius(time) --Logic debug function
--
--         if SpectraCurrentHour < 5 then
--                 DeltaHeatRadius = 5
--         elseif SpectraCurrentHour > 15 then
--                 DeltaHeatRadius = 20
--         else
--                 DeltaHeatRadius = 10
--         end
--         print(DeltaHeatRadius.." Delta Heat Radius ")--debug
--         RebuildInfopanel(self)
--         return DeltaHeatRadius
-- end

--~not sure how this is wokring (time)

-- function ZSpectraAccumulator:BuildingUpdate(time)
--         if SpectraCurrentHour < 5 then
--                 DeltaHeatRadius = 5
--         elseif SpectraCurrentHour > 15 then
--                 DeltaHeatRadius = 20
--         else
--                 DeltaHeatRadius = 10
--         end
--         print(DeltaHeatRadius.." Delta Heat Radius ")--debug
--         RebuildInfopanel(self) --
--         return DeltaHeatRadius
-- end




-- function ZSpectraAccumulator:ChargeHeatRadius()
--     if self.electricity.charge > 0 then self.GetHeatRange = 20
--     else self.GetHeatRange = 10
-- end
--
-- function SpectraChargeState()
--     SpectraCharging = self.electricity.charge
--     SpectraDischarge = self.electricity.discharge
--
-- end

--function is working, still range not updating by itself.
function ZSpectraAccumulator:ApplyHeat(...)

        DeltaHeatRadius = 0
        --code here for conditions--

        if SpectraCurrentHour < 5  then
                DeltaHeatRadius = 5
        elseif SpectraCurrentHour >15 then
                DeltaHeatRadius = 20
        else
                DeltaHeatRadius = 10
        end

        BaseHeater.ApplyHeat(self, ...) -- what do i write here exactly? lol
        ---code here to apply the heat---
        FinalHeat = 10 * DeltaHeatRadius * guim
        return FinalHeat
        -- return 10 * self.DeltaHeatRadius() * guim -- original value 10
end
-- Possible solution: force building to turn on/off itself to update Range
-- only if not turned off by player

function ZSpectraAccumulator:BuildingUpdate(dt, day, hour)
	self.SetWorking(true)
end


function ZSpectraAccumulator:SetStorageState(resource, state, ...)
    ElectrocityStorage.SetStorageState(self, resource, state, ...)
    if self.working then
        self:UpdateHeatingRangeHere()
    end
end


--use this function later to get states

-- function ElectricityStorage:SetStorageState(resource, state)
-- 	self.mode = state
-- end

--------------------------------------------
--Dev advice on how to call another lua code
--------------------------------------------
-- function YourClass:ApplyHeat(...)
--     --your code here...
--     BaseHeater.ApplyHeat(self, ...)
--     --your code here...
-- end
