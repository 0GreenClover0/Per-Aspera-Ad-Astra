draw_self();

//draw_rectangle_colour(x, y, x + 50, y + 50, c_grey, c_grey, c_grey, c_grey, false);

draw_set_colour(c_black);
draw_text(x, y, string("HP {0}, ATK {1}, DEF {2}, INT {3} DEX {4}", hp, atk, def, int, dex));
draw_set_colour(c_white);