textLatin = "Vivere militare est";
textPolish = "Życie jest walką";
textEffect = "Ustawia ATK na HP";

newX = x;
newY = y;

scaleLerp = 0.5;
yOffsetLerp = 0;
sway_phase = random(2 * pi);

isHovered = false;

function hover()
{
    isHovered = true;
}

function unhover()
{
    isHovered = false;
}