ServerLogoHUD <-
{
    Fields =
    {
        logo =
        {
            slot = g_ModeScript.HUD_FAR_RIGHT,
            dataval = "UNIFIX Servers",
            flags = g_ModeScript.HUD_FLAG_ALIGN_RIGHT | g_ModeScript.HUD_FLAG_NOBG | g_ModeScript.HUD_FLAG_BLINK,
            name = "serverlogohud"
        }
    }
}

HUDSetLayout(ServerLogoHUD)
HUDPlace(g_ModeScript.HUD_FAR_RIGHT, 0.500000, 0.000000, 0.500000, 0.079999)
