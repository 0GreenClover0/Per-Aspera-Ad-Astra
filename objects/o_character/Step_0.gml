if (isFighting or isBeingBeaten)
{
    x = lerp(x, room_width / 2 - orientation * 25, 0.01);
}
else 
{
	x = lerp(x, room_width / 2 - room_width * 0.27 * orientation, 0.05);
}

if (team == Team.Enemy)
{
   if (x <= room_width / 2 - room_width * 0.27 * orientation)
   {
       isEntering = false;
   }
}

if (team == Team.Player)
{
   if (x >= room_width / 2 - room_width * 0.27 * orientation)
   {
       isEntering = false;
   }
}

if (o_gameManager.roundState == RoundState.Visualization or o_gameManager.roundState == RoundState.Fight)
{
    y = lerp(y, vizualizationY, 0.1);
}
else 
{
	y = lerp(y, startY, 0.1);
}

if (age > 3)
{
    o_gameManager.kill(self);
}

xScale = lerp(xScale, 1, 0.05);
yScale = lerp(yScale, 1, 0.05);
rot = lerp(rot, 0, 0.05);