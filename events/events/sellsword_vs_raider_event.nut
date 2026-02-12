this.sellsword_vs_raider_event <- this.inherit("scripts/events/event", {
	m = {
		Sellsword = null,
		Raider = null
	},
	function create()
	{
		this.m.ID = "event.sellsword_vs_raider";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]Najeźdźca, %raider%, ostrzy broń przy ognisku. Opowiada historie o dniach grabieży wybrzeży i wynoszeniu stosów łupów, a jego krzywy uśmiech błyszczy w wypolerowanej stali. Najemnik %sellsword% słucha przez chwilę, po czym wstaje, śmiejąc się.%SPEECH_ON%Och, chłopie, ależ to historie opowiadasz. Posłuchaj mojej: na chleb zarabiałem, zabijając ludzi, czy to w ich domach, czy na polu bitwy, ale jednak ludzi. Wy latacie łódkami, czekacie, aż chłopy pójdą w pole, a potem pędzicie po plażach, by kopać malców, gwałcić dziewki i okradać starych mnichów. Nie masz się czym chwalić, najeźdźco.%SPEECH_OFF%%raider% opuszcza ostrze.%SPEECH_ON%My, wyspiarze, mamy przynajmniej honor między sobą, a ty wbiłbyś %companyname% nóż w plecy za dodatkową koronę w sakiewce. Powiedz jeszcze raz źle o mojej przeszłości, najemniku, a każę ci zębami gryźć ziemię.%SPEECH_OFF%Wymiana ciętych słów prowadzi do tego, co nieuniknione: walki. Ostrza błyskają, krew się leje. Reszta kompanii wkracza, zanim dojdzie do większej szkody.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie obchodzi mnie, skąd pochodzicie, przestańcie się bić.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sellsword.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury1 = _event.m.Sellsword.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury1.getIcon(),
						text = _event.m.Sellsword.getName() + " doznaje " + injury1.getNameOnly()
					});
				}
				else
				{
					_event.m.Sellsword.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Sellsword.getName() + " odnosi lekkie rany"
					});
				}

				_event.m.Sellsword.worsenMood(0.5, "Wdał się w bójkę z " + _event.m.Raider.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Sellsword.getMoodState()],
					text = _event.m.Sellsword.getName() + this.Const.MoodStateEvent[_event.m.Sellsword.getMoodState()]
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
						text = _event.m.Raider.getName() + " odnosi lekkie rany"
					});
				}

				_event.m.Raider.worsenMood(0.5, "Wdał się w bójkę z " + _event.m.Sellsword.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Raider.getMoodState()],
					text = _event.m.Raider.getName() + this.Const.MoodStateEvent[_event.m.Raider.getMoodState()]
				});
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

		local sellsword_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 6 && bro.getBackground().getID() == "background.sellsword")
			{
				sellsword_candidates.push(bro);
				break;
			}
		}

		if (sellsword_candidates.len() == 0)
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

		this.m.Sellsword = sellsword_candidates[this.Math.rand(0, sellsword_candidates.len() - 1)];
		this.m.Raider = raider_candidates[this.Math.rand(0, raider_candidates.len() - 1)];
		this.m.Score = (sellsword_candidates.len() + raider_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"sellsword",
			this.m.Sellsword.getName()
		]);
		_vars.push([
			"raider",
			this.m.Raider.getName()
		]);
	}

	function onClear()
	{
		this.m.Sellsword = null;
		this.m.Raider = null;
	}

});

