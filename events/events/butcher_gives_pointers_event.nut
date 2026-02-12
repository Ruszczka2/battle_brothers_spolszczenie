this.butcher_gives_pointers_event <- this.inherit("scripts/events/event", {
	m = {
		Butcher = null,
		Flagellant = null
	},
	function create()
	{
		this.m.ID = "event.pointers_from_butcher";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_38.png[/img]Zastajesz %butcher% rzeźnika, gdy przesuwa palcem po nagich plecach %flagellant%. Znajduje punkt między ścięgnami i bliznami i stuka w niego.%SPEECH_ON%Tu. Jeśli uderzysz się tutaj, trafisz w największą ilość mięsa - to znaczy mięśni.%SPEECH_OFF%Biczownik podnosi wzrok.%SPEECH_ON%Będzie bolało?%SPEECH_OFF%Na twarzy rzeźnika pojawia się uśmiech.%SPEECH_ON%Och tak, i to bardzo.%SPEECH_OFF%Wygląda na to, że mężczyzna daje biczownikowi wskazówki, jak się okaleczać. Zanim zdążysz zareagować, %flagellant% chwyta bicz i uderza się dokładnie tam, gdzie wskazał %butcher%. Rzemienie skóry, szkła i ostrych kości uderzają w jego plecy, wbijają się, a potem przy wyciąganiu rozdzierają ciało.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Po co, do diabła, mu to pokazywać?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());
				_event.m.Flagellant.getFlags().add("pointers_from_butcher");
				_event.m.Flagellant.getBaseProperties().MeleeSkill += 2;
				_event.m.Flagellant.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Flagellant.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Umiejętność walki wręcz"
				});
				local injury = _event.m.Flagellant.addInjury(this.Const.Injury.Flagellation);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Flagellant.getName() + " doznaje " + injury.getNameOnly()
				});
				_event.m.Butcher.improveMood(2.0, "Czerpał przyjemność z cudzego bólu");

				if (_event.m.Butcher.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Butcher.getMoodState()],
						text = _event.m.Butcher.getName() + this.Const.MoodStateEvent[_event.m.Butcher.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_butcher = [];
		local candidates_flagellant = [];

		foreach( bro in brothers )
		{
			if (bro.getFlags().has("pointers_from_butcher"))
			{
				continue;
			}

			if (bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.butcher")
			{
				candidates_butcher.push(bro);
			}
			else if (bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				candidates_flagellant.push(bro);
			}
		}

		if (candidates_butcher.len() == 0 || candidates_flagellant.len() == 0)
		{
			return;
		}

		this.m.Butcher = candidates_butcher[this.Math.rand(0, candidates_butcher.len() - 1)];
		this.m.Flagellant = candidates_flagellant[this.Math.rand(0, candidates_flagellant.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"butcher",
			this.m.Butcher.getNameOnly()
		]);
		_vars.push([
			"flagellant",
			this.m.Flagellant.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Butcher = null;
		this.m.Flagellant = null;
	}

});

