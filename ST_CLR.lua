--[[
This building concept will try to simulate a desired 85 percent efficiency on water recycling inside surviving mars, it will  be a small asset, with no animations and simple footprint. It sole purpose, simulate a close loop for water system

Simply put The CL will generate water based on the maximum used on the colony, then, from that maximum we will substract 25% of it to finally get the 85% effiencicy of production.

-------------------------
-------------------------

*the building will check the maximun water used every game hour.

*if there no usage it will return 0

*else the building will use that value and reduce it by 25%

*the building will then produce the resulting amount in water simulate a close loop recycling efficiency.

*end

]]

DefineClass.zCloseLoop={
__parents={"WaterProducer","ElectricityConsumer","ResourceProducer"},
},

function zCloseLoop:BuildingUpdate()
        RebuildInfopanel(self)
end

function zCloseLoop:GameInit()
    self.enabled=true,
    self.accumulate_dust = not self:IsObjInDome(self)
    self.city=self.city or UICity
end

function zCloseLoop.OnSetWorking(working)
    Building.OnSetWorking(self,working)
    loca production - working and self.water_production or 0
        if self.water then
            self.water:SetProduction(production, production)
end


-- Check current hour to see if Working

function OnMsg.NewHour()
    SpectraNewHour = UICity.NewHour
end

--check newhour. if new hour check demand, no demand then no water returned else return 85% water.


function zCloseLoop:WaterReturned()
    if demand not 0 then demand * 0.85
    else WaterReturned = 0
    end
end


function zCloseLoop:demand()
    demand = resource_overview_obj:GetTotalRequiredWater()
end



--[[biser Coldwave

to get and aproximated value of x*0.85 use 117 on (x*10)/117 or

Muldivround(x,10,117)

function zCloseLoop:WaterReturned()
    if self.demand > 0 then
        self.WaterReturned = MulDivRound(self.demand, 100, 100 - 85)
    else
        self.WaterReturned = 0
    end
end

]]


]
