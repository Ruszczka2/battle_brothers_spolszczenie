this.greenskins_caravan_ambush_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_caravan_ambush";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Wspinasz się na niewielkie wzgórze i widzisz karawanę ludzi na drodze. Turlają się ścieżką, a garnki i patelnie brzęczą o burty wozów, dzieci machają nogami zwieszonymi z krawędzi, kobiety na przedzie poganiają zwierzęta pociągowe ostrymi batami. Mężczyźni maszerują razem, patrząc na mapę i kłócąc się o nią, gestykulując w różne strony, by pokazać różnice w opiniach geograficznych. A potem, nieco dalej na drodze, poza wzrokiem podróżnych, leży w trawie kilku goblinów. %randombrother% też ich widzi i komentuje.%SPEECH_ON%Lepiej zejdźmy tam teraz, panie, zanim dojdzie do rzezi.%SPEECH_OFF%%randombrother2% wzrusza ramionami.%SPEECH_ON%Albo... pozwólmy goblinom zrobić swój ruch, a potem wpadniemy i posprzątamy bałagan. Łatwiej z nimi walczyć, gdy są poplątani, nie?%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Atakujemy teraz!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Czekamy, aż gobliny zaatakują pierwsze, potem uderzamy!",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Nie musimy się w to mieszać. Ruszać!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_48.png[/img]{Nie poświęcisz tych niewinnych ludzi dla taktycznej przewagi! Rozkazujesz ludziom atakować natychmiast. Gobliny od razu słyszą, że nadchodzicie, i odwracają się. W oddali chłopi rozbiegają się, widząc niebezpieczeństwo. Wygląda na to, że ich uratowałeś, ale teraz będziesz musiał stawić czoło całym goblinom!}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.GoblinRaiders, this.Math.rand(90, 110) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.Enemy);
						_event.registerToShowAfterCombat("AftermathB", null);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "AftermathB",
			Text = "[img]gfx/ui/events/event_83.png[/img]{Gdy z goblinami już po wszystkim, chłopi powoli zawracają wozy. Patrzą na scenę z wielkim podziwem. Jeden ściska ci dłoń.%SPEECH_ON%Na wszystkich dawnych bogów, każdy, kogo spotkamy, usłyszy imię %companyname%!%SPEECH_OFF%Kilku innych daje wam jedzenie, całusy i mnóstwo podziękowań.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "To nic takiego, naprawdę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Kompania zyskała renomę"
				});
				this.World.Assets.addMoralReputation(3);
				local food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Rozkazujesz ludziom czekać na właściwy moment.\n\n Gdy chłopi idą dalej drogą, gobliny zasadzają się na nich salwą zatrutych strzał. Kłócący się mężczyźni padają, strzały tkwią w piersiach, mięśnie sztywnieją, twarze napinają się, gdy trucizna krąży po ciele. Kilku innych mężczyzn wyrywa lejce swoim żonom i wyprowadza wozy. Niektórzy stają na straży, gromada chłopów z widłami jako tylna straż, ale nie wytrzymują długo wobec niehonorowych goblinów. Widząc, że gobliny są rozproszone w ataku, rozkazujesz %companyname% rozpocząć własną zasadzkę.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Do broni!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.Entities = [];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.GoblinRaiders, this.Math.rand(90, 110) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.Enemy);
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Peasants, this.Math.rand(40, 50) * _event.getReputationToDifficultyLightMult(), this.Const.Faction.PlayerAnimals);
						_event.registerToShowAfterCombat("AftermathC", null);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "AftermathC",
			Text = "[img]gfx/ui/events/event_83.png[/img]{Rozproszone resztki wędrujących chłopów powoli wyłaniają się ze zniszczonego pola bitwy. Stary mężczyzna ściska ci dłoń.%SPEECH_ON%Dziękuję, panie, gdybyś na nas nie trafił, wszyscy byśmy zostali zielonym mięsem!%SPEECH_OFF%Zanim zdąży puścić twoją dłoń, doskakuje inny, młodszy mężczyzna, wskazując palcem.%SPEECH_ON%A niech to, staruchu, widziałem, jak ten drań stał na wzgórzu i patrzył przez cały czas! Zostawił nas jako przynętę!%SPEECH_OFF%Stary odrywa dłoń.%SPEECH_ON%No proszę. Obyś zaznał wszystkich piekieł, najemniku!%SPEECH_OFF%Jakby cię to obchodziło. Mówisz starcowi, że wszystko, co znajdziecie, jest wasze. Jeśli chcą protestować, mogą sobie wsadzić usta na koniec ostrza, jeśli cię to obchodzi.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Spadajcie, chłopi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
				this.World.Assets.addMoralReputation(-2);
				local food = this.new("scripts/items/supplies/bread_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Zyskujesz " + food.getName()
				});
				local item = this.new("scripts/items/weapons/pitchfork");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_75.png[/img]{Tak czy inaczej, to nie twój problem. Cicho opuszczasz miejsce zdarzenia, choć kilku braci jest dość zaniepokojonych, że zostawiłeś tych biednych chłopów na tak straszny los, zwłaszcza gdy całe królestwo próbuje przetrwać te zielone bestie.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Pogódźcie się z tym.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.worsenMood(1.0, "Rozczarowany, że uniknąłeś walki i pozwoliłeś chłopom zginąć");

						if (bro.getMoodState() <= this.Const.MoodState.Neutral)
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
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 6)
			{
				return;
			}
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

