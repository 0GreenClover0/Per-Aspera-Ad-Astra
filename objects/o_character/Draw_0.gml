
if (keyboard_check_pressed(vk_f1))
{
    hp = irandom_range(0, 10);
}

draw_self();

//draw_rectangle_colour(x, y, x + 50, y + 50, c_grey, c_grey, c_grey, c_grey, false);

var heatX = x + sprite_xoffset - 18 * image_xscale;
var heatY = y + sprite_yoffset + 10;
var heartSpace = (sprite_get_width(s_heart)) * image_xscale;

var segmentX = x - sprite_xoffset + 10 * image_xscale;
var segmentY = y - sprite_yoffset + 35;
var segmentHorizontalSpace = (32) * image_xscale;
var segmentVerticalSpace = (32);

for (var i = 0; i < hp; i++)
{
    draw_sprite(s_heart, 0, heatX - i * heartSpace, heatY);
}

draw_set_colour(c_black);

if (image_xscale == 1)
{
    draw_set_halign(fa_left);
}

if (image_xscale == -1)
{
    draw_set_halign(fa_right);
}
draw_set_valign(fa_middle);

draw_sprite_ext(s_statIcons, 0, segmentX - segmentHorizontalSpace * 1.85, segmentY, image_xscale / 2, 0.5, 0, c_white, 1);
draw_text(                      segmentX - segmentHorizontalSpace * 1.5, segmentY, atk);

draw_sprite_ext(s_statIcons, 1, segmentX - segmentHorizontalSpace * 1.85, segmentY + segmentVerticalSpace, image_xscale / 2, 0.5, 0, c_white, 1);
draw_text(                      segmentX - segmentHorizontalSpace * 1.5, segmentY + segmentVerticalSpace, int);
    
draw_sprite_ext(s_statIcons, 2, segmentX - segmentHorizontalSpace * 3.85, segmentY + segmentVerticalSpace, image_xscale / 2, 0.5, 0, c_white, 1);
draw_text(                      segmentX - segmentHorizontalSpace * 3.5, segmentY + segmentVerticalSpace, def);

draw_sprite_ext(s_statIcons, 3, segmentX - segmentHorizontalSpace * 3.85, segmentY, image_xscale / 2, 0.5, 0, c_white, 1);
draw_text(                      segmentX - segmentHorizontalSpace * 3.5, segmentY, dex);

draw_set_colour(c_black);
//draw_text(x, y, string("HP {0}, ATK {1}, DEF {2}, INT {3} DEX {4}", hp, atk, def, int, dex));
draw_set_colour(c_white);