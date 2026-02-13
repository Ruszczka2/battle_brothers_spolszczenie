this.gladiator_origin_vs_anatomist_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Gladiator = null
	},
	function create()
	{
		this.m.ID = "event.gladiator_origin_vs_anatomist";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{Widzisz %anatomist% i %gladiator% siedzacych razem przy ognisku. Anatomista i gladiator zdaja sie kiepsko dobrani do rozmowy i po chwili ten drugi wstaje z wielka wsciekloscia.%SPEECH_ON%Wzmocnienia? Myslisz, ze biorę wzmocnienia? Ty glupcze, patyczaku, kwiatki zrywajacy, trupy goniacy glupcze! Moje miesnie sa z potu i krwi! Bez bolu nie ma zysku!%SPEECH_OFF%Gladiator kopie kupke popiolu na anatomiste i odchodzi. %anatomist% otrzepuje sie, po czym wyciaga plik notatek. Zauwaza, ze \"obiekt\" doswiadcza napadow goracej zlosci. Pytasz go, czy potajemnie cos robi gladiatorowi. %anatomist% zamyka notes z trzaskiem.%SPEECH_ON%Kapitanie! Nigdy!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dziwnie krotka odpowiedz, %anatomist%...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Gladiator.getImagePath());
				_event.m.Anatomist.getFlags().set("IsExperimentingOnGladiator", true);
				_event.m.Gladiator.getFlags().set("IsJuiced", true);
				_event.m.Gladiator.getBaseProperties().Hitpoints += 1;
				_event.m.Gladiator.getBaseProperties().Bravery += 1;
				_event.m.Gladiator.getBaseProperties().Stamina += 1;
				_event.m.Gladiator.getBaseProperties().Initiative += 1;
				_event.m.Gladiator.getBaseProperties().MeleeSkill += 1;
				_event.m.Gladiator.getBaseProperties().RangedSkill += 1;
				_event.m.Gladiator.getBaseProperties().MeleeDefense += 1;
				_event.m.Gladiator.getBaseProperties().RangedDefense += 1;
				_event.m.Gladiator.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.Gladiator.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Punkty Zycia"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Gladiator.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinacji"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Gladiator.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Zmeczenia"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Gladiator.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Inicjatywy"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Gladiator.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Umiejetnosci Walki Wrecz"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.Gladiator.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Umiejetnosci Walki Dystansowej"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Gladiator.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Obrony w Walce Wrecz"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.Gladiator.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Obrony w Walce Dystansowej"
				});
				_event.m.Gladiator.worsenMood(0.5, "Zostal oskarzony o sztuczne wzmocnienia");

				if (_event.m.Gladiator.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Gladiator.getMoodState()],
						text = _event.m.Gladiator.getName() + this.Const.MoodStateEvent[_event.m.Gladiator.getMoodState()]
					});
				}

				_event.m.Anatomist.improveMood(0.5, "Eksperymenty na " + _event.m.Gladiator.getName() + " przebiegaja pomyslnie");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.gladiators")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local gladiator_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && !bro.getFlags().has("IsExperimentingOnGladiator"))
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.gladiator" && bro.getFlags().get("IsPlayerCharacter") && !bro.getFlags().has("IsJuiced"))
			{
				gladiator_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0 || gladiator_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Gladiator = gladiator_candidates[this.Math.rand(0, gladiator_candidates.len() - 1)];
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
			"gladiator",
			this.m.Gladiator.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Gladiator = null;
	}

});

