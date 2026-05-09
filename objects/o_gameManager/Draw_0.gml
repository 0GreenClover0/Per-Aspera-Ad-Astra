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

var sentenceCounter = string("Jeszcze {0} sentencje", 3 - usedCards);

if (usedCards == 2)
{
    sentenceCounter = string("Jeszcze {0} sentencja", 3 - usedCards);
}

if (usedCards == 3)
{
    if (array_length(fightEvents) > 0)
    {
        var dmgStat = roundType == FightType.Combat ? fightEvents[0].who.atk : fightEvents[0].who.int;
        var defStat = fightEvents[0].whom.def;
    
        sentenceCounter = string("[A]{0} - [D]{1} = [H]{2}", dmgStat, defStat, max(0, fightEvents[0].dmg));
        
        var attackIcon = string_width(string_copy(sentenceCounter, 0, string_pos("[A]", sentenceCounter)));
        var defenseIcon = string_width(string_copy(sentenceCounter, 0, string_pos("[D]", sentenceCounter)));
        var damageIcon = string_width(string_copy(sentenceCounter, 0, string_pos("[H]", sentenceCounter)));
        
        draw_sprite_ext(s_statIcons, 0, room_width / 2 - string_width(sentenceCounter) / 2 + attackIcon + 15, 80, 0.75, 0.75, 0, c_white, 1);
        draw_sprite_ext(s_statIcons, 2, room_width / 2 - string_width(sentenceCounter) / 2 + defenseIcon + 15, 80, 0.75, 0.75, 0, c_white, 1);
        draw_sprite_ext(s_heart, 1, room_width / 2 - string_width(sentenceCounter) / 2 + damageIcon + 7, 80, 2, 2, 0, c_white, 1);
        sentenceCounter = string_replace(sentenceCounter, "[A]", "      ");
        sentenceCounter = string_replace(sentenceCounter, "[D]", "      ");
        sentenceCounter = string_replace(sentenceCounter, "[H]", "      ");
    }
}

draw_text(room_width / 2, 60, sentenceCounter);