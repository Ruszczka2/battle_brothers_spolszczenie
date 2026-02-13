this.tundra_elk_destroyed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.tundra_elk_destroyed";
		this.m.Title = "Po bitwie...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_146.png[/img]{Gdy cios śmiertelny trafia, Ijirok chwieje się na boki, trzymając się za ostatnią ranę. Wydaje skowyt bólu, ugina kolana i ledwie utrzymuje się jedną ręką, gdy ciało zwija się i wymiotuje na ziemię. Ale wszystko wygląda jak szarada, a bestia czasem zerka, jakby upewniała się, że patrzysz. To dramat. Słabo odegrany spektakl wystawiany przez coś, co w żadnym sensie nie zna śmierci. Oczy napotykają twoje spojrzenie i ten niepokojący uśmiech wraca, po czym monstrum błyska oślepiającym niebieskim światłem, a gdy wraca naturalne światło świata, ciało jest zamarznięte na kość i z nieba sypią się płatki śniegu.\n\nTo nie może być koniec. Po prostu to wiesz. Podchodzisz do skutej lodem reszty i zaczynasz rąbać. Gdy kujesz lód, z kanałów i szczelin sączy się niebieska maź. Ostatni cios rozbija lód i kłąb śluzu rozlewa się we wszystkie strony. Gdy ludzie patrzą z niepokojem, chwytasz rozbity pancerz z jaskini i wrzucasz go w krew Ijiroka. Dziwne włókna, które trzymały jego części razem, natychmiast jaśnieją i widzisz, jak zaczynają się napinać i ściągać płyty. Zfilcowane futro łosia łączy się z metalem, jakby były jednym bytem, który leczy stare rany. Krew wije się po płytach jak mech pod nurtem rzeki, zwija się i rozciąga, po czym spłaszcza i maluje pancerz na śliski czerwony kolor.\n\nPodnosząc go, czujesz mrowienie na czubkach palców.%SPEECH_ON%Mam nadzieję, że nie sugerujesz, żebym to nosił, kapitanie.%SPEECH_OFF%%randombrother% mówi, kręcąc głową z nerwowym uśmiechem. Nie wiesz jeszcze, do czego pancerz jest zdolny, ale chcesz zatrzymać go w ekwipunku, by to sprawdzić. Co do Ijiroka, nie masz wątpliwości, że wciąż gdzieś tam jest. Jego zwłoki szybko gniją, a kości, które pozostają, nie należą do olbrzymiej bestii, lecz do biednego łosia.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mimo wszystko, zwyciężyliśmy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IjirokStage", 5);
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.broken_ritual_armor")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});
						break;
					}
				}

				this.World.Assets.getStash().makeEmptySlots(2);
				local item = this.new("scripts/items/helmets/legendary/ijirok_helmet");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				local item = this.new("scripts/items/armor/legendary/ijirok_armor");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_146.png[/img]{Gdy cios śmiertelny trafia, Ijirok chwieje się na boki, trzymając się za ostatnią ranę. Wydaje skowyt bólu, ugina kolana i ledwie utrzymuje się jedną ręką, gdy ciało zwija się i wymiotuje na ziemię. Ale wszystko wygląda jak szarada, a bestia czasem zerka, jakby upewniała się, że patrzysz. To dramat. Słabo odegrany spektakl wystawiany przez coś, co w żadnym sensie nie zna śmierci. Oczy napotykają twoje spojrzenie i ten niepokojący uśmiech wraca, po czym monstrum błyska oślepiającym niebieskim światłem, a gdy wraca naturalne światło świata, ciało jest zamarznięte na kość i z nieba sypią się płatki śniegu.\n\nTo nie może być koniec. Po prostu to wiesz. Podchodzisz do skutej lodem reszty i zaczynasz rąbać. Gdy kujesz lód, z kanałów i szczelin sączy się niebieska maź. Ostatni cios rozbija lód i kłąb śluzu rozlewa się we wszystkie strony.\n\nNie masz wątpliwości, że ta rzecz wciąż gdzieś tam jest. Jej zwłoki szybko gniją, a kości, które pozostają, nie należą do olbrzymiej bestii, lecz do biednego łosia.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mimo wszystko, zwyciężyliśmy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IjirokStage", 5);
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		local stash = this.World.Assets.getStash().getItems();

		foreach( i, item in stash )
		{
			if (item != null && item.getID() == "misc.broken_ritual_armor")
			{
				return "A";
			}
		}

		return "B";
	}

	function onClear()
	{
	}

});

