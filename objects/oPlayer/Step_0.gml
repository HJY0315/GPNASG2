 /// @description Insert description here
// You can write your code in this editor
if ((global.dialogueState == DialogueState.None) && (global.focusState == FocusState.None)) {
	//Get Player input
	key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
	key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
	key_jump = keyboard_check_pressed(vk_space) || keyboard_check(ord("W"));
	mouse_attack = mouse_check_button_pressed(mb_left);
	mouse_hook = mouse_check_button_pressed(mb_right);
}

//Update position of health bar
healthbar_x = x - (healthbar_width / 2);
healthbar_y = y - 50;

 //Calculate movement
var move = key_right - key_left;


hsp = move * walksp; //positive if moving left negative when moving right

vsp = vsp + grv;  

var previousY = y;

if (previousY == y)  //If the player is not moving
{
    sprite_index = sprites[0];
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
	hsp = 0;
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
//canjump is for allowing player to jump even after they set off the ground for a few frame of time.
canjump --;
if ((canjump > 0) && (key_jump))
{ 
	audio_play_sound(snJump, 1, false);
	vsp = -7;
	canjump = 0;
}

if (place_meeting(x, y + 1, oWall))		//on ground
{
	canjump = 5;
	if (hsp != 0) //if direction button is clicked
	{
		sprite_index = sprites[1];
	}
}
else
{
    if (sign(vsp) > 0) // If object is moving down
    {
        sprite_index = sprites[3];
    }
    else // If object is moving up
    {
        sprite_index = sprites[2];
    }
}

if (place_meeting(x, y + 5, oWall))		//on ground
{
	if (sprite_index == sPlayerKnightFall || sprite_index == sCatFall)
	{
		audio_play_sound(snLanding_Grass, 0.5, false);
	}
}

//image_xscale will flip the sprite when it is -1
//sign(hsp) will return 1 if moving left else -1
if (hsp != 0) image_xscale = sign(hsp); 

if (!transform){
	attackdelay -= 1;
	if (mouse_attack && (attackdelay < 0))
	{
		audio_play_sound(snAttack, 1, false);
	    sprite_index = sPlayerKnightAttack;
	    attackdelay = 10;
	    ScreenShake(2,10);
	
	    // Set the direction of the slash based on the player's facing direction
	    var slashDirection = image_xscale > 0 ? 0 : 180;
	
	    with (instance_create_depth(x, y, 0, oSlash))
	    {
	        speed = 20;
	        direction = slashDirection;
	        image_angle = direction;
	    }
	}

	// Calculate the horizontal movement towards the player's facing direction
	if (sprite_index == sPlayerKnightAttack)
	{
	    var moveX = lengthdir_x(3, image_angle);
	    // Move the player towards their facing direction
	    if (image_xscale > 0)  // Player facing right
	    {
	        // Move right
	        if (!place_meeting(x + moveX, y, oWall))
	        {
	            x += moveX;
	        }
	    }
	    else  // Player facing left
	    {
	        // Move left
	        if (!place_meeting(x - moveX, y, oWall))
	        {
	            x -= moveX;
	        }
	    }
	}
	hook_timer --;
	if (has_hook)
	{
		//Grapling Hook
		if (mouse_hook && !active)
		{
			mx = mouse_x;
			my = mouse_y;
			// Calculate the angle in degrees between the player's position and the mouse position
		    var angle = point_direction(x, y, mx, my);
			if ((image_xscale > 0 && (angle > 270 || angle < 90)) || (image_xscale < 0 && ((angle > 90 && angle < 270))))
			{
				if (place_meeting(mx, my, oHanger_Hook))
				{
					active = true;
					hook_timer = room_speed * 1;
				}
			}
		}

		if (active)
		{
			grv = 0.1;
			x_move = (mx - x) * 0.05;
			y_move = (my - y) * 0.05;
			if (!place_meeting(x + x_move , y + y_move, oHanger_Hook))
			{
				x += x_move;
				y += y_move;
			}
		}
		grv = 0.3;

		if (hook_timer <= 0 || mouse_check_button_released(mb_right))
		{
			active = false;
		}
	}
}



// Activate Puzzle Stone
var objStone = instance_place(x + hsp, y, oPuzzleStone);

if (objStone != noone)
{
    hsp = 0;
    if (!objStone.activated) // Check if the chest is not already opened
    {
        if (keyboard_check_pressed(ord("F")))
        {
			if (objStone.valid == true){	//the puzzle stone is functional
				objStone.sprite_index = sPuzzleStone_Active;
	            objStone.activated = true; // Set the flag to true to indicate the chest is opened
				activated_stone += 1;
				if (activated_stone == 2){
					global.focusState = FocusState.Active;
					global.follow = oBlockage;
					key_left = 0;
					key_right = 0;
					activated_stone = 0;
					global.blockageState = BlockageState.None;
				}
			}
        }
    }
}


// Open Chest
var objChest = instance_place(x + hsp, y, oChest);

if (objChest != noone)
{
    hsp = 0;
    if (!objChest.opened) // Check if the chest is not already opened
    {
        if (keyboard_check_pressed(ord("F")))
        {
            objChest.sprite_index = sChestOpen;
            objChest.opened = true; // Set the flag to true to indicate the chest is opened
        }
    }
}

if (transform_cooldown > 0)
{
    transform_cooldown -= 1;
}

if (immortalTime > 0)
{
    immortalTime--;
}

//for showing text of clearing the blockage 
if (blockage_show_text_timer > 0)
{
    blockage_show_text_timer -= 1;
}

if (puzzleStone_show_text_timer > 0)
{
    puzzleStone_show_text_timer -= 1;
}

if (show_teleport_message_timer > 0)
{
    show_teleport_message_timer -= 1;
}

if (interact_show_text_timer > 0)
{
    interact_show_text_timer -= 1;
}

if (board_show_text_timer > 0)
{
    board_show_text_timer -= 1;
}


//increase speed

if(has_speed1)
{
	walksp = 5; //walk speed
}
if(has_speed2)
{
	walksp = 6; //walk speed
}
if(has_speed3)
{
	walksp = 7; //walk speed
}
if(has_speed4)
{
	walksp = 8; //walk speed
}

if (global.dialogueState == DialogueState.None)
{
	if (!instance_exists(oDialog_Level5_Cat) && !instance_exists(oDialog_Level5_Mentor) && !instance_exists(oDialog_Level5_RedCoatNPC) && !goGameEndRoom && final_cat_dialog_activated && final_mentor_dialog_activated && final_NPC_dialog_activated)
	{
		goGameEndRoom = true;
		room_goto_next();
	}
}