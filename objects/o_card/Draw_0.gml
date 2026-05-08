var t = current_time / 1000;
var freq = 0.28;
var sway = sin(t * freq * (2 * pi) + sway_phase);
var rot = sway * 3;
var scale = cos(sway * 0.18);
var y_bob = sin(t * freq * (4 * pi) + sway_phase) * 1.5;
var yOffset = 0;

if (isHovered)
{
    yOffsetLerp = lerp(yOffsetLerp, -30, 0.1);
    scaleLerp = lerp(scaleLerp, 1.15, 0.1);
}
else 
{
	yOffsetLerp = lerp(yOffsetLerp, 0, 0.1);
    scaleLerp = lerp(scaleLerp, 1, 0.1);
}

yOffset = yOffsetLerp;
scale *= scaleLerp

draw_sprite_ext(sprite_index, 0, x, y + y_bob + yOffset, scale, scale, rot, c_white, 1);

draw_set_colour(c_black);
draw_text(x - global.cardSizeX / 2, y, textLatin);
draw_text(x - global.cardSizeX / 2, y + 20, textPolish);
draw_text(x - global.cardSizeX / 2, y + 40, textEffect);
draw_set_colour(c_white);