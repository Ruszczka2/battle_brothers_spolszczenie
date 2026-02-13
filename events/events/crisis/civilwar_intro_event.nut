this.civilwar_intro_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_intro";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]Wchodzisz do %townname% i widzisz grupę pospólstwa stojącą wokół drewnianego podestu. Myśląc, że zaraz będzie wieszanie, szybko przepychasz się przez tłum. Zamiast tego zastajesz dziwacznie ubranego mężczyznę, który wykrzykuje nowiny do mieszkańców.%SPEECH_ON%Słuchajcie, słuchajcie, słuchajcie, zapadło postanowienie między rodami %noblehouse1% i %noblehouse2%! Doszli do wniosku, z którym wszyscy się zgodzą: nienawidzą się nawzajem!%SPEECH_OFF%Nerwowe szepty marszczą tłum. Gdy głośność rośnie, szepty przechodzą w ciszę. Minstrel ciągnie dalej.%SPEECH_ON%To prawda, moi piękni ludzie! Wojna nadchodzi! Ach tak, ten chimeryczny zwierz, który drzemie w każdym człowieku. Smutna sprawa, sprawiedliwa sprawa, honorowa sprawa!%SPEECH_OFF%Stary człowiek stojący przed tobą burczy i spluwa. Odchodzi, kręcąc głową i mamrocząc do siebie. Minstrel ciągnie dalej, a jego podekscytowanie nie pasuje do przerażonych twarzy przed nim.%SPEECH_ON%Nie traćmy czasu na ceremonie. Polecono mi mówić tak: mężczyźni, chwytajcie za broń, kiedy możecie, orzcie pola, gdy nie możecie. Kobiety, wychowujcie synów jak należy, by nie podnieśli miecza źle!%SPEECH_OFF%W końcu minstrel bierze wielki haust powietrza.%SPEECH_ON%A ci z was, którzy chcą zarobić porządny grosz, niech wiedzą: rody szlacheckie szukają usług każdego, kto potrafi machać mieczem. A wy, o mniejszym honorze, wy, co luzujecie uzdy, porywacie panny, sprzedajecie pijawki, cuchniecie, do niczego się nie nadajecie, oddani występkom i rozpasaniu, rozbójnicy, bandyci i złodzieje po praktykach, chorowici i wilgotni od trucizn, przeklęci i wściekli, uleczeni i jałowi, najemnicy i poeci sprzedający słowa, to, moi zacni panowie, jest WASZ czas. Idźcie, walczcie dla szlachty i zaróbcie na nowe życie! Szkoda, że wojna nie trwa wiecznie, więc lepiej robić to szybko!%SPEECH_OFF%Wygląda na to, że przyszłość %companyname% właśnie się rozjaśniła - dzięki górom złota, które zaraz zaczniecie zarabiać.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wojna nadchodzi.",
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
		if (this.World.Statistics.hasNews("crisis_civilwar_start"))
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
			this.m.NobleHouse = this.m.Town.getOwner();
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_civilwar_start");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"noblehouse1",
			this.m.NobleHouse.getNameOnly()
		]);
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local noblehouse2;

		do
		{
			noblehouse2 = nobles[this.Math.rand(0, nobles.len() - 1)];
		}
		while (noblehouse2 == null || noblehouse2.getID() == this.m.NobleHouse.getID());

		_vars.push([
			"noblehouse2",
			noblehouse2.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.NobleHouse = null;
	}

});

