particleSpeed -= 0.02;

var partType = particle_get_info(ps_Dead).emitters[0].parttype.ind;
part_type_speed(partType, particleSpeed, particleSpeed + 5, -0.15, 0);
part_type_life(partType, (particleSpeed / 10) * 30, (particleSpeed / 10) * 90);

if (particleSpeed <= 0)
{
    part_system_destroy(particlesDMG);
    
    image_alpha -= 0.02;
}

if (image_alpha <= 0)
{
    instance_destroy();
}