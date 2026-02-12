this.miasma_flail_spooks_bro_3_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.miasma_flail_spooks_bro_3";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Głos wsiąka w ciemność: gdziekolwiek jest... twoja matka wie, że cię porzuciła... gdziekolwiek ja jestem... wiesz, że kochałbym cię tak mocno, jak jej nieobecność cię zraniła. Umatkuję cię do potęgi, najemniku, nakarmię cię mlekiem życia z...\n\n Budzisz się przy jasnej zieleni i strzepujesz ją z twarzy. %hauntedbrother% pada na ziemię, a obok niego dźwięczy cep Wielkiego Wróżbity. Najemnik potrząsa głową i szeroko otwiera oczy, rozglądając się w osłupieniu.%SPEECH_ON%Co-co? Jak tu trafiłem?%SPEECH_OFF%Patrzysz na cep, obserwując, jak zieleń migocze, a potem przygasa, a wraz z nią niesie się groteskowy chichot.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholerne koszmary.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.worsenMood(1.0, "Został oczarowany cepem Wielkiego Wróżbity");

				if (_event.m.Dude.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local haveFlail = false;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			candidates.push(bro);
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && item.getID() == "weapon.miasma_flail")
			{
				haveFlail = true;
			}
		}

		if (!haveFlail)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && item.getID() == "weapon.miasma_flail")
				{
					haveFlail = true;
					break;
				}
			}
		}

		if (!haveFlail)
		{
			return;
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hauntedbrother",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

