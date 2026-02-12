this.dead_bodies_on_road_event <- this.inherit("scripts/events/event", {
	m = {
		Hunter = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.dead_bodies_on_road";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_02.png[/img] {Wóz przewrócony na bok. Martwe konie obok. Jeden martwy osioł, widać, że stawiał opór. Kobiety. Dzieci. Kilku starszych mężczyzn. Większość okaleczona w sposób, którego nikt nie chciałby oglądać, ale uznajesz, że twoja kompania była najlepszym kandydatem, by natknąć się na takie zgliszcza. Masz do tego żołądek, bo sam widziałeś i robiłeś gorsze rzeczy. To niewinność zmarłych ściska żołądek, więc w słabym odruchu naprawy moralnej skazy grzebiesz zmarłych. Niestety, w ich szczątkach nie ma nic wartościowego. | Krew w rowie przy drodze. Krew na całej drodze. Krew w rowie po drugiej stronie drogi. Krew na płótnie wozu. Krew w oczach martwych i krew w ich ustach. Jeden biedny rolnik, martwy, najwyraźniej napadnięty przez bandę złodziei, bo nic wartościowego, co miał, nie pozostało w ruinie, na którą się natknąłeś. | Ptaki były pierwszą wskazówką: krążące i zataczające koła nad odległą katastrofą. Sądziłeś, że to, co widzą, wciąż żyje, ale gdy dotarłeś na miejsce, stado już wylądowało, a ty natknąłeś się na martwego mężczyznę opierającego się o słupek przy drodze.\n\nPróbujesz odpędzić ptaki. Czarne sępy tylko odskakują o kilka kroków w przeciwną stronę, po czym odwracają się i patrzą na ciebie. Zwłoki są świeże, śmierć nastąpiła powoli: z boku wystaje kilka strzał. Sznur przy biodrze sugeruje, że miał tam sakiewkę. Ktoś go obrabował - dwukrotnie. | Natrafiasz na kilku powieszonych przestępców. Huśtają się na drzewie przy drodze, ich twarze to zaledwie zarysy pod wełnianymi workami na głowach. Kilku ma ślady tortur: rany tu i tam, napięte mięśnie sinieją, niektóre już szarzeją. Krew pod nogami jednego z nich sugeruje, że ktoś próbował go dobić, gdy się dusił. Naturalnie, nie mają nic wartościowego, więc wracasz na drogę. | Koza z dzwonkiem przytulona w ramionach martwego pasterza. Znajdujesz tę parę przy drodze. Gardło zwierzęcia jest podcięte, a na ciele mężczyzny nie ma ran. Może umarł z pękniętego serca. %randombrother% przeszukuje kieszenie zmarłego, ale wraca z pustymi rękami. Postanawiasz zostawić ich tam, gdzie leżeli. | Dwa sępy trzymają między sobą pasmo jelit, powoli je przeżuwając, aż ich dzioby stukają o siebie. Byłoby to zabawne, gdyby nie źródło posiłku: martwe dziecko, leżące twarzą do ziemi. Plecy zostały rozerwane, a makabryczna klatka piersiowa lśni w słońcu.\n\nOdpędzasz ptaki - choć wcale nie chcą się przestraszyć - i grzebiesz ciało. Wracając na drogę, widzisz, jak oba ptaki kucają nad grobem i dłubią w ziemi {w jakimś ptasim niepokoju | jakby próbowały odtworzyć to, co widziały, ale na odwrót}. W końcu dają za wygraną i odlatują, krążąc nad twoją bandą przez milę lub dwie, zanim polecą gdzie indziej. | Ogień trzaska i skwierczy, pochłaniając resztki wozu. %randombrother% grzebie w zwęglonym bałaganie, ale nic nie znajduje. Z popiołu i sadzy sterczy kilka rąk, równie czarnych jak reszta. Ciała całkowicie zniknęły, pogrzebane lub spalone albo zasypane tym, co spłonęło. Skoro nie ma nic do ocalenia, szybko zbierasz kompanię i ruszacie dalej. | Martwy koń. Jego jeździec leży po drugiej stronie drogi, doczołgał się do swojego ostatniego spoczynku. Złamane strzały zaścielają ścieżkę, a ich groty zostały wyrwane i zabrane. Mężczyzna nie ma skalpu, czubek głowy lśni czerwienią. Po szybkim przeszukaniu stwierdzasz, że nie ma tu nic do zabrania, więc idziesz dalej. | Natrafiasz na stertę nagich ciał przy drodze. Niektóre wyglądają makabrycznie, jakby były martwe od dawna, choć w ustach kilku widać całkiem świeżą krew. Kilku trupów zachowało kolor skóry, ale mają tu i ówdzie ślady po ugryzieniach. Wygląda na to, że podjęto środki zapobiegawcze, bo każdemu podcięto gardło. Nagie, jak są, nie znajdujesz nic poza tym, co naturalne dla natury. Ruszasz dalej. | Czujesz, że ktoś cię obserwuje, więc zatrzymujesz się i szybko zwracasz ku poboczu z dłonią na mieczu. Głowa spogląda na ciebie, a oczy ledwie wyglądają ponad trawę. %randombrother% podchodzi i podnosi ją. Twarz nosi piętno gwałtownej śmierci, z rozdziawionymi, przekrzywionymi szczękami. Mówisz najemnikowi, by odłożył głowę, bo masz lepsze rzeczy do roboty.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Spoczywaj w pokoju.",
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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local myTile = this.World.State.getPlayer().getTile();

		foreach( s in this.World.EntityManager.getSettlements() )
		{
			if (s.getTile().getDistanceTo(myTile) <= 6)
			{
				return;
			}
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

