local CATEGORY_NAME = "LModule"

function ulx.latch(calling_ply, ent)
    ent = calling_ply:GetEyeTrace().Entity
    local isLatched = ent:GetSaveTable().m_bLocked
    if IsValid(ent) then
        if isLatched == true then
            ent:Fire("Unlock")
            ulx.fancyLogAdmin( calling_ply, true, "#A unlocked door, Entity[#s]", tostring(ent:EntIndex()))
        elseif isLatched == false then
            ent:Fire("Lock")
            ulx.fancyLogAdmin( calling_ply, true, "#A locked door, Entity[#s]", tostring(ent:EntIndex()))
        end
    else
        ulx.fancyLog("That is not a valid door, #s!", calling_ply:GetName())
    end
end

local latch = ulx.command( CATEGORY_NAME, "ulx latch", ulx.latch, "!latch", false)
latch:defaultAccess( ULib.ACCESS_ADMIN )
latch:help( "Locks or unlocks a map door." )

////////////////////////////////////////////////////////////////////////////////
/*
function ulx.isolate(calling_ply)
    for k, v in pairs(player.GetAll()) do
        ulx.fancyLogAdmin(true,"#s --> #s Props, ",v:GetName(),tostring(v:GetCount("prop_*")))
    end
end

local isolate = ulx.command( CATEGORY_NAME, "ulx isolate", ulx.isolate, "!isolate", false)
isolate:defaultAccess( ULib.ACCESS_ADMIN )
isolate:help( "Lists players and their ownership data." )
*/
////////////////////////////////////////////////////////////////////////////////

function ulx.broom(calling_ply)
    for k,v in pairs(ents.GetAll()) do
        v:RemoveAllDecals()
        v:Extinguish()

        if v:GetClass() == "gib" then
            v:Remove()
        elseif string.sub(v:GetClass(), 1, 5) == "item_" then
            v:Remove()
        elseif v:GetClass() == "helicopter_chunk" then
            v:Remove()
        elseif string.sub(v:GetClass(), 1, 7) == "weapon_" then
            if !v:IsWeaponVisible() then
                v:Remove()
            end
        elseif v:GetClass() == "prop_ragdoll" then
                v:Remove()
        end
    end

    for k,v in pairs(player.GetAll()) do
        v:SendLua("game.RemoveRagdolls()")
        v:ConCommand("r_cleardecals")
        v:ConCommand("stopsound")
    end

    ulx.fancyLogAdmin( calling_ply, "#A swept the floor")
end

local broom = ulx.command( CATEGORY_NAME, "ulx broom", ulx.broom, "!broom", false)
broom:defaultAccess( ULib.ACCESS_ADMIN )
broom:help("Cleans up stray gibs, ragdolls, decals, fires, and stops sounds.")