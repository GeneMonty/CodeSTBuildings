--[[

SpectraAccumulator.lua is the current code of the STBattery(Spectra Accumulator).

Features
    Implemented= [+] // Not implemented [ ]

Battery
    [+]Energy charge
    [+]Energy discharge

Heat
    [x]Heat Production
    [x]100% heat radius when charging
    [x]80% radius when fully charged
    [x]100% radius when Discharging

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

    -- mode = "charging", -- "empty", "full", "charging", "discharging"
}

function ZSpectraAccumulator:GetHeatRange() --Gets Heat Range Values
    if self.mode == "full" then
        return 10 * 8 * guim
    elseif self.mode == "charging" or
           self.mode == "discharging" then
        return 10 * 10 * guim
    elseif self.mode == "empty" then
        return 0
    end
end

function ZSpectraAccumulator:GetHeatBorder()--gets heat border?
    return const.SubsurfaceHeaterFrameRange
end

function ZSpectraAccumulator:GetSelectionRadiusScale() --gets MineRadius?
    return const.MoholeMineHeatRadius
end


--Important function
function ZSpectraAccumulator:SetStorageState(resource, state, ...)
    ElectricityStorage.SetStorageState(self, resource, state, ...)
    if self.working then
            self:ApplyHeat(false)
            self:ApplyHeat(true)
        -- self:GetHeatRange()--self:UpdateHeatingRangeHere() --GetHeatRange()
    end
end







--function is working, still range not updating by itself.
-- function ZSpectraAccumulator:ApplyHeat(...)
--         --
--         BaseHeater.ApplyHeat(self, ...) -- what do i write here exactly? lol
--                 --
--         end



-- function OnMsg.NewHour()
--         SpectraCurrentHour = UICity.hour -- SpectraCurrentHour gets UICity.Hour
-- end

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
