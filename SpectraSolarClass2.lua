DefineClass.ZSpectralGenerator = {
	__parents = {
		"ElectricityProducer"
	},
	properties = {
		{
			template = true,
			id = "production_factor_interacted",
			name = Untranslated("Interacted Production Coef %"),
			category = "Power Production",
			editor = "number",
			default = 100,
			modifiable = true
		},
		{
			template = true,
			id = "production_factor_not_interacted",
			name = Untranslated("Not Interacted Production Coef %"),
			category = "Power Production",
			editor = "number",
			default = 100,
			modifiable = true
		},
		{
			template = true,
			id = "daily_dust_accumulation",
			name = Untranslated("Daily dust accumulation when opened"),
			category = "Power Production",
			editor = "number",
			default = 10000
		},
		{
			template = true,
			id = "RedundantCoolantSysChance",
			name = Untranslated("Redundant Coolant Sys Chance"),
			category = "Gameplay",
			editor = "number",
			default = 90,
			modifiable = true
		}
	},

	building_update_time = const.HourDuration,
	time_opened_start = false,
	opened = false,
	open_close_thread = false,
	artificial_sun = false,
	foo = false,
}
function ZSpectralGenerator:GameInit()
	self.opened = true
	self.accumulate_dust = self:IsOpened() and not IsObjInDome(self)
	self:SetAccumulateMaintenancePoints(self:IsOpened())
	--PlaceOb
end

function ZSpectralGenerator:BuildingUpdate(time)
	self:AccumulateDust()
	self:SetBase("electricity_production", self:GetClassValue ("electricity_production") * self.production_factor_interacted / (self:energyLoss() + self:energyStormLoss()))
	RebuildInfopanel(self)
end -- Working Fuction updating correctly


-- function ZSpectralGenerator:BuildingUpdate(dt, day, hour)
-- 	self:AccumulateDust()
-- 	self:SetBase("electricity_production", self:GetClassValue("electricity_production") *  self.production_factor_interacted / self:energyLoss() * self:energymidBonus())
-- 	RebuildInfopanel(self)
-- 	--This is very Important for update energy.
-- end

function ZSpectralGenerator:OnChangeState(foo)
	if self:IsOpened() then
		self:SetBase("electricity_production", self:GetClassValue("electricity_production") * self.production_factor_interacted / 100)
		else
		self:SetBase("electricity_production", self:GetClassValue("electricity_production") * self.production_factor_not_interacted / 100)
	end
	self.accumulate_dust = self:IsOpened() and not IsObjInDome(self)
	self:SetAccumulateMaintenancePoints(self:IsOpened())
	self:AccumulateDust()
	if foo then
		self:UpdateAnim()
	end
	RebuildInfopanel(self)
end
function ZSpectralGenerator:OnUpgradeToggled()
	self:OnChangeState(true)
end
function ZSpectralGenerator:AccumulateDust()
	if self.time_opened_start then
		local delta = GameTime() - self.time_opened_start
		self:AddDust(MulDivTrunc(self.daily_dust_accumulation, delta, const.DayDuration))
	end
	self.time_opened_start = self:IsOpened() and GameTime() or false
end
function ZSpectralGenerator:IsOpened()
	return self.opened and self.working
end
--[[function ZSpectralGenerator:UpdateAnim()
	DeleteThread(self.open_close_thread)
	self.open_close_thread = CreateGameTimeThread(function()
		local anim = self:GetStateText()
		if anim ~= "idle" and anim ~= "idleOpened" then
			Sleep(self:TimeToAnimEnd())
		end
		local opened = self:IsOpened()
		local current_state = GetStateName(self:GetState())
		if opened and current_state == "idleOpened" or not opened and current_state == "idle" then
			return
		end
		PlayFX("MoistureVaporator", opened and "open_start" or "close_start", self)
		local new_anim = opened and "opening" or "closing"
		if new_anim ~= anim then
			self:SetAnim(1, new_anim)
		end
		if opened then
			self:SetIsNightLightPossible(true)
		end
		Sleep(self:TimeToAnimEnd())
		if opened then
			self:SetAnim(1, "idleOpened")
			else
			self:SetAnim(1, "idle")
		end
		PlayFX("MoistureVaporator", opened and "open" or "close", self)
		if not opened then
			self:SetIsNightLightPossible(false)
		end
	end)
end]]
function ZSpectralGenerator:ToggleOpenedState(broadcast)
	local opened = not self.opened
	if broadcast then
		local list = self.city.labels.ZSpectralGenerator or empty_table
		for i, obj in ipairs(list) do
			if not obj:RepairNeeded() and obj.opened ~= opened then
				obj.opened = opened
				obj:OnChangeState()
			end
		end
		else
		if self:RepairNeeded() then
			return
		end
		self.opened = opened
		self:OnChangeState()
	end
	RebuildInfopanel(self)
end
function ZSpectralGenerator:GetUIOpenStatus()
	return self:IsOpened() and T({7356, "Open"}) or T({7357, "Closed"})
end
function ZSpectralGenerator:OnSetWorking(working)
	ElectricityProducer.OnSetWorking(self, working)
	self:OnChangeState()
end

function ZSpectralGenerator:UpdateSound(PlayFX)

	if self:IsOpened() then PlayFX("Object MoistureVaporator Loop", self) else
	PlayFX("ItemSelectorIn", "start")


	end
end


--function ZSpectralGenerator:GetAdditionalProduction()
--local optimal_production = self.electricity_production * self.production_factor_interacted / --self.energyBonus
--return optimal_production - self.electricity.production
--end


--SpectraFuction of Time Update

function OnMsg.NewHour()
	SpectraCurrentHour = UICity.hour
end

--Spectra Function of Energy Control
function ZSpectralGenerator:energyBonus()

	if SpectraCurrentHour < 7 then
		energyBonus = 200
		elseif SpectraCurrentHour > 19 then
		energyBonus = 200
		else
		energyBonus = 100
	end
	return energyBonus
end

--Spectra Function of Energy Control

-- function ZSpectralGenerator:energyLoss()
--
-- 	if SpectraCurrentHour < 5 then energyLoss = 200
-- 	elseif SpectraCurrentHour > 20 then energyLoss = 200
-- 	else energyLoss = 100
-- 	end
-- 	return energyLoss
-- end
function ZSpectralGenerator:energyLoss()
	if SpectraCurrentHour > 15 and SpectraCurrentHour < 5 then energyLoss = 200
	elseif SpectraCurrentHour <14 and SpectraCurrentHour> 6 then energyLoss = 100
	end
	return energyLoss
end



function ZSpectralGenerator:energyStormLoss()
	if g_DustStorm then
		energyStormLoss = 200
	else energyStormLoss = 100
	end
	return energyStormLoss
end


-- function ZSpectralGenerator:GetHeatRange()
-- 	return 10*self.effect_range*guim
-- end
-- function ZSpectralGenerator:GetHeatBorder()
-- 	return const.SubsurfaceHeaterFrameRange
-- end
