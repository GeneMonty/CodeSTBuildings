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
    utime = const.HourDuration

}

function ZSpectraAccumulator:GetHeatRange(time)--~time?
    return const.MoholeMineHeatRadius * 1 * self.DeltaHeatRadius() * guim -- original value 10
end

function ZSpectraAccumulator:GetHeatBorder()
    return const.SubsurfaceHeaterFrameRange
end

function ZSpectraAccumulator:GetSelectionRadiusScale()
    return const.MoholeMineHeatRadius
end

------------------------------------------------
--Work in progress function
--Logic is Working
--Not self updating radius yet
------------------------------------------------

function ZSpectraAccumulator:DeltaHeatRadius()

if SpectraCurrentHour < 5 then DeltaHeatRadius = 5
elseif SpectraCurrentHour > 15 then DeltaHeatRadius = 20
else DeltaHeatRadius = 10 end
    return DeltaHeatRadius
end

function OnMsg.NewHour()
	SpectraCurrentHour = UICity.hour -- SpectraCurrentHour gets UICity.Hour
end

-- if
--     SpectraCurrentHour < 9
--     then
--         DeltaHeatRadius = 5
--
-- elseif
--     SpectraCurrentHour > 10
--     or
--     SpectraCurrentHour < 25
--     then
--         DeltaHeatRadius = 20
-- else DeltaHeatRadius = 10 end

-- DeltaHeatRadius = 20


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
