if (!isSurfaceInitiatied)
{
    surface_set_target(cardSurface);
    
    draw_sprite(sprite_index, 0, global.cardSizeX / 2, global.cardSizeY / 2);
   
    draw_set_colour(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_font(f_latin);
    
    var latinScale = 1;
    while (string_width(card.textLatin) * latinScale > 328)
    {
        latinScale -= 0.01;
    }
    
    var polishScale = 1;
    while (string_width(card.textPolish) * polishScale > 328)
    {
        polishScale -= 0.01;
    }
    
    var effectScale = 1;
    while (string_width(card.textEffect) * effectScale > 318)
    {
        effectScale -= 0.01;
    }
    
    draw_text_transformed(global.cardSizeX / 2, 20, card.textLatin, latinScale, latinScale, 0);
    draw_text_transformed(global.cardSizeX / 2, 60, card.textPolish, polishScale, polishScale, 0);
    draw_line(40, 98, global.cardSizeX - 40, 98);
    draw_text_transformed(global.cardSizeX / 2, 100, card.textEffect, effectScale, effectScale, 0);
    draw_set_colour(c_white);
    
    surface_reset_target();
    cardSprite = sprite_create_from_surface(cardSurface, 0, 0, global.cardSizeX, global.cardSizeY, false, false, global.cardSizeX / 2, global.cardSizeY / 2);
    surface_free(cardSurface);
    
    isSurfaceInitiatied = true;
}
else 
{
    var t = current_time / 1000;
    var freq = 0.28;
    var sway = sin(t * freq * (2 * pi) + sway_phase);
    var rot = sway * 3;
    var scale = cos(sway * 0.18) * 0.73;
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
    
    if (isDissolving)
    {
        shader_set(shd_dissolve);
        var map = shader_get_sampler_index(shd_dissolve, "dissolveTexture");
        var mapTex = sprite_get_texture(s_noiseTexture2, 0);
        texture_set_stage(map, mapTex);

        var dissolveValueUniform = shader_get_uniform(shd_dissolve, "dissolveValue");
        var burnSizeUniform = shader_get_uniform(shd_dissolve, "burnSize");
        var burnColorUniform = shader_get_uniform(shd_dissolve, "burnColor");

        shader_set_uniform_f(dissolveValueUniform, dissolveValue);
        shader_set_uniform_f(burnSizeUniform, 0.04);
        shader_set_uniform_f(burnColorUniform, 217 / 255, 160 / 255, 102 / 255, 1.0);
    }
    else if (card == o_cardManager.przezTrudyDoGwiazd)
    {
        shd       = shd_foil;
        u_offset  = shader_get_uniform(shd, "u_offset");
        u_speed   = shader_get_uniform(shd, "u_speed");
        u_time    = shader_get_uniform(shd, "u_time");
        u_uvs     = shader_get_uniform(shd, "u_uvs");
        u_intensity = shader_get_uniform(shd, "u_intensity");
        
        shader_set(shd);
        var uvs = sprite_get_uvs(sprite_index, image_index);
        shader_set_uniform_f(u_uvs,    uvs[0], uvs[1], uvs[2], uvs[3]);
        shader_set_uniform_f(u_offset, 0.0, 0.0); // pan the foil pattern
        shader_set_uniform_f(u_speed,  0.6); // 0.0 → 1.0
        shader_set_uniform_f(u_time,   current_time / 1000.0); // ms -> seconds
        shader_set_uniform_f(u_intensity, 0.4);
    }
    else if (card == o_cardManager.poSmierciNieCzasNaPrzyjemnosci)
    {
        shd       = shd_foil;
        u_offset  = shader_get_uniform(shd, "u_offset");
        u_speed   = shader_get_uniform(shd, "u_speed");
        u_time    = shader_get_uniform(shd, "u_time");
        u_uvs     = shader_get_uniform(shd, "u_uvs");
        u_intensity = shader_get_uniform(shd, "u_intensity");
        
        shader_set(shd);
        var uvs = sprite_get_uvs(sprite_index, image_index);
        shader_set_uniform_f(u_uvs,    uvs[0], uvs[1], uvs[2], uvs[3]);
        shader_set_uniform_f(u_offset, 0.0, 0.0); // pan the foil pattern
        shader_set_uniform_f(u_speed,  0.6); // 0.0 → 1.0
        shader_set_uniform_f(u_time,   current_time / 1000.0); // ms -> seconds
        shader_set_uniform_f(u_intensity, 0.1);
    }
    
    draw_sprite_ext(cardSprite, 0, x, y + y_bob + yOffset, scale, scale, rot, c_white, 1);
    shader_reset();
}