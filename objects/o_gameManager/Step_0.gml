if (!init)
{
    init = true;
    
    o_inventory.add_card();
    o_inventory.add_card();
    
    startRound();
}

if (mouse_check_button_pressed(mb_left))
{
    for (var i = 0; i < array_length(o_inventory.inventory); ++i)
    {
        if (o_inventory.inventory[i].isHovered)
        {
            o_inventory.inventory[i].use();
            pickedCards += 1;
            o_inventory.remove_card(o_inventory.inventory[i]);
        }
    }
}

if (pickedCards >= 3)
{
    startCombatDebate();
}

if (array_length(enemiesCharacters) <= 0)
{
    startNewWave();
}