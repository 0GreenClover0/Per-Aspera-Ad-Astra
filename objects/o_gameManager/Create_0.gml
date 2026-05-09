window_set_fullscreen(true);

init = false;

playerCharacters = [];
enemiesCharacters = [];

textFightOrDebate = "";

enum RoundState
{
    PickingCards,
    Fight,
    Visualization,
}

enum FightType
{
    Combat,
    Debate
}

enum Team
{
    Player,
    Enemy,
}

roundState = RoundState.PickingCards;
roundType = FightType.Combat;
usedCards = 0;

fightEvents = [];

minEnemies = 1;
maxEnemies = 3;

pickedCard = undefined;
cardEffect = undefined;
selectType = undefined;

playerColumn = room_width / 2 - room_width * 0.27;
enemyColumn = room_width / 2 + room_width * 0.27;
startRow = room_height / 6;
rowIncrement = 100;

hoveredCharacter = undefined;
hoveredTeam = undefined;

battleY = -35;
battleYTarget = -35;

debateY = -35;
debateYTarget = -35;

spawnPlayerCharacters();
startNewWave();

function spawnPlayerCharacters()
{
    var rowMultiply = 0;
    for (var i = 0; i < 3; ++i)
    {
        var characterInstance = instance_create_depth(playerColumn, startRow + rowIncrement * rowMultiply, 1, o_character);
        characterInstance.team = Team.Player;
        characterInstance.randomizeParameters(10);
        array_push(playerCharacters, characterInstance);
        
        rowMultiply += 1;
    }
}

function startNewWave()
{
    var enemiesCount = irandom_range(minEnemies, maxEnemies);
    
    var maxHp = 0;
    var maxAtk = 0;
    var maxDef = 0;
    var maxInt = 0;
    var maxDex = 0;
    for (var i = 0; i < array_length(playerCharacters); ++i)
    {
        maxHp = max(maxHp, playerCharacters[i].hp);
        maxAtk = max(maxAtk, playerCharacters[i].atk);
        maxDef = max(maxDef, playerCharacters[i].def);
        maxInt = max(maxInt, playerCharacters[i].int);
        maxDex = max(maxDex, playerCharacters[i].dex);
    }
    
    var rowMultiply = 0;
    for (var i = 0; i < enemiesCount; ++i)
    {
        var characterInstance = instance_create_depth(enemyColumn, startRow + rowIncrement * rowMultiply, 1, o_character);
        characterInstance.team = Team.Enemy;
        characterInstance.image_xscale = -1;
        characterInstance.randomizeParameters(maxHp + maxAtk + maxDef + maxInt + maxDex);
        array_push(enemiesCharacters, characterInstance);
        
        rowMultiply += 1;
    }
}

function startRound()
{
    o_inventory.add_card();
    o_inventory.add_card();
    o_inventory.add_card();

    usedCards = 0;
    roundState = RoundState.PickingCards;
    roundType = irandom_range(0, 1);
    rewriteTextCombatOrDebate();
}

function rewriteTextCombatOrDebate()
{
    textCombatOrDebate = roundType == FightType.Combat ? "Walka na ATK" : "Debata na INT";
    
    if (roundType == FightType.Combat)
    {
        battleYTarget = -15;
        debateYTarget = -165;
    }
    else 
    {
    	battleYTarget = -165;
        debateYTarget = -15;
    }
}

function runEvent(event)
{
    show_debug_message("Events {0}", fightEvents);
    event.whom.hp = clamp(event.whom.hp - event.dmg, 0, event.whom.hp);
    
    if (event.whom.hp <= 0)
    {
        kill(event.whom);
    }
}

function kill(character)
{
    var arr;
    if (character.team == Team.Player)
    {
        arr = playerCharacters;
    }
    else
    {
        arr = enemiesCharacters;
    }
    
    for (var i = 0; i < array_length(arr); ++i)
    {
        if (arr[i] == character)
        {
            array_delete(arr, i, 1);
        }
    }
    
    if (hoveredCharacter == character)
    {
        hoveredCharacter = undefined;
    }
    
    character.unhover();
    
    character.die();
}

