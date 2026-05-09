card = o_cardManager.cardTypes[irandom(array_length(o_cardManager.cardTypes) - 1)];

newX = x;
newY = y;

scaleLerp = 0.5;
yOffsetLerp = 0;
sway_phase = random(2 * pi);
initialDepth = depth;

isHovered = false;

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