this.human_camp_supplies <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Zapasy";
	}

	function getDescription()
	{
		return "Zapasy do wyżywienia mieszkańców tego obozu.";
	}

	function onInit()
	{
		local variants = [
			"03",
			"04",
			"05",
			"06",
			"12",
			"16"
		];
		local body = this.addSprite("body");
		body.setBrush("camp_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

