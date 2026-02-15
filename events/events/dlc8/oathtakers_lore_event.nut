this.oathtakers_lore_event <- this.inherit("scripts/events/event", {
	m = {
		Oathtaker = null,
		Town = null,
		Replies = [],
		Results = [],
		Texts = []
	},
	function create()
	{
		this.m.ID = "event.oathtakers_lore";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Texts.resize(4);
		this.m.Texts[0] = "Opowiedz o Slubach.";
		this.m.Texts[1] = "Opowiedz o Mlodym Anselmie.";
		this.m.Texts[2] = "Opowiedz o tych cholernych typach.";
		this.m.Texts[3] = "Powiedzielismy juz wszystko.";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Ludzie z %townname% ciesza sie na widok %companyname%. To niezwykle przyjecie dla bandy najemnikow, ale wyglada na to, ze slubne aspekty waszej dzialalnosci sa wysoko cenione przez lud.%SPEECH_ON%Nareszcie ktos przywrocil honor i dume tym ziemiom.%SPEECH_OFF%Mowi jeden z chlopow. Kobiety przyozdabiaja was kwiatami i innymi przyslugami. Gdy zatrzymujesz woz, gromada dzieci podbiega, chcac dotknac czaszki Mlodego Anselma.%SPEECH_ON%Czy da nam sily? Czy mnie rozchoruje?%SPEECH_OFF%Inny dzieciak podchodzi i odpycha go lokciem.%SPEECH_ON%Niech nam juz powie, co robia i czym sa! Sluby, ta czaszka, a ostatnio slyszelismy o Slubodawcach, wiec czym sie tak roznicie?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B0",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Kladac dlon na glowie Anselma, wyjasniasz Sluby.%SPEECH_ON%Kazdego dnia, gdy wstajemy i ofiarowujemy sie temu swiatu, skladamy slub. Slub wobec siebie, wobec bliskich, wobec sasiadow, nawet wobec ziemi i zwierzat, ktore ja zdobia. Skladamy slub calemu swiatu.%SPEECH_OFF%Dzieciak gryzie jablko. Mowi.%SPEECH_ON%Jesli wszyscy skladaja sluby, co czyni was Swietobiorcami? Czy wszyscy nie jestesmy Swietobiorcami?%SPEECH_OFF%Usmiechasz sie i kiwasz glowa.%SPEECH_ON%Dokladnie. Wszyscy jestesmy Swietobiorcami. Jednak jesli moge zdradzic wam mala tajemnice...%SPEECH_OFF%Dzieci zbieraja sie wokol, uciszajac sie nawzajem. Wyjasniasz.%SPEECH_ON%Kiedy sie urodziliscie, nie wiedzieliscie wszystkiego, prawda? Tak samo jest z naszymi slubami. Starzy bogowie chca, bysmy poznali ten swiat w calosci, a nie dostali jego tajemnice na tacy. Gdyby je nam podano, czy bylibysmy tu, gdzie jestesmy? Czy nasza beztroska zostawilaby nas w pierwszych siedzibach? My, Swietobiorcy, badamy, jak bardzo starzy bogowie nas wzmocnili, ale i oslabili, a szukajac wszystkich naszych granic, zblizymy sie do starych bogow i do wszystkich innych.%SPEECH_OFF%Jedno z dzieci kopie ziemie. Pyta, czy masz w wozie jakies slodkie placki.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[0] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Stukasz w czaszke Mlodego Anselma.%SPEECH_ON%Mlody Anselm byl Pierwszym Swietobiorca, poczatkiem Swietobiorcow. Jako pierwszy zrozumial, ze prawdziwa natura czlowieka wymaga poswiecenia. Wierzyl, i slusznie, ze gdy czlowiek po raz pierwszy wedrowal po ziemi, czynil to w stanie cierpienia, i to w nim dokonywal najwiekszych postepow. To, co mamy teraz, jest bardzo dalekie od tego, jak bylo. Teraz jest po prostu za dobrze.%SPEECH_OFF%Jedno z dzieci drapie czarna strupke i strzepuje ja na twarz innego. Drugie dziecko wyciera to, wyciska kroste i rozsmarowuje rope po tamtym. Gdy sie kloca, ty kontynuujesz.%SPEECH_ON%Mlody Anselm zrozumial, ze ten swiat musi wrocic do zycia poswiecenia, zrezygnowac z czesci tego, co lubimy, zahartowac sie o kamien cierpienia. Naturalnie, to uczynilo Mlodego Anselma wrogiem wielu.%SPEECH_OFF%Jedno z dzieci podnosi wzrok i pyta, jak zmarl Mlody Anselm. Usmiechasz sie i mowisz, ze to opowiesc na inny raz.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[1] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Jedno z dzieci sie odzywa.%SPEECH_ON%Mielismy w miescie grupe ludzi takich jak wy. Mowili, ze sa \'Slubodawcami.\' Sa jak wasi bracia czy co?%SPEECH_OFF%Zaczynasz odpowiadac, gdy %oathtaker% sie wtraca.%SPEECH_ON%Slubodawcy to bluzniercy! To poganie, nie straznicy slubow, lecz ich lamacze! Ukradli szczeke Mlodego Anselma i slubujemy zabic kazdego Slubodawce, by ja odzyskac.%SPEECH_OFF%Chlopiec mowi, ze Slubodawcy chcieli zabrac wam czaszke, bo to wy, Swietobiorcy, jestescie prawdziwymi poganami. Gniew %oathtaker% siega zenitu.%SPEECH_ON%Slubodawcy gadaja mnostwo bzdur! To handlarze klamstwami, bredniami i histeria zamiast towarem, a ich dobrem sa okrutne urojenia!%SPEECH_OFF%Patrzysz na Swietobiorce przez chwile, potem kladziesz mu dlon na ramieniu i mowisz, ze moze powinien pojsc policzyc zapasy, zeby troche ostygnac.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[2] = true;
				_event.addReplies(this.Options);
			}

		});
	}

	function addReplies( _to )
	{
		local n = 0;

		for( local i = 0; i < 3; i = ++i )
		{
			if (!this.m.Replies[i])
			{
				local result = this.m.Results[i];
				_to.push({
					Text = this.m.Texts[i],
					function getResult( _event )
					{
						return result;
					}

				});
				n = ++n;

				if (n >= 4)
				{
					break;
				}

				  // [034]  OP_CLOSE          0      4    0    0
			}
		}

		if (n == 0)
		{
			_to.push({
				Text = this.m.Texts[3],
				function getResult( _event )
				{
					return 0;
				}

			});
		}
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
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

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local haveSkull = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				candidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
			{
				haveSkull = true;
			}
		}

		if (!haveSkull)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
				{
					haveSkull = true;
					break;
				}
			}
		}

		if (!haveSkull)
		{
			return;
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Oathtaker = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 25;
	}

	function onPrepare()
	{
		this.m.Replies = [];
		this.m.Replies.resize(3, false);
		this.m.Results = [];
		this.m.Results.resize(3, "");

		for( local i = 0; i < 3; i = ++i )
		{
			this.m.Results[i] = "B" + i;
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Oathtaker = null;
		this.m.Town = null;
	}

});

