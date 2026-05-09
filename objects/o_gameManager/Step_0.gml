if (!init)
{
    init = true;
    
    o_inventory.add_card();
    o_inventory.add_card();
    
    startRound();
}

hover_character_under_mouse();
hover_team_under_mouse();

if (mouse_check_button_pressed(mb_left))
{
    for (var i = 0; i < array_length(o_inventory.inventory); ++i)
    {
        if (o_inventory.inventory[i].isHovered)
        {
            pickedCard = o_inventory.inventory[i];
            o_inventory.inventory[i].pick();
            
            selectType = o_inventory.inventory[i].card.selectType;
            cardEffect = o_inventory.inventory[i].card.effect;
            
            break;
        }
    }
}

if (usedCards >= 3)
{
    startCombatDebate();
}

if (array_length(enemiesCharacters) <= 0)
{
    startNewWave();
}
    
if (selectType != undefined and cardEffect != undefined)
{
    if (selectType == SelectType.All)
    {
        cardEffect();
        selectType = undefined;
        cardEffect = undefined;
        
        usedCards += 1;
        o_inventory.remove_card(pickedCard);
        pickedCard = undefined;
    }
    else if (selectType == SelectType.Team)
    {
        var target = selectTeamUnderMouse();
        
        if (target != undefined)
        {
            if (hoveredTeam == Team.Player)
            {
                cardEffect(playerCharacters);
            }
            else
            {
                cardEffect(enemiesCharacters);
            }
            
            selectType = undefined;
            cardEffect = undefined;
            
            usedCards += 1;
            o_inventory.remove_card(pickedCard);
            pickedCard = undefined;
        }
    }
    else
    {
        var target = selectCharacterUnderMouse();
        
        if (target != undefined)
        {
            cardEffect(target);
            selectType = undefined;
            cardEffect = undefined;
            
            usedCards += 1;
            o_inventory.remove_card(pickedCard);
            pickedCard = undefined;
        }
    }
}