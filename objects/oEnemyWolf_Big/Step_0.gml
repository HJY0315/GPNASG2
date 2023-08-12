 vsp = vsp + grv;  

var previousY = y;

if (previousY == y)  //If the player is not moving
{
    sprite_index = sEnemy_Wolf_Idle;
}

previousY = y;

//Horizontal Collision
if (place_meeting(x + hsp, y, oWall))
{
	//if there is no collision at one pixel besides object
	while (!place_meeting(x + sign(hsp), y, oWall))
	{
		x += sign(hsp); //Move one pixel to right or left
	}
	hsp = -hsp;
}

//x is a built in property represent the x (horizontal) coordinate of object
 x += hsp; 

//Vertical Collision
if (place_meeting(x, y + vsp, oWall))
{
	//if there is no collision at one pixel up and down of object,
	//which means that the object is in air
	while (!place_meeting(x, y + sign(vsp), oWall))
	{
		//sign() return 1 if the value is positive else -1
		y += sign(vsp); //Move one pixel down so that it can initially stay on ground
	}
	vsp = 0;
}
//y is a built in property represent the y (vertical) coordinate of object
 y += vsp; 
 

//we have collision with one pixel below us, 
//which means object is on the ground.
if (place_meeting(x, y + 1, oWall)) 
{

	if (hsp != 0)
	{
		sprite_index = sEnemy_Wolf_Attack_Walk;
	}
}
else
{
    if (sign(vsp) > 0) // If object is moving down
    {
        sprite_index = sEnemy_Wolf_Fall;
    }
    else // If object is moving up
    {
        sprite_index = sEnemy_Wolf_Jump;
    }
}



var _edge;

if (sign(hsp) == 1) //facing right
{
	_edge = place_meeting(x + 32, y + 32, oWall); //true if got collision
}
else if (sign(hsp) == -1) //facing right
{
	_edge = place_meeting(x - 32, y + 32, oWall);
}



// This checks if a collision was NOT found there, meaning we've hit a ledge.
if (!_edge)	//if not true, means that there is no platform or tile ahead
{
	// This ensures the enemy is grounded, so enemies in mid-air do not turn.
	if (place_meeting(x, y + 1, oWall))
	{
		// This makes the enemy turn.
		hsp = -hsp;
	}
}



if (chargingSkill)
{
	if (skillChargeDuration == 50) 
    {
        side = x - oPlayer.x; //positive if player is on left of monster
		if (sign(hsp) == 1 && sign(side) == 1)
		{
			hsp = -hsp;
		}
		if (sign(hsp) == -1 && sign(side) == -1)
		{
			hsp = -hsp;
		}
    }
	if (!place_meeting(x + (-sign(side) * 2), y, oWall))
	{
		x += -sign(side) * 4;
	}
	skillChargeDuration--;
    if (skillChargeDuration <= 0)
    {
        chargingSkill = false;
        skillCooldown = skillChargeTime; 
    }
}
else
{
    if (skillCooldown <= 0)
    {
        var dist = 200; 
        
        if (point_distance(x, y, oPlayer.x, oPlayer.y) <= dist)
        {
            chargingSkill = true;
            skillChargeDuration = 50; 
            
            //audio_play_sound(snd_skill_charge, 1, false);
        }
    }
    else
    {
        skillCooldown--;
    }
}


//image_xscale will flip the sprite when it is -1
//sign(hsp) will return 1 if moving left else -1
if (hsp != 0) image_xscale = sign(-hsp) * size; 
image_yscale = size;
