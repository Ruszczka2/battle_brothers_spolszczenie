this.lend_men_to_build_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.lend_men_to_build";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]Gdy zbliżasz się do %townname%, miejscowy mężczyzna macha do ciebie. Stoi obok szkieletu czegoś, co wygląda na młyn. Rozdrażniony wyjaśnia, że jego robotnicy dziś nie przyszli, a on musi dokończyć młyn, zanim przybędzie miejscowy baron. Jeśli go nie skończy, baron może nigdy nie dać mu kolejnego zlecenia. W kompanii masz kilku byłych robotników. Może mogą mu pomóc?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wy budujecie, my zabijamy. Szukaj kogoś innego.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Dobrze, mogę oddelegować jednego czy dwóch.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_79.png[/img]Zgadzasz się oddelegować kilku najlepszych z %companyname% do pracy. Wracają do dawnych ról jak w rękawiczce, szybko krzątają się po materiały, stukają młotkami, murowaniem, montażem drzwi? Cokolwiek trzeba, by wstawić drzwi, robią to sprawnie. Gdy wszystko jest gotowe, miejscowy mężczyzna podchodzi do ciebie z uśmiechem od ucha do ucha. Podaje sakiewkę.%SPEECH_ON%Zasłużyłeś na to, dobry panie! A co więcej, zyskałeś moje słowo - będę szerzył twoją hojność, kiedy tylko będę mógł!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie przyzwyczajajcie się do takiej roboty, ludzie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationFavor, "Oddelegowałeś ludzi do budowy młyna");
				this.World.Assets.addMoney(150);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]150[/color] koron"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local id = bro.getBackground().getID();

					if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
					{
						if (this.Math.rand(1, 100) <= 33)
						{
							local effect = this.new("scripts/skills/effects_world/exhausted_effect");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + " jest wyczerpany"
							});
						}

						if (this.Math.rand(1, 100) <= 50)
						{
							bro.improveMood(0.5, "Pomógł w budowie młyna");

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
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_79.png[/img]Zgadzasz się pomóc mężczyźnie. Niestety wygląda na to, że nie zaplanował tego zbyt dobrze. Dach zawala się w chwili, gdy jeden z twoich \"robotników\" stawia na nim stopę, posyłając go przez zapadlisko gontów. Inny mężczyzna wbija gwóźdź, a drewniana belka pęka na pół, uderzając go w twarz drzazgami. Luźne cegły spadają, mokre błoto sprawia, że ludzie się ślizgają, a wszelkie możliwe zagrożenia kończą cały projekt katastrofą.\n\n Miejscowy człowiek przeprasza bez końca, gryząc paznokcie i zastanawiając się, jak poradzi sobie z baronem. Pstryka palcami i stwierdza, że po prostu zapłaci baronowi koronami.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Te korony należą do nas!",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "W takim razie powodzenia z baronem.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_79.png[/img]Gdy umysł mężczyzny odpływa ku zadowalającemu rozwiązaniu problemu, pstrykasz palcami, by sprowadzić go z powrotem do brutalnej rzeczywistości.%SPEECH_ON%Te korony należą do nas, chłopie. Taki był układ.%SPEECH_OFF%Jego policzki trzęsą się, gdy kręci głową.%SPEECH_ON%Ale młyn... nawet nie jest skończony!%SPEECH_OFF%Wzruszasz ramionami.%SPEECH_ON%To nie nasz problem. Teraz oddawaj, zanim zrobisz się naszym problemem.%SPEECH_OFF%Mężczyzna przytakuje uroczyście, posłusznie podając ci sakiewkę koron.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Następnym razem więcej szczęścia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(-this.Const.World.Assets.RelationFavor, "Mocno naciskałeś ważnego obywatela, by zapłacił za pomoc przy budowie młyna");
				this.World.Assets.addMoney(200);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]200[/color] koron"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local id = bro.getBackground().getID();

					if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
					{
						if (this.Math.rand(1, 100) <= 33)
						{
							local effect = this.new("scripts/skills/effects_world/exhausted_effect");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + " jest wyczerpany"
							});
						}

						if (this.Math.rand(1, 100) <= 50)
						{
							bro.improveMood(0.5, "Pomógł w budowie młyna");

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
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_79.png[/img]Przez krótką chwilę widzisz siebie, jak przebijasz tego zezowatego mężczyznę mieczem. To naprawdę obudziłoby go na realia świata, ale zamiast tego odpuszczasz. Robotnicy, którzy brali udział w katastrofie projektu, nie są zbyt szczęśliwi. Oby i tak wynieśli z tego nauczkę.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powodzenia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationFavor, "Oddelegowałeś ludzi do budowy młyna");
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local id = bro.getBackground().getID();

					if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
					{
						if (this.Math.rand(1, 100) <= 33)
						{
							local effect = this.new("scripts/skills/effects_world/exhausted_effect");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + " jest wyczerpany"
							});
						}

						if (this.Math.rand(1, 100) <= 33)
						{
							bro.worsenMood(1.0, "Pomógł w budowie młyna bez zapłaty");

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
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getMoney() > 3000)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			local id = bro.getBackground().getID();

			if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

