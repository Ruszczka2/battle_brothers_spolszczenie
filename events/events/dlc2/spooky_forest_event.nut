this.spooky_forest_event <- this.inherit("scripts/events/event", {
	m = {
		Brave = null,
		Lumberjack = null
	},
	function create()
	{
		this.m.ID = "event.spooky_forest";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Podczas biwaku w lesie %randombrother% woła cię z namiotu dowodzenia. Pytasz, czego chce, a on przykłada palec do ust, uciszając. Wskazuje na drzewo, które wznosi się wysoko w wieczorny mrok. Słyszysz trzaski, jakby coś budowało gniazdo z całych gałęzi. Hałas ucicha tylko po to, by prychnąć i zachichotać krótkim terkotem gardłowych treli, jak ptak wołający o pomoc z brzucha węża. Gdy spoglądasz w dół, ludzie patrzą na ciebie, szukając pomysłu, co z tym zrobić.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To tylko jakieś zwierzę. Wracajcie do roboty.",
					function getResult( _event )
					{
						return "WalkOff";
					}

				},
				{
					Text = "Lepiej dmuchać na zimne. Zetniemy drzewo.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "CutdownGood";
						}
						else
						{
							return "CutdownBad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Lumberjack != null)
				{
					this.Options.push({
						Text = "%lumberjack%, wiesz najlepiej, jak ścinać drzewa. Zrób to.",
						function getResult( _event )
						{
							return "Lumberjack";
						}

					});
				}

				if (_event.m.Brave != null)
				{
					this.Options.push({
						Text = "%bravebro%, jesteś najodważniejszy z całej bandy. Idź sprawdź, o co chodzi.",
						function getResult( _event )
						{
							return "Brave";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Lumberjack",
			Text = "[img]gfx/ui/events/event_25.png[/img]Rozkazujesz %lumberjack%owi, drwalowi, powalić drzewo. Kiwa głową i zabiera się do pracy, używając całego zestawu narzędzi, nie wszystkie to topory. Rozwiera drewno w klinie z jednej strony, wciska w szczeliny styliska broni, po czym przechodzi na drugą stronę i rąbie pień. Pracuje z szybkością, którą chciałbyś widzieć na polu bitwy. To rzadko spotykana autentyczność: człowiek na swoim miejscu, oczy skupione na kształtowaniu nieuniknionej przyszłości, dłonie nie tyle przydzielone do zadania, co do niego stworzone.%SPEECH_ON%Aj-jo!%SPEECH_OFF%Krzyczy i drzewo pada. Trzaska i osuwa się ciężarem, przechyla w stronę lasu, gdzie długi pień spada przez gałęzie i uderza o ziemię tak mocno, że aż ziemia zdaje się boleć. Dobijasz miecza i idziesz obejrzeć powalony wierzchołek. Znajdujesz tam parę Nachzehrerów, zmiażdżonych na płasko, zębami rozsypanymi po leśnej ściółce jak grzyby bez kapeluszy. Strach kompanii ustępuje wobec tego makabrycznego widoku.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I zagadka rozwiązana.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Lumberjack.getImagePath());
				local item = this.new("scripts/items/misc/ghoul_teeth_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Brave",
			Text = "[img]gfx/ui/events/event_25.png[/img]%bravebro%, zawsze odważny najemnik, wspina się na drzewo z szybkością, której nie spowalnia ani strach, ani wahanie. Można by pomyśleć, że wypatrzył tam pannę, tak się spieszy. Niedługo potem znika z pola widzenia, choć skrobanie i szuranie jego hałaśliwej wspinaczki jest nie do pomylenia. W końcu słyszysz, jak wraca, a zgrzyty jego zejścia pojawiają się i zanikają, gdy znajduje bezpieczne oparcie. Widzisz, jak znowu się pojawia, a najpierw w mroku ukazują się podeszwy jego butów, jakby zwisały niczym blachy na masło. Jego ciemny zarys podąża za nimi, zsuwa się coraz niżej, aż wykonuje ostatni skok na ziemię. Celowo ugina kolana i opiera się plecami o pień, znużone dłonie bezwładnie spoczywają na kolanach.%SPEECH_ON%To był czarny niedźwiedź, łeb miał wsadzony w plaster miodu, ale bestia nie żyje od co najmniej dwóch dni. Widziałem, jak przy moim podejściu wypadła stamtąd chmara nietoperzy, chyba jadły mu wnętrzności. To wypadło, gdy uciekły.%SPEECH_OFF%Odwraca się i rzuca na ziemię miecz. Jest oblepiony lepkim miodem i sosnowymi igłami, ale poza tym wygląda na znakomite ostrze.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pokaż to ostrze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brave.getImagePath());
				local item = this.new("scripts/items/weapons/arming_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "CutdownGood",
			Text = "[img]gfx/ui/events/event_25.png[/img]Rozkazujesz kompanii ściąć drzewo. Zabierają się do pracy, choć mają w tym niewielkie doświadczenie, a kończy się to panicznym biegiem w bezpieczne miejsce, gdy pień spada w nieoczekiwanym kierunku. Z wierzchołka zrywa się mocno wystraszony czarny niedźwiedź. Ma plaster miodu na pysku i sapie, uciekając w mrok lasu.\n\n Nikt nie został przygnieciony, ale chaos i odłamki sprawiają, że kilku ludzi jest poobijanych.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No, to było warte zachodu...",
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
					if (bro.getSkills().hasSkill("trait.swift") || bro.getSkills().hasSkill("trait.sure_footed") || bro.getSkills().hasSkill("trait.lucky") || bro.getSkills().hasSkill("trait.quick"))
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 20)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " odnosi lekkie rany"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "CutdownBad",
			Text = "[img]gfx/ui/events/event_25.png[/img]Rozkazujesz ludziom ściąć drzewo. %randombrother% zaczyna z ciężkim uderzeniem. Opiera stopę o pień, by wyrwać narzędzie, i to mniej więcej ostatni raz, gdy go widzisz, bo odlatuje w bok. Gałąź wraca do pola widzenia, a z pnia dobywa się długie jęknięcie, jakby w jego wnętrzu ścinano pradawne drzewo. Patrzysz, jak drewno pęka, odrywa się od ziemi i wykorzenia. Szmaragdowe oczy rozbłyskują i rozszerzają się, a ich spojrzenie migocze wśród wirujących liści.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co do diabła!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.Entities = [];
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Schrats, this.Math.rand(90, 110), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
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
			ID = "WalkOff",
			Text = "[img]gfx/ui/events/event_25.png[/img]Nie zamierzasz zawracać sobie głowy takimi drobnostkami. To pewnie ryś albo jakiś orzeł. Jeśli jest gorzej, zejdzie na dół i kompania się z tym upora. Taki tok myślenia nie podoba się części ludzi.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To tylko jakieś zwierzę...",
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
						bro.worsenMood(0.5, "Zmartwiło go, że nie zareagowałeś na możliwe zagrożenie");

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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 15)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_lumberjack = [];
		local candidates_brave = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.lumberjack")
			{
				candidates_lumberjack.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.brave") || bro.getSkills().hasSkill("trait.fearless"))
			{
				candidates_brave.push(bro);
			}
		}

		if (candidates_lumberjack.len() != 0)
		{
			this.m.Lumberjack = candidates_lumberjack[this.Math.rand(0, candidates_lumberjack.len() - 1)];
		}

		if (candidates_brave.len() != 0)
		{
			this.m.Brave = candidates_brave[this.Math.rand(0, candidates_brave.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"lumberjack",
			this.m.Lumberjack ? this.m.Lumberjack.getNameOnly() : ""
		]);
		_vars.push([
			"bravebro",
			this.m.Brave ? this.m.Brave.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Lumberjack = null;
		this.m.Brave = null;
	}

});

