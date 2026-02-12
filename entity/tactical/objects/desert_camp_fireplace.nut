this.desert_camp_fireplace <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Ognisko";
	}

	function getDescription()
	{
		return "Ognisko do przygotowywania potraw.";
	}

	function onInit()
	{
		local variants = [
			"05",
			"08"
		];
		local body = this.addSprite("body");
		body.setBrush("desert_camp_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

