this.slave_revolt_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.slave_revolt";
		this.m.Name = "Bunt Niewolników";
		this.m.Description = "Zadłużeni, klasa niewolników państw-miast, chwyciła za broń i powstała przeciwko swym panom! Ciężko obecnie kupić zadłużonego, a broń i pancerze niemal całkowicie zniknęły z rynku.";
		this.m.Icon = "ui/settlement_status/settlement_effect_40.png";
		this.m.Rumors = [
			"Niewolnicy w %settlement% chwycili za broń i zajęli się bandytyzmem oraz napaściami. Znaczy Niepokalani, czy jak ich tam zwą. Z pewnością jest tam nieco do roboty dla takiego najemnika, jak ty.",
			"Doszły nas wieści, że niewolnicy w %settlement% się buntują. Porządna rewolta może zachwiać ich całym miastem. I mam nadzieję, że tak właśnie się stanie."
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " niewolnicy się zbuntowali";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " zakończył się bunt niewolników";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RecruitsMult *= 0.75;
		_modifiers.RarityMult *= 0.5;
	}

	function onUpdateDraftList( _draftList )
	{
		for( local i = _draftList.len() - 1; i >= 0; i = i )
		{
			if (_draftList[i] == "slave_background" || _draftList[i] == "slave_southern_background")
			{
				_draftList.remove(i);
			}

			i = --i;
		}
	}

});

