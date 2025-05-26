-- data/routes.lua
GarbageRoutes = {
    {
        vector3(-350.1, -1568.6, 25.2),
        vector3(-340.1, -1560.6, 25.2),
        vector3(-330.1, -1550.6, 25.2)
    },
    {
        vector3(215.8, -810.1, 29.7),
        vector3(220.5, -820.0, 29.6),
        vector3(230.2, -830.5, 29.5)
    }
}

_G.GetRandomGarbageRoute = function()
    local index = math.random(1, #GarbageRoutes)
    return GarbageRoutes[index]
end
