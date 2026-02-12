this.graveyard_sarcophagus <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Sarkofag";
	}

	function getDescription()
	{
		return "Przypuszczalnie ostatnie miejsce spoczynku kogoś, kto umarł dawno temu.";
	}

	function onInit()
	{
		local variants = [
			"03"
		];
		local body = this.addSprite("body");
		body.setBrush("graveyard_" + variants[this.Math.rand(0, variants.len() - 1)]);
		body.setHorizontalFlipping(this.Math.rand(0, 1) == 1);
		this.setBlockSight(true);
	}

});

