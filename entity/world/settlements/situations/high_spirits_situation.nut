this.high_spirits_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.high_spirits";
		this.m.Name = "Dobry Nastrój";
		this.m.Description = "Nastroje są tu bardzo pogodne, a ludzie chętnie dobiją z tobą targu.";
		this.m.Icon = "ui/settlement_status/settlement_effect_05.png";
		this.m.Rumors = [
			"Przybyłem tu dziś z %settlement%, szat jeszcze z przydrożnego kurzu nie otrzepałem. Tamtejsi ludzie bez wątpienia byli w dobrym nastroju, choć nie jestem pewien z jakiego powodu...",
			"Nie musisz przynosić mi kufla. Jeszcze nie wytrzeźwiałem ze świętowania w %settlement%. Bez wątpienia wiedzą, jak dobrze się bawić!",
			"Plotka głosi, że ludność %settlement% właśnie odzyskała jakąś ważną relikwię."
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " panuje dobry nastrój";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " już nie panuje dobry nastrój";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 1.05;
		_modifiers.BuyPriceMult *= 0.95;
		_modifiers.RarityMult *= 1.1;
	}

});

