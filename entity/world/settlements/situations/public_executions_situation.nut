this.public_executions_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.public_executions";
		this.m.Name = "Publiczne Egzekucje";
		this.m.Description = "Publicznych egzekucji nie można przegapić i zapewniają one rozrywkę dla całej rodziny. Przy takich okazjach żywność i napitek są łatwo dostępne, choć kupcy mogą próbować zarobić na gawiedzi.";
		this.m.Icon = "ui/settlement_status/settlement_effect_14.png";
		this.m.Rumors = [
			"Całe tłumy ludzi zmierzają do %settlement% na wielki spektakl! Chłopy, dziewki, podrostki... wszyscy na szlaku, by zobaczyć nadchodzące egzekucje!",
			"Słyszałem, że schwytali jakichś zbójców w pobliżu %settlement% i że skończą oni z głowami na pieńku. Należy im się za to napadanie na ludzi na szlakach...",
			"My, biedni ludzie, niewiele radości w tych czasach, ale porządne wieszanie to zawsze miły dla oka widok. Nie było tu żadnego od jesieni, ale ponoć mają wieszać kogoś w %settlement%, a przynajmniej tak mi %randomname% mówił."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 2;
	}

	function getAddedString( _s )
	{
		return "W " + _s + " odbywają się publiczne egzekucje";
	}

	function getRemovedString( _s )
	{
		return "W " + _s + " zakończyły się publiczne egzekucje";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 1.35;
		_modifiers.FoodPriceMult *= 1.15;
	}

});

