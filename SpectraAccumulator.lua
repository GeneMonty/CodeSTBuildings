--[[

SpectraAccumulator.lua is the current code of the STBattery.

Features
Implemented= [+] // Not implemented [ ]

Battery
[+]Energy charge
[+]Energy discharge

Heat
[x]Heat Production
[ ]100% heat radius when charging
[ ]80% radius when fully charged
[ ]50% radius when Discharging

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

    heat = 2*const.MaxHeat

}

function ZSpectraAccumulator:GetHeatRange()
    return const.MoholeMineHeatRadius * 10 * guim
end

function ZSpectraAccumulator:GetHeatBorder()
    return const.SubsurfaceHeaterFrameRange
end

function ZSpectraAccumulator:GetSelectionRadiusScale()
    return const.MoholeMineHeatRadius
end

function ZSpectraAccumulator:GetChargeState()
end
