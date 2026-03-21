-- Working CSS Ladders 1.1 by Brainles$
-- Place in init folder
-- Early release for testing, cleanup, and finetuning will be done.
-- ladder dismount and sideways climbing to be added later.

-- A lot of different ways to make ladders for CSS... if the map uses any of these for something else than ladders and
-- is where a player can get to it, might cause issues...
LADDERMATERIAL = {
    "TOOLS/TOOLSINVISIBLELADDER",
    "TOOLS/TOOLSPLAYERCLIP",
    "TOOLS/TOOLSNODRAW",
}

CssLadderDirections = {
    vector3(1, 0, 0),
    vector3(0.923, 0.382, 0),
    vector3(0.707, 0.707, 0),
    vector3(0.382, 0.923, 0),
    vector3(0, 1, 0),
    vector3(-0.382, 0.923, 0),
    vector3(-0.707, 0.707, 0),
    vector3(-0.923, 0.382, 0),
    vector3(-1, 0, 0),
    vector3(-0.923, -0.382, 0),
    vector3(-0.707, -0.707, 0),
    vector3(-0.382, -0.923, 0),
    vector3(0, -1, 0),
    vector3(0.382, -0.923, 0),
    vector3(0.707, -0.707, 0),
    vector3(0.923, -0.382, 0)
}

function LadderMaterialChecker(tracemat)
    for _, laddermaterial in LADDERMATERIAL do
        if tracemat == laddermaterial then return true end
    end
    return false
end

--Laddertimer can be set to 0 to be on think, but for online 0.1 might be better.
if CssLadderThink then HaltTimer(CssLadderThink) end
CssLadderThink = AddTimer(0.1, 0, function()
    for i = 1, _MaxPlayers() do
        if _PlayerInfo(i, "connected") then
            local isonladder = false
            local origin = _EntGetPos(i)

            if _EntGetWaterLevel(i) > 0 then
                origin = vecAdd(origin, vector3(0,0,10))
            end

            for _, direction in ipairs(CssLadderDirections) do
                _TraceSetMask(MASK_SOLID)
                _TraceLine(origin, direction, 40, i)
                if LadderMaterialChecker(_TraceGetTexture()) then
                    isonladder = true
                    break
                end
            end

            if isonladder then
                if _PlayerIsKeyDown(i, IN_FORWARD) then
                    _TraceSetMask(MASK_SOLID)
                    _TraceLine(_PlayerGetShootPos(i), vector3(0, 0, -1), 80, i)

                    local newvel = vecMul(vector3(0, 0, 1), _PlayerGetShootAng(i))

                    if _TraceHitWorld() then
                        newvel = vecMul(vector3(150, 150, 1), _PlayerGetShootAng(i))
                    end

                    _PlayerLockInPlace(i, false)
                    _EntSetVelocity(i, vecMul(newvel, vector3(1, 1, 300)))
                elseif _PlayerIsKeyDown(i, IN_BACK) then
                    _TraceSetMask(MASK_SOLID)
                    _TraceLine(_PlayerGetShootPos(i), vector3(0, 0, -1), 80, i)

                    local newvel = vecMul(vector3(0, 0, 1), _PlayerGetShootAng(i))

                    if _TraceHitWorld() then
                        newvel = vecMul(vector3(150, 150, 1), _PlayerGetShootAng(i))
                    end

                    _PlayerLockInPlace(i, false)
                    _EntSetVelocity(i, vecMul(newvel, vector3(-1, -1, -300)))
                else
                    _PlayerLockInPlace(i, true)
                end
            else
                _PlayerLockInPlace(i, false)
            end
        end
    end
end)
