this.local_holiday_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.local_holiday";
		this.m.Name = "Miejscowe Święta";
		this.m.Description = "Miejscowe święta wprawiły ludzi w dobry nastrój. Czas jedzenia i picia!";
		this.m.Icon = "ui/settlement_status/settlement_effect_22.png";
		this.m.Rumors = [
			"Jeśli chcesz się zabawić, udaj się do %settlement% i dołącz do świętowania! Ech, jakże chciałbym tam być.",
			"Nie wyglądasz mi na wielbiciela festynów, jeśli mogę się tak wyrazić, ale może twoi ludzie chcieliby się nacieszyć jadłem i napitkiem. Sporo tego znajdziecie teraz w %settlement%, bo obchodzą obecnie jakieś swoje święta.",
			"Dobrzy ludzie z %settlement% obchodzą obecnie swoje coroczne święta. Byłbym tam teraz, pijąc, jedząc i dobrze się bawiąc, gdybym tylko miał na to korony. Postawisz mi jeszcze jeden kufel, przyjacielu?"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 2;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " rozpoczęły się miejscowe święta";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " skończyły się miejscowe święta";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 1.05;
		_modifiers.BuyPriceMult *= 0.95;
		_modifiers.FoodRarityMult *= 1.5;
		_modifiers.FoodPriceMult *= 0.9;
	}

});

