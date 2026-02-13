this.runaway_harem_event <- this.inherit("scripts/events/event", {
	m = {
		Citystate = null
	},
	function create()
	{
		this.m.ID = "event.runaway_harem";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_170.png[/img]{Napotykasz nieliczną grupę nomadów kłócących się z oddziałem ludzi wezyra. Między nimi stoi inna grupa kobiet, wyglądających na takie, które mogłyby być w haremie wezyra. Gdy się zbliżasz, wszyscy milkną i wpatrują się w ciebie. Porucznik oddziału wezyra macha na ciebie ręką.%SPEECH_ON%To cię nie dotyczy, Koroniarzu.%SPEECH_OFF%Nomadzi, być może chcąc wciągnąć cię w sprawę, wyjaśniają: kobiety to \'dłużniczki\', których służba należy się innym za przewinienia lub uchybienia. W tym przypadku są winne służbę wezyrowi. Jednak uciekły, a nomadzi, którzy uważają ideę dłużnictwa za herezję, przyjęli je pod swój dach.%SPEECH_ON%Ej, Koroniarzu! Nie słuchaj ani słowa tego nomadzkiego jadu! A ty, nomado, te kobiety idą z nami, albo WSZYSCY tu zginiecie.%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wolałbym się w to nie mieszać.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Kobiety należą do wezyra.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Kobiety są wolne i mogą iść, gdzie zechcą.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.Citystate.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_170.png[/img]{Wyciągasz miecz i każesz ludziom wezyra się wynosić, licząc, że to zadziała, bo każda przemoc z nimi nie obejdzie się bez sporego rozlewu krwi. Na szczęście się wycofują. Porucznik kłania się szyderczo.%SPEECH_ON%Kobiety są wolne, ale z nieopłaconymi długami wobec Gildera będą płonąć w jamach gorejącego piasku, w piekle, z którego nie ma ucieczki!%SPEECH_OFF%Śmiejąc się, dziękujesz mu za obrazowe słowa. Nomadzi również ci dziękują, podobnie jak uwolnione kobiety, choć bardziej oczami niż słowami. Jeden nomada wręcza ci dar w postaci skarbów.%SPEECH_ON%Nosimy je nie dla siebie, lecz na czas, gdy spotkamy wędrowców takich jak ty. Nie szukamy pociech w rzeczach materialnych, nie na tym świecie. I nie ufaj temu człowiekowi wezyra. Kłamie. Gilder ujrzy nas wszystkich w chwale, gdy nadejdzie nasz czas.%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cieszcie się wolnością.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.Citystate.getUIBannerSmall();
				this.World.Assets.addMoralReputation(1);
				this.World.Assets.addMoney(100);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]100[/color] koron"
					}
				];
				_event.m.Citystate.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Pomogłeś w ucieczce haremu wezyra");
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_170.png[/img]{Wiesz, kiedy widzisz dobry zarobek, a przez zarobek rozumiesz ambasadora wezyra. Wyciągasz miecz i wskakujesz między nomadów a kobiety, każąc tym pierwszym się wycofać i wrócić na pustynię. Nomadzi naciągają łuki i podnoszą włócznie, ale ich przywódca ich ucisza.%SPEECH_ON%Nie, przybysz interweniował w sposób, który uznał za najbardziej właściwy, i z pewnością Gilder wybrał go na rozjemcę w tej sprawie z dobrego powodu. Zabierzcie kobiety, a spór jest zakończony.%SPEECH_OFF%Ludzie wezyra zbierają harem z powrotem w swoje szeregi. Porucznik przynosi ci ciężki worek.%SPEECH_ON%Zapłata, Koroniarzu. To nie było twoje zadanie, ale to nie znaczy, że nie ma nagrody. Uratowałeś te dłużniczki przed piekielnym ogniem Gildera. Niech nasza hojność będzie stałym przypomnieniem na przyszłość, tak?%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Liczymy na dalsze interesy z twoim panem.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.Citystate.getUIBannerSmall();
				this.World.Assets.addMoney(150);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]150[/color] koron"
					}
				];
				_event.m.Citystate.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Pomogłeś w powrocie haremu wezyra");
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_170.png[/img]{Kręcisz głową i życzysz kobietom wszystkiego najlepszego, ale sprawa rozwiązuje się, zanim zdążysz odejść: nomadzi ustępują, a ludzie wezyra zabierają kobiety. Gdy pytasz nomadów, czemu tak szybko odpuścili, ich przywódca mówi, że musiałeś być rozjemcą zesłanym przez samego Gildera, więc jeśli tak wybrałeś, niech tak będzie. Wygląda na to, że nomadzi nigdy nie mieli szans z tymi zawodowymi żołnierzami, a ty byłeś ich ostatnią nadzieją.}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak już jest.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.Citystate.getUIBannerSmall();
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

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local bestTown;
		local bestDistance = 9000;

		foreach( t in towns )
		{
			local d = currentTile.getDistanceTo(t.getTile());

			if (d <= bestDistance)
			{
				bestDistance = d;
				bestTown = t;
			}
		}

		if (bestTown == null || bestDistance < 7)
		{
			return;
		}

		this.m.Citystate = bestTown.getOwner();
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
		this.m.Citystate = null;
	}

});

