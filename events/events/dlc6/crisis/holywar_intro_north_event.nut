this.holywar_intro_north_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_intro_north";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{%SPEECH_START%Dobrze, dobrze, ogarnij się, ogarnij.%SPEECH_OFF%Podchodzisz do chłopa, który przemawia, co nie zaskakuje, do innych chłopów.%SPEECH_ON%No i właśnie mi powiedziano, że ci Gilded z południa myślą, że ich \"stwórca\" ma coś przeciwko starym bogom.%SPEECH_OFF%Głos z tłumu pyta, co to może być. Mówca wzrusza ramionami.%SPEECH_ON%Nie wiem. Ale chyba wszyscy się zgodzimy, że stare bogi zakończyły swoje wojny dawno temu i nie ma potrzeby przemocy. Ale Gilder to nie jest żaden stary bóg. To jest herezja.%SPEECH_OFF%Tłum wiwatuje. Zaczynasz się zastanawiać, czy ten człowiek nie jest duchownym w chłopskich łachach. Kontynuuje.%SPEECH_ON%Zbierzcie broń, zbroje, złoto, a przede wszystkim wiarę, bo rzucimy cień na tego \"Gildera\"! Stare bogi tak chcą!%SPEECH_OFF%Tłum ryczy tym razem tak głośno, że trzeszczą ci uszy. Dobrze widzieć taką energię. Gdy zacznie się walka, będzie mnóstwo roboty, bo prawi z pewnością złożą wiarę w %companyname%. | Brodaty duchowny stoi przed tłumem chłopów.%SPEECH_ON%Mówi się, że stare bogi doprowadziły swoje wojny do końca wiele lat temu, że rozerwały ten świat i zostawiły nas w zgliszczach, a potem zostały pod wrażeniem naszej zdolności przetrwania wobec tak wielkiego trudu.%SPEECH_OFF%Tłum mruczy. Mężczyzna kontynuuje.%SPEECH_ON%Ale wciąż jesteśmy wystawiani na próbę, wierni! Na południu błądzą heretycy, wyznawcy \"Gildera\", fałszywego boga przepychu, rozrzutności i marnej prestidigitacji, którą nazywają prawością.%SPEECH_OFF%Tłum nie wie, co te słowa znaczą, ale wznoszą widły w powietrze i ryczą, wzywając duchownych, by wskazali im drogę. Uśmiechając się, starszyzna spogląda na siebie i przytakuje. Mało cię obchodzi, kto lub co rozpętuje tę krucjatę między północą a południem, byle %companyname% zarobiła na tym grubą sakiewkę. | Arsenał zebrany przed tobą nie przypomina niczego, co widziałeś. Uzbrojenie piętrzy się wyżej niż trzech ludzi od stóp do głów. Żołnierze stoją w szeregu, połowa z nich trzyma religijne sztandary, każdy ozdobiony jednym ze starych bogów. Duchowni i mnisi przechodzą wzdłuż szeregu, mówiąc o sprawie zarówno tonem ziemskim, jak i niebiańskim. To krucjata, wielkie religijne wezwanie północy przeciw wyznawcom Gildera.%SPEECH_ON%Najemnik, co?%SPEECH_OFF%Odwracasz się i widzisz młodego chłopaka zbrojącego się.%SPEECH_ON%Pójdziesz prawą ścieżką, wiem to, a stare bogi będą nad nami czuwać. Postępuj wedle nich, mały łobuzie.%SPEECH_OFF%Oczywiście. Ale najpierw zadbasz o %companyname% i o tłustą sakiewkę z nadchodzącej roboty.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wojna jest tuż za progiem.",
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

		if (this.World.Statistics.hasNews("crisis_holywar_start"))
		{
			local playerTile = this.World.State.getPlayer().getTile();
			local towns = this.World.EntityManager.getSettlements();
			local nearTown = false;
			local town;

			foreach( t in towns )
			{
				if (t.isSouthern())
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

			this.m.Town = town;
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_holywar_start");
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

