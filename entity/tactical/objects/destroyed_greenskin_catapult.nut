this.destroyed_greenskin_catapult <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Zniszczona Machina Oblężnicza";
	}

	function getDescription()
	{
		return "Ta machina oblężnicza zielonoskórych została całkowicie zniszczona.";
	}

	function onInit()
	{
		local flip = false;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("greenskin_catapult_destroyed_bottom");
		local top = this.addSprite("top");
		top.setBrush("greenskin_catapult_destroyed_top");
		this.setSpriteOcclusion("top", 1, 2, -3);
		this.setBlockSight(false);
	}

	function isDying()
	{
		return true;
	}

});

