if (tooltip != "")
{
    draw_set_valign(fa_middle);
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