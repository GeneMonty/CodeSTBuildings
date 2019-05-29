--[[ v.1.20
SpectraAccumulator.lua is the current code of the STBattery(Spectra Accumulator).

Features
        Implemented [+]  Not Implemented [ ] Disabled [-]
        Bug [!] Development [x]

Battery
        [+] Energy charge
        [+] Energy discharge

Heat
        [+] Heat Production
        [+] 120% heat radius when charging
        [+] 120% radius when Discharging
        [+] 100% radius when fully charged

UI Stuff
        [x] Display Plop Default Heat Range Border
        [!] Display Current Heat Range while Selected
        [] Display current Heat % at Infopannel

Sound Stuff
        [] Play sound on Selection
        [] Play sound while active
Water
        [] Produce Water 1 cold
        [] Store water 1 water
        
]]

DefineClass.ZSpectraAccumulator = {
    __parents = {
        "ElectricityStorage",
        "BaseHeater",
        "UIRangeBuilding"

    },

    heat = 2*const.MaxHeat,
    UIRange = 10  --result, needs a small value, GetHeatRange output value is to high
    -- mode = "charging", -- "empty", "full", "charging", "discharging"
}

--------<
-- Heat
--------<
function ZSpectraAccumulator:GetHeatRange() -- Gets heat range from Values
        local result = 0

        if self.mode =="full" then
                result = 10 * 10 * guim --Range when Full
        elseif self.mode == "charging" or
                self.mode == "discharging" then
                result = 10 * 12 * guim --range when Discharging/Charging
        elseif self.mode == "empty"  then
                result = 0
        end
        -- self.UIRange = result
        return result
end

--Important function to enable heat change on condition in realtime

function ZSpectraAccumulator:SetStorageState(resource, state, ...) --override ElectricityStorage by our own.
        ElectricityStorage.SetStorageState(self, resource, state, ...)
        if self.working then --Apply Heat change in realtime
                self:ApplyHeat(false)
                self:ApplyHeat(true)
                -- self:GetHeatRange()--self:UpdateHeatingRangeHere() --GetHeatRange()
        end
end

-- GetHeatBorder() and GetSelectionRadiusScale() is currently disabled because is not working correctly for our needs.
-- function ZSpectraAccumulator:GetHeatBorder(...)--Returns heat border ?
--         SubsurfaceHeater:GetHeatBorder(self,...)
--         return UIRange
-- --     -- return const.SubsurfaceHeaterFrameRange
-- --     -- return SpectraBorder
-- end
-- -- -- --
-- function ZSpectraAccumulator:GetSelectionRadiusScale() --Returns Selection Radius Scale?
--     -- return self:GetHeatRange() --crash
--     -- return const.MoholeMineHeatRadius
--     return UIRange
-- end

--------<
-- Sound
--------<

--Currently on development no sound working yet.
function OnMsg.SelectedObjChange(obj, prev)
        if IsKindOf(obj, "ZSpectralAccumulator") then
                PlayFX("Select", "end", self)
        end
end



--------------------------------------------
--Dev advice on how to call another lua code
--------------------------------------------
-- function YourClass:ApplyHeat(...)
--     --your code here...
--     BaseHeater.ApplyHeat(self, ...)
--     --your code here...
-- end
