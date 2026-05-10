window_set_fullscreen(true);

init = false;

playerCharacters = [];
enemiesCharacters = [];

particleSystems = [];
titleY = h_to_gui(camera_get_view_height(view_camera[0]) * 3 / 15);
creditsY = 0;
textFightOrDebate = "";

showPercent = false;

function x_to_gui(xx)
{
    return ((xx - camera_get_view_x(view_camera[0])) / camera_get_view_width(view_camera[0])) * display_get_gui_width();
}

function w_to_gui(xx)
{
    return ((xx) / camera_get_view_width(view_camera[0])) * display_get_gui_width();
}

function y_to_gui(yy)
{
    return ((yy - camera_get_view_y(view_camera[0])) / camera_get_view_height(view_camera[0])) * display_get_gui_height();
}

function h_to_gui(yy)
{
    return ((yy) / camera_get_view_height(view_camera[0])) * display_get_gui_height();
}


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

selectedDuo = [];

playerColumn = room_width / 2 - room_width * 1.27;
enemyColumn = room_width / 2 + room_width * 1.27;
startRow = room_height / 6;
rowIncrement = 100;

hoveredCharacter = undefined;
hoveredTeam = undefined;

battleY = -165;
battleYTarget = -35;

debateY = -165;
debateYTarget = -35;

isMenu = true;

sententionY = -165;
percentY = -165;

textCombatOrDebate = "";

spawnPlayerCharacters();
startNewWave();

function spawnPlayerCharacters()
{
    var rowMultiply = 0;
    for (var i = 0; i < 3; ++i)
    {
        var characterInstance = instance_create_depth(playerColumn - rowMultiply * 1500, startRow + rowIncrement * rowMultiply, 1, o_character);
        characterInstance.team = Team.Player;
        characterInstance.randomizeParameters(10);
        characterInstance.startY = startRow + rowIncrement * rowMultiply;
        characterInstance.vizualizationY = startRow + rowIncrement * rowMultiply + 100;
        characterInstance.idInArray = i;
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
        var characterInstance = instance_create_depth(enemyColumn + rowMultiply * 1500, startRow + rowIncrement * rowMultiply, 1, o_character);
        characterInstance.team = Team.Enemy;
        characterInstance.orientation = -1;
        characterInstance.randomizeParameters(maxHp + maxAtk + maxDef + maxInt + maxDex);
        characterInstance.startY = startRow + rowIncrement * rowMultiply;
        characterInstance.vizualizationY = startRow + rowIncrement * rowMultiply + 100;
        characterInstance.idInArray = i;
        array_push(enemiesCharacters, characterInstance);
        
        rowMultiply += 1;
    }
}

