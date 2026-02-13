this.trade_black_book_event <- this.inherit("scripts/events/event", {
	m = {
		Translator = null
	},
	function create()
	{
		this.m.ID = "event.trade_black_book";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Do obozu podchodzi mężczyzna. Wychodzisz z namiotu i widzisz go stojącego z dłońmi opartymi na złotej włóczni, której drzewce rozgałęzia się w ostre kolce. Choć broń wygląda groźnie, przy jej końcach wiszą dwa dzbany z wodą i złote bibeloty, nadając jej też inne zastosowanie. Mężczyzna odrzuca płaszcz, ukazując bardzo osobliwą, bladą twarz bez choćby jednego włosa na skórze. Przedstawia się nienaganną wymową.%SPEECH_ON%Witaj, nieznajomy, nazywam się Yuchi Eveohtse. Szukam w tych ziemiach dwóch rzeczy, z których jedna, jak zrozumiałem, jest w twoim posiadaniu. To głęboki tekst o naturze, nie, o samym istnieniu śmierci. Wierzę, że jeden z twoich ludzi odsłonił już część jego tajemnic i w tej chwili ma on dla ciebie niewielką wartość.%SPEECH_OFF%%translator% przytakuje, stwierdzając, że dopóki wpatruje się w strony, nic więcej z nich nie wyciągnie i wątpi, by ktokolwiek mógł. Yuchi gwiżdże, a ty spoglądasz na niego. Mężczyzna unosi trzy palce.%SPEECH_ON%W zamian za księgę oferuję jedno z następujących: albo złotą tarczę, którą wierni tych ziem nazywają Uściskiem Gildera, albo moje dwa dzbany, które po wypiciu wzmocnią człowieka w sposób, jakiego sobie nie wyobrażasz, albo, skoro jesteście najemnikami, sumę 50 000 koron.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wymieniamy księgę na złotą tarczę.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Wymieniamy księgę na dwa dzbany.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Wymieniamy księgę na 50 000 koron.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Translator.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "A2",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Do obozu podchodzi mężczyzna. Wychodzisz z namiotu i widzisz go stojącego z dłońmi opartymi na złotej włóczni, której drzewce rozgałęzia się w ostre kolce. Choć broń wygląda groźnie, przy jej końcach wiszą dwa dzbany z wodą i złote bibeloty, nadając jej też inne zastosowanie. Mężczyzna odrzuca płaszcz, ukazując bardzo osobliwą, bladą twarz bez choćby jednego włosa na skórze. Przedstawia się nienaganną wymową.%SPEECH_ON%Witaj, nieznajomy, nazywam się Yuchi Eveohtse. Szukam w tych ziemiach dwóch rzeczy, z których jedna, jak zrozumiałem, jest w twoim posiadaniu. To głęboki tekst o naturze, nie, o samym istnieniu śmierci.%SPEECH_OFF%Mężczyzna unosi trzy palce.%SPEECH_ON%W zamian za księgę oferuję jedno z następujących: albo złotą tarczę, którą wierni tych ziem nazywają Uściskiem Gildera, albo moje dwa dzbany, które po wypiciu wzmocnią człowieka w sposób, jakiego sobie nie wyobrażasz, albo, skoro jesteście najemnikami, sumę 50 000 koron.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wymieniamy księgę na złotą tarczę.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Wymieniamy księgę na dwa dzbany.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Wymieniamy księgę na 50 000 koron.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Yuchi kłania się na ułamek chwili, a gdy prostuje się, trzyma tarczę. Na pierwszy rzut oka wygląda jak zwykła stal z ozdobnymi złoceniami na krawędziach, ale nagle po zewnętrznym rancie krąży kula żółtego światła, wirując w kółko.%SPEECH_ON%Nazywają ją Uściskiem Gildera, bo mówi się, że boskość samego Boga została ujęta w jej ramy. Widzisz, gdybyś zwrócił ją przeciw wrogom, światło rozbłysłoby tak oślepiająco, że nic by nie widzieli. A jak sam widzisz, teraz światło jest przytłumione, bo nie jesteśmy wrogami, nieznajomy.%SPEECH_OFF%Mężczyzna wyciąga dłoń. Dajesz mu księgę, a on daje ci tarczę. Nawet na księgę nie patrzy, tylko chowa ją i zabiera włócznię. Pytasz, co zamierza zrobić z tekstem. Uśmiecha się.%SPEECH_ON%Kto wie. Może po prostu ją zwrócę, hm? A może nie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Po co było to drugie, po które przyszedłeś?",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local book;

				foreach( item in this.World.Assets.getStash().getItems() )
				{
					if (item != null && item.getID() == "misc.black_book")
					{
						book = item;
						break;
					}
				}

				this.World.Assets.getStash().removeByID("misc.black_book");
				this.List.push({
					id = 10,
					icon = "ui/items/" + book.getIcon(),
					text = "Tracisz " + book.getName()
				});
				local item = this.new("scripts/items/shields/legendary/gilders_embrace_shield");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Yuchi przechyla złoconą włócznię do przodu. Jej ostrość jest niesamowita, jak coś, o czym kowal może marzyć, ale czego żadna śmiertelna ręka nie potrafi wytworzyć. Para dzbanów zsuwa się, a on łapie je za paski i wyciąga do ciebie. Dajesz mu księgę, a on puszcza dzbany. Nie chcąc zostać otrutym, prosisz, by napił się z obu dzbanów, co czyni bez wahania. Ocierając usta, kiwa głową.%SPEECH_ON%Jestem bardzo przywiązany do jego smaku i działania, proszę, nie marnuj więcej na swoje podejrzenia i wahania.%SPEECH_OFF%Mężczyzna chowa księgę w płaszczu, zbiera swój sprzęt i zaczyna odchodzić. Pytasz, co planuje zrobić z tekstem. Uśmiecha się.%SPEECH_ON%Kto wie. Może po prostu ją zwrócę, hm? A może nie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Po co było to drugie, po które przyszedłeś?",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local book;

				foreach( item in this.World.Assets.getStash().getItems() )
				{
					if (item != null && item.getID() == "misc.black_book")
					{
						book = item;
						break;
					}
				}

				this.World.Assets.getStash().removeByID("misc.black_book");
				this.List.push({
					id = 10,
					icon = "ui/items/" + book.getIcon(),
					text = "Tracisz " + book.getName()
				});
				local item = this.new("scripts/items/special/trade_jug_01_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.World.Assets.getStash().makeEmptySlots(1);
				item = this.new("scripts/items/special/trade_jug_02_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Yuchi kiwa głową.%SPEECH_ON%Daj mi księgę i przynieś skarbiec wojenny.%SPEECH_OFF%Rzucasz mu tekst, a potem każesz przynieść skarbiec kompanii. Rozkłada oba rękawy płaszcza i powoli je przechyla. Z rękawów płyną korony, zdawałoby się bez końca, po czym w jednej chwili podnosi ramiona.%SPEECH_ON%Twoje %reward% koron powinno tam być.%SPEECH_OFF%Liczysz monety i jest dokładnie tyle. Podnosisz wzrok, by powiedzieć, że ma szczęście, ale mężczyzna już zbiera swoje rzeczy i szykuje się do odejścia.%SPEECH_ON%Uważaj na siebie, nieznajomy.%SPEECH_OFF%Zanim odejdzie, pytasz, co planuje zrobić z tekstem. Uśmiecha się.%SPEECH_ON%Kto wie. Może po prostu ją zwrócę, hm? A może nie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Po co było to drugie, po które przyszedłeś?",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local book;

				foreach( item in this.World.Assets.getStash().getItems() )
				{
					if (item != null && item.getID() == "misc.black_book")
					{
						book = item;
						break;
					}
				}

				this.World.Assets.getStash().removeByID("misc.black_book");
				this.List.push({
					id = 10,
					icon = "ui/items/" + book.getIcon(),
					text = "Tracisz " + book.getName()
				});
				this.World.Assets.addMoney(50000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]50 000[/color] koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Yuchi odwraca się.%SPEECH_ON%Hm?%SPEECH_OFF%Wyjaśniasz, że mówił, iż przybył do tych ziem po dwie rzeczy. Jedną była księga, a co było drugie? Uśmiecha się.%SPEECH_ON%W tych stronach było miasto o nazwie Dagentear. Miasta już nie ma, ale coś, co tam żyło, wciąż wędruje. Istota, którą nazywają \"Upiorem\". Chcę ją odnaleźć i z nią porozmawiać.%SPEECH_OFF%Gdy prosisz o więcej informacji, po prostu żegna się eleganckim ukłonem.%SPEECH_ON%Dziękuję za łagodne interesy, nieznajomy.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mam nadzieję, że dobrze zrobiliśmy, oddając mu tę księgę...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsLorekeeperTradeMade", true);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.Flags.get("IsLorekeeperDefeated"))
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local hasBlackBook = false;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.black_book")
			{
				hasBlackBook = true;
				break;
			}
		}

		if (!hasBlackBook)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.militia")
		{
			local brothers = this.World.getPlayerRoster().getAll();
			local candidates_mad = [];

			foreach( bro in brothers )
			{
				if (bro.getSkills().hasSkill("trait.mad"))
				{
					candidates_mad.push(bro);
					break;
				}
			}

			if (candidates_mad.len() == 0)
			{
				return;
			}

			this.m.Translator = candidates_mad[this.Math.rand(0, candidates_mad.len() - 1)];
		}

		this.m.Score = 150;
	}

	function onPrepare()
	{
	}

	function onDetermineStartScreen()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.militia")
		{
			return "A2";
		}
		else
		{
			return "A";
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"translator",
			this.m.Translator != null ? this.m.Translator.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Translator = null;
	}

});

