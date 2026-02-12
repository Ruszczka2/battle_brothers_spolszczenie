this.more_action_event <- this.inherit("scripts/events/event", {
	m = {
		Bro1 = null,
		Bro2 = null
	},
	function create()
	{
		this.m.ID = "event.more_action";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]Siedzisz w namiocie, ciesząc się ciszą i spokojem, które, niczym rosnąca miara, zdają się narastać tak, że każdy dzień jest przyjemniejszy od poprzedniego. Nagle wchodzą %combatbro1% i %combatbro2%. Domagają się rozmowy. Zgadzasz się, przesuwasz dłonie po stole i zapraszasz ich, by usiedli. Siadają i szybko oświadczają, że minęło już dużo czasu od ich ostatniej walki. Zaskoczony, dosłownie opierasz się na krześle.%SPEECH_ON%Czy to nie dobra rzecz?%SPEECH_OFF%%combatbro1% kręci głową i wykonuje zdecydowany gest dłonią.%SPEECH_ON%Nie. Zatrudniono nas do walki i tego chcemy. Chcemy bitew, chcemy rzezi i chcemy chwały, która idzie z jednym i drugim.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wkrótce zobaczymy bitwę - masz moje słowo!",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "I tak dostajecie żołd - a teraz możecie żyć i wydawać korony.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());
				this.Characters.push(_event.m.Bro2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]Kiwasz głową.%SPEECH_ON%Rozumiem. Jesteście dwoma żądnymi bitwy ludźmi. Przypominacie mi nawet mnie samego, choć przy waszych umiejętnościach zapewniam, że tylko ja wypadam lepiej w takim porównaniu. Jesteście świetnymi wojownikami, ale czy to nie prawda, że dostaniecie taki sam żołd niezależnie od tej czy innej bitwy? Czemu tak się martwicie o walki? One nadejdą. Nie płacę wam za siedzenie. Płacę wam za gotowość do walki.%SPEECH_OFF%Mężczyźni wymieniają spojrzenia, po czym wzruszają ramionami i kiwają głowami. Wstają jednocześnie.%SPEECH_ON%Masz rację, panie. A gdy nadejdzie czas, będziemy gotowi stanąć i walczyć dla ciebie!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, że ludzie aż rwą się do bitki.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());
				this.Characters.push(_event.m.Bro2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]Próbujesz wyjaśnić ludziom, że niezależnie od tego, czy walczą, czy nie, dostaną zapłatę. Ale pieniądze nie są ich głównym zmartwieniem. Naprawdę chcą walczyć, a twoje słowa mają niewielki wpływ na ich zbyt gorliwe nastawienie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ale...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());
				this.Characters.push(_event.m.Bro2.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isCombatBackground() && this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(1.0, "Stracił zaufanie do twojego dowodzenia");

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
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]Wstajesz i spłaszczasz knykcie na stole.%SPEECH_ON%Chcecie walczyć?%SPEECH_OFF%Mężczyźni wymieniają spojrzenia i szybko kiwają głowami.%SPEECH_ON%Zatem walkę dostaniecie! Nie lękajcie się pochowanego miecza, najemnicy. W swoim czasie znajdę wam dobrą bitwę!%SPEECH_OFF%Wstając, mężczyźni ściskają ci dłoń. Dziękują, wychodząc z namiotu. Gdy już ich nie ma, wracasz do map i szukasz najbliższego tyłka do skopania.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, że ludzie aż rwą się do bitki.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());
				this.Characters.push(_event.m.Bro2.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isCombatBackground() && this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Obiecano mu rychłą bitwę");

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
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.trader")
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() < this.World.getTime().SecondsPerDay * 10)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().isCombatBackground() && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Bro1 = candidates[0];
		this.m.Bro2 = candidates[1];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"combatbro1",
			this.m.Bro1.getName()
		]);
		_vars.push([
			"combatbro2",
			this.m.Bro2.getName()
		]);
	}

	function onClear()
	{
		this.m.Bro1 = null;
		this.m.Bro2 = null;
	}

});

