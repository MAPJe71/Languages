-- https://github.com/notepad-plus-plus/notepad-plus-plus/issues/4563

local magdipoleVecZero     = Vector()
local magdipoleAngZero     = Angle ()
local magdipoleMetersGLU   = 0.01905 -- Convert the [glu] length to meters
local magdipoleNullModel   = "null"
local magdipoleSentName    = "gmod_magnetdipole"
local magdipoleEpsilonZero = 1e-5

function magdipoleGetNullModel()
  return magdipoleNullModel end

function magdipoleGetSentName()
  return magdipoleSentName end

function magdipoleGetZeroVacAng()
  return magdipoleVecZero, magdipoleAngZero end

function magdipoleSelect(bCnd, vT, vF)
  if (bCnd) then return vT else return vF end
end

--Extracts valid physObj ENT from trace
function magdipoleGetTracePhys(oTrace)
  if(not oTrace     ) then return nil end -- Duhh ...
  if(not oTrace.Hit ) then return nil end -- Did not hit anything
  if(oTrace.HitWorld) then return nil end -- It's not Entity
  local trEnt = oTrace.Entity
  if(trEnt                              and
     trEnt:IsValid()                    and
     trEnt:GetPhysicsObject():IsValid() and not
         ( trEnt:IsPlayer()  or
           trEnt:IsNPC()     or
           trEnt:IsVehicle() or
           trEnt:IsRagdoll() or
           trEnt:IsWidget() )
  ) then return trEnt end  -- PhysObj ENT
  return nil -- Some other kind of ENT
end

function magdipoleGetEpsilonZero()
  return magdipoleEpsilonZero
end
