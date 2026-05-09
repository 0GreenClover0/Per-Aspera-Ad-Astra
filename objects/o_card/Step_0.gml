x = lerp(x, newX, 0.1);
y = lerp(y, newY, 0.1);

depth = initialDepth - x;
if (isHovered)
{
    depth = -999;
}