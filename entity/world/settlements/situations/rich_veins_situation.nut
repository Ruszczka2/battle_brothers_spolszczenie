this.rich_veins_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.rich_veins";
		this.m.Name = "Bogate Złoża";
		this.m.Description = "Jakiemuś górnikowi się poszczęściło i natrafił na wyjątkowo bogatą żyłę! Wydobycie metali i minerałów znacznie wzrośnie, póki złoże się nie wyczerpie, jednak można też w osadzie zaobserwować sporą inflację.";
		this.m.Icon = "ui/settlement_status/settlement_effect_33.png";
		this.m.Rumors = [
			"Natrafili na obfite złoża w %settlement%. Sam też przez dekady pracowałem w kopalniach i jedyne, czego się dzięki temu dorobiłem, to paskudny kaszel.",
			"Ci cholerni szczęściarze w %settlement% znaleźli nową żyłę w kopalni. Karawany nie nadążają z przywożeniem tego, co oni tam wykopują.",
			"Słyszałem, że kopalnie w %settlement% są ostatnio niezwykle produktywne. To całkiem niezła okazja do zarobku, jeśli parasz się handlem."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 4;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " natrafiono na bogate złoża";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " skończyły się bogate złoża";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 1.1;
		_modifiers.BuyPriceMult *= 1.1;
		_modifiers.MineralRarityMult = 1.5;
	}

});

