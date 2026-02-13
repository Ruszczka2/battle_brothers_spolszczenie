this.undead_plague_or_infected_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.undead_plague_or_infected";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]Napotykasz grupę chłopów siedzących przy skraju ścieżki. Mężczyźni, kobiety, dzieci. Brudne ubrania, zabłocone buty, owrzodzenia na skórze. Kilku ma rany przypominające ślady ugryzień. Najstarszy z grupy odzywa się.%SPEECH_ON%Proszę, panie, czy masz dla nas trochę jedzenia albo wody?%SPEECH_OFF%Zdaje się dostrzegać, że przyglądasz się krostom i śladom ugryzień. Kręci głową.%SPEECH_ON%Och, nie zwracaj na to uwagi. Proste polowanie na lisy poszło źle. Potrzebujemy tylko odrobiny pomocy i ruszymy w drogę.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Możemy odstąpić trochę jedzenia.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "To nie nasz problem.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Tylko powiększycie szeregi nieumarłych. Lepiej zakończymy to teraz.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_59.png[/img]Rozkazujesz tym schorowanym duszom ozdrowieć - rozkazując swoim ludziom, by wszystkich zabili. Starszy odprowadza kobiety i dzieci, a mężczyźni wstają, by stawić opór. Jeden z nich, chwiejący się na zielonkawych, łuszczących się nogach, wskazuje na ciebie.%SPEECH_ON%Aleś święty, ty chujku. Obym wrócił z martwych. Oby mój trup pozabijał was wszystkich, pieprzone dzikusy.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "W takim razie z przyjemnością zabiję cię dwa razy.",
					function getResult( _event )
					{
						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
						}

						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.PeasantsArmed, this.Math.rand(50, 100), this.Const.Faction.Enemy);
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_59.png[/img]Mówisz %randombrother%, by rozdał trochę jedzenia i zapasów. Starszy dziękuje i mówi, że będzie dobrze mówił o %companyname%, gdziekolwiek się uda. Kilku mężczyzn wydaje się ulżyć, że nie poprosiłeś ich o coś strasznego.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Robimy, co możemy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				local food = this.World.Assets.getFoodItems();

				for( local i = 0; i < 2; i = ++i )
				{
					local idx = this.Math.rand(0, food.len() - 1);
					local item = food[idx];
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Tracisz " + item.getName()
					});
					this.World.Assets.getStash().remove(item);
					food.remove(idx);
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_29.png[/img]Mówisz %randombrother%, by rozdał trochę jedzenia i zapasów. Starszy dziękuje i mówi, że będzie dobrze mówił o %companyname%, gdziekolwiek się uda. Biorąc kawałek chleba, kucasz obok chorowitego dziecka i ojca, który je trzyma. Gdy podajesz bochenek, dziecko unosi głowę i wbija zęby w szyję ojca. Każdy chłop na tyle zdrowy, by wstać, robi to i ucieka. Reszta... cóż, reszta dźwiga się na nogi, twarze mają blade, szczęki rozluźnione, oczy świecą czerwienią wściekłego głodu. Szybko rozkazujesz najemnikom ustawić szyk.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Żaden dobry uczynek nie pozostaje bez kary.",
					function getResult( _event )
					{
						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
						}

						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Peasants, this.Math.rand(10, 30), this.Const.Faction.PlayerAnimals);
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.ZombiesLight, this.Math.rand(60, 90), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local food = this.World.Assets.getFoodItems();

		if (food.len() < 3)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			local d = currentTile.getDistanceTo(t.getTile());

			if (d <= 4)
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

