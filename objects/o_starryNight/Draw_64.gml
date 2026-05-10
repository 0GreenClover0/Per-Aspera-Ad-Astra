if (!surface_exists(surf))
{
    surf = surface_create(display_get_gui_width(), display_get_gui_height());
}

surface_set_target(surf);

draw_clear_alpha(c_black, 0.0);
shader_set(shd);
shader_set_uniform_f(u_time, current_time / 1000.0);
shader_set_uniform_f(u_screen_size, display_get_gui_width(), display_get_gui_height());
shader_set_uniform_f(u_alpha, alpha);
draw_rectangle_color(x, y, display_get_gui_width() + x, display_get_gui_height() + y, c_white, c_white, c_white, c_white, false);
shader_reset();
surface_reset_target();

draw_surface(surf, 0, 0);

draw_set_halign(fa_center);

draw_set_font(f_latinMenu);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var title = "Dolor Sit Amet";
var centerX = o_gameManager.w_to_gui(camera_get_view_width(view_camera[0]) / 2);
var baseY = titleY;

var waveAmplitude = 2;
var waveSpeed = 0.005;
var waveFrequency = 0.2;

var totaWidth = string_width(title);
var startX = centerX - totaWidth / 2;

var offsetX = 0;
for (var i = 1; i <= string_length(title); i++) {
    var letter = string_char_at(title, i);
    var letterWidht = string_width(letter);

    var waveOffset = waveAmplitude * sin(waveFrequency * i + current_time * waveSpeed);

    draw_set_alpha(alpha);
    draw_set_color(c_black)
    draw_text(startX + offsetX + 10, baseY + waveOffset + 10, letter);
    draw_set_color(c_white)
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(f_latin);
    draw_set_color(c_black)
    draw_text(room_width / 2 + 5, baseY + 205, "T h a n k s   f o r   p l a y i n g");
    draw_text(room_width / 2 + 5, baseY + 265, "R   t o   R e s t a r t");
    draw_set_color(c_white)
    draw_text(room_width / 2, baseY + 200, "T h a n k s   f o r   p l a y i n g");
    draw_text(room_width / 2, baseY + 260, "R   t o   R e s t a r t");
    draw_set_font(f_latinMenu);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white)
    draw_text(startX + offsetX, baseY + waveOffset, letter);
    draw_set_color(c_white)
    offsetX += letterWidht;
}

draw_set_font(f_latin);