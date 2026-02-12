this.broken_cart_event <- this.inherit("scripts/events/event", {
	m = {
		Injured = null
	},
	function create()
	{
		this.m.ID = "event.broken_cart";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_55.png[/img]Maszerując drogą, znajdujesz mężczyznę z uszkodzonym wozem przy skraju traktu. Przy wozie stoi osioł, bezczynny i tak przygnębiony, jak tylko osioł potrafi wyglądać. Kupiec wygląda nieco lepiej, ale twój widok najwyraźniej go przestraszył. Odskakuje i cofa się na chwilę.%SPEECH_ON%Przyszliście zabrać moje rzeczy? Jeśli tak, nie musicie mnie zabijać. Weźcie, co chcecie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ludzie, bierzcie z wozu wszystko, co się przyda!",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Pomóżmy ci znów postawić wóz na drodze.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "C";
					}

				},
				{
					Text = "Nie mamy na to czasu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_55.png[/img]Uspokajasz mężczyznę i rozkazujesz kilku najlepszym z %companyname%, by znów postawili wóz na drodze. Robią to szybko, a kupiec wygląda na pod wrażeniem ich sprawności. Gdy jego towary znów są w drodze, oferuje kilka oznak wdzięczności prosto z wozu. Te zapasy przydadzą się w nadchodzących dniach.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Żegnaj.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveStuff(1);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_55.png[/img]Kupiec boi się twojej obecności, ale szybko odbierasz mu strach. Kilku braci zostaje wysłanych, by przestawić wóz na trakt. Robią to tak szybko, jak tylko potrafią zahartowani ludzie, ale gdy kończą, jeden z nich krzyczy i zgina się wpół.\n\nKupiec, z oczami szeroko otwartymi z nowego przerażenia, szybko oferuje ci kilka zapasów jako wyraz wdzięczności. Może myśli, że go ukarzesz za obrażenia? Tak czy inaczej, zapasy przydadzą się w nadchodzących dniach.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mam nadzieję, że było warto.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Injured.getImagePath());
				local injury = _event.m.Injured.addInjury(this.Const.Injury.Helping);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Injured.getName() + " doznaje " + injury.getNameOnly()
					}
				];
				this.List.extend(_event.giveStuff(1));
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_55.png[/img]Rozkazujesz ludziom przeszukać wóz i zabrać, co się da. %randombrother% dobywa miecza i wygląda, jakby miał zabić osła, a zwierzę głupawo wpatruje się w swoją śmiertelność w odbiciu ostrza. Kupiec krzyczy, a ty wyciągasz rękę, wstrzymując egzekucję.%SPEECH_ON%Zostawcie zwierzę pociągowe tam, gdzie stoi.%SPEECH_OFF%Kupiec składa skąpe podziękowania, gdy szeregi twoich ludzi idą za nim z jego własnymi dobrami w rękach.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zabierzcie wszystko, ruszamy dalej.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveStuff(3);
			}

		});
	}

	function giveStuff( _mult )
	{
		local result = [];
		local gaveSomething = false;

		if (this.Math.rand(1, 100) <= 50)
		{
			gaveSomething = true;
			local food = this.new("scripts/items/supplies/bread_item");
			this.World.Assets.getStash().add(food);
			result.push({
				id = 10,
				icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
			});
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			gaveSomething = true;
			local amount = this.Math.rand(1, 10) * _mult;
			this.World.Assets.addArmorParts(amount);
			result.push({
				id = 10,
				icon = "ui/icons/asset_supplies.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] narzędzia i zapasy."
			});
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			gaveSomething = true;
			local amount = this.Math.rand(1, 5) * _mult;
			this.World.Assets.addMedicine(amount);
			result.push({
				id = 10,
				icon = "ui/icons/asset_medicine.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] zapasy medyczne."
			});
		}

		if (!gaveSomething)
		{
			local food = this.new("scripts/items/supplies/bread_item");
			this.World.Assets.getStash().add(food);
			result.push({
				id = 10,
				icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
			});
		}

		return result;
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( b in brothers )
		{
			if (!b.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(b);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Injured = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 9;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Injured = null;
	}

});

