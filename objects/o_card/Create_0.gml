card = o_cardManager.cardTypes[irandom(array_length(o_cardManager.cardTypes) - 1)];

newX = x;
newY = y;

scaleLerp = 0.5;
yOffsetLerp = 0;
sway_phase = random(2 * pi);
initialDepth = depth;

isHovered = false;

function pick()
{
    newX = room_width / 2;
    newY = room_height / 2 - room_height * 0.1;
}

function use()
{
    show_debug_message("USE");
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