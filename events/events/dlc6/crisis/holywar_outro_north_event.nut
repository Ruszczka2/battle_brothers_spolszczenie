this.holywar_outro_north_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_outro_north";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_84.png[/img]{Wiara w starych bogów została nagrodzona: święta wojna dobiegła końca, a północniacy stoją zwycięsko. Pieśni wypełniają powietrze, a tłumy poruszają się jak jedna masa, pięści w górze, sztandary powiewają, na chwilę zjednoczone wspólnym poczuciem pobożności. Stoisz z boku, a twoje ramiona już oplecione są ozdobami, koralikami, naszyjnikami, rzeczami bez materialnej wartości, które jednak niosą ciężar odczuwalny tylko wtedy, gdy spojrzy się w oczy tych, którzy je wręczają.\n\n Oczywiście pewne godności umykają w świętowaniu: ciała pokonanych wystawia się na pokaz, szarpie w sposób mający zadowolić stare bogi, które patrzą, a święte totemy Gildera są wyśmiewane, profanowane i ostatecznie palone. I z pewnością żadna radosna dusza nie uzna cię za siłę w tym pogodnym zwieńczeniu. Po prostu ponownie zniknąłeś w tle, najemniku, koronniczku, przybyszu. Ale %companyname% zarobiła małą fortunę na religijnych przedsięwzięciach. Mimo uśmiechów i śmiechu wiesz, że taki konflikt jest pogrzebany w umyśle, nie w ziemi, i pewnego dnia ktoś lub coś go wskrzesi, a wtedy kompania będzie czekać na kolejną chwalebną wypłatę. A może to dobry moment, by odłożyć miecz i cieszyć się koronami?\n\n%OOC%Wygrałeś! Battle Brothers zaprojektowano z myślą o powtarzalności i kampaniach, które gra się do momentu pokonania jednego lub dwóch kryzysów późnej gry. Rozpoczęcie nowej kampanii pozwoli ci spróbować innych rzeczy w innym świecie.\n\nMożesz też kontynuować kampanię tak długo, jak chcesz. Pamiętaj jednak, że kampanie nie są zaprojektowane tak, by trwać wiecznie, i w końcu prawdopodobnie zabraknie wyzwań.%OOC_OFF%}",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "%companyname% potrzebuje swojego dowódcy!",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Czas zakończyć życie najemnika. (Zakończ kampanię)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Combat.abortAll();
				this.World.FactionManager.makeEveryoneFriendlyToPlayer();
				this.World.FactionManager.createAlliances();
				this.updateAchievement("CulturalMisunderstanding", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.HolyWar;
					this.setPersistentStat("CrisesDefeatedOnIronman", defeated);

					if (defeated == this.Const.World.GreaterEvilTypeBit.All)
					{
						this.updateAchievement("Savior", 1, 1);
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_84.png[/img]{Wypowiedzieć ich imię to wydobyć słowa z języka ku wieczności: stare bogi. Są poza czasem, a ich wielka liczba budzi podziw bardziej niż konkret. Choć brzmi to ujmująco dla każdego słuchacza, wierzącego czy nie, nadaje też większą wagę każdej porażce tych, którzy podążają za tymi nieoznaczonymi bytami. Krucjaty dobiegły końca, a północniacy przegrali.\n\n Patrzysz, jak północniacy próbują wyjaśnić sobie, jak do tego doszło. To nie była tu klęska ziemska, ani nawet zwycięstwo południowców - nie, to była kara. Północniacy odeszli zbyt daleko od świętych ziem, rozgościli się w świecie materialnym, a klasztory i kościoły od dawna stoją puste i wydrążone. Oczywiście pojawiają się pytania o naturę południowego \"Gildera\", ale szybko cichną. Samo roztrząsanie Go to zapraszanie wątpliwości, a teraz wątpliwość jest tak niebezpieczna jak trucizna. Oczywiście %companyname% trzyma się z boku. Jako najemnicy pokładacie wiarę w mieczu i sakiewce, i oba zostały w tej wojnie wynagrodzone. Jedyne filozofowanie, jakie cię czeka w najbliższych dniach, to zastanawianie się, jak szybko północ i południe znów zaczną wyliczać swoje różnice. A może to dobry moment, by odłożyć miecz i cieszyć się koronami?\n\n%OOC%Wygrałeś! Battle Brothers zaprojektowano z myślą o powtarzalności i kampaniach, które gra się do momentu pokonania jednego lub dwóch kryzysów późnej gry. Rozpoczęcie nowej kampanii pozwoli ci spróbować innych rzeczy w innym świecie.\n\nMożesz też kontynuować kampanię tak długo, jak chcesz. Pamiętaj jednak, że kampanie nie są zaprojektowane tak, by trwać wiecznie, i w końcu prawdopodobnie zabraknie wyzwań.%OOC_OFF%}",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "%companyname% potrzebuje swojego dowódcy!",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Czas zakończyć życie najemnika. (Zakończ kampanię)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Combat.abortAll();
				this.World.FactionManager.makeEveryoneFriendlyToPlayer();
				this.World.FactionManager.createAlliances();
				this.updateAchievement("CulturalMisunderstanding", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.HolyWar;
					this.setPersistentStat("CrisesDefeatedOnIronman", defeated);

					if (defeated == this.Const.World.GreaterEvilTypeBit.All)
					{
						this.updateAchievement("Savior", 1, 1);
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.18)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Contracts.getActiveContract() != null)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_holywar_end"))
		{
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_holywar_end");
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		local north = 0;
		local south = 0;
		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0)
				{
					if (this.World.FactionManager.getFaction(v.getFaction()).getType() == this.Const.FactionType.NobleHouse)
					{
						north = ++north;
					}
					else
					{
						south = ++south;
					}
				}
			}
		}

		if (north >= south)
		{
			return "A";
		}
		else
		{
			return "B";
		}
	}

	function onClear()
	{
	}

});

