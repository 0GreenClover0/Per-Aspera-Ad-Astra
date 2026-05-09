draw_sprite(s_topBar, 0, room_width / 2, -15);
draw_set_colour(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(room_width / 2, 7, textCombatOrDebate);
draw_sprite_ext(s_statIcons, roundType, room_width / 2 - string_width(textCombatOrDebate) / 2 - sprite_get_width(s_statIcons) / 1.7, 22, 0.7, 0.7, 0, c_white, 1);
draw_sprite_ext(s_statIcons, roundType, room_width / 2 + string_width(textCombatOrDebate) / 2 + sprite_get_width(s_statIcons) / 1.7, 22, -0.7, 0.7, 0, c_white, 1);

if (hoveredCharacter != undefined)
{
    var numberOfStatusEffects = array_length(hoveredCharacter.statusEffects);
    for (var i = 0; i < numberOfStatusEffects; i++)
    {
        draw_text(mouse_x, mouse_y + i * 20, o_character.effectToString(hoveredCharacter.statusEffects[i]));
    }
}