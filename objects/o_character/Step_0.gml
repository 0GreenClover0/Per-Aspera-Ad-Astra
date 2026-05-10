if (!o_gameManager.isMenu)
{
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
    
    startY = o_gameManager.startRow + o_gameManager.rowIncrement * idInArray;
    vizualizationY = o_gameManager.startRow + o_gameManager.rowIncrement * idInArray + 100;
}

if (age > 3)
{
    o_gameManager.kill(self);
}

xScale = lerp(xScale, 1, 0.05);
yScale = lerp(yScale, 1, 0.05);
rot = lerp(rot, 0, 0.05);

if (o_gameManager.showFullCharData)
{
    dataSizeToShow = lerp(dataSizeToShow, 7.5, 0.1);
}

intColor = merge_colour(intColor, c_white, 0.02);
atkColor = merge_colour(atkColor, c_white, 0.02);
defColor = merge_colour(defColor, c_white, 0.02);
dexColor = merge_colour(dexColor, c_white, 0.02);
ageColor = merge_colour(ageColor, c_white, 0.02);

intScale = lerp(intScale, 1, 0.05);
atkScale = lerp(atkScale, 1, 0.05);
defScale = lerp(defScale, 1, 0.05);
dexScale = lerp(dexScale, 1, 0.05);
ageScale = lerp(ageScale, 1, 0.05);

if (intBefore != int) {intScale = 2; intColor = int - intBefore > 0 ? c_lime : c_red; intBefore = int;}
if (atkBefore != atk) {atkScale = 2; atkColor = atk - atkBefore > 0 ? c_lime : c_red; atkBefore = atk;}
if (defBefore != def) {defScale = 2; defColor = def - defBefore > 0 ? c_lime : c_red; defBefore = def;}
if (dexBefore != dex) {dexScale = 2; dexColor = dex - dexBefore > 0 ? c_lime : c_red; dexBefore = dex;}
if (ageBefore != age) {ageScale = 2; ageColor = age - ageBefore > 0 ? c_lime : c_red; ageBefore = age;}