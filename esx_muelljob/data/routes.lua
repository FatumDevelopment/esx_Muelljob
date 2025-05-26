-- data/routes.lua

GarbageRoutes = {
    {
        vector3(67.21, -1318.92, 29.22),   -- Strawberry Ave
        vector3(249.76, -1347.99, 29.66),
        vector3(443.94, -1498.47, 29.29),
        vector3(185.85, -1600.76, 29.03),
        vector3(-38.91, -1391.24, 29.18)
    },
    {
        vector3(-708.44, -905.89, 19.22), -- Vespucci Blvd
        vector3(-930.67, -1125.63, 2.16),
        vector3(-1061.77, -1160.57, 2.74),
        vector3(-1192.26, -1155.73, 6.65),
        vector3(-1305.28, -1010.72, 6.70)
    },
    {
        vector3(-1483.95, -537.14, 33.74), -- Del Perro Area
        vector3(-1455.24, -432.63, 34.26),
        vector3(-1412.08, -298.55, 45.01),
        vector3(-1337.88, -138.29, 48.51),
        vector3(-1221.45, -130.38, 39.32)
    },
    {
        vector3(362.56, 297.48, 103.51), -- Vinewood Area
        vector3(433.05, 206.81, 103.14),
        vector3(512.90, 180.19, 104.74),
        vector3(601.47, 169.31, 97.23),
        vector3(682.76, 129.55, 80.75)
    },
    {
        vector3(1030.72, -193.56, 70.74), -- Mirror Park & East Vinewood
        vector3(1103.77, -390.22, 66.89),
        vector3(1193.37, -574.35, 64.76),
        vector3(1251.92, -644.16, 67.05),
        vector3(1315.42, -707.12, 65.35)
    },
    {
        vector3(834.99, -1025.78, 26.62), -- La Mesa & El Burro
        vector3(1022.64, -1203.88, 25.57),
        vector3(1137.58, -1334.33, 35.73),
        vector3(1258.67, -1400.88, 35.94),
        vector3(1380.89, -1521.40, 57.33)
    }
}

_G.GetRandomGarbageRoute = function()
    local index = math.random(1, #GarbageRoutes)
    return GarbageRoutes[index]
end
