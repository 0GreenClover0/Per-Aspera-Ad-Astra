hover_card_under_mouse();

if (o_gameManager.roundState == RoundState.Visualization)
{
    yHide = lerp(yHide, 400, 0.1);
}
else 
{
	yHide = lerp(yHide, 0, 0.1);
}

if (yHide < 1) {yHide = 0;}
if (yHide > 399) {yHide = 400;}

if (yHide != 0 and yHide != 400)
{
    arrange();
}