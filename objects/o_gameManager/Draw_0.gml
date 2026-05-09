draw_set_colour(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_sprite_ext(s_topBar, 0, room_width / 2, 35, 0.9, 1, 0, c_white, 1);

battleY = lerp(battleY, battleYTarget, 0.05);
debateY = lerp(debateY, debateYTarget, 0.05);

draw_sprite(s_topBar, 0, room_width / 2, battleY);
draw_text(room_width / 2, 7 + battleY + 15, "Walka na ATK");
draw_sprite_ext(s_statIcons, 0, room_width / 2 - string_width(textCombatOrDebate) / 2 - sprite_get_width(s_statIcons) / 1.7, 22 + battleY + 35 - 18, 0.7, 0.7, 0, c_white, 1);
draw_sprite_ext(s_statIcons, 0, room_width / 2 + string_width(textCombatOrDebate) / 2 + sprite_get_width(s_statIcons) / 1.7, 22 + battleY + 35 - 18, -0.7, 0.7, 0, c_white, 1);

draw_sprite(s_topBar, 0, room_width / 2, debateY);
draw_text(room_width / 2, 7 + debateY + 15, "Debata na INT");
draw_sprite_ext(s_statIcons, 1, room_width / 2 - string_width(textCombatOrDebate) / 2 - sprite_get_width(s_statIcons) / 1.7, 22 + debateY + 35 - 18, 0.7, 0.7, 0, c_white, 1);
draw_sprite_ext(s_statIcons, 1, room_width / 2 + string_width(textCombatOrDebate) / 2 + sprite_get_width(s_statIcons) / 1.7, 22 + debateY + 35 - 18, -0.7, 0.7, 0, c_white, 1);

var sentenceCounter = string("Jescze {0} sentencje", 3 - usedCards);

if (usedCards == 2)
{
    sentenceCounter = string("Jescze {0} sentencja", 3 - usedCards);
}

draw_text(room_width / 2, 60, sentenceCounter);