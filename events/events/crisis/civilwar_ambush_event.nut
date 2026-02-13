this.civilwar_ambush_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_ambush";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Lasy skrywają wiele rzeczy, będąc naturalnym schronieniem drapieżników i ludzi o dzikszych zamiarach. Ale ty dobrze to wiesz i potrafisz wypatrzyć cienie najbardziej niepasujące do tej scenerii. Nie mija wiele czasu, gdy orientujesz się, że nie ma tu tylko drzew, i szybkim uderzeniem w gęstwinę krzewu wyciągasz młodego chłopca z łukiem. Krzyczy o pomoc, a posiłki nadchodzą jak śpiew ptaków do najpiękniejszej melodii: z cieni wyłania się tuzin mężczyzn, lecz kompania jest gotowa, dobywa broni i staje z nimi na równej stopie.\n\n Starszy mężczyzna występuje, unosząc dłonie.%SPEECH_ON%Poczekaj, nie ma potrzeby przemocy.%SPEECH_OFF%Podchodzi do ciebie i tłumaczy przyciszonym, uczonym tonem, co się dzieje. Mała grupa chłopów szykuje zasadzkę na oddział żołnierzy %noblehouse%, którzy lada chwila będą przechodzić tędy. Mówi, że dostaniesz część nagrody, jeśli pomożesz. Jeśli nie, proszę, zejdź z drogi.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Pomóżmy tym chłopom.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Musimy ostrzec żołnierzy.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Nie mamy na to czasu.",
					function getResult( _event )
					{
						return 0;
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
			Text = "[img]gfx/ui/events/event_10.png[/img]To chłopi, obdarci i wyglądający, jakby przyszli tu szukać liści na odzienie. Ale ich lichym łukom towarzyszą stwardniałe dłonie, wprawione w posyłaniu strzał do celów, których nie powinni tak łatwo znajdować. To ludzie lasu. Pewny, że zasadzka się powiedzie, decydujesz się do nich dołączyć.\n\n Nie musisz długo czekać, aż żołnierze %noblehouse% zaczną tamtędy nadciągać. Są głośni, nieznośni, a kilku z nich puszcza bąki i narzeka na grzyby, które zjedli przez pomyłkę.\n\n Chłopak mniej więcej połowę twojego wzrostu oddaje pierwszy strzał. Strzała śmiga między dwiema gałęziami i prowadzący zwiadowca pada na kolana. Liście szeleszczą, jakby nadeszła wielka wichura - strzały, niewidoczne w locie, wbijają się w kolumnę żołnierzy i są tak celne, że cele padają bez głosu. Kilku żołnierzy zdoła zbliżyć się, unosząc miecze i tarcze, lecz wtedy wkracza %companyname% i kładzie ich trupem. Po zaledwie minucie cały oddział jest wybity.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Poszło dobrze. Podzielmy łupy.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_87.png[/img]Twoi ludzie przeszukują zwłoki, dołącza do nich różnorodna zgraja zabójców. Wybucha sprzeczka o to, kto ma wziąć tarczę. Wyjaśniasz, że jedyny powód, dla którego tarcza nadaje się do zabrania, jest taki, że twoi ludzie wyszli naprzód, by zabić jej właściciela. Przywódca grupy kiwa głową na znak zgody. Woła, że wasza kompania powinna wziąć cięższy ekwipunek, bo twoi ludzie na pewno lepiej go wykorzystają.\n\n Gdy dzielisz łupy, jeden z łuczników występuje naprzód.%SPEECH_ON%Chyba jeden z nich uciekł. Są ślady, ale musiał być trochę sprytniejszy od swoich martwych braci, bo zawrócił i dobrze je ukrył.%SPEECH_OFF%A już myślałeś, że uda ci się coś uchachać...",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Poza tym, że jeden uciekł, to też poszło dobrze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationOffense, "Ambushed some of their men");
				this.World.Assets.addMoralReputation(-1);
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationFavor, "Helped in an ambush against " + _event.m.NobleHouse.getName());
				local item;
				local banner = _event.m.NobleHouse.getBanner();
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
					item = this.new("scripts/items/weapons/billhook");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				r = this.Math.rand(1, 4);

				if (r == 1)
				{
					item = this.new("scripts/items/shields/faction_wooden_shield");
					item.setFaction(banner);
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/shields/faction_kite_shield");
					item.setFaction(banner);
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/armor/mail_shirt");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/armor/basic_mail_shirt");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_94.png[/img]Mówisz chłopom, że nie chcesz mieć nic wspólnego z ich wojną, ale i tak się nie wtrącasz.\n\n Gdy tylko znikają z oczu i słuchu, odnajdujesz żołnierzy %noblehouse% i informujesz ich o kłopotach, które wkrótce nadejdą. Porucznik nie wierzy ci, dopóki nie prowadzisz go do chłopów i ich nie wskazujesz, a raczej ich smukłych cieni skrycie czających się za tą czy inną gałęzią.\n\n Wracając do oddziału, organizujesz szturm. To dość proste - omijasz zasadzkę i uderzasz od tyłu. Starcy, zdesperowani mężczyźni i naiwni chłopcy giną po kolei. Nie spodziewali się tego, lecz w wirze chaosu kilku niemal na pewno uciekło i opowiedziało o twojej zdradzie. Zbierasz kilka rzeczy z pola walki i zyskujesz dawkę przychylności od chorążych %noblehouse%.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Więc miejscowi mogą o tym usłyszeć, co z tego?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationFavor, "Saved some of their men");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationOffense, "Killed some of their men");
				local money = this.Math.rand(200, 400);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
				});
				local item;
				local r = this.Math.rand(1, 5);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/pitchfork");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/short_bow");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/hunting_bow");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/militia_spear");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/shields/wooden_shield");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();

		if (playerTile.Type != this.Const.World.TerrainType.Forest && playerTile.Type != this.Const.World.TerrainType.LeaveForest && playerTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() >= 3)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d < bestDistance)
			{
				bestDistance = d;
				bestTown = t;
			}
		}

		if (bestTown == null || bestDistance > 10)
		{
			return;
		}

		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local candidates = [];

		foreach( h in nobleHouses )
		{
			if (h.getID() != bestTown.getOwner().getID())
			{
				candidates.push(h);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = bestTown;
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
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Town = null;
	}

});

