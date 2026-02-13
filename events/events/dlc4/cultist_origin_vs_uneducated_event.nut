this.cultist_origin_vs_uneducated_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		Uneducated = null
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_vs_uneducated";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 13.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Kilku braci przychodzi do ciebie z wyraźnym niepokojem. Mówią, że %cultist% siedzi z %uneducated% już od kilku godzin. Gdy pytasz, co ich martwi, przypominają ci, że kultysta ma zbliznowaciałe czoło i mówi o niezwykle dziwnych rzeczach. Tak. To są wymagania Davkula, przykład czyjegoś oddania. Nie rozumiesz, co mogłoby być w tym złego.\n\nIdziesz zobaczyć obu mężczyzn. %uneducated% spogląda na ciebie z uśmiechem i mówi, że kultysta naprawdę ma go wiele nauczyć. Być może. Ale wiesz, że obecność Davkula nie musi być odczuwana przez wszystkich, a gdyby chciała zostać narzucona światu, byłoby to nieporozumienie co do celu Davkula.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pokaż mu ciemność.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Davkul go nie chce.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Uneducated.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]Kiwasz głową i odchodzisz. Następnego ranka %uneducated% zostaje znaleziony ze świeżą raną na czole, krwią nawrócenia i ceną, jaką niektórzy muszą zapłacić, by poświęcić się Davkulowi. Gdy pytasz, jak się czuje, wypowiada tylko kilka słów.%SPEECH_ON%Davkul nadchodzi.%SPEECH_OFF%Kręcisz głową i poprawiasz go.%SPEECH_ON%Davkul nie nadchodzi. Davkul CZEKA na nas wszystkich.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Davkul czeka.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Uneducated.getImagePath());
				local background = this.new("scripts/skills/backgrounds/converted_cultist_background");
				_event.m.Uneducated.getSkills().removeByID(_event.m.Uneducated.getBackground().getID());
				_event.m.Uneducated.getSkills().add(background);
				background.buildDescription();
				background.onSetAppearance();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Uneducated.getName() + " został nawrócony na kultystę"
					}
				];
				_event.m.Cultist.getBaseProperties().Bravery += 2;
				_event.m.Cultist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Cultist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Determinacji"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Rozdzielasz tych dwóch, każąc %uneducated% iść policzyć zapasy. Gdy odchodzi, %cultist% prycha na ciebie.%SPEECH_ON%Davkul czeka. Widzisz go we śnie. Widzisz go w nocach. Jego ciemność nadchodzi. Żadne światło nie płonie wiecznie.%SPEECH_OFF%Mężczyzna zatrzymuje się i wpatruje w twoją duszę. A ty patrzysz z miejsca, które nie jest twoim ciałem. Widzisz tylko nieskończoną czerń wokół i kropkę światła, przez którą spogląda %cultist%. Powoli wracasz ku światłu i znowu mrugasz, patrząc na mężczyznę. On się kłania.%SPEECH_ON%Przepraszam, kapitanie, nie wiedziałem, że Davkul ma takie plany.%SPEECH_OFF%Mrugasz raz jeszcze i możesz tylko kiwnąć głową.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Davkul czeka na nas wszystkich.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Uneducated.getImagePath());
				_event.m.Cultist.worsenMood(1.0, "Odmówiono mu szansy na nawrócenie " + _event.m.Uneducated.getName());

				if (_event.m.Cultist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local cultist_candidates = [];
		local uneducated_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getFlags().get("IsSpecial") || bro.getFlags().get("IsPlayerCharacter") || bro.getBackground().getID() == "background.slave")
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				cultist_candidates.push(bro);
			}
			else if (bro.getBackground().isLowborn() && !bro.getSkills().hasSkill("trait.bright") || !bro.getBackground().isNoble() && bro.getSkills().hasSkill("trait.dumb") || bro.getSkills().hasSkill("injury.brain_damage"))
			{
				uneducated_candidates.push(bro);
			}
		}

		if (cultist_candidates.len() == 0 || uneducated_candidates.len() == 0)
		{
			return;
		}

		this.m.Cultist = cultist_candidates[this.Math.rand(0, cultist_candidates.len() - 1)];
		this.m.Uneducated = uneducated_candidates[this.Math.rand(0, uneducated_candidates.len() - 1)];
		this.m.Score = cultist_candidates.len() * 9;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist.getName()
		]);
		_vars.push([
			"uneducated",
			this.m.Uneducated.getName()
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
		this.m.Uneducated = null;
	}

});

