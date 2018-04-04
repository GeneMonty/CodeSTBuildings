DefineClass.ZSpectraBattery = {
  __parents = {
    "Building",
    "ElectricityGridObject"
  },
  properties = {
    {
      template = true,
      id = "max_electricity_charge",
      name = T({
        938,
        "Max consumption while charging"
      }),
      category = "Power Storage",
      editor = "number",
      default = 100,
      help = "This is the amount of electricity the battery can charge per hour.",
      modifiable = true
    },
    {
      template = true,
      id = "max_electricity_discharge",
      name = T({
        939,
        "Max output while discharging"
      }),
      category = "Power Storage",
      editor = "number",
      default = 100,
      help = "This is the amount of electricity the battery can discharge per hour.",
      modifiable = true
    },
    {
      template = true,
      id = "conversion_efficiency",
      name = T({
        940,
        "Conversion efficiency % (charging)"
      }),
      category = "Power Storage",
      editor = "number",
      default = 90,
      help = "(100 - this number)% will go to waste when charging.",
      modifiable = true
    },
    {
      template = true,
      id = "capacity",
      name = T({
        941,
        "Capacity (watts*hour)"
      }),
      editor = "number",
      category = "Power Storage",
      default = 1000,
      modifiable = true
    },
    {
      template = true,
      id = "charge_animation",
      name = T({
        942,
        "Change animation"
      }),
      editor = "combo",
      default = "none",
      items = function(obj)
        return GetEntityStatesForTemplateObj(obj, true)
      end,
      category = "Power Storage",
      help = "If not none will play said animation, where the start of the anim will be when charge == 0 and the end of the anim will be when charge is 100%."
    },
    {
      template = true,
      id = "empty_state",
      name = T({
        943,
        "Empty state"
      }),
      editor = "combo",
      default = "none",
      items = function(obj)
        return GetEntityStatesForTemplateObj(obj, true)
      end,
      category = "Power Storage",
      help = "If charge anim is none this is ignored. Will set said state when storage == 0 and no anim is playing."
    },
    {
      template = true,
      id = "full_state",
      name = T({944, "Full state"}),
      editor = "combo",
      default = "none",
      items = function(obj)
        return GetEntityStatesForTemplateObj(obj, true)
      end,
      category = "Power Storage",
      help = "If charge anim is none this is ignored. Will set said state when storage == 100% and no anim is playing."
    },
    {
      id = "StoredPower",
      name = T({
        945,
        "Stored Power"
      }),
      editor = "number",
      default = 0,
      scale = const.ResourceScale,
      no_edit = true
    }
  },
  building_update_time = 5000,
  mode = "charging",
  cur_phase = false,
  play_fx_on_next_update = false,
  last_fx_moment = false,
  deflate_on_constructed = true,
  pin_progress_value = "StoredPower",
  pin_progress_max = "capacity"
}
function ZSpectraBattery:OnModifiableValueChanged(prop)
  if self.electricity and (prop == "max_electricity_charge" or prop == "max_electricity_discharge" or prop == "conversion_efficiency" or prop == "capacity") then
    self.electricity.charge_efficiency = self.conversion_efficiency
    self.electricity.storage_capacity = self.capacity
    if self.electricity.grid and self.electricity.current_storage > self.capacity then
      local delta = self.electricity.current_storage - self.capacity
      self.electricity.current_storage = self.capacity
      self.electricity.grid.current_storage = self.electricity.grid.current_storage - delta
    end
    self.electricity:SetStorage(self.max_electricity_charge, self.max_electricity_discharge)
  end
end
function ZSpectraBattery:CreateElectricityElement()
  self.electricity = NewSupplyGridStorage(self, self.capacity, self.max_electricity_charge, self.max_electricity_discharge, self.conversion_efficiency)
  self.electricity:SetStoredAmount(self.StoredPower, "electricity")
end
function ZSpectraBattery:ShouldShowNotConnectedToGridSign()
  return self:ShouldShowNotConnectedToPowerGridSign()
end
function ZSpectraBattery:ShouldShowNotConnectedToPowerGridSign()
  return not self.parent_dome and #self.electricity.grid.producers <= 0
end
function ZSpectraBattery:OnDestroyed()
  if self.full_state ~= "none" then
    self:SetAnim(1, self.full_state, 0, 0)
  end
  ElectricityGridObject.OnDestroyed(self)
