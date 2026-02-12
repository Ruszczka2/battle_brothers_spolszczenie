this.orc_camp_fireplace <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Ognisko";
	}

	function getDescription()
	{
		return "Ognisko. Nie chcesz wiedzieć, co tu na nim pieką.";
	}

	function onInit()
	{
		local variants = [
			"06",
			"09"
		];
		local body = this.addSprite("body");
		body.setBrush("orcs_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

