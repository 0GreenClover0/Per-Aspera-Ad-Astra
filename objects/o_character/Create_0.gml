// Base parameters
#macro BASE_PARAMETERS_COUNT 5

enum BaseParameters
{
    Health = 0,
    Attack = 1,
    Defense = 2,
    Intelligence = 3,
    Dexterity = 4,
}

enum StatusEffect
{
    Drunk,
    InLove,
    Angry,
    Ill,
    Scared,
}

hp = 0;
atk = 0;
def = 0;
int = 0;
dex = 0;

// Additional parameters
age = 0;

statusEffects = [];

team = undefined;

show_debug_message("HP {0}, ATK {1}, DEF {2}, INT {3}, DEX {4}", hp, atk, def, int, dex);

isHovered = false;

normalSprite = s_warrior;
fightSprite = s_warriorFight;
deadSprite = s_warriorDead;
isFighting = false;
isBeingBeaten = false;
fightingCounter = 0;
startY = 0;
vizualizationY = 0;
orientation = 1;
xScale = 1;
yScale = 1;
rot = 0;

idInArray = 0;

isEntering = true;
isSkeletor = false;

function hasEffect(effect)
{
    for (var i = 0; i < array_length(statusEffects); ++i)
    {
        if (statusEffects[i] == effect)
        {
            return true;
        }
    }
    
    return false;
}

function addEffect(effect)
{
    for (var i = 0; i < array_length(statusEffects); ++i)
    {
        if (statusEffects[i] == effect)
        {
            return false;
        }
    }
    
    array_push(statusEffects, effect);
    return true;
}

function removeEffect(effect)
{
    for (var i = 0; i < array_length(statusEffects); ++i)
    {
        if (statusEffects[i] == effect)
        {
            array_delete(statusEffects, i, 1);
            return true;
        }
    }
    
    return false;
}

function removeAllEffect()
{
    array_delete(statusEffects, 0, array_length(statusEffects));
    return true;
}

function effectToString(effect)
{
    switch(effect)
    {
        case StatusEffect.Drunk:
        {
            return "Pijany";
        }
            case StatusEffect.InLove:
        {
            return "Zakochany";
        }
            case StatusEffect.Angry:
        {
            return "Wściekły";
        }
            case StatusEffect.Ill:
        {
            return "Chory";
        }
            case StatusEffect.Scared:
        {
            return "Przerażony";
        }
    }
}

function hover()
{
    isHovered = true;
    
    if (o_gameManager.roundState != RoundState.Visualization and sprite_index != fightSprite)
    {
        sprite_index = fightSprite;
    }
}

function unhover()
{
    isHovered = false;
    
    if (o_gameManager.roundState != RoundState.Visualization and sprite_index != normalSprite)
    {
        sprite_index = normalSprite;
    }
}

function aging()
{
    age++;
    
    if (age > 3)
    {
        o_gameManager.kill(self);
    }
}

function randomizeParameters(baseParametersCap)
{
    // First initialize random cap at equal contribution.
    // Ex. parameter cap = 12, there are 4 base parameters, each parameter gets a max value of 3.
    var parameterRandomCap = baseParametersCap / BASE_PARAMETERS_COUNT;
    
    // Randomly move the parameter cap towards the full cap.
    parameterRandomCap += random_range(0, parameterRandomCap);
    
    var parametersSum = 0;
    
    var randomParameterOrder = [];
    for (var i = 0; i < BASE_PARAMETERS_COUNT; ++i)
    {
        array_push(randomParameterOrder, i);
    }
    randomParameterOrder = array_shuffle(randomParameterOrder);
    
    for (var i = 0; i < BASE_PARAMETERS_COUNT; ++i)
    {
        var rand = randomParameterOrder[i];
        var maxCap = baseParametersCap - parametersSum;
        maxCap = min(maxCap, parameterRandomCap);
        
        switch (rand)
        {
        	case BaseParameters.Health:
            {
                hp = irandom_range(1, maxCap);
                parametersSum += hp;
                break;
            }
        	case BaseParameters.Attack:
            {
                atk = irandom_range(0, maxCap);
                parametersSum += atk;
                break;
            }
        	case BaseParameters.Defense:
            {
                def = irandom_range(0, maxCap);
                parametersSum += def;
                break;
            }
        	case BaseParameters.Intelligence:
            {
                int = irandom_range(0, maxCap);
                parametersSum += int;
                break;
            }
        	case BaseParameters.Dexterity:
            {
                dex = irandom_range(0, maxCap);
                parametersSum += dex;
                break;
            }
        }
    }
    
    var highest = max(atk, int, def, dex);
    if (highest == atk) {normalSprite = s_warrior; fightSprite = s_warriorFight; deadSprite = s_warriorDead};
    if (highest == int) {normalSprite = s_jesus; fightSprite = s_jesusFight; deadSprite = s_jesusDead};
    if (highest == dex) {normalSprite = s_sprinter; fightSprite = s_sprinterFight; deadSprite = s_sprinterDead};
    if (highest == def) {normalSprite = s_defender; fightSprite = s_defenderFight; deadSprite = s_defenderDead};
    
    if (isSkeletor) {normalSprite = s_sekletor; fightSprite = s_sekletorFight; deadSprite = s_sekletorDead};
    
    sprite_index = normalSprite;
}

function die()
{
    // Some animation or something...
    
    var inst = instance_create_depth(x, y, depth, o_deadBody);
    inst.sprite_index = deadSprite;
    inst.image_xscale = orientation;
    
    instance_destroy(self);
}