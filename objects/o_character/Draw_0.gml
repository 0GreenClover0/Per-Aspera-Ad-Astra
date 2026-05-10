
if (keyboard_check_pressed(vk_f1))
{
    hp = irandom_range(0, 10);
}

image_xscale = orientation;

draw_sprite_ext(sprite_index, image_index, x, y, xScale * orientation, yScale, rot, image_blend, image_alpha);


var heatX = x + sprite_xoffset - 18 * orientation;
var heatY = y + sprite_yoffset + 17;
var heartSpace = (sprite_get_width(s_heart)) * orientation;

var segmentX = room_width / 2 - room_width * 0.27 * orientation - sprite_xoffset + 10 * orientation;
if (isEntering)
{
    segmentX = x - sprite_xoffset + 10 * orientation;
}
var segmentY = y - sprite_yoffset + 35;
var segmentHorizontalSpace = (32) * orientation;
var segmentVerticalSpace = (32);

draw_set_colour(c_black);
draw_set_alpha(0.3);
draw_rectangle(segmentX - 15 * orientation, segmentY - 20, segmentX - segmentHorizontalSpace * dataSizeToShow, segmentY + segmentVerticalSpace + 20, false);
draw_set_colour(c_white);
draw_set_alpha(1);

var distToHP = room_width;
for (var i = 0; i < hp; i++)
{
    distToHP = min(distToHP, point_distance(mouse_x, mouse_y, heatX - i * heartSpace + ((hp - 2.5) * heartSpace / 2), heatY));
    
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
draw_text_transformed_colour(   segmentX - segmentHorizontalSpace * 1.5, segmentY, atk, atkScale, atkScale, 0, atkColor, atkColor, atkColor, atkColor, 1);

draw_sprite_ext(s_statIcons, 1, segmentX - segmentHorizontalSpace * 1.85, segmentY + segmentVerticalSpace, orientation / 2, 0.5, 0, c_white, 1);
draw_text_transformed_colour(   segmentX - segmentHorizontalSpace * 1.5, segmentY + segmentVerticalSpace, int, intScale, intScale, 0, intColor, intColor, intColor, intColor, 1);
    
if (o_gameManager.showFullCharData)
{
   draw_sprite_ext(s_statIcons, 2, segmentX - segmentHorizontalSpace * 3.85, segmentY + segmentVerticalSpace, orientation / 2, 0.5, 0, c_white, 1);
   draw_text_transformed_colour(   segmentX - segmentHorizontalSpace * 3.5, segmentY + segmentVerticalSpace, def, defScale, defScale, 0, defColor, defColor, defColor, defColor, 1);
   
   draw_sprite_ext(s_statIcons, 3, segmentX - segmentHorizontalSpace * 3.85, segmentY, orientation / 2, 0.5, 0, c_white, 1);
   draw_text_transformed_colour(   segmentX - segmentHorizontalSpace * 3.5, segmentY, dex, dexScale, dexScale, 0, dexColor, dexColor, dexColor, dexColor, 1);
   
   draw_sprite_ext(s_statIcons, 4, segmentX - segmentHorizontalSpace * 6.85, segmentY, orientation / 2, 0.5, 0, c_white, 1);
   draw_text_transformed_colour(   segmentX - segmentHorizontalSpace * 6.5, segmentY, string("{0}/2", age), ageScale, ageScale, 0, ageColor, ageColor, ageColor, ageColor, 1);
}

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
    
    if (o_gameManager.showFullCharData)
    {
        draw_sprite_ext(s_statusEffects, statusEffects[i], segmentX - segmentHorizontalSpace * (4.85 + i), segmentY + segmentVerticalSpace, orientation / 2, 0.5, 0, c_white, 1);
    }
}

var distToATK = point_distance(mouse_x, mouse_y, segmentX - segmentHorizontalSpace * 1.85, segmentY);
var distToINT = point_distance(mouse_x, mouse_y, segmentX - segmentHorizontalSpace * 1.85, segmentY + segmentVerticalSpace);
var distToDEF = point_distance(mouse_x, mouse_y, segmentX - segmentHorizontalSpace * 3.85, segmentY + segmentVerticalSpace);
var distToDEX = point_distance(mouse_x, mouse_y, segmentX - segmentHorizontalSpace * 3.85, segmentY);
var distToAGE = point_distance(mouse_x, mouse_y, segmentX - segmentHorizontalSpace * 6.85, segmentY);

var closestDist = min(distToHP, distToATK, distToINT, distToDEF, distToDEX, distToAGE, distToStatus);
tooltip = "";

if (closestDist < 16)
{
    if (closestDist == distToHP) {tooltip = "Punkty Życia";}
    if (closestDist == distToATK) {tooltip = string("Atak: {0}\n{1}", atk, hasEffect(StatusEffect.Angry) ? " +2 (wściekły)" : "");}
    if (closestDist == distToINT) {tooltip = string("Inteligencja: {0}\n{1}", int, hasEffect(StatusEffect.Drunk) ? " -1 (pijany)" : "");}
    
    if (o_gameManager.showFullCharData)
    {
        if (closestDist == distToDEF) {tooltip = string("Obrona: {0}\n{1}", def, hasEffect(StatusEffect.InLove) ? " -1 (zakochany)" : "");}
        if (closestDist == distToDEX) {tooltip = "Zręczność";}
        if (closestDist == distToAGE) {tooltip = "Wiek";}
        if (closestDist == distToStatus) 
        {
            tooltip = string(effectToString(statusEffects[closestStatus]));
            
            if (statusEffects[closestStatus] == StatusEffect.Angry)
            {
                tooltip += "\n +2 ATK";
            }
            
            if (statusEffects[closestStatus] == StatusEffect.Drunk)
            {
                tooltip += "\n -1 INT";
            }
            
            if (statusEffects[closestStatus] == StatusEffect.InLove)
            {
                tooltip += "\n -1 OBR";
            }
        }
    }
}