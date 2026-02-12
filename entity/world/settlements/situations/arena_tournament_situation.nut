this.arena_tournament_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.arena_tournament";
		this.m.Name = "Turniej";
		this.m.Description = "Wielki turniej ma odbyć się na arenie. Dołącz do niego, aby zdobyć wspaniałe nagrody!";
		this.m.Icon = "ui/settlement_status/settlement_effect_45.png";
		this.m.Rumors = [
			"Wyglądasz na zdolnego wojownika. Arena w %settlement% organizuje turniej i z pewnością nadal możesz dołączyć!",
			"Jak dopiję, to ruszam prosto w stronę %settlement%, aby obejrzeć wielki turniej na arenie! Najlepsza rozrywka w tym roku!",
			"Słyszałem, że nagroda dla zwycięzcy turnieju na arenie w %settlement% jest w tym roku jeszcze wspanialsza!"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 5;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " odbywa się turniej";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " już nie odbywa się turniej";
	}

	function onAdded( _settlement )
	{
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
	}

});

