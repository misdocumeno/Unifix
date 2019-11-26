ServerLogoHUD <-
{
    Fields =
    {
        logo =
        {
            slot = g_ModeScript.HUD_FAR_RIGHT,
            dataval = "UNIFIX Servers",
            flags = g_ModeScript.HUD_FLAG_NOBG | g_ModeScript.HUD_FLAG_ALIGN_LEFT,
            name = "serverlogohud"
        }
    }
}

HUDSetLayout(ServerLogoHUD)
HUDPlace(g_ModeScript.HUD_FAR_RIGHT, 0.7, 0.001, 1, 0.05)
g_ModeScript