end
function ZSpectraBattery:GameInit()
  if self.charge_animation ~= "none" then
    if self.deflate_on_constructed then
      local dur = GetAnimDuration(self:GetEntity(), self.charge_animation)
      local next_phase = self.electricity and MulDivRound(self.electricity.current_storage, dur, self.electricity.storage_capacity) or 0
      self:SetAnim(1, self.charge_animation, const.eReverse, 1000)
      self.deflate_on_constructed = GameTime() + dur * ((dur - next_phase) / dur)
      if not self.electricity or not self.electricity:CanDischarge() then
        CreateGameTimeThread(g_CObjectFuncs.SetSIModulation, self, 0)
      end
    elseif self.empty_state ~= "none" then
      self:SetAnim(1, self.empty_state, 0, 0)
    else
      self:SetAnim(1, self.charge_animation)
      self:SetAnimSpeed(1, 0)
      self:SetAnimPhase(1, 0)
    end
  end
end
function ZSpectraBattery:SetStorageState(resource, state)
  self.mode = state
end
function ZSpectraBattery:UpdateAttachedSigns()
  self:AttachSign(self:ShouldShowNotConnectedToPowerGridSign(), "SignNoPowerProducer")
end
function ZSpectraBattery:ChangeWorkingStateAnim(working)
  if not working then
    self:SetAnimSpeed(1, 0)
    self.play_fx_on_next_update = false
  end
end
function ZSpectraBattery:OnSetWorking(working)
  Building.OnSetWorking(self, working)
  local electricity = self.electricity
  if working then
    electricity:UpdateStorage()
  else
    electricity:SetStorage(0, 0)
  end
end
function ZSpectraBattery:MoveInside(dome)
  return ElectricityGridObject.MoveInside(self, dome)
end
function ZSpectraBattery:MyPlayFX(ev, moment, ...)
  if self.last_fx_moment ~= moment then
    PlayFX(ev, moment, ...)
    self.last_fx_moment = moment
  end
end
function ZSpectraBattery:PlayFXHooks(cur_phase, next_phase, dur)
  if cur_phase == 0 then
    self:MyPlayFX("Battery", "charge0", self)
  elseif cur_phase == dur - 1 then
    self:MyPlayFX("Battery", "charge100", self)
  elseif next_phase == dur then
    self.play_fx_on_next_update = "charge100"
  elseif next_phase == 0 then
    self.play_fx_on_next_update = "charge0"
  elseif cur_phase >= dur / 2 and next_phase < dur / 2 or cur_phase <= dur / 2 and next_phase > dur / 2 then
    self:MyPlayFX("Battery", "charge50", self)
  end
end
function ZSpectraBattery:BuildingUpdate(delta, day, hour)
  if not self.working or self.deflate_on_constructed and GameTime() <= self.deflate_on_constructed then
    return
  end
  if self.play_fx_on_next_update then
    self:MyPlayFX("Battery", self.play_fx_on_next_update, self)
    self.play_fx_on_next_update = false
  end
  local electricity = self.electricity
  if self.charge_animation ~= "none" then
    local dur = GetAnimDuration(self:GetEntity(), self.charge_animation)
    local next_phase = MulDivRound(electricity.current_storage, dur, electricity.storage_capacity)
    local cur_phase = self.cur_phase or self:GetAnimPhase(1)
    if abs(cur_phase - next_phase) > 10 then
      self:PlayFXHooks(cur_phase, next_phase, dur)
      local flags = 0
      if next_phase < cur_phase then
        flags = const.eReverse
      end
      local phase_delta = abs(cur_phase - next_phase)
      local speed = MulDivRound(1000, phase_delta, self.building_update_time)
      self:SetAnim(1, self.charge_animation, flags, speed)
      self:SetAnimPhase(1, cur_phase)
    elseif self.empty_state ~= "none" and next_phase <= 1 then
      self:SetAnim(1, self.empty_state, 0, 0)
    elseif self.full_state ~= "none" and next_phase == dur then
      self:SetAnim(1, self.full_state, 0, 0)
    else
      if GetStateName(self:GetAnim(1)) ~= self.charge_animation then
        self:SetAnim(1, self.charge_animation, 0, 0)
      end
      self:SetAnimPhase(1, next_phase)
      self:SetAnimSpeed(1, 0)
    end
    if self.electricity:CanDischarge() then
      self:SetSIModulation(1000)
    else
      self:SetSIModulation(0)
    end
    self.cur_phase = next_phase
  end
end
function ZSpectraBattery:Getui_mode()
  local statuses = {
    discharging = T({
      946,
      "Discharging"
    }),
    charging = T({947, "Charging"}),
    empty = T({588, "Empty"}),
    full = T({948, "Full"})
  }
  return statuses[self.mode] or T({949, "idle"})
end
function ZSpectraBattery:CheatFill()
  self.electricity:SetStoredAmount(self.capacity, "electricity")
end
function ZSpectraBattery:CheatEmpty()
  self.electricity:SetStoredAmount(0, "electricity")
end
function ZSpectraBattery:GetStoredPower()
  return self.electricity.current_storage
end