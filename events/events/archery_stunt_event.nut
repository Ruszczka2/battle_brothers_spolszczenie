this.archery_stunt_event <- this.inherit("scripts/events/event", {
	m = {
		Clown = null,
		Archer = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.archery_stunt";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Jakiś harmider wyciąga cię z namiotu. Ludzie siedzą na kilku pniakach albo na ziemi i z zapałem patrzą w dal. Mrużąc oczy, dostrzegasz %clown% i %archer%, którzy robią coś dziwnego. Na głowie jednego leży jabłko, a drugi oddala się z łukiem w dłoni.\n\nPytasz %otherguy%, o co chodzi, a on wyjaśnia, że dwaj mężczyźni chcą wykonać jakiś numer, polegający na strzeleniu w owoc na głowie drugiego. Zszokowany mówisz, że to wcale nie jest bezpieczne, na co brat uśmiecha się i tłumaczy, że właśnie o to chodzi.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Natychmiast przestańcie!",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "No cóż... to powinno być ciekawe.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= _event.m.Archer.getCurrentProperties().RangedSkill)
						{
							return "C";
						}
						else
						{
							return "B1";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Clown.getImagePath());
				this.Characters.push(_event.m.Archer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_10.png[/img]Rozważasz sytuację. Bracia patrzą na ciebie, spodziewając się przerwania, ale zamiast tego siadasz wśród nich. To wywołuje krótki okrzyk radości, który szybko cichnie do szeptów, gdy %clown% i %archer% szykują się.%SPEECH_ON%Tylko traf w jabłko!%SPEECH_OFF%Woła jeden z braci. Śmiech przechodzi przez grupę.%SPEECH_ON%Z tej odległości nos %clown_short% wygląda dla mnie jak jabłko.%SPEECH_OFF%Kolejne śmiechy, ale nerwowe, bo numer zaraz się zacznie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ooo!",
					function getResult( _event )
					{
						return "B2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Clown.getImagePath());
				this.Characters.push(_event.m.Archer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_10.png[/img]%archer% ustawia ramiona w stronę %clown% i naciąga łuk, a sylwetka mężczyzny staje się półksiężycem z drewna, cięciwy i ramienia. Nie widzisz twarzy %clown%, ale zakładasz, że ma zamknięte oczy. Strzał pada. Świszczy. Znika. %clown% cofa się, chwytając się za twarz. To nie wygląda dobrze. Mężczyzna krzyczy. Tłum wydaje jęk. %archer% powoli opuszcza łuk i patrzy na niego, jakby to była jego wina.\n\n W końcu %clown% jest niesiony obok ciebie, z drzewcem strzały wystającym z głowy. Inny brat zostaje z tyłu, spokojnie jedząc jabłko pośród tego chaosu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To zostawi ślad...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Clown.getImagePath());
				this.Characters.push(_event.m.Archer.getImagePath());
				local injury = _event.m.Clown.addInjury(this.Const.Injury.Archery);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Clown.getName() + " doznaje: " + injury.getNameOnly()
				});
				_event.m.Archer.worsenMood(2.0, "Ciężko zranił " + _event.m.Clown.getName() + " przez przypadek");

				if (_event.m.Archer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer.getMoodState()],
						text = _event.m.Archer.getName() + this.Const.MoodStateEvent[_event.m.Archer.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Clown.getID() || bro.getID() == _event.m.Archer.getID())
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.bright") || bro.getSkills().hasSkill("trait.fainthearted"))
					{
						bro.worsenMood(1.0, "Współczuł " + _event.m.Clown.getName());

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_10.png[/img]Ludzie wiwatują, gdy kiwasz głową na znak zgody. Siadasz wśród nich, gdy %archer% i %clown% szykują się: pierwszy zakłada strzałę, a drugi balansuje jabłkiem na głowie. Gdy owoc leży stabilnie, łucznik naciąga łuk, tworząc sylwetkę człowieka, drewna i cięciwy, półksiężyc determinacji, gdy celuje w dal. Ludzie zakładają się, czy chybi. Chciałbyś odwrócić wzrok, ale to widowisko jest zbyt wielkie.\n\n Po wypuszczeniu strzały rozlega się zbiorowe westchnienie, jakby właśnie spełniło się dawno zapowiadane złe wydarzenie. Mężczyźni cofają się na siedzeniach, krzywiąc się i zaciskając zęby. Jabłko zostaje strącone z głowy %clown%, a owoc i strzała wirują w powietrzu. Po krótkiej ciszy ludzie wybuchają oklaskami. %clown% kłania się, a %archer% luzuje naciąg i wygląda na odrobinę ulżonego.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Strzał w dziesiątkę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Clown.getImagePath());
				this.Characters.push(_event.m.Archer.getImagePath());
				_event.m.Clown.getBaseProperties().Bravery += 1;
				_event.m.Clown.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Clown.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinację"
				});
				_event.m.Archer.getBaseProperties().RangedSkill += 1;
				_event.m.Archer.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.Archer.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Umiejętności strzeleckie"
				});
				_event.m.Clown.improveMood(1.0, "Wziął udział w pokazie");

				if (_event.m.Clown.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Clown.getMoodState()],
						text = _event.m.Clown.getName() + this.Const.MoodStateEvent[_event.m.Clown.getMoodState()]
					});
				}

				_event.m.Archer.improveMood(1, "Zaprezentował swoje umiejętności łucznicze");

				if (_event.m.Archer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer.getMoodState()],
						text = _event.m.Archer.getName() + this.Const.MoodStateEvent[_event.m.Archer.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Clown.getID() || bro.getID() == _event.m.Archer.getID())
					{
						continue;
					}

					if (bro.getMoodState() >= this.Const.MoodState.Neutral && this.Math.rand(1, 100) <= 10 && !bro.getSkills().hasSkill("trait.bright"))
					{
						bro.improveMood(1.0, "Poczuł się rozbawiony");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "Kręcisz głową na \'nie\', wychodzisz na pole i stajesz między dwoma mężczyznami.%SPEECH_ON%Jeśli chcieliście robić sztuczki, trzeba było iść do cyrku. Wracajcie do pracy, zanim ktoś poważnie ucierpi.%SPEECH_OFF%Fala rozczarowania przetacza się po ludziach. Kilku nawet gwiżdże i pokazuje kciuk w dół lub inne, bardziej rubaszne gesty.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To dla ich dobra.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Clown.getImagePath());
				this.Characters.push(_event.m.Archer.getImagePath());
				_event.m.Clown.worsenMood(1.0, "Odmówiono mu prośby");

				if (_event.m.Clown.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Clown.getMoodState()],
						text = _event.m.Clown.getName() + this.Const.MoodStateEvent[_event.m.Clown.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Clown.getID())
					{
						continue;
					}

					if (bro.getMoodState() >= this.Const.MoodState.Neutral && this.Math.rand(1, 100) <= 10 && !bro.getSkills().hasSkill("trait.bright") && !bro.getSkills().hasSkill("trait.fainthearted"))
					{
						bro.worsenMood(1.0, "Nie dostał rozrywki, na którą liczył");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local clown_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.bright") || bro.getSkills().hasSkill("trait.hesitant") || bro.getSkills().hasSkill("trait.craven") || bro.getSkills().hasSkill("trait.fainthearted") || bro.getSkills().hasSkill("trait.insecure"))
			{
				continue;
			}

			if ((bro.getBackground().getID() == "background.minstrel" || bro.getBackground().getID() == "background.juggler" || bro.getBackground().getID() == "background.vagabond") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				clown_candidates.push(bro);
			}
		}

		if (clown_candidates.len() == 0)
		{
			return;
		}

		local archer_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.bright") || bro.getSkills().hasSkill("trait.hesitant") || bro.getSkills().hasSkill("trait.craven") || bro.getSkills().hasSkill("trait.fainthearted") || bro.getSkills().hasSkill("trait.insecure"))
			{
				continue;
			}

			if ((bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.bowyer") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				archer_candidates.push(bro);
			}
		}

		if (archer_candidates.len() == 0)
		{
			return;
		}

		this.m.Clown = clown_candidates[this.Math.rand(0, clown_candidates.len() - 1)];
		this.m.Archer = archer_candidates[this.Math.rand(0, archer_candidates.len() - 1)];
		this.m.Score = clown_candidates.len() * 3;

		do
		{
			this.m.OtherGuy = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
		while (this.m.OtherGuy == null || this.m.OtherGuy.getID() == this.m.Clown.getID() || this.m.OtherGuy.getID() == this.m.Archer.getID());
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"clown",
			this.m.Clown.getName()
		]);
		_vars.push([
			"clown_short",
			this.m.Clown.getNameOnly()
		]);
		_vars.push([
			"archer",
			this.m.Archer.getName()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onClear()
	{
		this.m.Clown = null;
		this.m.Archer = null;
		this.m.OtherGuy = null;
	}

});

