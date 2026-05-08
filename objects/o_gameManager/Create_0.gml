//window_set_fullscreen(true);

playerCharacters = [];

var characterInstance = instance_create_depth(1920 / 2 - 200, 1080 / 2, 1, o_character);
array_push(playerCharacters, characterInstance);

characterInstance = instance_create_depth(1920 / 2 - 200, 1080 / 2 - 100, 1, o_character);
array_push(playerCharacters, characterInstance);

characterInstance = instance_create_depth(1920 / 2 - 200, 1080 / 2 - 200, 1, o_character);
array_push(playerCharacters, characterInstance);

enemiesCharacters = [];

characterInstance = instance_create_depth(1920 / 2 + 200, 1080 / 2, 1, o_character);
array_push(enemiesCharacters, characterInstance);

characterInstance = instance_create_depth(1920 / 2 + 200, 1080 / 2 - 100, 1, o_character);
array_push(enemiesCharacters, characterInstance);

characterInstance = instance_create_depth(1920 / 2 + 200, 1080 / 2 - 200, 1, o_character);
array_push(enemiesCharacters, characterInstance);