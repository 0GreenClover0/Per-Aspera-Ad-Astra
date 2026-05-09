// Base parameters
#macro BASE_PARAMETERS_COUNT 5

image_speed = 0;

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
            return "Drunk";
        }
            case StatusEffect.InLove:
        {
            return "In Love";
        }
            case StatusEffect.Angry:
        {
            return "Angry";
        }
            case StatusEffect.Ill:
        {
            return "Ill";
        }
            case StatusEffect.Scared:
        {
            return "Scared";
        }
    }
}

function hover()
{
    isHovered = true;
    image_blend = c_lime;
}

function unhover()
{
    isHovered = false;
    image_blend = c_white;
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
    if (highest == atk) {image_index = 0};
    if (highest == int) {image_index = 1};
    if (highest == dex) {image_index = 2};
    if (highest == def) {image_index = 3};
}

function die()
{
    // Some animation or something...
    
    instance_destroy(self);
}