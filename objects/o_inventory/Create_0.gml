inventory = [];

global.cardSizeX = 192;
global.cardSizeY = 320;

offsetBetweenCards = 40;

hoveredCard = undefined;

centerPosition = surface_get_width(application_surface) / 2;

add_card();

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
    
    instance_destroy(card);
    arrange();
}

function arrange()
{
    var screenWidth = surface_get_width(application_surface);
    var inventorySize = array_length(inventory);

    offsetBetweenCards = 40 - (inventorySize - 1) * 1.5;
    offsetBetweenCards = clamp(offsetBetweenCards, 10, 40);

    var totalWidth = inventorySize * global.cardSizeX + (inventorySize - 1) * offsetBetweenCards;

    var marginLeft = global.cardSizeX * 3.5;
    var marginRight = global.cardSizeX * 0.45;
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

    for (var i = 0; i < inventorySize; ++i)
    {
        inventory[i].newX = firstPosition + i * global.cardSizeX + i * offsetBetweenCards;
        inventory[i].newY = surface_get_height(application_surface) - global.cardSizeY * 0.5;
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

        show_debug_message(mouseX);
        
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