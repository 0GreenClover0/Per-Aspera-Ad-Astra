if (sprite_index != s_sekletorDead)
{
    audio_play_sound(choose(Death1, Death2, Death3), 0, false,,, random_range(0.8, 1.2));
}
else 
{
	audio_play_sound(choose(SkeletonDeath1, SkeletonDeath2, SkeletonDeath3), 0, false,,, random_range(0.8, 1.2));
}