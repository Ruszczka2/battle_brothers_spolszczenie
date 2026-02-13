this.civilwar_wounded_soldier_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_wounded_soldier";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_21.png[/img]{Maszerując ścieżką, napotykasz żołnierza %noblehouse%, waszych sojuszników. Leży na ziemi, oparty o skalny mur, z jedną ręką przerzuconą przez jego szczyt, jakby właśnie położył ostatni kamień. Zerkając na ciebie, szydzi.%SPEECH_ON%Czego chcesz, najemniku? Przyszedłeś mnie dobić, co? Zabrać wszystko, co mam, i jeszcze więcej?%SPEECH_OFF%Ma na sobie porządny pancerz i nosi broń. Nie będzie się nią bronił w tym stanie, ale dobrze wyglądałaby w rękach jednego z twoich ludzi. %randombrother% podchodzi.%SPEECH_ON%Możemy go wziąć, panie, ale musimy zrobić to szybko. Nie wiadomo, kto nas nakryje, bo nosi barwy szlacheckiej armii.%SPEECH_OFF% | Napotykasz rannego żołnierza %noblehouse%, waszych sojuszników. Leży w trawie, podnosi się, by dobrze ci się przyjrzeć, a ty przyglądasz się jemu w zamian: mężczyzna ma przyzwoity pancerz i broń opartą na nogach. Mógłbyś zabrać oba, ale człowiek nie wygląda na skłonnego, by spokojnie się z nimi rozstać. I jest spora szansa, że reszta żołnierzy tej armii nie jest daleko... | Ranny żołnierz %noblehouse%, waszych sojuszników, leży na ścieżce. Czołga się, by się oddalić, ale gdy cię słyszy, zatrzymuje się i odwraca.%SPEECH_ON%A niech to. Lepiej zawróć, najemniku. Moi ludzie są niedaleko, a jeśli ruszysz na mnie, będę krzyczał.%SPEECH_OFF%Unosisz brew.%SPEECH_ON%To zginiesz jak baba, co?%SPEECH_OFF%Mężczyzna spluwa.%SPEECH_ON%Zginę wiedząc, że nie będę długo czekał, by spotkać cię znów w następnym świecie.%SPEECH_OFF%Ten zadziorny typ ma porządny pancerz i broń, ale %randombrother% ostrzega, że to członek szlacheckiej armii. | Ranny żołnierz armii %noblehouse% leży przed tobą. Z jednej strony ma broń i pancerz, które mógłbyś mu zabrać. Z drugiej, bez wątpienia jest częścią znacznie większej siły niż twoja. Po prostu akurat teraz nie patrzy. Jeśli zdecydujesz się zabrać jego rzeczy, rób to szybko. | Szczęście czy nadciągająca katastrofa? Znalazłeś rannego żołnierza w całkiem niezłym pancerzu. Ma też broń przy boku, która wyglądałaby jeszcze lepiej przy boku jednego z ludzi %companyname%. Zabranie jego rzeczy byłoby dziecinnie proste. Nikogo nie ma w pobliżu, a uciszenie go nie byłoby trudne.\n\nZ drugiej strony, jeśli ktoś by to zobaczył, najpewniej byłby to ktoś z bardzo, bardzo dużej armii, bo ten żołnierz nosi barwy %noblehouse%, waszego sojusznika. Decyzje, decyzje... | Napotykasz rannego żołnierza z poszarpanym sztandarem %noblehouse%, waszego sojusznika. Widząc cię, szybko cofa się po trawie. Wyciąga rękę i próbuje przekląć, ale z ust tryska tylko krew. %randombrother% podchodzi do ciebie.%SPEECH_ON%Panie, ma porządny pancerz i broń. Możemy go wykończyć, jeśli chcesz, ale istnieje ryzyko, że jego armia nie jest daleko. Musimy być bardzo ostrożni.%SPEECH_OFF% | Znajdujesz żołnierza %noblehouse% próbującego wyważyć drzwi opuszczonej chaty. Słysząc cię, szybko się odwraca, unosząc miecz do obrony. Ostrze jednak chwieje się w niestabilnym uścisku. Krew spływa wzdłuż jego ramienia, kapiąc z nadgarstka, a mężczyzna ledwo stoi.%SPEECH_ON%Zostańcie z tyłu, wszyscy!%SPEECH_OFF%Przerażony człowiek zepchnięty do kąta. Jakie to nieszczęście, że nie jest zwierzęciem, bo wtedy dwa razy byś się zastanowił...\n\n %randombrother% chwyta cię za ramię.%SPEECH_ON%Chwileczkę, panie. Jeśli reszta jego armii nas zobaczy, wpadniemy w poważne kłopoty. Spróbujmy to przemyśleć, dobrze?%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			Banner = "",
			Options = [
				{
					Text = "Lepiej zostawić go w spokoju i ruszać dalej.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Ten pancerz i broń mogą się przydać, a on nie będzie ich potrzebował po śmierci.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);

						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_21.png[/img]{Wyciągasz miecz z pochwy i podchodzisz do żołnierza. Krzyczy, ale krótko, kończąc na ostrym brzęku twojego ostrza, które przebija mu język aż do potylicy. Krztusi się, uderzając w metal śmiertelnego ciosu, po czym nieruchomieje. Drżące oczy spoglądają na ciebie, gdy zimna śmierć go dopada. Odbierasz miecz, rozglądasz się przez ramię i każesz ludziom zabrać wszystko, co miał przy sobie. Wycierasz ostrze w tkaninę sztandaru martwego. | Mężczyzna widzi zamiar w twoich oczach i szybko podnosi głos, ale ty rzucasz się do przodu, dobywając ostrza i jednym ruchem przebijając mu czaszkę. Umiera, a ty czujesz kłucie w boku. Nie moralne, tylko stare, bardziej realne. %randombrother% podtrzymuje cię dłonią na ramieniu.%SPEECH_ON%Spokojnie, panie, nie jesteś tak gibki jak kiedyś.%SPEECH_OFF%Kiwasz głową, czyścisz ostrze i każesz ludziom zabrać, co się da. | Żołnierz odchyla się.%SPEECH_ON%A, rozumiem.%SPEECH_OFF%Podnosi szyję.%SPEECH_ON%Masz mnie. Odejść powinienem jak mężczyzna.%SPEECH_OFF%Szybkim cięciem opuszcza głowę, a po piersi spływa bulgocząca karminowa piana. Twoi ludzie grabią, co się da. | Wyciągasz sztylet. Mężczyzna unosi broń, ale ty odrzucasz ją kopnięciem. Jego ramię opada bez wysiłku, jakbyś właśnie zdjął z niego wielki ciężar. Patrzy na ciebie.%SPEECH_ON%Czekaj...%SPEECH_OFF%To jego ostatnie słowo. Próbuje powiedzieć coś jeszcze, ale ogromna rana, którą rozciąłeś mu gardło, wydaje tylko ohydne bulgotanie. Każesz %randombrother% zabrać z ciała wszystko, co się da.}",
			Image = "",
			Characters = [],
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Kolejna ofiara wojny.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.addLoot(this.List);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Dobywasz miecz i robisz krok w stronę mężczyzny. Unosi dłoń, a ty przebijasz ostrzem jego dłoń i prosto do czaszki. Język zwisa mu przy ostatnich słowach, jakimś śliniącym się, krwawym bełkocie. Czyszcząc ostrze, odwracasz się do %randombrother%, tylko po to, by zobaczyć chorążych na horyzoncie.%SPEECH_ON%O, do diabła. Wszyscy, biec!%SPEECH_OFF%%companyname% ucieka szybko, choć niezgrabnie, przeskakując przez zarośla i koryta strumieni, zawracając, kryjąc się i po cichu zabijając jednego psa gończego, zanim zdążył zaszczekać. W końcu udaje ci się uciec, ale bez czasu na zabranie czegokolwiek. | Dobywasz miecz i wbijasz go w pierś mężczyzny. Wyciąga rękę i chwyta cię za koszulę, podciągając się po ostrzu. Szczerzy zęby w krwawym uśmiechu.%SPEECH_ON%Pierdol się, najemniku. Zobaczymy się po drugiej stronie.%SPEECH_OFF%Puszcza i opada, a strumień czerwieni tryska, gdy twój miecz go opuszcza. Nagle %randombrother% woła do ciebie, głos ma wysoki.%SPEECH_ON%Panie, musimy iść! Chorążowie, spójrz!%SPEECH_OFF%Na pobliskim wzgórzu stoją jeźdźcy %noblehouse% i bez wątpienia widzieli, co zrobiłeś. Krzycząc jak najgłośniej, każesz ludziom salwować się szybką ucieczką. Udało wam się ujść, ale bez wątpienia straciłeś przychylność potencjalnego pracodawcy. | Żołnierz śmieje się, gdy na niego nacierasz. Śmieje się, gdy wbijasz mu miecz w pierś. I śmieje się, ostatnim, zmęczonym chichotem, gdy wyciągasz ostrze. Jego oczy gasną, patrząc ponad ciebie na pobliskie wzgórze, gdzie, jak się okazuje, puenta mordu stoi: chorążowie żołnierza są na horyzoncie, najwyraźniej widząc twój czyn.\n\nKrzycząc, każesz %companyname% pospiesznie się wycofać, by cała armia nie spadła na was i nie wyrżnęła do nogi. W pośpiesznym odwrocie rezygnujesz z jakiejkolwiek nagrody za swój czyn. Rozsądna wymiana za zachowanie głów na karkach. | Szybkim cięciem otwierasz mężczyźnie gardło. Zasłania ranę dłonią, ale życie dosłownie przecieka mu między palcami. Gdy się osuwa, %randombrother% krzyczy do ciebie.%SPEECH_ON%Panie, patrz!%SPEECH_OFF%Towarzyszący żołnierzowi chorążowie stoją na odległym wzgórzu, bez wątpienia widząc, co właśnie zrobiłeś. Szybkim rozkazem zwołujesz %companyname% do pospiesznego odwrotu, opuszczając teren tak szybko, jak się da, zanim cała armia spadnie na was. W szaleńczym odwrocie nie masz czasu, by zabrać jakąkolwiek nagrodę za swój krwawy czyn.}",
			Image = "",
			Characters = [],
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Pycha! Przeżywalna pycha!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationOffense, "Killed one of their men");
			}

		});
	}

	function addLoot( _list )
	{
		local item;
		local banner = this.m.NobleHouse.getBanner();
		local r;
		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			item = this.new("scripts/items/weapons/arming_sword");
		}
		else if (r == 2)
		{
			item = this.new("scripts/items/weapons/morning_star");
		}
		else if (r == 3)
		{
			item = this.new("scripts/items/weapons/military_pick");
		}
		else if (r == 4)
		{
			item = this.new("scripts/items/weapons/warbrand");
		}

		this.World.Assets.getStash().add(item);
		_list.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			item = this.new("scripts/items/armor/special/heraldic_armor");
			item.setFaction(banner);
		}
		else if (r == 2)
		{
			item = this.new("scripts/items/helmets/faction_helm");
			item.setVariant(banner);
		}
		else if (r == 3)
		{
			item = this.new("scripts/items/armor/mail_shirt");
		}
		else if (r == 4)
		{
			item = this.new("scripts/items/armor/mail_hauberk");
			item.setVariant(28);
		}

		item.setCondition(44.0);
		this.World.Assets.getStash().add(item);
		_list.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local candidates = [];

		foreach( h in nobleHouses )
		{
			if (h.isAlliedWithPlayer())
			{
				candidates.push(h);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
	}

});

