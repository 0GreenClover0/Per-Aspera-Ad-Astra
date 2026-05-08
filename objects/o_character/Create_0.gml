// Base parameters
#macro BASE_PARAMETERS_COUNT 4

enum BaseParameters
{
    Health = 0,
    Attack = 1,
    Defense = 2,
    Intelligence = 3,
}

hp = 0;
atk = 0;
def = 0;
int = 0;

// Additional parameters
age = 0;
dex = 0;

randomizeParameters(10);

show_debug_message("HP {0}, ATK {1}, DEF {2}, INT {3}", hp, atk, def, int);

function randomizeParameters(baseParametersCap)
{
    // First initialize random cap at equal contribution.
    // Ex. parameter cap = 12, there are 4 base parameters, each parameter gets a max value of 3.
    var parameterRandomCap = baseParametersCap / BASE_PARAMETERS_COUNT;
    
    // Randomly move the parameter cap towards the full cap.
    parameterRandomCap += random_range(0, parameterRandomCap * (BASE_PARAMETERS_COUNT - 1));
    
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
        }
    }
}
