-- Working CSS Ladders 0.2 by Brainles$
-- Place in init folder
-- Early release for testing, cleanup, and finetuning will be done.
-- ladder dismount and sideways climbing to be added later.

LADDERMATERIAL = "TOOLS/TOOLSINVISIBLELADDER"

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

if CssLadderThink then HaltTimer(CssLadderThink) end
CssLadderThink = AddTimer(0, 0, function()
    for i = 1, _MaxPlayers() do
        if not _PlayerInfo(i, "alive") or (alive and not alive[i]) then return end

        local isonladder = false
        local origin = _EntGetPos(i)

        for _, direction in ipairs(CssLadderDirections) do
            _TraceSetMask(MASK_SOLID)
            _TraceLine(origin, direction, 40, i)
            if _TraceGetTexture() == LADDERMATERIAL then
                isonladder = true
                break
            end
        end

        if not isonladder then
             _PlayerLockInPlace(i, false)
            return
        end

        if _PlayerIsKeyDown(i, IN_FORWARD) then
            _TraceSetMask(MASK_SOLID)
            _TraceLine(_PlayerGetShootPos(i), vector3(0, 0, -1), 80, i)

            local newvel = vecMul(vector3(0,0,1), _PlayerGetShootAng(i))

            if _TraceHitWorld() then
                newvel = vecMul(vector3(150, 150, 1), _PlayerGetShootAng(i))
            end

            _PlayerLockInPlace(i, false)
            _EntSetVelocity(i, vecMul(newvel, vector3(1, 1, 300)))

        elseif _PlayerIsKeyDown(i, IN_BACK) then
            _TraceSetMask(MASK_SOLID)
            _TraceLine(_PlayerGetShootPos(i), vector3(0, 0, -1), 80, i)

            local newvel = vecMul(vector3(0,0,1), _PlayerGetShootAng(i))

            if _TraceHitWorld() then
                newvel = vecMul(vector3(150, 150, 1), _PlayerGetShootAng(i))
            end

            _PlayerLockInPlace(i, false)
            _EntSetVelocity(i, vecMul(newvel, vector3(-1, -1, -300)))
        else
            _PlayerLockInPlace(i, true)
        end
    end
end)
