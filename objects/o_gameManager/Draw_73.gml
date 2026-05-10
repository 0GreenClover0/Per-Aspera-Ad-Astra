draw_set_halign(fa_center);

draw_set_font(f_latinMenu);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var title = "Dolor Sit Amet";
var centerX = w_to_gui(camera_get_view_width(view_camera[0]) / 2);
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

    draw_set_color(c_black)
    draw_text(startX + offsetX + 10, baseY + waveOffset + 10, letter);
    draw_set_color(c_white)
    draw_set_font(f_credits)
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(room_width / 2, room_height - 20 + creditsY, "Game by: Miłosz Kawczyński & Mikołaj Przybylski");
    draw_set_font(f_latinMenu);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white)
    draw_text(startX + offsetX, baseY + waveOffset, letter);
    draw_set_color(c_white)
    offsetX += letterWidht;
}

draw_set_font(f_latin);
