if (!init)
{
    init = true;
    
    o_inventory.add_card();
    o_inventory.add_card();
    
    startRound();
}

hover_character_under_mouse();
hover_team_under_mouse();

if (roundState != RoundState.Visualization and mouse_check_button_pressed(mb_left))
{
    for (var i = 0; i < array_length(o_inventory.inventory); ++i)
    {
        if (o_inventory.inventory[i].isHovered)
        {
            if (pickedCard != undefined)
            {
                o_inventory.arrange();
            }
            
            pickedCard = o_inventory.inventory[i];
            o_inventory.inventory[i].pick();
            
            selectType = o_inventory.inventory[i].card.selectType;
            cardEffect = o_inventory.inventory[i].card.effect;
            
            break;
        }
    }
}

if (usedCards >= 3 and roundState == RoundState.PickingCards)
{
    runFight();
}

if (roundState == RoundState.Visualization and o_inventory.yHide > 399)
{
    runEvent(fightEvents[0]);
    
    if (array_length(fightEvents) <= 0)
    {
        startRound();
    }
}

if (array_length(enemiesCharacters) <= 0)
{
    var percent = o_cardManager.chancesForAstra / array_length(o_cardManager.cardTypes) * 100;
    
    while(percent + 1 > o_cardManager.chancesForAstra / array_length(o_cardManager.cardTypes) * 100)
    {
        o_cardManager.chancesForAstra++;
        array_push(o_cardManager.cardTypes, o_cardManager.przezTrudyDoGwiazd);
    }
    
    startNewWave();
}

if (selectType != SelectType.Duo)
{
    if (array_length(selectedDuo) == 1)
    {
        selectedDuo[0].image_blend = c_white;
    }
    
    array_delete(selectedDuo, 0, array_length(selectedDuo));
}

if (array_length(selectedDuo) == 1)
{
    selectedDuo[0].image_blend = c_lime;
}

if (roundState != RoundState.Visualization and selectType != undefined and cardEffect != undefined)
{
    var usedCardsOld = usedCards;
    if (selectType == SelectType.All)
    {
        cardEffect();
        selectType = undefined;
        cardEffect = undefined;
        
        usedCards += 1;
        pickedCard.use();
        o_inventory.remove_card(pickedCard);
        pickedCard = undefined;
    }
    else if (selectType == SelectType.Duo)
    {
        var target = selectCharacterUnderMouse();
        
        if (target != undefined)
        {
            if (array_length(selectedDuo) == 1 and selectedDuo[0] == target)
            {
                array_delete(selectedDuo, 0, 1);
            }
            else
            {
            	array_push(selectedDuo, target);
            }
        }
        
        if (array_length(selectedDuo) == 2)
        {
            cardEffect(selectedDuo[0], selectedDuo[1]);
            selectType = undefined;
            cardEffect = undefined;
            array_delete(selectedDuo, 0, array_length(selectedDuo));
             
            usedCards += 1;
            pickedCard.use();
            o_inventory.remove_card(pickedCard);
            pickedCard = undefined;
        }

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
            pickedCard.use();
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
            pickedCard.use();
            o_inventory.remove_card(pickedCard);
            pickedCard = undefined;
        }
    }
    
    if (usedCards != usedCardsOld and roundState == RoundState.PickingCards and array_length(enemiesCharacters) <= 0)
    {
        startRound();
    }
}