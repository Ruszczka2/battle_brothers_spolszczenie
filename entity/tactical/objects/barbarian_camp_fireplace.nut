this.barbarian_camp_fireplace <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Ognisko";
	}

	function getDescription()
	{
		return "Ognisko od przygotowywania potraw.";
	}

	function onInit()
	{
		local variants = [
			"01"
		];
		local body = this.addSprite("body");
		body.setBrush("barbarians_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

