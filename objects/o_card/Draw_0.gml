if (!isSurfaceInitiatied)
{
    surface_set_target(cardSurface);
    
    draw_sprite(sprite_index, 0, global.cardSizeX / 2, global.cardSizeY / 2);
   
    draw_set_colour(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_font(f_latin);
    draw_text(global.cardSizeX / 2, 20, textLatin);
    draw_text(global.cardSizeX / 2, 60, textPolish);
    draw_text(global.cardSizeX / 2, 100, textEffect);
    draw_set_colour(c_white);
    
    surface_reset_target();
    cardSprite = sprite_create_from_surface(cardSurface, 0, 0, global.cardSizeX, global.cardSizeY, false, true, global.cardSizeX / 2, global.cardSizeY / 2);
    surface_free(cardSurface);
    
    isSurfaceInitiatied = true;
}
else 
{
    var t = current_time / 1000;
    var freq = 0.28;
    var sway = sin(t * freq * (2 * pi) + sway_phase);
    var rot = sway * 3;
    var scale = cos(sway * 0.18);
    var y_bob = sin(t * freq * (4 * pi) + sway_phase) * 1.5;
    var yOffset = 0;
   
    if (isHovered)
    {
       yOffsetLerp = lerp(yOffsetLerp, -30, 0.1);
       scaleLerp = lerp(scaleLerp, 1.15, 0.1);
    }
    else 
    {
   	    yOffsetLerp = lerp(yOffsetLerp, 0, 0.1);
        scaleLerp = lerp(scaleLerp, 1, 0.1);
    }
   
    yOffset = yOffsetLerp;
    scale *= scaleLerp;
    
    draw_sprite_ext(cardSprite, 0, x, y + y_bob + yOffset, scale, scale, rot, c_white, 1); 
}