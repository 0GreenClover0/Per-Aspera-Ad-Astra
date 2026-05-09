//window_set_fullscreen(true);

init = false;

playerCharacters = [];

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

roundStage = RoundState.PickingCards;
roundType = FightType.Combat;
pickedCards = 0;

var characterInstance = instance_create_depth(1920 / 2 - 200, 1080 / 2.5, 1, o_character);
characterInstance.team = Team.Player;
array_push(playerCharacters, characterInstance);

characterInstance = instance_create_depth(1920 / 2 - 200, 1080 / 2.5 + 100, 1, o_character);
characterInstance.team = Team.Player;
array_push(playerCharacters, characterInstance);

characterInstance = instance_create_depth(1920 / 2 - 200, 1080 / 2.5 + 200, 1, o_character);
characterInstance.team = Team.Player;
array_push(playerCharacters, characterInstance);

enemiesCharacters = [];

characterInstance = instance_create_depth(1920 / 2 + 200, 1080 / 2.5, 1, o_character);
characterInstance.team = Team.Enemy;
array_push(enemiesCharacters, characterInstance);

characterInstance = instance_create_depth(1920 / 2 + 200, 1080 / 2.5 + 100, 1, o_character);
characterInstance.team = Team.Enemy;
array_push(enemiesCharacters, characterInstance);

characterInstance = instance_create_depth(1920 / 2 + 200, 1080 / 2.5 + 200, 1, o_character);
characterInstance.team = Team.Enemy;
array_push(enemiesCharacters, characterInstance);

function startRound()
{
    o_inventory.add_card();
    o_inventory.add_card();
    o_inventory.add_card();

    pickedCards = 0;
    roundStage = RoundState.PickingCards;
    roundType = irandom_range(0, 1);
    textCombatOrDebate = roundType == FightType.Combat ? "Walka na ATK" : "Debata na INT";
}

function startCombatDebate()
{
    roundStage = RoundState.Fight;
    
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
            }
            
            break;
        }
    }
}