function runFight()
{
    roundState = RoundState.Fight;
    
    var sortedCharacters = array_concat(playerCharacters, enemiesCharacters);
    
    array_sort(sortedCharacters, function(current, next)
    {
        return next.dex - current.dex;
    });
    
    var savedHp = [];
    for (var i = 0; i < array_length(sortedCharacters); ++i)
    {
        array_push(savedHp, sortedCharacters[i].hp);
    }
    
    for (var i = 0; i < array_length(sortedCharacters); ++i)
    {
        if (!instance_exists(sortedCharacters[i]) or sortedCharacters[i].hp <= 0)
        {
            continue;
        }
        
        var dmg = roundType == FightType.Combat ? sortedCharacters[i].atk : sortedCharacters[i].int;
        
        var opponents;
        if (sortedCharacters[i].team == Team.Player)
        {
            opponents = enemiesCharacters;
        }
        else
        {
        	opponents = playerCharacters;
        }
        
        for (var k = 0; k < array_length(opponents); ++k)
        {
            if (opponents[k].hp <= 0)
            {
                continue;
            }
            
            var dealtDmg = dmg - opponents[k].def;
            
            opponents[k].hp = clamp(opponents[k].hp - dealtDmg, 0, opponents[k].hp);
            
            var event = {
                who: sortedCharacters[i],
                whom: opponents[k],
                dmg: dealtDmg
            };

            array_push(fightEvents, event);
            
            break;
        }
    }
    
    for (var i = 0; i < array_length(sortedCharacters); ++i)
    {
        sortedCharacters[i].hp = savedHp[i];
    }
    
    roundState = RoundState.Visualization;
}

function hover_team_under_mouse()
{
    var mouseX = device_mouse_x_to_gui(0);
    var mouseY = device_mouse_y_to_gui(0);
    
    var selectionTolerance = 80;
    
    hoveredTeam = undefined;
    
    if (array_length(playerCharacters) > 0)
    {
        var left = playerCharacters[0].x - selectionTolerance;
        var right = playerCharacters[0].x + selectionTolerance;
        
        var up = playerCharacters[0].y - selectionTolerance;
        var down = playerCharacters[array_length(playerCharacters) - 1].y + selectionTolerance;
        
        if (mouseX > left and mouseX < right and mouseY > up and mouseY < down)
        {
            for (var i = 0; i < array_length(playerCharacters); ++i)
            {
                hoveredTeam = Team.Player;
            }
        }
    }
    
    if (array_length(enemiesCharacters) > 0)
    {
        var left = enemiesCharacters[0].x - selectionTolerance;
        var right = enemiesCharacters[0].x + selectionTolerance;
        
        var up = enemiesCharacters[0].y - selectionTolerance;
        var down = enemiesCharacters[array_length(enemiesCharacters) - 1].y + selectionTolerance;
        
        if (mouseX > left and mouseX < right and mouseY > up and mouseY < down)
        {
            for (var i = 0; i < array_length(enemiesCharacters); ++i)
            {
                hoveredTeam = Team.Enemy;
            }
        }
    }
}

function hover_character_under_mouse()
{
    var hovered = false;
    var allCharacters = array_concat(playerCharacters, enemiesCharacters);
    for (var i = 0; i < array_length(allCharacters); ++i)
    {
        if (hovered)
        {
            allCharacters[i].unhover();
            continue;
        }

        var left = allCharacters[i].x - sprite_get_width(allCharacters[i].sprite_index) / 1.9;
        var right = allCharacters[i].x + sprite_get_width(allCharacters[i].sprite_index) / 1.9;
        var up = allCharacters[i].y - sprite_get_height(allCharacters[i].sprite_index) / 1.9;
        var down = allCharacters[i].y + sprite_get_height(allCharacters[i].sprite_index) / 1.9;

        var mouseX = device_mouse_x_to_gui(0);
        var mouseY = device_mouse_y_to_gui(0);
        
        if (mouseX > left and mouseX < right and mouseY > up and mouseY < down)
        {
            hovered = true;
            
            if (!allCharacters[i].isHovered)
            {
                //audio_play_sound(sn_cardFromHand, 0, false, random_range(0.5, 1), 0, lerp(0.5, 1, i / array_length(inventory)));
            }
            
            if (mouseY < (down + up) * 0.5)
            {
                allCharacters[i].hover();
            }
            else 
            {
            	allCharacters[i].hover();
            }
            
            hoveredCharacter = allCharacters[i];
        }
        else
        {
        	allCharacters[i].unhover();
        }
    }
    
    if (not hovered)
    {
        hoveredCharacter = undefined;
    }
}

function selectCharacterUnderMouse()
{
    if (mouse_check_button_pressed(mb_left))
    {
        return hoveredCharacter;
    }
}

function selectTeamUnderMouse()
{
    if (mouse_check_button_pressed(mb_left))
    {
        return hoveredTeam;
    }
}