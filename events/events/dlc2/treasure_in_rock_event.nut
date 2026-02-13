this.treasure_in_rock_event <- this.inherit("scripts/events/event", {
	m = {
		Miner = null,
		Tiny = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.treasure_in_rock";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_66.png[/img]%randombrother% prowadzi cię do szczeliny w boku wapiennej skarpy. W mroku widać coś błyszczącego. Czymkolwiek to jest, twarda ziemia będzie trudna do przekopania. Najemnik kiwa głową.%SPEECH_ON%Wiem, że to tkwi tam solidnie, ale uważam, że warto to wydobyć. Co o tym myślisz?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Kopać!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "DigGood";
						}
						else
						{
							return "DigBad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Miner != null)
				{
					this.Options.push({
						Text = "Przyda się tu wiedza górnika.",
						function getResult( _event )
						{
							return "Miner";
						}

					});
				}

				if (_event.m.Tiny != null)
				{
					this.Options.push({
						Text = "Kto z was jest dość drobny, by się tam zmieścić?",
						function getResult( _event )
						{
							return "Tiny";
						}

					});
				}

				this.Options.push({
					Text = "To nie nasz cel. Szykować się do dalszej drogi.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Miner",
			Text = "[img]gfx/ui/events/event_66.png[/img]%miner% kiwa głową na twoją prośbę. Zbiera narzędzia i przez kilka minut bada skarpę. Pluje na skałę, kiwa głową i bierze się do pracy. Po kilku minutach ten kamieniarz już wyłapuje słabe punkty i kruszy twardą ziemię na pył. Ukryty skarb się odsłania, a mężczyzna wyciąga go i podaje.%SPEECH_ON%Dobra robota, kapitanie, i powiedziałbym, że była warta czasu. Doceniam, że na mnie liczysz, mówię szczerze.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Miner.getImagePath());
				local item = this.new("scripts/items/trade/uncut_gems_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/trade/uncut_gems_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				_event.m.Miner.improveMood(2.0, "Wykorzystał swoje górnicze doświadczenie dla dobra kompanii");

				if (_event.m.Miner.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Miner.getMoodState()],
						text = _event.m.Miner.getName() + this.Const.MoodStateEvent[_event.m.Miner.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Tiny",
			Text = "[img]gfx/ui/events/event_66.png[/img]Zawsze drobny %tiny% podchodzi do szczeliny w skarpie i wpatruje się w nią. Obraca się jak bąk.%SPEECH_ON%Nie żebym coś sugerował, ale mam wrażenie, że mnie tu lekceważycie.%SPEECH_OFF%Zapewniasz go, że nie masz na myśli nic złego, prosząc, by wykorzystał swój komiczny rozmiar. Kiwa głową i zabiera się do pracy, jakby był do tego stworzony, z łatwością przeciska się w szczelinę, aż z ziemi wystają tylko buty. Jeden z najemników zerka i cicho pyta, czy to dziwne, że ma ochotę połaskotać go po stopach. Pytasz, co to u diabła ma znaczyć, nie zamierzając uzyskać odpowiedzi. Na szczęście %tiny% krzyczy, że ma przedmiot, a ludzie pomagają wyciągnąć go z powrotem. %tiny% przewraca się, trzymając skarb wysoko w swoich małych dłoniach.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Tiny.getImagePath());
				local item = this.new("scripts/items/armor/ancient/ancient_breastplate");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/weapons/ancient/ancient_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				_event.m.Tiny.improveMood(2.0, "Wykorzystał swój wyjątkowy wzrost dla dobra kompanii");

				if (_event.m.Tiny.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Tiny.getMoodState()],
						text = _event.m.Tiny.getName() + this.Const.MoodStateEvent[_event.m.Tiny.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "DigGood",
			Text = "[img]gfx/ui/events/event_66.png[/img]Rozkazujesz najemnikom użyć dowolnych narzędzi, by przekopać skarpę. Przebicie się przez twardą ziemię zajmuje sporo czasu, ale w końcu %randombrother% luzuje ją na tyle, by sięgnąć do środka i wyciągnąć ukryty skarb. To złoty kielich i garść innych przedmiotów, które można sprzedać na rynku.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Szczęście dziś nam sprzyja.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local amount = this.Math.rand(5, 15);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Narzędzi i Zaopatrzenia."
				});
				local item = this.new("scripts/items/loot/golden_chalice_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "DigBad",
			Text = "[img]gfx/ui/events/event_66.png[/img]Rozkazujesz kilku najemnikom zabrać się za skarpę z użyciem narzędzi odpowiednich do zadania. Robią, co mogą, ale ledwo zaczęli kopać, gdy fragment twardej ziemi osuwa się i uderza %hurtbro%a, powalając go nieprzytomnego. Po nim wypada pożądany skarb, lecz okazuje się nim zardzewiały i zniszczony kawałek metalu, prawie bezużyteczny dla kogokolwiek.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do diabła.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local amount = this.Math.rand(5, 10);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Narzędzi i Zaopatrzenia."
				});
				local injury = _event.m.Other.addInjury(this.Const.Injury.Accident3);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Other.getName() + " doznaje " + injury.getNameOnly()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Steppe && currentTile.TacticalType != this.Const.World.TerrainTacticalType.SteppeHills)
		{
			return;
		}

		if (this.World.Assets.getArmorParts() < 20)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_miner = [];
		local candidates_tiny = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.miner")
			{
				candidates_miner.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.tiny"))
			{
				candidates_tiny.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.lucky") && !bro.getSkills().hasSkill("trait.swift"))
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_miner.len() != 0)
		{
			this.m.Miner = candidates_miner[this.Math.rand(0, candidates_miner.len() - 1)];
		}

		if (candidates_tiny.len() != 0)
		{
			this.m.Tiny = candidates_tiny[this.Math.rand(0, candidates_tiny.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"miner",
			this.m.Miner != null ? this.m.Miner.getNameOnly() : ""
		]);
		_vars.push([
			"tiny",
			this.m.Tiny != null ? this.m.Tiny.getNameOnly() : ""
		]);
		_vars.push([
			"hurtbro",
			this.m.Other.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Miner = null;
		this.m.Tiny = null;
		this.m.Other = null;
	}

});

