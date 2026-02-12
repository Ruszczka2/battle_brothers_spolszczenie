this.pimp_and_harlots_event <- this.inherit("scripts/events/event", {
	m = {
		Payment = 0
	},
	function create()
	{
		this.m.ID = "event.pimp_and_harlots";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_85.png[/img]Podczas marszu natrafiasz na kobietę stojącą z boku drogi. Stoi na przedzie wozu ciągniętego przez osła. Widząc cię, klaszcze w dłonie i wydaje jakiś rozkaz. Po chwili z tyłu wozu wylewają się dziewczyny i ustawiają się przed tobą. Są źle ubrane i, jeśli to przedstawienie, to kiepsko wyreżyserowane. Większość wygląda, jakby wolała być gdzie indziej, co u kobiet na odludziu jest dość zwyczajne. Pytasz \"przywódczynię\" tej grupy, co robi. Uśmiecha się od ucha do ucha.%SPEECH_ON%Jestem handlarką ciałem, zarabiam na porządnym bzykaniu. Te tutaj to mój towar.%SPEECH_OFF%Wykonuje gest w stronę prostytutek. One prostują się, albo rozluźniają, i udają zainteresowanie tobą oraz twoimi ludźmi. Stręczycielka kiwa głową.%SPEECH_ON%No i co, pomożemy spuścić z was ciśnienie, hm? Długi dzień, co? Przy tylu chłopach postawiłabym, że to będzie niskie %cost% koron.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Masz układ!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 60)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "A może po prostu oddasz kosztowności?",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "Nie, dzięki.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]Mimo protestów części ludzi odmawiasz oferty stręczycielki. Wzrusza ramionami.%SPEECH_ON%Cholera, wiedziałam, że powinnam była zainwestować w inny towar. No cóż, jak sobie chcesz.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "W następnym mieście będzie rozrywka.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.worsenMood(0.75, "Odmówiłeś zapłaty za ladacznice");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_85.png[/img]Kobiety podchodzą bliżej, jedne leniwie mrugając, inne mrugając krzywo z ospałymi oczami. To marna gromada dziewek, ale ludziom przyda się odrobina ulgi. Zgadzasz się na cenę stręczycielki, a ludzie załatwiają resztę, znikając w krzakach i innych osłonach. Gdy się zabawiają, stręczycielka podchodzi do ciebie.%SPEECH_ON%Dzięki, że nas nie okradłeś.%SPEECH_OFF%Wzruszasz ramionami i mówisz, że to wciąż możliwe. Ona też wzrusza ramionami.%SPEECH_ON%Wiem, ale nie sądzę, że to zrobisz. Ty i ja jesteśmy do siebie podobni. Ty walczysz o jedzenie, my rżniemy się o jedzenie.%SPEECH_OFF%Ciekawy, pytasz, czy nadal \"rżnie\" się o jedzenie. Śmieje się.%SPEECH_ON%Tylko gdy muszę. Ta \"rola przywódczyni\" to całkiem niezła fucha. A ty nadal \"walczysz\" o swoje?%SPEECH_OFF%Dajesz jej po prostu prawdę.%SPEECH_ON%Zabiłem bardzo, bardzo wielu ludzi.%SPEECH_OFF%Teraz podchodzi naprawdę blisko i zjeżdża dłonią w dół.%SPEECH_ON%No proszę.%SPEECH_OFF%No proszę, doprawdy.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Warto było.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-_event.m.Payment);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Payment + "[/color] koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.0, "Zabawiał się z ladacznicami");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_07.png[/img]Zgadzasz się na ofertę. Stręczycielka i jej ladacznice podchodzą, wlewając się w wasze szeregi jak stado lubieżnych węży. Zaledwie chwilę po tym, jak większość ludzi ma już spuszczone gacie, z krzaków wychodzi grupa bandytów. Chwytasz miecz, ten z ostrzem, i gołonogi odcinasz złodziejowi głowę od barku, a drugiego przebijasz przez pierś. Pojawiają się kolejni rzezimieszkowie z bronią gotową do walki, ale stręczycielka wskakuje między wszystkich.%SPEECH_ON%Hej! Nie trzeba tu więcej śmierci!%SPEECH_OFF%Część twoich ludzi nadal nie zdaje sobie sprawy, co się dzieje, co jest najlepszym znakiem, że ta baba cię zaskoczyła. Mimo to %companyname% nadal jest siłą natury, w spodniach czy bez, i stręczycielka to rozpoznaje. Łaje najemników.%SPEECH_ON%Myślałam, że mówiłam wam, durnie, żeby nie atakować, jeśli klienci wyglądają groźnie. Nie wyglądają na cholernie groźnych? Do diabła. Słuchaj, najemniku. Wezmę podwójną stawkę i dam wam spokój. Podwójna stawka i idziemy.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dobra, zgoda.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Nie ma mowy.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_07.png[/img]Nie chcesz ryzykować ludzi, więc zgadzasz się na jej warunki. Zabiera pieniądze i kiwa głową.%SPEECH_ON%Większość facetów dałaby się ponieść dumie, ale ty wiesz, jak dbać o bezpieczeństwo ludzi. Sprytny najemnik to dziś rzadkość, a twoi ludzie powinni się cieszyć, że mają cię za przywódcę.%SPEECH_OFF%Gdy zbóje i ladacznice odchodzą, %randombrother% podchodzi, jęcząc.%SPEECH_ON%No cholera. Jestem tak rozgrzany, że mógłbym rozłupać dziewkę na pół.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie musiałem tego wiedzieć.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-_event.m.Payment * 2);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Payment * 2 + "[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_06.png[/img]Nie tyle mówisz \"nie\", co to pokazujesz. Z mieczem w dłoni wymierzasz cios i rozcinasz twarz stręczycielki. Gdy patrzy na ciebie z niedowierzaniem, odwracasz cięcie i odrąbujesz jej głowę. Ludzie, z opuszczonymi spodniami, chwytają swój sprzęt i ruszają do walki. Kilka ladacznic wymachuje sztyletami i zadaje parę pchnięć, ale szybko giną. Większość prostytutek jest bezbronna, lecz w zamieszaniu i chaosie zostaje zarżnięta.\n\nRabusie, którzy pewnie nie spodziewali się prawdziwej walki, żegnają swoje krótkie, gówniane życia. Gdy wszystko się kończy, na polu leży dobrych dwadzieścia trupów, a większość najemników nie wychodzi z tego bez szwanku. Próbujesz uratować z pola, co się da.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chyba nie powinniśmy walczyć z opuszczonymi spodniami.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/weapons/dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/bludgeon");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(100, 300);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						local injury = bro.addInjury(this.Const.Injury.Brawl);
						this.List.push({
							id = 10,
							icon = injury.getIcon(),
							text = bro.getName() + " doznaje " + injury.getNameOnly()
						});
					}
					else
					{
						local injury = bro.addInjury(this.Const.Injury.PiercingBody);
						this.List.push({
							id = 10,
							icon = injury.getIcon(),
							text = bro.getName() + " doznaje " + injury.getNameOnly()
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_07.png[/img]Rozważasz ofertę, po czym uświadamiasz sobie, że to tylko gromada kobiet na odludziu. Mocnym uderzeniem z grzbietu dłoni posyłasz stręczycielkę na ziemię. Pociera policzek i mówi, że takie przepychanki kosztują ekstra. Kiwasz głową.%SPEECH_ON%Tak, kosztuje was wszystko, co macie. Ludzie, bierzcie wszystko.%SPEECH_OFF%Stręczycielka pyta, czy to napad, a ty kiwasz głową. Gdy tylko dajesz jasno do zrozumienia swoje zamiary, z pobliskich krzaków wychodzi grupa uzbrojonych mężczyzn. Stręczycielka wstaje i pociera policzek.%SPEECH_ON%Wciąż jestem skłonna rozstać się tu na neutralnych warunkach, najemniku. Solidny policzek nie stanowi w tym fachu problemu. Nawet się tego spodziewa, ale tak samo jak rabusiów, morderców i gwałcicieli. Jeśli chcesz dalej robić swoje, to naszczuję na ciebie tych ludzi, żeby zrobić to, co muszę, czyli zadbać o bezpieczeństwo moje i moich.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dobra, odpuścimy.",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Ci strażnicy są żałośni. Atak!",
					function getResult( _event )
					{
						return "I";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_64.png[/img]Patrząc na strażników i na swoich ludzi, których nie chcesz stracić przez tę bzdurę, kiwasz głową.%SPEECH_ON%Mądra kobieta. Dobra. Nie ma potrzeby rozlewu krwi.%SPEECH_OFF%Stręczycielka wzdycha z ulgą.%SPEECH_ON%Cieszę się, że doszliśmy do porozumienia. Obawiam się, że moja poprzednia oferta jest nieaktualna. Jestem pewna, że rozumiesz.%SPEECH_OFF%Chowając miecz, mówisz, że tak. Kilku braci spluwa i kręci głowami. Uważają, że przez twoją agresję przegapili niezłą zabawę.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nie widać, że i tak chcieli nas obrabować?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(1.0, "Przez ciebie przegapił niezłą zabawę");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_60.png[/img]Ci \"strażnicy\" są nic nie warci. Każesz ludziom atakować. Walka to krótki zryw akcji. Najęci pachołkowie ladacznic zachowują się tak, jakby nie spodziewali się prawdziwej walki.\n\n Gdy walka się kończy, widzisz, że wóz wciąż tu jest, ale stręczycielka i jej prostytutki zniknęły. Musiały zwinąć się podczas walki. Zabrały nawet osła, szczęściarz.\n\n Twoi ludzie plądrują wóz. Gdy biorą wszystko, co nie jest przybite, %randombrother% słyszy stukanie. Sprawdza spód wozu i pociąga za sznur, opuszczając listwę drewna, z której wypada mężczyzna całkowicie okryty czarną skórą. Odsuwasz maskę z jego twarzy. Wciąga powietrze.%SPEECH_ON%D-dziękuję! Na starych bogów, myślałem, że będą mnie tam trzymać na zawsze!%SPEECH_OFF%Pytasz, kim jest. Wypluwa skórzane strzępy z ust.%SPEECH_ON%Gimp.%SPEECH_OFF%Po prostu \"Gimp\"? Kiwie głową.%SPEECH_ON%Tak, panie. Hej, ładna broń. Zgrabna zbroja też. Hm. Mój pan zniknął, więc...%SPEECH_OFF%Kręcisz głową.%SPEECH_ON%Idź do najbliższego miasta i doprowadź się do porządku, przybyszu.%SPEECH_OFF%Kiwa głową.%SPEECH_ON%Jak sobie życzysz, panie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Tak, tak. Idź.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/weapons/dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/bludgeon");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(100, 300);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							local injury = bro.addInjury(this.Const.Injury.Brawl);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " doznaje " + injury.getNameOnly()
							});
						}
						else
						{
							bro.addLightInjury();
							this.List.push({
								id = 10,
								icon = "ui/icons/days_wounded.png",
								text = bro.getName() + " doznaje lekkich ran"
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 10)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() <= 3)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 50 * brothers.len() * 2 + 500)
		{
			return;
		}

		this.m.Payment = 50 * brothers.len();
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cost",
			this.m.Payment
		]);
	}

	function onClear()
	{
		this.m.Payment = 0;
	}

});

