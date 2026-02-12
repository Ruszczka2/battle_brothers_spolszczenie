this.monk_vs_monk_event <- this.inherit("scripts/events/event", {
	m = {
		Monk1 = null,
		Monk2 = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.monk_vs_monk";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img] Ach, przy ognisku wrze rozmowa i gwar. Ludzie popijają piwo i jedzą, gdy nagle krzyki dwóch mężczyzn uciszają resztę nie dlatego, że krzyczą głośniej, ale dlatego, że to u nich nietypowe: mnisi %monk1% i %monk2% tkwią po uszy w teologicznym sporze.\n\nNie masz wykształcenia, by zrozumieć zawiłości ich argumentów, ale wiesz jedno: wchodzenie komuś w twarz i wściekłe wskazywanie palcem na niego lub na świętą księgę to proszenie się o kłopoty.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To mnie nie dotyczy.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Kompania najemników to nie miejsce na dysputy o religii!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk1.getImagePath());
				this.Characters.push(_event.m.Monk2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img] Przez chwilę chcesz przerwać spór, zanim przerodzi się w bójkę, ale potem przypominasz sobie, że to nie pierwszy raz, gdy widzisz dwóch świętych mężów w gorącej wymianie zdań. Oni po prostu tak mają. Postanawiasz więc pozwolić im to rozstrzygnąć. Z czasem ich głosy cichną, a twarze pochylają się nad księgą. Cicho ją przeglądają, stukając się głowami, gdy wodzą wzrokiem po stronach. W końcu %monk1% podnosi się i wskazuje na zdanie.%SPEECH_ON%Tutaj! Właśnie tutaj! \"Człowiek z błota\", nie \"człowiek z krwi\". Człowiek nie może być z krwi, bo sam jest krwią! Człowiek nie może być z siebie, rozumiesz? To teraz ma sens?%SPEECH_OFF%%monk2% drapie się po brodzie i kiwa głową, ale zaraz zastanawia się głośno.%SPEECH_ON%A co jeśli...%SPEECH_OFF%Zanim zdąży dokończyć myśl, %monk1% trzaska księgą i wyrzuca ręce w górę.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Świątobliwi mężowie zażegnali kolejny kryzys.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk1.getImagePath());
				this.Characters.push(_event.m.Monk2.getImagePath());
				_event.m.Monk1.improveMood(1.0, "Odbył pobudzającą dysputę o sprawach wiary");

				if (_event.m.Monk1.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk1.getMoodState()],
						text = _event.m.Monk1.getName() + this.Const.MoodStateEvent[_event.m.Monk1.getMoodState()]
					});
				}

				_event.m.Monk2.improveMood(1, "Odbył pobudzającą dysputę o sprawach wiary");

				if (_event.m.Monk2.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk2.getMoodState()],
						text = _event.m.Monk2.getName() + this.Const.MoodStateEvent[_event.m.Monk2.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]To nie pierwszy raz, gdy widzisz dwóch mnichów kłócących się. Ostatnim razem debatujący szybko się dogadali, więc naturalnie myślisz, że i tym razem będzie tak samo. Niestety, tak nie jest. Ich głosy stają się coraz głośniejsze. Nie wiedziałeś, że mnisi potrafią mieć tak cięty język. Zaciętość i nieprzyzwoitość nie oddają nawet części obelg, które przerzucają. Kilka sekund później leżą już na ziemi, szarpiąc się i okładając pięściami, aż każesz %otherguy% to przerwać.\n\nWygląda na to, że kompania najemników i ich krwawa robota odcisnęły piętno na niegdyś spokojnym usposobieniu obu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To pewnie nazywają kryzysem wiary.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk1.getImagePath());
				this.Characters.push(_event.m.Monk2.getImagePath());
				_event.m.Monk1.getBaseProperties().Bravery += 1;
				_event.m.Monk1.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk1.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinacji"
				});
				_event.m.Monk2.getBaseProperties().Bravery += 1;
				_event.m.Monk2.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk2.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinacji"
				});
				_event.m.Monk1.worsenMood(1.0, "Stracił panowanie i uciekł się do przemocy");

				if (_event.m.Monk1.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk1.getMoodState()],
						text = _event.m.Monk1.getName() + this.Const.MoodStateEvent[_event.m.Monk1.getMoodState()]
					});
				}

				_event.m.Monk2.worsenMood(1.0, "Stracił panowanie i uciekł się do przemocy");

				if (_event.m.Monk2.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk2.getMoodState()],
						text = _event.m.Monk2.getName() + this.Const.MoodStateEvent[_event.m.Monk2.getMoodState()]
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Monk1.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Monk1.getName() + " doznaje lekkich ran"
					});
				}
				else
				{
					local injury = _event.m.Monk1.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Monk1.getName() + " doznaje " + injury.getNameOnly()
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Monk2.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Monk2.getName() + " doznaje lekkich ran"
					});
				}
				else
				{
					local injury = _event.m.Monk2.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Monk2.getName() + " doznaje " + injury.getNameOnly()
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local monk_candidates = [];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() < 3)
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.monk")
			{
				monk_candidates.push(bro);
			}
			else
			{
				other_candidates.push(bro);
			}
		}

		if (monk_candidates.len() < 2)
		{
			return;
		}

		if (other_candidates.len() == 0)
		{
			return;
		}

		this.m.Monk1 = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
		this.m.Monk2 = null;
		this.m.OtherGuy = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];

		do
		{
			this.m.Monk2 = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
		}
		while (this.m.Monk2 == null || this.m.Monk2.getID() == this.m.Monk1.getID());

		this.m.Score = monk_candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk1",
			this.m.Monk1.getNameOnly()
		]);
		_vars.push([
			"monk2",
			this.m.Monk2.getNameOnly()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Monk1 = null;
		this.m.Monk2 = null;
		this.m.OtherGuy = null;
	}

});

