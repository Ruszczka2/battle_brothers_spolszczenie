this.come_across_burial_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.come_across_burial";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 130.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_28.png[/img]Podczas marszu natrafiasz na tłum ludzi zgromadzonych wokół kopca ziemi. Gdy podchodzisz bliżej, uświadamiasz sobie, że to pogrzeb. Jeden z uczestników odwraca się do ciebie.%SPEECH_ON%Znałeś go? Walczyłeś u jego boku?%SPEECH_OFF%Kręcisz głową i przeciskasz się przez tłum, by zobaczyć zmarłego. Widzisz mężczyznę wyglądającego tak stary jak tylko martwy może wyglądać. Na piersi spoczywa niebywale ostry i połyskujący miecz, a jego brudne, robakowi przeznaczone palce ściskają rękojeść. %randombrother% staje obok i szepcze.%SPEECH_ON%To, eee, całkiem ładna broń, tak tylko mówię.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zróbmy z niej naszą.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 35 ? "B" : "C";
					}

				},
				{
					Text = "Zostawmy ich.",
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
			Text = "[img]gfx/ui/events/event_36.png[/img]Dobywasz miecza, a reszta kompanii robi to samo. Najemnicy odpychają tłum, ale opór jest mniejszy, niż się spodziewałeś. Jeden z uczestników podchodzi.%SPEECH_ON%Chodzi o miecz, prawda? Proszę, weź go. Ten zmarły mówił o kimś takim jak ty. Powiedział, że bardziej go potrzebujesz niż on kiedykolwiek.%SPEECH_OFF%Chowając miecz, pytasz, czy dlatego wszyscy tu stoją. Mężczyzna śmieje się.%SPEECH_ON%Nie, mówił też, że nigdy nie umrze, więc chcieliśmy się przekonać, czy to się sprawdzi.%SPEECH_OFF%Powoli bierzesz miecz, zastanawiając się teraz, czy nie było jakiegoś powiedzenia o zarżnięciu człowieka, który sięgnie po ten oręż. Na szczęście, jak widać, potężny zmarły nie powiedział nic takiego.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Już mu się nie przyda.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/longsword");
				item.setCondition(27.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_28.png[/img]Sięgasz przez tłum i chwytasz miecz zmarłego. Jeden z uczestników krzyczy. %randombrother% uderza i posyła chłopa do krainy snów. Reszta kompanii dobywa broni, by dalsze protesty nie poszły za daleko. Starsza kobieta przeciska się przez tłum, na ile starsza kobieta potrafi, chwiejąc się i drżąc.%SPEECH_ON%Panie, to nie należy do ciebie. Odłóż to.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Teraz należy.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Staruszka ma rację, nie będziemy dalej zakłócać pogrzebu.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_36.png[/img]Mówisz staruszce, żeby wpełzła swoim zrzędliwym tyłkiem do dołu i tam zdechła. Miecz zmarłego trafia do twojego ekwipunku, a %companyname% wraca na drogę.\n\nOburzeni chłopi krzyczą, że wieść o tym, co zrobiłeś, poniesie wiatr jak pierdnięcia tysiąca krów. Ty tylko się śmiejesz i doceniasz ich wyobraźnię.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak działa świat.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-3);
				local item = this.new("scripts/items/weapons/longsword");
				item.setCondition(27.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_28.png[/img]Odkładasz miecz w dłonie zmarłego. Staruszka kiwa głową.%SPEECH_ON%A więc są jeszcze dobrzy ludzie, którzy posłuchają mądrych.%SPEECH_OFF%Inny chłop wychwala twoją uczciwość, a inni idą w jego ślady. Wygląda na to, że samo wzięcie broni i jej oddanie wystarczyło, by zyskać w oczach pospólstwa pewien prestiż. Może powinieneś częściej udawać kradzież.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I tak jej nie potrzebowaliśmy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(5);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type == this.Const.World.TerrainType.Snow || currentTile.Type == this.Const.World.TerrainType.Forest || currentTile.Type == this.Const.World.TerrainType.LeaveForest || currentTile.Type == this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		this.m.Score = 2;
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

