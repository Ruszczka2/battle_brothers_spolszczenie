this.besieged_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.besieged";
		this.m.Name = "Oblężenie";
		this.m.Description = "To miejsce jest lub niedawno było oblężone przez wroga! Osada odniosła szkody, brakuje zapasów, a wielu mieszkańców utraciło życie.";
		this.m.Icon = "ui/settlement_status/settlement_effect_13.png";
		this.m.Rumors = [
			"Głazy i strzały zapalające przeszywają niebo, wrzący olej się leje, ludzie głodują i umierają - tak wygląda oblężenie. Możesz udać się do %settlement% i przekonać na własne oczy.",
			"Kiedy byłem młodszy, służyłem w armii, którą prowadził %randomnoble%. Najgorsze oblężenie, w którym uczestniczyliśmy, trwało miesiącami. To straszne, to samo dzieje się teraz w %settlement%.",
			"Słyszałeś wieści? %settlement% jest pod oblężeniem! Biedni tamtejsi ludzie, sporo się nacierpią."
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + " jest pod oblężeniem";
	}

	function getRemovedString( _s )
	{
		return _s + " już nie jest pod oblężeniem";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(false);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 1.0;
		_modifiers.BuyPriceMult *= 1.25;
		_modifiers.FoodPriceMult *= 2.0;
		_modifiers.RecruitsMult *= 0.5;
		_modifiers.RarityMult *= 0.5;
	}

});

