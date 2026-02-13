this.arena_tournament_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.arena_tournament";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_97.png[/img]Dwoje dzieci przebiega ci przez drogę, jedno trzyma zabawkową tarczę, drugie wbija w nią całkiem prawdziwe widły. Łapiesz narzędzie i wyrywasz je, na co dziecko krzyczy, że tylko się bawią. Starsze z nich wyjaśnia, że po prostu ekscytują się nadchodzącym turniejem gladiatorów. Mówią, że %town% organizuje serię walk na arenie, a nagroda jest ogromna. Bardzo interesujące. Używając wideł, spychasz dzieci z drogi, po czym ciskasz narzędzie na drugą stronę. | [img]gfx/ui/events/event_97.png[/img]Widzisz dwóch chłopców próbujących zagonić psa do sieci. Pies żartobliwie zmyka w lewo i prawo, ale w końcu go łapią. Kundel niemal od razu godzi się z losem i kładzie. Myślisz, że go oprawią i zjedzą, lecz chłopcy po prostu puszczają go wolno, by zacząć zabawę od nowa. Zapytani, wyjaśniają, że niektórzy gladiatorzy w %town% walczą z użyciem sieci. Co ciekawsze, mówią też, że trwa wielka seria igrzysk gladiatorskich i że podobno dla zwycięzcy jest duża nagroda. | [img]gfx/ui/events/event_92.png[/img]Posłaniec w trzewikach biegnie drogą, rzuca ci zwój i z zadyszką mija cię w kilka sekund. Rozwijasz papier i znajdujesz ogłoszenie: %town% organizuje turniej igrzysk gladiatorów. Zwycięzca serii walk otrzyma nagrodę, a także uwielbienie i sławę, oczywiście. | [img]gfx/ui/events/event_34.png[/img]Znajdujesz mężczyznę kucającego przy drodze. Jest półnagi i, sądząc po stanie jego odzieży, nie rozebrał się sam. Wyjaśnia, że jechał do %town%, by wziąć udział w igrzyskach gladiatorów, ale grupa łotrów go obrabowała. Niezainteresowany jego nieszczęściem pytasz o te igrzyska. Wyjaśnia, że to seria walk jak w turnieju i zwycięzca dostaje dużą nagrodę. Mężczyzna kręci głową.%SPEECH_ON%Wygląda na to, że jedyną nagrodą było lanie po tyłku. Hej, wyglądasz, jakbyś potrzebował pomocy, co powiesz, że ja...%SPEECH_OFF%Odchodzisz, rozważając, czy szukać %town% i jego świątecznej areny.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Interesujące.",
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

		if (currentTile.SquareCoords.Y >= this.World.getMapSize().Y * 0.6)
		{
			return;
		}

		local town;
		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.hasSituation("situation.arena_tournament"))
			{
				town = t;
				break;
			}
		}

		if (town == null)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 50;
	}

	function onPrepare()
	{
		this.m.Town.getSituationByID("situation.arena_tournament").setValidForDays(5);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

