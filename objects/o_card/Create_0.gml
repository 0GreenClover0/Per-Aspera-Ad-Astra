var chancePerAstra = o_cardManager.getAstraChancePerCard();

if (!astraDrawn and random_range(0, 100) < chancePerAstra)
{
    card = o_cardManager.przezTrudyDoGwiazd;
    astraDrawn = true;
}
else
{
    var index = irandom(array_length(o_cardManager.cardTypes) - 1);
    while (true)
    {
        card = o_cardManager.cardTypes[index];
        
        var noDuplicate = true;
        for (var i = 0; i < array_length(o_inventory.inventory); ++i)
        {
            if (card == o_inventory.inventory[i].card)
            {
                noDuplicate = false;
                break;
            }
        }
        
        if (noDuplicate)
        {
            break;
        }
        
        index = (index + 1) % array_length(o_cardManager.cardTypes);
    }
}

newX = x;
newY = y;

scaleLerp = 0.5;
yOffsetLerp = 0;
sway_phase = random(2 * pi);
initialDepth = depth;

isHovered = false;

isDissolving = false;
dissolveValue = 1.0;

function pick()
{
    newX = room_width / 2;
    newY = room_height / 2 - room_height * 0.1;
}

function use()
{
    isDissolving = true;
}

function hover()
{
    isHovered = true;
}

function unhover()
{
    isHovered = false;
}

cardSurface = surface_create(global.cardSizeX, global.cardSizeY);
cardSprite = undefined;
isSurfaceInitiatied = false;