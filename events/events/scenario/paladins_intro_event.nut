this.paladins_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.paladins_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Świetnie znałeś tę grę i, jak to było z każdą dobra grą, wypaliłeś się na zasadach i ich twórcach. Przysięgi na to, Przysięgi na tamto. Wiedziałeś tylko, że nigdy nie będzie ci dane potrzymać czaszki Młodego Anzelma, a do tego jeden z Dawców Przysięgi zwiał w siną dal z jego wybitną szczęką. Opuszczenie Przysięgających było najlepszą decyzją, jaką kiedykolwiek podjąłeś, choćby z tego względu, że zachowałeś resztki zdrowego rozsądku.\n\nNiestety, wierni mają wyczulony węch na zapach apostatów. Kiedy dziś rano otworzyłeś drzwi, to było jak patrzenie na dwie kupki gówna, które podrzucił ci jakiś dowcipniś: %oathtaker1% oraz %oathtaker2%, we własnej osobie. Pierwszy to podstarzały mężczyzna, który po prostu nigdy nie zachwiał się w swoich przekonaniach, a drugi utalentowany giermek, który trochę przypomina ci ciebie. Bez wątpienia to ten młodszy był bardziej wyszczekany i to on pierwszy zaczął skomleć: Przysięgający potrzebują kogoś, kto zna te krainy i będzie pomagał nam wypełniać zadania i przysięgi. Zamykasz im drzwi przed nosem, ale starszy blokuje je stopą. Dźwiga w dłoni mieszek złota, a twój nos musiał się zmarszczyć lub drygnąć, bo obaj mężczyźni nagle się rozpromienili.\n\nPrzystajesz na to tylko dlatego, że czasy są ciężkie, a praca najemna - nawet pod przykrywką religijnego obowiązku - potrafi być bardzo dochodowa. A skoro ktoś chce cię wciągnąć w tak lukratywne zadanie, to niech tak będzie. Dajesz tylko jeden warunek: złożysz przysięgę Kapitaństwa, co oznacza, że wszelkie walki i ciężary wędrówki spoczną na barkach innych. Bez chwili namysłu obaj Przysięgający zgadzają się, a następnie pokazują ci czaszkę Młodego Anzelma. Dawno temu utraciłeś kontakt z zakonem, ale widok tej głupiej pustej kopuły wciąż budzi jakieś poruszenie w twoim sercu. %oathtaker2% przytakuje.%SPEECH_ON%Przemierzajmy te ziemie w poszukiwaniu honoru, i bądźmy konsekwentni w naszych zadaniach, i obyśmy kiedyś zdołali uczynić Młodego Anzelma na powrót całym, wbrew tym szczurzym bękartom, Dawcom Przysięgi, którzy go rozbili!%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Za złoto, sławę i Młodego Anzelma!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Przysięgający";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"oathtaker1",
			brothers[0].getName()
		]);
		_vars.push([
			"oathtaker2",
			brothers[1].getName()
		]);
	}

	function onClear()
	{
	}

});

