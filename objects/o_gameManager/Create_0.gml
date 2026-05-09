window_set_fullscreen(true);

init = false;

playerCharacters = [];
enemiesCharacters = [];

textFightOrDebate = "";

enum RoundState
{
    PickingCards,
    Fight
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
pickedCards = 0;

minEnemies = 1;
maxEnemies = 3;

playerColumn = room_width / 2 - room_width * 0.2;
enemyColumn = room_width / 2 + room_width * 0.1;
startRow = room_height / 6;
rowIncrement = 100;

spawnPlayerCharacters();
startNewWave();

function spawnPlayerCharacters()
{
    var rowMultiply = 0;
    for (var i = 0; i < 3; ++i)
    {
        var characterInstance = instance_create_depth(playerColumn, startRow + rowIncrement * rowMultiply, 1, o_character);
        characterInstance.team = Team.Player;
        array_push(playerCharacters, characterInstance);
        
        rowMultiply += 1;
    }
}

function startNewWave()
{
    var enemiesCount = irandom_range(minEnemies, maxEnemies);
    
    var rowMultiply = 0;
    for (var i = 0; i < enemiesCount; ++i)
    {
        var characterInstance = instance_create_depth(enemyColumn, startRow + rowIncrement * rowMultiply, 1, o_character);
        characterInstance.team = Team.Enemy;
        characterInstance.image_xscale = -1;
        array_push(enemiesCharacters, characterInstance);
        
        rowMultiply += 1;
    }
}

function startRound()
{
    o_inventory.add_card();
    o_inventory.add_card();
    o_inventory.add_card();

    pickedCards = 0;
    roundState = RoundState.PickingCards;
    roundType = irandom_range(0, 1);
    textCombatOrDebate = roundType == FightType.Combat ? "Walka na ATK" : "Debata na INT";
}

function startCombatDebate()
{
    roundState = RoundState.Fight;
    
    // Fight
    runFight();
    
    startRound();
}

function runFight()
{
    var sortedCharacters = array_concat(playerCharacters, enemiesCharacters);
    
    array_sort(sortedCharacters, function(current, next)
    {
        return next.dex - current.dex;
    });
    
    for (var i = 0; i < array_length(sortedCharacters); ++i)
    {
        if (sortedCharacters[i].hp <= 0)
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
            
            if (dealtDmg > 0)
            {
                opponents[k].hp = clamp(opponents[k].hp - dealtDmg, 0, opponents[k].hp);
                
                if (opponents[k].hp == 0)
                {
                    opponents[k].die();
                    array_delete(opponents, k, 1);
                }
            }
            
            break;
        }
    }
}
