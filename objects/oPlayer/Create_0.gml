	/// @description Insert description here
// You can write your code in this editor

//Health
hp = 20;
hp_max = hp;

healthbar_width = 100;
healthbar_height = 12;
healthbar_x = x - (healthbar_width/2);
healthbar_y = y - 50;

//increase speed power up
has_speed1 = false;
has_speed2 = false;
has_speed3 = false;
has_speed4 = false;

hsp = 0; //Horizontal speed
vsp = 0; //Vertical speed
grv = 0.3; //gravity
walksp = 4; //walk speed
canjump = 0;

attackdelay = 0;
durationLimit = 10;

quest1_accept = false;
quest1_complete = false;
quest1_targetCount = 0;

final_mentor_dialog_activated = false;
final_cat_dialog_activated = false;
final_NPC_dialog_activated = false;
goGameEndRoom = false;
 

has_hook = false;
mx = x;		//hook x coordinate
my = y;		//hook y coordinate
active = false;
hook_timer = 0;

transform = false;
transform_cooldown = 0;

immortalTime = 0;
immortalDuration = room_speed * 1;

//for showing text when player collide with Blockage, puzzle stone etc
blockage_show_text_timer = 0;
puzzleStone_show_text_timer = 0;

collided_puzzleStone_active = false; //to track whether the collided stone is activate or not

show_teleport_message_timer = 0; //for alert text when teleport with monster not eliminated

interact_show_text_timer = 0; //for alert player to press E to talk with npc

sprites = [sPlayerKnight, sPlayerKnightRun, sPlayerKnightJump, sPlayerKnightFall];

board_show_text_timer = 0;


activated_stone = 0;


enum FocusState  //for camera
{
    None,
    Active
}


global.focusState = FocusState.None;


