this.mirage_sightings_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.mirage_sightings";
		this.m.Name = "Fatamorgany";
		this.m.Description = "Piekący gorąc i falujące powietrze spowodowały, że wiele osób widziało miraże, w których ponoć ruszały się jakieś dziwne postacie. ";
		this.m.Icon = "ui/settlement_status/settlement_effect_43.png";
		this.m.Rumors = [
			"Mówię ci, cudowna, bujna oaza, złote dachy połyskujące w oddali, a nad głową ptaki w kolorach tęczy! Gdzie to widziałem? Na szlaku do %settlement%. Przysięgam!",
			"Niektóre zła nie przychodzą w ciemnościach nocy i nie czają się w cieniach. Przybywają w piekącym słońcu, w środku dnia. Udaj się do %settlement%, jeśli chcesz się przekonać, o czym mówię.",
			"Miraże można czasem dostrzec na pustyniach, a podążając za nimi możesz skazać się na los znacznie gorszy, niż tylko zabłądzenie na pustyni."
		];
	}

	function getAddedString( _s )
	{
		return "W " + _s + " widziano fatamorgany";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " już nie widuje się fatamorgan";
	}

	function onAdded( _settlement )
	{
		_settlement.removeSituationByID("situation.safe_roads");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
	}

});

