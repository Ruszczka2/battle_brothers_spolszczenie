this.graverobber_heist_event <- this.inherit("scripts/events/event", {
	m = {
		Graverobber = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.graverobber_heist";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%graverobber%, brudny grabarz, wchodzi do twojego namiotu z rękami za plecami. Nie chcesz dłużej zwlekać z szaleństwem, które przed tobą stoi, więc pytasz, czego chce.%SPEECH_ON%Panie... ja... ja usłyszałem, że lokalny baron - bogaty człowiek, bez dwóch zdań! - został niedawno pochowany na cmentarzu niedaleko stąd.%SPEECH_OFF%Odchylasz się na krześle i wzruszasz ramionami. On mówi dalej.%SPEECH_ON%Ja... nie chcę prosić innych o pomoc, bo patrzą na mnie jak na jakąś potworność. Ale ty... ty jesteś inny. W końcu mnie zatrudniłeś.%SPEECH_OFF%Pochylasz się do przodu, napinając zbroję, a krzesło pod tobą jęczy drewnianym skrzypnięciem.%SPEECH_ON%Niech zgadnę: chcesz, żebym pomógł ci wykopać grób tego barona.%SPEECH_OFF%Mężczyzna uśmiecha się żałośnie, jak pies, którego kiedyś zganiłeś za kradzież ciastka.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eee, może innym razem.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
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
					Text = "Ja tego nie zrobię, i ty też nie.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Pójdę po łopatę!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]Usprawiedliwiając się z wyprawy, wracasz do pracy. Czas płynie, ćmy krążą w powtarzalnych pętlach wokół świecy, która opada coraz niżej, a jej szklany płomień tak łatwo drga od ruchu skrzydeł stworzeń wokół. W końcu %graverobber% wraca, wnosząc do namiotu niewielką skrzynię. Wygląda bardziej jak błoto niż człowiek.%SPEECH_ON%Mam to, panie!%SPEECH_OFF%Grabarz szybko spogląda za siebie, po czym mówi znów, tym razem nieco ciszej.%SPEECH_ON%Mam to... mam wszystko. Słuchaj, podzielę się z tobą. To znaczy, nie pomogłeś mi ominąć strażnika, ani odgarnąć ziemi, ani wyciągnąć ciała, ani wyciągnąć skrzyni, ani włożyć trumny z powrotem, ani zasypać trumny, ani ominąć strażnika drugi raz, ani zaciągnąć skrzyni do obozu... ale pozwoliłeś mi to zrobić!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Właśnie tak.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local money = this.Math.rand(50, 150);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Otrzymujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Koron"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]Usprawiedliwiając się z wyprawy, wracasz do pracy. Czas płynie, ćmy krążą w powtarzalnych pętlach wokół świecy, która opada coraz niżej, a jej szklany płomień tak łatwo drga od ruchu skrzydeł stworzeń wokół. W końcu %graverobber% wraca, a pierwszym znakiem jego obecności jest drgający brzeg klapy namiotu. Odkładasz pióro i każesz mu wejść. Wchodzi dość niepewnie, jak człowiek przekraczający próg, którego wolałby nie przekraczać. Nawet w przyćmionym świetle świecy widzisz barwy, które mrok zwykle dobrze skrywa: fiolety, błękity i ciemne czerwienie. Uśmiecha się nieśmiało.%SPEECH_ON%Oni, eee, złapali mnie, panie.%SPEECH_OFF%Kiwasz głową.%SPEECH_ON%Tak, widzę.%SPEECH_OFF%Mężczyzna szybko unosi palec, a kleks błota leci w bok, lądując z mokrym plaskiem.%SPEECH_ON%Ale następnym razem!%SPEECH_OFF%Zatrzymujesz go uniesioną dłonią.%SPEECH_ON%Może idź się opatrzyć, a potem porozmawiamy o tym \"następnym razem\", tak?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I uważaj, by wychodząc nie chlapać więcej błotem.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury2 = _event.m.Graverobber.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury2.getIcon(),
						text = _event.m.Graverobber.getName() + " doznaje " + injury2.getNameOnly()
					});
				}
				else
				{
					_event.m.Graverobber.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Graverobber.getName() + " doznaje lekkich ran"
					});
				}

				_event.m.Graverobber.worsenMood(0.5, "Got beaten up in " + _event.m.Town.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]%townname% nie jest filarem, na którym chcesz poświęcać swoje dobre imię w świecie - a przynajmniej to, jakie dobre imię może mieć najemnik. Mówisz %graverobber%, że nie tylko nie będziesz mu towarzyszył, ale też nie pozwolisz mu iść i zrobić tego samemu. Marszczy się jak młody myśliwy, któremu zły ojciec zabrał łuk.%SPEECH_ON%Cóż... no dobrze... to tylko bogactwa...%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wracaj do roboty.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				_event.m.Graverobber.worsenMood(1.0, "Was forbidden to rob a grave");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_33.png[/img]Ty i %graverobber% skradacie się nisko przez krzaki, niezgrabny duet absurdu, sylwetki mętne, niosące oczywistą psotę nawet w najciemniejszą noc. Wchodzicie na cmentarz, jakbyście przypadkiem się tu znaleźli, wesoło udając, że to, co za chwilę nastąpi, na pewno nie może być dziełem takich dziwaków jak wy.\n\n Wokół cmentarza stoją rzędy szarych płyt i marmurowych posągów bez twarzy, a czarne żelazne bramy skrzypią na wietrze. Wszędzie wysoka trawa, nawozu pod dostatkiem. Kwiaty uprawiane na miejscu i inne przyniesione z zewnątrz, a niektóre po trochu jedno i drugie.\n\nZaciskając usta, grabarz odwraca się. Wbija łopatę w ziemię i opiera pięści na biodrach.%SPEECH_ON%Cholera.%SPEECH_OFF%Wy czuwając nad sytuacją, pytasz, co jest nie tak. Pluje i odpowiada.%SPEECH_ON%Nie pamiętam, czy to ten grób, tamten, czy tamten.%SPEECH_OFF%Wskazuje trzy różne miejsca: jedno to skromny kamień, wyblakły i ogołocony, upamiętniający śmierć; drugie ogrodzone jest gotyckimi wieżyczkami; trzecie to po prostu drzwi do mauzoleum. Grabarz odwraca się do ciebie.%SPEECH_ON%Pewnie nie mamy tu dużo czasu, który grób, twoim zdaniem?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wykopiemy skromny grób.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							return "F";
						}
						else
						{
							return "I";
						}
					}

				},
				{
					Text = "Przebijemy się przez gotyckie ogrodzenie.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							return "G";
						}
						else
						{
							return "I";
						}
					}

				},
				{
					Text = "Włamiemy się do mauzoleum.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							return "H";
						}
						else
						{
							return "I";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_33.png[/img]Ty i %graverobber% skradacie się nisko przez krzaki, niezgrabny duet absurdu, sylwetki mętne, niosące oczywistą psotę nawet w najciemniejszą noc. Wchodzicie na cmentarz, jakbyście przypadkiem się tu znaleźli, wesoło udając, że to, co za chwilę nastąpi, na pewno nie może być dziełem takich dziwaków jak wy.\n\n Wokół cmentarza stoją rzędy szarych płyt i marmurowych posągów bez twarzy, a czarne żelazne bramy skrzypią na wietrze. Wszędzie wysoka trawa, nawozu pod dostatkiem. Kwiaty uprawiane na miejscu i inne przyniesione z zewnątrz, a niektóre po trochu jedno i drugie.\n\nZaciskając usta, grabarz odwraca się. Wbija łopatę w ziemię i opiera pięści na biodrach.%SPEECH_ON%Cholera.%SPEECH_OFF%Wy czuwając nad sytuacją, pytasz, co jest nie tak. Pluje i odpowiada.%SPEECH_ON%Nie pamiętam, czy to ten grób, tamten, czy tamten.%SPEECH_OFF%Wskazuje trzy różne miejsca: jedno to skromny kamień, wyblakły i ogołocony, upamiętniający śmierć; drugie ogrodzone jest gotyckimi wieżyczkami; trzecie to po prostu drzwi do mauzoleum. Grabarz odwraca się do ciebie.%SPEECH_ON%Pewnie nie mamy tu dużo czasu, który grób, twoim zdaniem?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wszystko na nic.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				_event.m.Graverobber.worsenMood(0.5, "Had no success robbing a grave with you");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_33.png[/img]Jednym szybkim uderzeniem łopaty rozbijasz gotycką bramę. Metaliczny dźwięk rozchodzi się między nagrobkami, a kołyszące się gałęzie drzew zdają się szydzić z twojego głośnego wtargnięcia. Gdy otwierasz bramę, zawiasy zawodzą, jakby obudziły się duchy. Wchodzisz na mały kwadratowy skwer i opierasz się o wieżyczki ogrodzenia. Krótki rozkaz wystarcza, by %graverobber% wziął się do pracy, a ty czuwasz niczym człowiek nieporuszony naturą własnych zbrodni. Po kilku minutach skrupulatnego kopania rabusiów kończy. Znajdujecie bardzo dużą trumnę, której nie da się wyciągnąć z ziemi, przynajmniej nie we dwóch.\n\n Tym samym sposobem, którym uderzyłeś bramę, zrywasz zatrzaski trumny i otwierasz ją. Świeżo zmarły mężczyzna patrzy na ciebie, a w jego oczodołach tkwią dwa kamienie pomalowane na oczy. Widok cię zaskakuje, ale szybko zaczynasz przeszukiwać jego dobytek. Okazuje się, że %graverobber% miał rację: mężczyzna został pochowany z wielkimi sakwami złota i kielichami, nawet złotymi kielichami. Zabierasz wszystko, zamykasz trumnę i wymykasz się z cmentarza.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Skarby!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local money = this.Math.rand(200, 500);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Otrzymujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Koron"
					}
				];
				_event.m.Graverobber.improveMood(1.0, "Found treasure while robbing a grave");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_33.png[/img]Wchodzisz do mauzoleum jak człowiek, który boi się, że drzwi za nim mogą na zawsze się zatrzasnąć. Trumna spoczywa na marmurowej płycie, a przy jej czterech rogach palą się świece. Choć na zewnątrz nie ma wiatru, słyszysz jego cichy jęk krążący po pomieszczeniu. Odpędzając strach, ty i %graverobber% zsuwacie wieko trumny, uważając, by nie spadło na drugą stronę i nie obudziło, zapewne, połowy miasta.\n\n W sarkofagu znajdujesz człowieka ubranego jak rycerz: hełm, napierśnik i tarcza. Miecz leży na jego ciele od szyi po pachwiny, a dłonie są zaciśnięte na rękojeści w gotowym do walki uścisku. Spoglądasz na %graverobber%, który wzrusza ramionami.%SPEECH_ON%Pewnie ten facet był rycerzem.%SPEECH_OFF%Kiwając głową, patrzysz, jak grabarz zerka z martwego na żywego.%SPEECH_ON%Pewnie... temu rycerzowi nie potrzeba już tego sprzętu...%SPEECH_OFF%Skoro i tak nie zamierzasz wyjść z pustymi rękami, znów kiwasz głową. Martwy rycerz stawia spory opór, gdy %graverobber% usiłuje go pozbawić tego, czego już nie potrzebuje. Po kilku minutach walki pomagasz zdjąć hełm. Wypada z niego wielki kosmyk blond włosów. %graverobber% cofa się.%SPEECH_ON%To kobieta!%SPEECH_OFF%Nagle z zewnątrz cmentarza rozlegają się głosy. Chwytasz wszystko, co się da, i każesz grabarzowi uciekać.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Skarby!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local item;
				local r = this.Math.rand(1, 3);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/arming_sword");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/helmets/decayed_full_helm");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/armor/decayed_coat_of_plates");
				}

				item.setCondition(item.getCondition() / 2);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Otrzymujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Graverobber.improveMood(1.0, "Found treasure while robbing a grave");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_33.png[/img]Gdy tylko chwytasz łopatę, odzywa się męski głos.%SPEECH_ON%A co wy, do diabła, myślicie, że robicie?%SPEECH_OFF%Odwracasz się i widzisz mężczyznę zapalającego latarnię. Unosi ją, a uchwyt skrzypi, gdy latarnia kołysze się w przód i w tył.%SPEECH_ON%Wyglądacie mi na rabusiów grobów.%SPEECH_OFF%%graverobber% wyciąga nóż z pasa. Strażnik wyciąga dzwonek z własnego pasa, duży, okrągły instrument, który lśni złotem od strony światła latarni i bielą od strony księżyca.%SPEECH_ON%Możecie iść za mną, ale najpierw dam temu dzwonkowi porządnie zadzwonić. A następny dzwon, który usłyszycie, zadzwoni już za was.%SPEECH_OFF%Łapiesz %graverobber% za kołnierz i każesz mu odejść. Nie ma sensu robić kłopotów. Strażnik szczeka za tobą, gdy odchodzisz.%SPEECH_ON%Zapamiętam wasze twarze! Jak kopnięty pies pamięta but, który go skopał, tak ja zapamiętam wasze twarze!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Żenujące.",
					function getResult( _event )
					{
						this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationOffense, "You and your men attempted to rob a local grave");
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				_event.m.Graverobber.worsenMood(0.5, "Was caught trying to rob a grave");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_graverobber = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				candidates_graverobber.push(bro);
			}
		}

		if (candidates_graverobber.len() == 0)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getSize() >= 2 && t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
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
		this.m.Graverobber = candidates_graverobber[this.Math.rand(0, candidates_graverobber.len() - 1)];
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"graverobber",
			this.m.Graverobber.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Graverobber = null;
		this.m.Town = null;
	}

});

