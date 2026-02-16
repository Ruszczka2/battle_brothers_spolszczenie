this.anatomist_vs_splinter_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		SplinterBro = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_splinter";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 110.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{Zastajesz %anatomist% trzymającego bosą stopę %splinterbro%. Naturalnie pytasz, co robią. Anatomista prostuje się z pęsetą w dłoni, a między jej końcówkami tkwi ogromna drzazga. %splinterbro% porusza palcami, po czym wstaje. Chodzi w koło, potem szybko staje na stopie, obraca się i chodzi tam i z powrotem.%SPEECH_ON%Niech mnie. Myślałem, że po prostu sobie rozwaliłem stopę czy coś, a tu się okazuje, że przez lata chodziłem z wielką drzazgą w nodze! To wspaniałe uczucie!%SPEECH_OFF%Zamiast wyrzucić drzazgę, %anatomist% zamyka ją w drewnianym pudełku, gdzie toczy się inne medyczne osobliwości.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lepiej żebym nie widział, jak używasz tego jako wykałaczki.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.SplinterBro.getImagePath());
				_event.m.SplinterBro.getBaseProperties().MeleeDefense += 1;
				_event.m.SplinterBro.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.SplinterBro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Obrony w Walce Wręcz"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local splinter_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.bright") && !(bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.historian" || bro.getBackground().getID() == "background.adventurous_noble" || bro.getBackground().getID() == "background.disowned_noble" || bro.getBackground().getID() == "background.regent_in_absentia" || bro.getBackground().getID() == "background.minstrel"))
			{
				splinter_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0 || splinter_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.SplinterBro = splinter_candidates[this.Math.rand(0, splinter_candidates.len() - 1)];
		this.m.Score = 3 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"splinterbro",
			this.m.SplinterBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.SplinterBro = null;
	}

});

