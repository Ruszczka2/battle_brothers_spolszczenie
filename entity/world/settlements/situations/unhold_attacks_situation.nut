this.unhold_attacks_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.unhold_attacks";
		this.m.Name = "Ataki Unholdów";
		this.m.Description = "Wielkie Unholdy były widziane i słyszane w okolicy. Mieszkańcy boją się opuszczać osadę.";
		this.m.Icon = "ui/settlement_status/settlement_effect_26.png";
		this.m.Rumors = [
			"Podróżujący kupiec powiedział mi o olbrzymich śladach w pobliżu traktu z %settlement%. Za cholerę nie chciałbym spotkać tej bestii, która je zostawiła!",
			"Gdy ostatnio byłem w %settlement%, zaginęła grupa myśliwych. Wyruszyli zapolować na jakiegoś olbrzyma, czy coś...",
			"Słyszałeś kiedyś o Unholdach? Ogromne potwory, które potrafią rozdeptać cały wóz! Krążą plotki, że widziano je pod %settlement%."
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + " jest atakowane przez Unholdy";
	}

	function getRemovedString( _s )
	{
		return _s + " już nie jest atakowane przez Unholdy";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.1;
		_modifiers.SellPriceMult *= 0.9;
		_modifiers.RarityMult *= 0.9;
		_modifiers.RecruitsMult *= 0.75;
	}

});

