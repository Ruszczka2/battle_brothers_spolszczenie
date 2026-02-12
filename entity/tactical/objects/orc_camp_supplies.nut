this.orc_camp_supplies <- this.inherit("scripts/entity/tactical/entity", {
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
			"01",
			"04",
			"05"
		];
		local body = this.addSprite("body");
		body.setBrush("orcs_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});

