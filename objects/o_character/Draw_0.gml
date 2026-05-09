
if (keyboard_check_pressed(vk_f1))
{
    hp = irandom_range(0, 10);
}

image_xscale = orientation;

draw_sprite_ext(sprite_index, image_index, x, y, xScale * orientation, yScale, image_angle, image_blend, image_alpha);


var heatX = x + sprite_xoffset - 18 * orientation;
var heatY = y + sprite_yoffset + 17;
var heartSpace = (sprite_get_width(s_heart)) * orientation;

var segmentX = room_width / 2 - room_width * 0.27 * orientation - sprite_xoffset + 10 * orientation;
var segmentY = y - sprite_yoffset + 35;
var segmentHorizontalSpace = (32) * orientation;
var segmentVerticalSpace = (32);

draw_set_colour(c_black);
draw_set_alpha(0.3);
draw_rectangle(segmentX - 15 * orientation, segmentY - 20, segmentX - segmentHorizontalSpace * 7.5, segmentY + segmentVerticalSpace + 20, false);
draw_set_colour(c_white);
draw_set_alpha(1);

var distToHP = room_width;
for (var i = 0; i < hp; i++)
{
    distToHP = min(distToHP, point_distance(mouse_x, mouse_y, heatX - i * heartSpace + (hp * heartSpace / 2), heatY));
    
    var hearthColor = c_white;
    
    if (orientation == -1)
    {
        hearthColor = c_purple;
    }
    
    draw_sprite_ext(s_heart, 0, heatX - i * heartSpace + ((hp - 2.5) * heartSpace / 2), heatY, 1, 1, 0, hearthColor, 1);
}

if (orientation == 1)
{
    draw_set_halign(fa_left);
}

if (orientation == -1)
{
    draw_set_halign(fa_right);
}
draw_set_valign(fa_middle);

draw_sprite_ext(s_statIcons, 0, segmentX - segmentHorizontalSpace * 1.85, segmentY, orientation / 2, 0.5, 0, c_white, 1);
draw_text(                      segmentX - segmentHorizontalSpace * 1.5, segmentY, atk);

draw_sprite_ext(s_statIcons, 1, segmentX - segmentHorizontalSpace * 1.85, segmentY + segmentVerticalSpace, orientation / 2, 0.5, 0, c_white, 1);
draw_text(                      segmentX - segmentHorizontalSpace * 1.5, segmentY + segmentVerticalSpace, int);
    
draw_sprite_ext(s_statIcons, 2, segmentX - segmentHorizontalSpace * 3.85, segmentY + segmentVerticalSpace, orientation / 2, 0.5, 0, c_white, 1);
draw_text(                      segmentX - segmentHorizontalSpace * 3.5, segmentY + segmentVerticalSpace, def);

draw_sprite_ext(s_statIcons, 3, segmentX - segmentHorizontalSpace * 3.85, segmentY, orientation / 2, 0.5, 0, c_white, 1);
draw_text(                      segmentX - segmentHorizontalSpace * 3.5, segmentY, dex);

draw_sprite_ext(s_statIcons, 4, segmentX - segmentHorizontalSpace * 6.85, segmentY, orientation / 2, 0.5, 0, c_white, 1);
draw_text(                      segmentX - segmentHorizontalSpace * 6.5, segmentY, string("{0}/3", age));

var distToStatus = room_width;
var closestStatus = 0;

var numberOfStatusEffects = array_length(statusEffects);
for (var i = 0; i < numberOfStatusEffects; i++)
{
    var potentialDistanceToStatus = point_distance(mouse_x, mouse_y, segmentX - segmentHorizontalSpace * (4.85 + i), segmentY + segmentVerticalSpace);
    
    if (potentialDistanceToStatus < distToStatus)
    {
        distToStatus = potentialDistanceToStatus;
        closestStatus = i;
    }
    
    draw_sprite_ext(s_statusEffects, statusEffects[i], segmentX - segmentHorizontalSpace * (4.85 + i), segmentY + segmentVerticalSpace, orientation / 2, 0.5, 0, c_white, 1);
}

var distToATK = point_distance(mouse_x, mouse_y, segmentX - segmentHorizontalSpace * 1.85, segmentY);
var distToINT = point_distance(mouse_x, mouse_y, segmentX - segmentHorizontalSpace * 1.85, segmentY + segmentVerticalSpace);
var distToDEF = point_distance(mouse_x, mouse_y, segmentX - segmentHorizontalSpace * 3.85, segmentY + segmentVerticalSpace);
var distToDEX = point_distance(mouse_x, mouse_y, segmentX - segmentHorizontalSpace * 3.85, segmentY);
var distToAGE = point_distance(mouse_x, mouse_y, segmentX - segmentHorizontalSpace * 6.85, segmentY);

var closestDist = min(distToHP, distToATK, distToINT, distToDEF, distToDEX, distToAGE, distToStatus);

if (closestDist < 16)
{
    var tooltip = "";
    if (closestDist == distToHP) {tooltip = "Health Points";}
    if (closestDist == distToATK) {tooltip = "Attack";}
    if (closestDist == distToINT) {tooltip = "Inteligence";}
    if (closestDist == distToDEF) {tooltip = "Defense";}
    if (closestDist == distToDEX) {tooltip = "Dexterity";}
    if (closestDist == distToAGE) {tooltip = "Age";}
    if (closestDist == distToStatus) {tooltip = effectToString(statusEffects[closestStatus]);}
    
    draw_set_halign(fa_center);
    var tooltipWidth = string_width(tooltip) / 2;
    var tooltipHeigh = string_height(tooltip) / 2;
    draw_set_colour(c_black);
    draw_set_alpha(0.5);
    
    var tooltipMinX = mouse_x - tooltipWidth * 1.1;
    var tooltipMaxX = mouse_x + tooltipWidth * 1.1;
    
    var shiftX = 0;
    while(tooltipMinX + shiftX < 0)
    {
        shiftX++;
    }
    
    while(tooltipMaxX + shiftX > room_width)
    {
        shiftX--;
    }
    
    
    draw_rectangle(tooltipMinX + shiftX, mouse_y + 30 - tooltipHeigh * 1.1, tooltipMaxX + shiftX, mouse_y + 30 + tooltipHeigh * 1.1, false);
    draw_set_colour(c_white);
    draw_set_alpha(1);
    draw_text(mouse_x + shiftX, mouse_y + 30, tooltip);
}