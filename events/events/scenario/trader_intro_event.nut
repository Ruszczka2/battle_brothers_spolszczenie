this.trader_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.trader_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_95.png[/img]Nad zwłokami roi się od much, %ch1% stoi pośród tej chmary, jakby własnoręcznie zbudował totem, który je przyciągnął. Odwraca się do ciebie.%SPEECH_ON%To robota zielonoskórych. Żaden człowiek nie jest w stanie rozrąbać głowy na pół, jak tutaj i nikt też przy zdrowych zmysłach nie ułożyłby ich w taki sposób. Do tego na grotach strzał czuć truciznę goblinów.%SPEECH_OFF% %ch2% przytakuje.%SPEECH_ON%Wczoraj znaleźliśmy kupca powieszonego przez bandytów, a teraz jeszcze to. Drogi stają się zbyt niebezpieczne dla obładowanych wozów. Nie mówię, że moje zdolności bitewne nie są warte swej ceny, ale jest nas tylko dwóch do ochrony i naprawdę igramy sobie z losem. Panie, powinieneś zatrudnić nieco więcej straży.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A tam, nic nam nie będzie.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Zatrudnimy więcej strażników, a potem kolejnych!",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[0].getImagePath());
				this.Characters.push(brothers[1].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_95.png[/img]Potrząsasz głową.%SPEECH_ON%Nie. Wiecie co zrobimy? Będziemy się bronić i walczyć. Zatrudnię najemników, by stworzyć prawdziwą kompanię, a wy dwaj możecie być pierwszymi z nich, o ile zechcecie zarabiać na życie machając mieczem.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A teraz naprzód, mamy towary do sprzedania!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[0].getImagePath());
				this.Characters.push(brothers[1].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_95.png[/img]Potrząsasz głową.%SPEECH_ON%Już i tak ledwie osiągamy zyski. Nie stać mnie, by nająć więcej strażników. A przynajmniej nie do czasu, aż znajdziemy bardziej dochodowy szlak handlowy. I to właśnie mam zamiar zrobić!%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A teraz naprzód, mamy towary do sprzedania!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[0].getImagePath());
				this.Characters.push(brothers[1].getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Karawana Kupiecka";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"ch1",
			brothers[0].getName()
		]);
		_vars.push([
			"ch2",
			brothers[1].getName()
		]);
	}

	function onClear()
	{
	}

});

