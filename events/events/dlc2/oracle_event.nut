this.oracle_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.oracle";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_11.png[/img]{Natrafiasz przy drodze na namiot z koziej skóry. Skóry zostały zanurzone w purpurowych barwnikach, a w węzły z koziej sierści wpleciono świeże stokrotki. Na zewnątrz stoi garbata starucha z dłońmi złożonymi i zwisającymi wzdłuż ciała. Mierzy cię wyschniętym wzrokiem od stóp do głów.%SPEECH_ON%Ach, najemnik. Nie, kapitan najemników. A może coś więcej. Czuję od ciebie dziwny zapach, nie tylko mężczyzny. Chcesz, abym przepowiedziała ci los?%SPEECH_OFF%Wskazuje wnętrze namiotu. Widzisz kilka długich kart rozłożonych na stole obrazem do dołu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powiedz mi mój los, starucho.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 20 && this.World.getTime().Days > 15)
						{
							return "D";
						}
						else if (r <= 80)
						{
							return "E";
						}
						else
						{
							return "F";
						}
					}

				},
				{
					Text = "Ja powiem ci twój: zaraz oddasz nam wszystkie kosztowności.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "Nie, obejdziemy się.",
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
			Text = "[img]gfx/ui/events/event_11.png[/img]{Taka czytelniczka kart jak ta pewnie robiła niezły interes, dość, byś nie miał nic przeciwko temu, by wziąć go dla siebie. Każesz kompanii splądrować to miejsce. Kobieta nic nie mówi, gdy odsuwasz ją na bok, i nic nie mówi, gdy najemnicy oblegają namiot i przechylają słup na ziemię. Uśmiecha się lekko, kiedy zrzucają kozią płachtę, by zobaczyć łup, jak magicy odsłaniający nieudany trik. Uśmiech znika, gdy zaczynają grzebać w jej rzeczach, a ich buty miażdżą i tłuką wszystko, co bezużyteczne. Wiedźma wzrusza ramionami i unosi dwie karty, jakby wyjęte prosto z rękawów.%SPEECH_ON%Powiedz mi, najemniku, co widzisz?%SPEECH_OFF%Przyglądasz się. Karty tarota przedstawiają grupę rycerzy plądrujących wioskę, a druga ukazuje cmentarz strzeżony przez szczególnie surowego strażnika. Wzruszasz ramionami i mówisz jej, że trzyma te dwie karty na takie właśnie okazje i nie jesteś głupcem, który uwierzy w bezradną wiedźmę rozjeżdżaną na drodze. Mówisz jej, że może przestraszyła tym trikiem kilku rabusiów, ale ciebie tak łatwo nie oszuka. Śmieje się.%SPEECH_ON%Jesteś tak samo mądry, jak okrutny.%SPEECH_OFF%Dokładnie tak. A teraz zobaczmy, co kompania znalazła.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wracajmy na drogę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local money = this.Math.rand(75, 200);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_11.png[/img]{Dobrze się rozglądasz. Gdyby starucha miała gdzieś zasadzkę, na pewno byś ją zauważył. Machasz ręką i rozkazujesz kompanii splądrować jej miejsce. Kilku braci wślizguje się do namiotu i zaczyna go rozbierać, przewracając stoły i wyciągając szuflady. Stara kobieta odsuwa się, i odsuwa, i odsuwa. Ona... się uśmiecha?%SPEECH_ON%Hej, spójrzcie na to!%SPEECH_OFF%Odwracasz się i widzisz jednego z najemników, który chwyta kulę wiszącą u sufitu namiotu. Szarpie ją. Łańcuch napina się, zahacza, słychać brzęk pękającego drutu. Niebieskie iskry pędzą po łańcuchu i zygzakiem spływają prosto do kuli. Nic nie słyszysz. Namiot rozrywa się w błysku niebieskiego płomienia, słup strzela w niebo, a sylwetki najemników potykają się w gorącym dymie. Szare i płonące stokrotki wirują w powietrzu. Przecierasz uszy, by odzyskać słuch, po czym rozglądasz się za kobietą, ale jej już nie ma. Zaciskasz usta i pędzisz sprawdzić szkody.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wracajmy na drogę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " odnosi lekkie rany"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_11.png[/img]{Gdy wchodzisz, namiot zamyka się za tobą. Pomarańczowa poświata migocze od latarni. Stękając, starucha pochyla się nad nią ze świecznikiem i poszerza światło na stół i dwa krzesła. Wskazuje je.%SPEECH_ON%Siadaj.%SPEECH_OFF%Siadasz. Ona siada. Mlaska bezzębnymi dziąsłami, kiwa głową i zaczyna przerzucać karty.%SPEECH_ON%Najpierw jest...%SPEECH_OFF%Pochylasz się, by lepiej zobaczyć, a stół łamie się pod twoim ciężarem. Karty fruwają, kobieta przewraca się do tyłu, a świeca leci w górę. Jedną ręką chwytasz świecznik w powietrzu, a drugą ratujesz ją przed upadkiem. Sadzasz ją z powrotem i oddajesz świecę. Wpatruje się w ciebie, uśmiechając się czarną obwódką uśmiechu, oczy mruży w kropki.%SPEECH_ON%Zapomnijmy, że to się stało, i uznajmy, że dostajesz wszystko, o czym kiedykolwiek marzyłeś, najemniku, zaczynając od tego.%SPEECH_OFF%Daje ci śliniasty pocałunek w czoło i szturcha cię rękojeścią sztyletu.%SPEECH_ON%Umowa!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co za kobieta.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/named/named_dagger");
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_11.png[/img]{Wchodzisz do namiotu. Zaniepokojony %randombrother% zagląda, gdy fałdy zamykają jego i resztę świata na zewnątrz. Starucha zapala świecę i niesie ją do swojego miejsca. Paradoksalnie, jej starcze kształty stają się w mroku jeszcze bardziej wyraziste, gdy cienie znajdują szczeliny, o których nie wiedziałeś, że mogą istnieć na człowieku, a jej skóra lśni trwałym blaskiem. Od razu zaczyna przerzucać karty i mówić.%SPEECH_ON%Porażka. Przypuszczenia. Wątpliwość.%SPEECH_OFF%Źle namalowani rycerze pojawiają się i znikają, ich kończyny są przekrzywione w dziwnych pozach.%SPEECH_ON%Więcej porażek. Ale też zwycięstwo. Wiele zwycięstw. Zapominasz o słabości. Męczysz się jej zaraźliwą naturą. Stajesz się potężny. Siła to przetrwanie. I oto jesteś. Stary. Umierasz.%SPEECH_OFF%Unosisz brew, chwytasz ostatnią kartę i wsuwasz ją w światło. Widzisz mężczyznę z długą siwą brodą siedzącego na krześle. Mówisz kobiecie, że nigdy nie potrafiłeś zapuścić brody, a ona gasi świecę i wygania cię z namiotu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powinienem przestać się golić.",
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
			ID = "F",
			Text = "[img]gfx/ui/events/event_11.png[/img]{Wchodzisz do namiotu i jego fałdy zamykają się, a ty stajesz w absolutnej ciemności. Stoisz tak chwilę i pytasz kobietę, gdzie poszła. Zaciskasz usta i uchylasz wejście, by wpuścić trochę światła. Smuga światła odbija się w ciemności i odwracasz się, by zobaczyć sztylet lecący w twoją stronę. Odbijasz go rękawicą, dobywasz miecza i wbijasz go w pierś wiedźmy. Upuszcza nóż i chwyta cię za ramię.%SPEECH_ON%Jaki z ciebie potwór, najemniku, zabijać dobrą staruszkę taką jak ja. Zginiesz za to. Ty i twoi ludzie wszyscy zginiecie.%SPEECH_OFF%Przyciągasz wiedźmę bliżej i widzisz nagle jasne, nikczemne kocie oczy. Plujesz i kiwasz głową.%SPEECH_ON%Wróżenie zagłady w świecie, gdzie wszystko umiera? To nie trudna robota. Wiesz, na czym polega moja praca, wiedźmo?%SPEECH_OFF%Uśmiecha się czarną obwódką bezzębnego uśmiechu. Czarna krew tryska na jej wargi, gdy się śmieje.%SPEECH_ON%Och, najemniku! Zobaczymy, kim będziesz, kiedy Davkul będzie miał cię w swoich rękach.%SPEECH_OFF%Ciało wiedźmy wiotczeje, a twój miecz nagle tnie na wylot, pozostawiając porozcinane mięso zwisające u twoich stóp. Szybko wychodzisz z namiotu i każesz go spalić. Niektórzy z ludzi przysięgają, że widzą twarz kobiety uśmiechającą się w kłębach dymu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Spalić wiedźmę!",
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type == this.Const.World.TerrainType.Snow || currentTile.Type == this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		this.m.Score = 5;
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

