this.gunpowder_wagon_event <- this.inherit("scripts/events/event", {
	m = {
		Bought = 0
	},
	function create()
	{
		this.m.ID = "event.gunpowder_wagon";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Na horyzoncie pojawia się karawana wielbłądów. Po ich bokach kołyszą się dziesiątki toreb i sakw, a nad nimi niesione są duże parasole. Wielbłądy prowadzi jeden dżokej jadący na przednim zwierzęciu: stary człowiek siedzący bokiem, z jedną stopą w strzemieniu i drugą podtrzymującą talerz. Je orzechy i jagody, popijając chłodny napój. Na twój widok nie robi wrażenia.%SPEECH_ON%Koroniarze, tak? Widać po kroku, po zadziorze alchemików, którzy transmutują surowe złoto w miedzi krwi bliźniego. Nie patrzę na ciebie z góry, Koroniarzu, i ty nie spoglądaj na mnie jak na łup dla rozbójnictwa, które wiem, że kapryśnie pulsuje w twoim sercu.%SPEECH_OFF%Unosi kij z czarną kreską na końcu, zaciśniętym na nim paznokciem.%SPEECH_ON%Wiozę saletrę dla rozmaitych machin wojennych wezyrów. Widzisz, wielkie żeliwne pociski nie lecą wysoko i daleko bez mojego składnika, tego łagodnego pyłu, który wypełnia każdą sakwę moich wielbłądów. Gdybyś pomyślał, że jesteś dzielnym rabusiem, podpalę swoje towary i sprawię, że wszyscy razem zabłyśniemy tak jasno, iż sam Gilder osłoni oczy.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rozumiem. Sprzedajesz coś?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Zostawimy cię w podróży.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Kupiec uśmiecha się.%SPEECH_ON%Cieszę się, że pytasz, bo czasem męczy mnie interesowanie się z wezyrami w ich piórkowych liberiach. Łotry i szelmy.%SPEECH_OFF%Pstryka palcami i wskazuje na ciebie z ojcowską szczerością.%SPEECH_ON%Rozmowa szybko przeradza się w poufałą naradę. Jak mawiał mój ojciec, handel to ballada. A wszyscy potrzebujemy trochę poezji w szarości życia.%SPEECH_OFF%Kiwa głową i mówi tonem, którego używa wobec innych kupców.%SPEECH_ON%Mam zobowiązanie wobec wezyrów, ale bycie obrabowanym lub utrata towaru też jest oczekiwaniem tego zobowiązania. Dlatego mam coś do zaoferowania, co - jeśli się zgodzisz - zostanie mi \'skradzione\' na twój koszt. Ale możesz wziąć tylko jedną z tych opcji: handgonne za jedyne 2500 koron albo ognistą lancę za marne 500 koron. Tylko jedna z dwóch.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Weźmiemy handgonne za 2500 koron.",
					function getResult( _event )
					{
						_event.m.Bought = 1;
						return "C";
					}

				},
				{
					Text = "Ognistą lancę za 500 koron.",
					function getResult( _event )
					{
						_event.m.Bought = 2;
						return "C";
					}

				},
				{
					Text = "Za taką cenę żadna nie jest warta uwagi.",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Ty i kupiec dochodzicie do porozumienia w sprawie towaru. Po wymianie monet i dóbr wraca na wielbłąda i kpiąco pokazuje ci figę.%SPEECH_ON%Tak mi przykro, że mnie okradziono, to był naprawdę straszny dzień. Ach, wezyrowie będą równie smutni jak ja.%SPEECH_OFF%Kupiec znów siada bokiem i zaczyna ucztować na swoich jagodach i orzechach. Nie chwyta za wodze, a jednak wielbłądy ruszają, jakby na rozkaz.%SPEECH_ON%Niech twoja ścieżka zawsze będzie Złocona, Koroniarzu, i niech moje utracone dobra dadzą ci blask, którego szukasz.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I obyś i ty znalazł blask.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				switch(_event.m.Bought)
				{
				case 1:
					local item = this.new("scripts/items/weapons/oriental/handgonne");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
					item = this.new("scripts/items/ammo/powder_bag");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
					this.World.Assets.addMoney(-2500);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]2500[/color] koron"
					});
					break;

				case 2:
					local item = this.new("scripts/items/weapons/oriental/firelance");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
					this.World.Assets.addMoney(-500);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Wydajesz [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] koron"
					});
					break;
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Kupiec wyciąga ręce, jakbyś go okradał.%SPEECH_ON%To nic, że nie chcesz moich towarów, naprawdę.%SPEECH_OFF%Krzyżuje nogi i znów siada bokiem, a wielbłądy natychmiast ruszają, jakby dostały rozkaz. Kupiec mówi, jedząc orzechy i jagody.%SPEECH_ON%Niech twoja ścieżka zawsze będzie Złocona, Koroniarzu, a wezyrowie tych pustyń niech zrobią z ciebie dobry użytek.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oby tak było.",
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_171.png[/img]{Kiwasz głową i życzysz mu powodzenia w podróży. Kłania się z szacunkiem.%SPEECH_ON%Niech twoja ścieżka zawsze będzie Złocona, Koroniarzu.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I twoja także.",
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.FactionManager.isHolyWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills && currentTile.Type != this.Const.World.TerrainType.Oasis)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 2500)
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 1)
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
		this.m.Bought = 0;
	}

});

