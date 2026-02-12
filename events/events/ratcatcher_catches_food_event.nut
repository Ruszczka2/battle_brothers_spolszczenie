this.ratcatcher_catches_food_event <- this.inherit("scripts/events/event", {
	m = {
		Ratcatcher = null
	},
	function create()
	{
		this.m.ID = "event.ratcatcher_catches_food";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img] Gdy racje spadły do zera, %ratcatcher% słabo wchodzi do twojego namiotu, a za zasłoną słychać jęki głodnych ludzi, nim klapy zamkną się za nim. Wyjaśnia, że ma rozwiązanie problemu z jedzeniem. Boisz się spytać, co to takiego, ale nie masz już wielkiego wyboru. Szczurołap zrzuca na stół jutowy worek. Coś w środku się porusza, szura, podskakuje i piszczy. Mężczyzna uderza w to pięścią, po czym uśmiecha się do ciebie.%SPEECH_ON%Przepraszam, żywy się trafił!%SPEECH_OFF%Wyjaśnia, że szczur nie jest najżywniejszym ani najzdrowszym zwierzęciem, ale pomoże kompanii przetrwać, aż wrócicie do miasta lub farmy. Z niechęcią zgadzasz się, by uchronić ludzi przed głodem.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie mamy wyboru...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
				local food = this.new("scripts/items/supplies/strange_meat_item");
				food.setAmount(12);
				this.World.Assets.getStash().add(food);
				this.List = [
					{
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + food.getAmount() + "[/color] mięsa szczura"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Ratcatcher.getID())
					{
						continue;
					}

					if (bro.getBackground().isNoble())
					{
						bro.worsenMood(1.0, "Stracił zaufanie do twojego dowodzenia");
						bro.worsenMood(2.0, "Dostał szczura na obiad");
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
					else
					{
						local r = this.Math.rand(1, 5);

						if (r == 1 && !bro.getBackground().isLowborn())
						{
							bro.worsenMood(1.0, "Dostał szczura na obiad");

							if (bro.getMoodState() < this.Const.MoodState.Neutral)
							{
								this.List.push({
									id = 10,
									icon = this.Const.MoodStateIcon[bro.getMoodState()],
									text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
								});
							}
						}
						else if (r == 2 && !bro.getSkills().hasSkill("injury.sickness"))
						{
							local effect = this.new("scripts/skills/injury/sickness_injury");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + " jest chory"
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getFood() > 15)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.ratcatcher")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Ratcatcher = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Ratcatcher = null;
	}

});

