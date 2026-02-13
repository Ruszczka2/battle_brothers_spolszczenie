this.belly_dancer_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.belly_dancer";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Tancerka brzucha hipnotyzuje centralny plac %townname%. Same rytmiczne ruchy potrafią skłonić żebraka do wrzucenia korony, a na scenie całego placu to wystarcza, by przyciągnąć tłumy i z nimi stosy złota. Zamaskowana zielonym jedwabiem, niemal prześwitującym, i ubrana w cienkie tkaniny z odkrytym całym brzuchem, tancerka bez wątpienia jest mistrzynią w swoim fachu. Wiruje, biodra hipnotyczne, łokcie zgięte, dłonie uderzają o małe talerzyki, stopy stąpają na palcach, a ona obraca się w miejscu tak ciasno, że być może niewidzialny bóg nad nią trzyma ją w miejscu, gdy olśniewa i zachwyca.\n\n Ktoś rzuca w powietrze jabłko, a tancerka obraca się i przebija je małym sztyletem, trafiając prosto w środek i strącając owoc na ziemię. Kolejne jabłko leci, tym razem pojawia się duża szabla, odcina ogonek, a ona łapie resztę i odgryza kęs. Tłum delikatnie klaszcze.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota, masz koronę.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Czas iść.",
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
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Wyciągasz koronę i podrzucasz ją tancerce. Jej oczy wyłapują blask, ale nie przerywa tańca. Odkłada broń i kołysząc się podchodzi, talerzyki brzęczą, biodra falują, kolana ledwo się zginają, a stopy niemal mistycznie niosą ją po ziemi. Zbliża się. Twarz jest wąska, lecz szczęka szeroka. Skronie głębokie. Uśmiecha się. To mężczyzna. On jest mężczyzną. Uderza talerzykami tuż przed twoją twarzą, po czym obraca się, na chwilę muskając twoje krocze pośladkiem, i zaczyna tańczyć z powrotem do środka. Podbiera twoją monetę palcem u stopy i podrzuca ją, a ta wpada do glinianego dzbana. Tłum wiwatuje.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Może uda się nam z niego skorzystać?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Czas iść.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-1);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]1[/color] koronę"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Gdy męski tancerz brzucha bierze twoją koronę, czekasz, aż przedstawienie się skończy. Podchodzisz, gdy zbiera swoje rzeczy. Spogląda na ciebie z przekąsowym uśmiechem.%SPEECH_ON%Ach, wielbiciel. Wybacz, tylko jeden występ tej nocy, dobry nieznajomy.%SPEECH_OFF%Kręcisz głową i pytasz, czy zna się na walce. Kiwając, odpowiada.%SPEECH_ON%Oczywiście. Blask Gildera spoczywa na nas wszystkich, lecz nie o każdej porze i nie każdego dnia. Czasem musimy znaleźć własną drogę przez ciemność. Sądząc po twoim stroju, jesteś Koronnikiem, który przykłada swoje ostrze tam, gdzie powinno, i czasem tam, gdzie nie powinno.%SPEECH_OFF%Kiwasz głową i pytasz, czy byłby zainteresowany dołączeniem. Rozstawia nogi i osuwa się na ziemię jak zawalająca się kratownica. Liczy swoje korony.%SPEECH_ON%Nie wiem, czy masz dobre oko do wędrownej natury ludzi takich jak ja. Być może dostrzegłeś zawodowe zmęczenie, o którym nawet ja nie wiedziałem do tej chwili. Tak czy inaczej, musisz się bardziej postarać, żeby skłonić mnie do zabijania za pieniądze.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Masz talent do ostrza, jakiego nigdy nie widziałem.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "E" : "D";
					}

				},
				{
					Text = "Zapłacę ci teraz 500 koron, jeśli do nas dołączysz.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"belly_dancer_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Znalazłeś %name% w " + _event.m.Town.getName() + ", zamaskowanego zielonym jedwabiem i przyciągającego tłumy rytmicznymi ruchami oraz imponująco precyzyjnym krojeniem owoców. Ta druga umiejętność to dar dla każdej kompanii najemników, więc nie wahałeś się go zwerbować.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/dexterous_trait");
				_event.m.Dude.getSkills().add(trait);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Łagodzisz jego ego, mówiąc, że jest jednym z najlepszych, jakich widziałeś z ostrzem. Tancerz opuszcza dłonie ku ziemi, palce wsuwają się pod każdą monetę i przerzucają ją do glinianego dzbana. Lewa ręka sięga po ziemi, lecz gdy to przykuwa twój wzrok, prawa chwyta ostrze całkowicie zakopane w piasku. Kieruje je ku twojemu kroczu.%SPEECH_ON%Jestem zabójczy z ostrzem, tak jak ty z tym żądłem. Wiem, że tylko głaszczesz to, co ma sprawić, żebym mruczał, żerując na mojej dumie, jak myśliwy na lwach, i powiem tak: zadziałało. Będę walczył dla ciebie, kapitanie Koronników, i będę walczył dobrze.%SPEECH_OFF%Kiwając głową prosisz, by opuścił ostrze. Obraca je w dłoni i jednym ruchem chowa. Wstaje, rozbierając się do naga.%SPEECH_ON%To życie porzucam całkowicie, a życiu Koronnika poświęcę się w pełni.%SPEECH_OFF%Ściskasz mu dłoń. Przechodzień zerka i drapie się po głowie.%SPEECH_ON%Zaraz, masz tam węża! Myślałem, że jesteś damą tańca, ale to...%SPEECH_OFF%Ociera czoło szmatką i ścisza głos.%SPEECH_ON%To czyni to jeszcze lepszym.%SPEECH_OFF%Tancerz patrzy na ciebie i śmieje się.%SPEECH_ON%Wszyscy mamy niebezpieczeństwa do stawienia czoła w swoich zajęciach, Koronniku, i czekam, by zobaczyć twoje.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj w kompanii!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Mówisz tancerzowi, że jest jednym z najlepszych, jakich widziałeś z ostrzem. Śmieje się.%SPEECH_ON%To naprawdę dobrze intencjonowana próba z twojej strony, Koronniku, by wciągnąć mnie w twój tryb życia. Ale dobrze wiesz, że nie ma nic, co mógłbyś powiedzieć lub zrobić, by odciągnąć mnie od tego życia. Tak, ostrze mi pasuje, ale równie dobrze pasuje mi krążenie pośród tłumu i zdobywanie uznania bez rozlewu krwi. Ty idź bawić się w gladiatora na piaskach i zarabiaj swoje monety, Koronniku, a ja będę tu zarabiał swoje.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Musiałem zapytać.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Oferujesz tancerzowi pięćset koron. On dalej podnosi monety - po jednej - i wkłada je do glinianego dzbana. To niemal cichy rytuał, monety głośno brzęczą, wpadając do prawie pustego naczynia z gliny. Spogląda w górę, spogląda w dół. Wkłada jeszcze jedną koronę i wstaje. Zdejmuje ubranie i wyciąga rękę.%SPEECH_ON%Gilded musi błyszczeć nad nami obojgiem, skoro dorobiłeś się takiego zarobku, i bez wątpienia poprowadził twoją sakiewkę tu, by trafiła do mnie.%SPEECH_OFF%Kiwasz głową i ściskasz mu dłoń. Przechodzień zerka i drapie się po głowie.%SPEECH_ON%Zaraz, masz tam węża! Myślałem, że jesteś damą tańca, ale to...%SPEECH_OFF%Ociera czoło i ścisza głos.%SPEECH_ON%To czyni to jeszcze lepszym.%SPEECH_OFF%Wzdychając, tancerz prosi, by mógł rzucić okiem na twój ekwipunek.%SPEECH_ON%Ciało takie jak moje, wszystko będzie pasować, od środka czy z zewnątrz, poradzę sobie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj w kompanii!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Wydajesz [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] koron"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getMoney() < 750)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= 4 && t.isAlliedWithPlayer())
			{
				this.m.Town = t;
				break;
			}
		}

		if (this.m.Town == null)
		{
			return;
		}

		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Dude = null;
	}

});

