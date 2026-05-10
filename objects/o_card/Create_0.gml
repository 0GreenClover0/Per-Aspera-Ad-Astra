var chancePerAstra = o_cardManager.getAstraChancePerCard();

if (!o_cardManager.astraDrawn and random_range(0, 100) < chancePerAstra)
{
    card = o_cardManager.przezTrudyDoGwiazd;
    astraDrawn = true;
}
else
{
    if (!o_gameManager.showFullCharData)
    {
        var arr = [o_cardManager.powtarzamCoUslyszakem, o_cardManager.zycieJestWalka];
        
        card = arr[instance_number(o_card) - 1];
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
    
    o_gameManager.showGuide = true;
    
    audio_play_sound(Card3, 0, false, 0.6,, random_range(0.95, 1.05));
}

function use()
{
    isDissolving = true;
    
    alarm[0] = 45;
}

function hover()
{
    if (!isHovered)
    {
       var numberOfCards = array_length(o_inventory.inventory);
       var myId = 0
       for(var i = 0; i < numberOfCards; i++)
       {
           if (o_inventory.inventory[i].card == card)
           {
               myId = i;
               break;
           }
       }
       
        audio_play_sound(Card2, 0, false,0.6,, lerp(0.95, 1.05, i / numberOfCards));
       
       isHovered = true;
    }
}

function unhover()
{
    isHovered = false;
}

cardSurface = surface_create(global.cardSizeX, global.cardSizeY);
cardSprite = undefined;
isSurfaceInitiatied = false;