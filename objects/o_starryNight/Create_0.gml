shd = shd_starryNight;
u_time = shader_get_uniform(shd, "u_time");
u_screen_size = shader_get_uniform(shd, "u_screen_size");
u_alpha = shader_get_uniform(shd, "u_alpha");
u_frequency_start = shader_get_uniform(shd, "u_frequency_start");
surf = undefined;

x = 0;
y = 0;

alpha = 0;
newAlpha = alpha;

titleY = o_gameManager.h_to_gui(camera_get_view_height(view_camera[0]) * 3 / 15);