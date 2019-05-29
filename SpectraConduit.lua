--[[v1.30 this lua will replace SpectraSolarClass2.lua
SpectraConduit.lua is the current code of the "Asset name here".

Features
        Implemented [+]  Not Implemented [ ] Disabled [-]
        Bug [!] Development [x] Fixed[F]

Placement
        [+]Place in Dome

Energy production
	[+] Solar Energy Production
	[+] Reduced Production at night.
	[+] Reduced production caused by Dust storm disaster indoor/outdoor
	[x] Cold wave increse of production (Cold Increases Efficiency of Conduit)

UI Stuff
        [ ] Placeholder at Infopannel
        [ ] Placeholder Ground while Selected

Sound Stuff
        [ ] Play sound on Selection
        [ ] Play sound while active

Bugs
        [!F] Cant Multi ctrl+click enable/Disable
        [!F] No mantainance point / dust accumulation


]]
DefineClass.ZSpectralConduit = {
        __parents = {
                "ElectricityProducer",
                "StirlingGenerator"
        },

        -- isCold = false,


}

-- GameInit Working - Accumulating Dust correctly
function ZSpectralConduit:GameInit()

        self.opened = true
	self.accumulate_dust = self:IsOpened() and not IsObjInDome(self)
	self:SetAccumulateMaintenancePoints(self:IsOpened())

end


-- BuildingUpdate() change energy production of building--Broke on SpaceRace Patch
function ZSpectralConduit:BuildingUpdate(dt,day,hour)

        self:SetBase("electricity_production",self:GetClassValue("electricity_production")
        / self:energyCalculation() * self.production_factor_interacted / (self:energyLoss())
        )--* self:energyColdBoost()
        RebuildInfopanel(self)
        --works only with int value atm, cant feed function value for some reason.
end

-- function ZSpectralGenerator:BuildingUpdate(time)
-- 	self:AccumulateDust()
-- 	self:SetBase("electricity_production", self:GetClassValue ("electricity_production") / self:energyStormLoss() * self.production_factor_interacted / (self:energyLoss()))
-- 	RebuildInfopanel(self) --
-- 	-- print(energyLoss.."EnergyLoss")--debug
-- end -- Working Fuction updating correctly to Calculate energy output


---------------------
--Dust Functions
---------------------
function ZSpectralConduit:IsOpened()
	return self.opened and self.working
end--needed for dust accumulation

function ZSpectralConduit:AccumulateDust()
	if self.time_opened_start then
		local delta = GameTime() - self.time_opened_start
		self:AddDust(MulDivTrunc(self.daily_dust_accumulation, delta, const.DayDuration))
	end
	self.time_opened_start = self:IsOpened() and GameTime() or false
end-- main function for dust accumulation


--------------------------------------
----The Start of my Custom Fuctions
--------------------------------------
--SpectraFuction of Time Update
function OnMsg.NewHour()
	SpectraCurrentHour = UICity.hour -- SpectraCurrentHour gets UICity.Hour
        -- print(energyLoss.." EnergyLoss|",
        -- energyStormLoss.." STORMLOSS|",
        -- SpectraCurrentHour.." HOUR|",
        -- energyColdBoost.." COLDBOOST|")
        -- print(energyColdBoost.." Coldboost")
        print(energyCalculation.." Resulting Energy")
end

--Spectra Function to Calculate Energy Loss by time
function ZSpectralConduit:energyLoss()
        local result = 100

        if SpectraCurrentHour < 5 or
        SpectraCurrentHour > 15 then
                result = 200
        else
                result = 100
        end
        return result


        -- if SpectraCurrentHour < 5 then energyLoss = 200
	-- elseif SpectraCurrentHour > 18 then energyLoss = 200
	-- else energyLoss = 100
	-- end
	-- return energyLoss
end

--DustStorm Affects Production inside and outside Dome.
function ZSpectralConduit:energyStormLoss()
	if g_DustStorm then
		energyStormLoss = 3
	else energyStormLoss = 1
	end
	return energyStormLoss
end

--Coldwave boost energy production.
function ZSpectralConduit:energyColdBoost()
        if g_ColdWave then
                energyColdBoost = 5
        else energyColdboost = 1
        end
        return energyColdboost
end

function ZSpectralConduit:energyCalculation()

        resultEnergy = self:energyColdBoost() * self:energyStormLoss()
        return resultEnergy
end



-- GlobalVar("g_ColdWave", false)
-- GlobalVar("g_ColdWaves", 0)

--------\
--Sound  |
--------/
