particlesDMG = part_system_create(ps_Dead);
part_system_position(particlesDMG, x, y + 20);
part_system_depth(particlesDMG, -999999);
array_push(o_gameManager.particleSystems, particlesDMG);

alarm[0] = 1;

particleSpeed = 10;