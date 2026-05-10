particlesDMG = part_system_create(ps_Dead);
part_system_position(particlesDMG, x, y + 20);
part_system_depth(particlesDMG, -999999);
array_push(o_gameManager.particleSystems, particlesDMG);

audio_play_sound(choose(Death1, Death2, Death3), 0, false,,, random_range(0.8, 1.2));

particleSpeed = 10;