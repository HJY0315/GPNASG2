if(hp <= 0)
{
	instance_destroy();//Monster dies if hp <= 0
	instance_create_layer(x, y, layer, oHealPotion); //boss monster drops heal potion
}