this.flesh_cradle_destroyed <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Zniszczona Cielesna Kołyska";
	}

	function getDescription()
	{
		return "Zniszczony kamienny pojemnik. Wnętrzności i krew, które kiedyś znajdowały się w środku, rozlały się po otaczającej je ziemi.";
	}

	function onInit()
	{
		local flip = false;
		local body = this.addSprite("body");
		body.setBrush("flesh_cradle_01_destroyed");
		this.setBlockSight(false);
	}

	function isDying()
	{
		return true;
	}

});

