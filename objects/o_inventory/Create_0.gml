x = room_width / 2;
y = room_height * 1.1;

inventory = [];

global.cardSizeX = sprite_get_width(s_card);
global.cardSizeY = sprite_get_height(s_card);

offsetBetweenCards = 40;

hoveredCard = undefined;

centerPosition = surface_get_width(application_surface) / 2;

function add_card()
{
    var inventoryCard = instance_create_depth(x, y, 0, o_card);

    array_push(inventory, inventoryCard);

    arrange();
}

function add_existing_card(inventoryCard)
{
    array_push(inventory, inventoryCard);
    
    arrange();
}

function remove_card(card)
{
    for (var i = 0; i < array_length(inventory); ++i)
    {
        if (inventory[i] == card)
        {
            array_delete(inventory, i, 1);
            break;
        }
    }
    
    arrange();
}

function arrange()
{
    var screenWidth = surface_get_width(application_surface);
    var inventorySize = array_length(inventory);

    offsetBetweenCards = -global.cardSizeX * 0.5;

    var totalWidth = inventorySize * global.cardSizeX + (inventorySize - 1) * offsetBetweenCards;

    var marginLeft = global.cardSizeX * 0.05;
    var marginRight = global.cardSizeX * 0.05;
    var maxCenter = totalWidth * 0.5 + marginLeft;
    var minCenter = screenWidth - totalWidth * 0.5 - marginRight;

    if (totalWidth <= screenWidth)
    {
        centerPosition = screenWidth * 0.5;
    }
    else
    {
        centerPosition = clamp(centerPosition, minCenter, maxCenter);
    }

    var firstPosition = centerPosition - inventorySize * 0.5 * global.cardSizeX
                        - (inventorySize - 1) * offsetBetweenCards * 0.5
                        + global.cardSizeX * 0.5;

    var offsetYAlternate = 0.0;
    for (var i = 0; i < inventorySize; ++i)
    {
        if (i % 2 == 1)
        {
            offsetYAlternate = 130;
        }
        else
        {
            offsetYAlternate = 0;
        }
        
        inventory[i].newX = firstPosition + i * global.cardSizeX + i * offsetBetweenCards;
        inventory[i].newY = surface_get_height(application_surface) - global.cardSizeY * 0.5 - offsetYAlternate;
    }
}

function hover_card_under_mouse()
{
    var hovered = false;
    for (var i = 0; i < array_length(inventory); ++i)
    {
        if (hovered)
        {
            inventory[i].unhover();
            continue;
        }

        var left = inventory[i].x - global.cardSizeX / 1.9;
        var right = inventory[i].x + global.cardSizeX / 1.9;
        var up = inventory[i].y - global.cardSizeY / 1.9;
        var down = inventory[i].y + global.cardSizeY / 1.9;

        var mouseX = device_mouse_x_to_gui(0);
        var mouseY = device_mouse_y_to_gui(0);
        
        if (mouseX > left and mouseX < right and mouseY > up and mouseY < down)
        {
            hovered = true;
            
            if (!inventory[i].isHovered)
            {
                //audio_play_sound(sn_cardFromHand, 0, false, random_range(0.5, 1), 0, lerp(0.5, 1, i / array_length(inventory)));
            }
            
            if (mouseY < (down + up) * 0.5)
            {
                inventory[i].hover();
            }
            else 
            {
            	inventory[i].hover();
            }
            hoveredCard = inventory[i];
        }
        else
        {
        	inventory[i].unhover();
        }
    }
    
    if (not hovered)
    {
        hoveredCard = undefined;
    }
}

init = true;