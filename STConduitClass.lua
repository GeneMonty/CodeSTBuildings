DefineClass.zSTConduit={
  __parents={"ElectricityProducer"},

  properties={
  {
      template=true,
      id="production_factor_interacted",
      name = Untranslated("Interacted Production Coef%"),
      category="Power Production",
      editor="number",
      default=100,
      modifiable=true
  },
  {
    template = true,
    id = "daily_dust_accumulation",
    name = Untranslated("Daily dust accumulation when opened"),
    category = "Power Production",
    editor = "number",
    default = 10000
  }
},
  building_update_time=const.HourDuration,
  enabled=false,
  disabled=false
}
-- function zSTConduit:Init()
--   self.enabled=false
-- end

function zSTConduit:GameInit()
  self.enabled=true
  self.city = self.city or UICity
end


---------------------------------------------

function zSTConduit:SelectObj(self)
  PlayFX("SensorTower","start")

end

function OnMsg.GatherFXActors(list)
	list[#list + 1] = "SensorTower"
end






























function zSTConduit:Playsound()
	self.enabled = CreateGameTimeThread(function()
    while true do
    PlayFX("DroneRechargePulse", "start", self)
    PlayFX("DroneRechargeCoilArc", "start", self)
    PlayFX("RechargeStation", "start", self)
    PlayFX("RechargeStationPlatform", "start", self)
  end
  end)
end

function OnMsg.SelectedObjChange(obj, prev)
	-- if obj and IsKindOf(obj) then
      PlayFX("DroneRechargePulse", "start", self)
    --obj:UpdateProduction() -- force recalc of shadow state when panel is selected
	end

function zSTConduit:Done()
  PlayFX("Working", "end", self)
end
