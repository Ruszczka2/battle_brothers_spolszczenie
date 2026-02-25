this.oathtakers_noble_contracts_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.oathtakers_noble_contracts";
		this.m.Title = "Po drodze...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_63.png[/img]{Ludzie przychodzą do ciebie z zaskakującym odkryciem: we wklęsłej części czaszki Młodego Anselma znajdował się mały, zwinięty list - a jego woskowa pieczęć nosi znak pierścienia szlachcica. Za zgodą ludzi rozrywasz go i czytasz. Okazuje się, że Młody Anselm sam był wysokiego urodzenia i posiadał list Curia in Absentia - czyli, w języku najemników, pozwolenie na wstęp do szlacheckich dworów. Spoglądasz na ludzi i mówisz,%SPEECH_ON%Młody Anselm znów nas wszystkich pobłogosławił!%SPEECH_OFF%Choć wrażliwość wykorzenionych najemników nie pozwoliłaby takim awanturnikom nawet rozmawiać z możnymi, a co dopiero bezcześcić ich delikatne kamienne posadzki, list Młodego Anselma niesie wyjątkowy znak: każdy, kto jest w jego kompanii, zyska takie same prawa, zarówno na tym świecie, jak i następnym. Ludzie wnioskują, że Młody Anselm musiał zajmować bardzo wysoką pozycję w kręgach szlacheckich, skoro tak się stało, i że musiał też darzyć twoją kompanię wielkim szacunkiem, skoro ofiarował wam taką moc.%SPEECH_ON%Ale, yyy, kto włożył ten zwój do jego głowy?%SPEECH_OFF%%randombrother% pyta. Ty i ludzie każecie mu zamknąć usta. Nie ma sensu rozpamiętywać jak i co, i dlaczego. To wyraźny cud i kolejny znak, że Przysięgobiorcy są na właściwej drodze.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Z tym listem nawet szlachta da nam pracę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Ambitions.getAmbition("ambition.make_nobles_aware").setDone(true);
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Szlachta będzie teraz dawać ci kontrakty"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1050)
		{
			return;
		}

		this.m.Score = 2000;
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

