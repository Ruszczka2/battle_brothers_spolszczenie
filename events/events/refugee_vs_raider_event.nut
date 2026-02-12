this.refugee_vs_raider_event <- this.inherit("scripts/events/event", {
	m = {
		Refugee = null,
		Raider = null
	},
	function create()
	{
		this.m.ID = "event.refugee_vs_raider";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]%refugee%, człowiek niegdyś zepchnięty na drogi jako uchodźca, beznamiętnie wpatruje się w %raider%. Raider, czując spojrzenie, opuszcza talerz z jedzeniem.%SPEECH_ON%Na co się gapisz, co?%SPEECH_OFF%Uchodźca wskazuje łyżką, z której kapie.%SPEECH_ON%Jesteś rajderem, tak?%SPEECH_OFF%%raider% kiwa głową.%SPEECH_ON%Byłem. Może kiedyś znów będę. Co ci do tego?%SPEECH_OFF%Wstając, %refugee% wskazuje palcem.%SPEECH_ON%To tacy jak ty wypędzili dobrych ludzi z domów. Dobrych ludzi, którzy musieli ciągnąć całe swoje życie po tej cholernej drodze.%SPEECH_OFF%Śmiejąc się, %raider% też wstaje.%SPEECH_ON%A, tak? I co czyniło ich tak dobrymi? To, że nie potrafili machać mieczem ani się bronić? Wierzysz choć przez chwilę, że gdyby role się odwróciły, nie zrobiliby mi tego samego? Albo tobie? Ludzie są tylko tak dobrzy, jak ich możliwości.%SPEECH_OFF%Sprzeczka się zaostrza i kilku innych najemników wstaje. Nikt nie jest w stanie powstrzymać pierwszej szamotaniny, dwóch mężczyzn wymienia ciosy i przekleństwa, jak w każdej karczemnej bójce, jaką widziałeś. Na szczęście nic zbyt poważnego z tego nie wynika.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Spokojnie, już.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Refugee.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury1 = _event.m.Refugee.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury1.getIcon(),
						text = _event.m.Refugee.getName() + " doznaje " + injury1.getNameOnly()
					});
				}
				else
				{
					_event.m.Refugee.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Refugee.getName() + " doznaje lekkich ran"
					});
				}

				_event.m.Refugee.worsenMood(1.0, "Wdał się w bójkę z " + _event.m.Raider.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Refugee.getMoodState()],
					text = _event.m.Refugee.getName() + this.Const.MoodStateEvent[_event.m.Refugee.getMoodState()]
				});

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury2 = _event.m.Raider.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury2.getIcon(),
						text = _event.m.Raider.getName() + " doznaje " + injury2.getNameOnly()
					});
				}
				else
				{
					_event.m.Raider.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Raider.getName() + " doznaje lekkich ran"
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local refugee_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 2 && bro.getBackground().getID() == "background.refugee")
			{
				refugee_candidates.push(bro);
				break;
			}
		}

		if (refugee_candidates.len() == 0)
		{
			return;
		}

		local raider_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 6 && bro.getBackground().getID() == "background.raider")
			{
				raider_candidates.push(bro);
			}
		}

		if (raider_candidates.len() == 0)
		{
			return;
		}

		this.m.Refugee = refugee_candidates[this.Math.rand(0, refugee_candidates.len() - 1)];
		this.m.Raider = raider_candidates[this.Math.rand(0, raider_candidates.len() - 1)];
		this.m.Score = (refugee_candidates.len() + raider_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"refugee",
			this.m.Refugee.getNameOnly()
		]);
		_vars.push([
			"raider",
			this.m.Raider.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Refugee = null;
		this.m.Raider = null;
	}

});