function startRound()
{
    while (array_length(o_inventory.inventory) < 5)
    {
        o_inventory.add_card();
    }

    usedCards = 0;
    roundState = RoundState.PickingCards;
    var roundBefore = roundType;
    roundType = irandom_range(0, 1);
    if (roundType != roundBefore)
    {
        audio_play_sound(choose(Bong1, Bong2, Bong3, Bong4, Bong5), 0, false,,, random_range(0.8, 1.2));
    }
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
    if (!event.who.isFighting)
    {
        event.who.isFighting = true;
        event.whom.isBeingBeaten = true;
        event.who.fightingCounter = 150;
        event.who.sprite_index = event.who.fightSprite;
    }
    else 
    {
    	event.who.fightingCounter--;
        
        var partType = particle_get_info(ps_noDMG).emitters[0].parttype.ind;
        var minD = min(90 + 35 * event.who.orientation, 90 + 75 * event.who.orientation);
        var maxD = max(90 + 35 * event.who.orientation, 90 + 75 * event.who.orientation);
        part_type_direction(partType, minD, maxD, 0, 0);
        
        var partType = particle_get_info(ps_DMG).emitters[0].parttype.ind;
        var minD = min(90, 90 + 30 * event.who.orientation);
        var maxD = max(90, 90 + 30 * event.who.orientation);
        part_type_direction(partType, minD, maxD, 0, 0);
        
        if (event.who.image_index == 0)
        {
            if (event.dmg <= 0)
            {
                var particlesNoDMG = part_system_create(ps_noDMG);
                part_system_position(particlesNoDMG, event.whom.x, event.whom.y);
                part_system_depth(particlesNoDMG, -999999);
                array_push(particleSystems, particlesNoDMG);
                
                if (event.whom.isSkeletor)
                {
                    audio_play_sound(choose(SkeletonDamage1, SkeletonDamage2, SkeletonDamage3), 0, false,,, random_range(0.8, 1.2));
                }
                else 
                {
                	audio_play_sound(choose(BlockedDamage1, BlockedDamage2, BlockedDamage3, BlockedDamage4, BlockedDamage5), 0, false,,, random_range(0.8, 1.2));
                }
            }
            else 
            {
            	var particlesDMG = part_system_create(ps_DMG);
                part_system_position(particlesDMG, event.whom.x, event.whom.y);
                part_system_depth(particlesDMG, -999999);
                array_push(particleSystems, particlesDMG);
                
                if (event.whom.isSkeletor)
                {
                    audio_play_sound(choose(SkeletonDamage1, SkeletonDamage2, SkeletonDamage3), 0, false,,, random_range(0.8, 1.2));
                }
                else 
                {
                    audio_play_sound(choose(Damage1, Damage2, Damage3, Damage4, Damage5, Damage6, Damage7, Damage8, Damage9), 0, false,,, random_range(0.8, 1.2));
                }
            }
            
            if (choose(false, true))
            {
                event.whom.xScale = random_range(1.25, 2);
                event.whom.yScale = 1 / event.whom.xScale * 1.2;
            }
            else 
            {
            	event.whom.yScale = random_range(1.25, 2);
                event.whom.xScale = 1 / event.whom.yScale * 1.2;
            }
            
            event.whom.rot = random_range(-30, 30);
        }
        
        if (event.who.fightingCounter <= 0)
        {
            event.who.fightingCounter = 0;
            event.who.isFighting = false;
            event.whom.isBeingBeaten = false;
            event.who.sprite_index = event.who.normalSprite;
            
            afterEvent(event);
        }
    }
    
}

function afterEvent(event)
{
    event.whom.hp = clamp(event.whom.hp - event.dmg, 0, event.whom.hp);
    
    if (event.whom.hp <= 0)
    {
        kill(event.whom);
    }
    array_delete(fightEvents, 0, 1);
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
        var value = next.dex - current.dex;
        if (value == 0)
        {
            return -1;
        }
        
        return value;
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
            hoveredTeam = Team.Player;
            
            for (var i = 0; i < array_length(playerCharacters); ++i)
            {
                playerCharacters[i].hover();
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
            hoveredTeam = Team.Enemy;
            
            for (var i = 0; i < array_length(enemiesCharacters); ++i)
            {
                enemiesCharacters[i].hover();
            }
        }
    }
}

function hover_character_under_mouse(onlyUnhover)
{
    var hovered = false;
    var allCharacters = array_concat(playerCharacters, enemiesCharacters);
    for (var i = 0; i < array_length(allCharacters); ++i)
    {
        if (hovered)
        {
            if (selectType == SelectType.Duo and array_length(selectedDuo) == 1 and selectedDuo[0] == allCharacters[i])
            {
                // Don't unhover the other duo character.
            }
            else
            {
            	allCharacters[i].unhover();
            }
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
            
            if (mouseY < (down + up) * 0.5 and !onlyUnhover)
            {
                if (selectType == SelectType.Player and allCharacters[i].team == Team.Player)
                {
                    allCharacters[i].hover();
                    hoveredCharacter = allCharacters[i];
                }
                else if (selectType != SelectType.Player)
                {
                    allCharacters[i].hover();
                    hoveredCharacter = allCharacters[i];
                }
            }
            else if (!onlyUnhover)
            {
                if (selectType == SelectType.Player and allCharacters[i].team == Team.Player)
                {
                	allCharacters[i].hover();
                    hoveredCharacter = allCharacters[i];
                }
                else if (selectType != SelectType.Player)
                {
                	allCharacters[i].hover();
                    hoveredCharacter = allCharacters[i];
                }
            }
        }
        else
        {
            if (selectType == SelectType.Duo and array_length(selectedDuo) == 1 and selectedDuo[0] == allCharacters[i])
            {
                // Don't unhover the other duo character.
            }
            else
            {
            	allCharacters[i].unhover();
            }
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