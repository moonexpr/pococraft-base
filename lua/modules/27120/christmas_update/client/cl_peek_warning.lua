surface.CreateFont( "WarningFont", {
    font = "coolvetica",
    size = 40,
    weight = 10,
    blursize = 0,
    outline = false,
} )
        
hook.Add( "HUDPaint", "", function()
    draw.DrawText( "Alpha Concept: This does not represent the final product", "WarningFont", surface.ScreenWidth() / 2, surface.ScreenHeight() - 40, Color(255, 255, 255, 250), TEXT_ALIGN_CENTER )
end )
