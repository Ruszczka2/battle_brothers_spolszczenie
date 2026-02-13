this.holywar_warnings_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holy_warnings";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 3.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Mija cię chłop na ścieżce. Mimochodem wspomina, że nie rozumie, czemu bogowie mieliby kazać swoim wyznawcom walczyć ze sobą. Skoro naprawdę chcą to rozstrzygnąć, czemu nie zrobią tego sami? Łapiesz go za koszulę i pytasz, co to za brednie. Odsuwa się.%SPEECH_ON%Hej! Ręce przy sobie, bo cię ugryzę! A ja tylko narzekam, i tyle. Wszędzie gadanie o Gilded i wyznawcach starych bogów, co znowu się ścierają. Znowu. A teraz daj mi ponarzekać w spokoju!%SPEECH_OFF%Mężczyzna odchodzi, mamrocząc i, ironicznie, robiąc się głośniejszy im dalej od ciebie. | Natykasz się na zgromadzenie mnichów Gildera i starych bogów. Rozmawiają o możliwości nadchodzącej wojny i o tym, jak się zabezpieczyć, jeśli do niej dojdzie. W sumie wszystko jest zadziwiająco przyjacielskie, ale w powietrzu unosi się nuta religijnego rozrachunku. | Mężczyzna naprawiający wóz przy drodze kręci głową.%SPEECH_ON%Wiesz, chciałbym po prostu iść z jednego miejsca świata do drugiego i mieć spokój. Ale nie. Pieprzona... coś! Zawsze coś! Coś musi pójść źle. Hej, a skoro o kołach mowa, słyszę jedno, które się kręci: Gilder i stare bogi mogą znowu zderzyć się głowami. Widziałem burzowe chmury nad tym. Święta wojna na niebie. Co znaczy święta wojna tutaj. Mam nadzieję zdążyć się zmyć, zanim się zacznie. Widziałeś ostatnią? Paskudny interes.%SPEECH_OFF%Na pewno, ale paskudny interes to dobry interes dla %companyname%. | %SPEECH_ON%Kolana mnie bolą.%SPEECH_OFF%Spoglądasz i widzisz starca poruszającego dwoma kikutami. Uśmiecha się.%SPEECH_ON%To znaczy, duch mojego kolana robi się zły. Kiedy miałem nogi, mrowienie w kolanie oznaczało złą pogodę. Teraz drganie w nie-kolanie oznacza coś gorszego.%SPEECH_OFF%Młody chłopiec podchodzi i wciąga starca na taczkę. Zanim odjedzie, pytasz, co ma na myśli. Odwraca się, łokieć uniesiony, dłoń oparta na dłoni, wyglądając rześko i elegancko jak na swój stan.%SPEECH_ON%Rozrachunek z góry. Gilder, stare bogi, a może nawet coś więcej. Myślę, że wszyscy się z nami bawią, podjudzają nas, byśmy zabijali się nawzajem, żeby ich zadowolić, żeby mogli to oglądać. Wyglądasz na najemnika, więc sądzę, że interes będzie ci sprzyjał, kiedy te duchowne barwy zechcą przejść w czerwień.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze wiedzieć.",
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.FactionManager.getGreaterEvilType() == this.Const.World.GreaterEvilType.HolyWar && this.World.FactionManager.getGreaterEvilPhase() == this.Const.World.GreaterEvilPhase.Warning)
		{
			local playerTile = this.World.State.getPlayer().getTile();
			local towns = this.World.EntityManager.getSettlements();

			foreach( t in towns )
			{
				if (t.getTile().getDistanceTo(playerTile) <= 4)
				{
					return;
				}
			}

			this.m.Score = 80;
		}
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

