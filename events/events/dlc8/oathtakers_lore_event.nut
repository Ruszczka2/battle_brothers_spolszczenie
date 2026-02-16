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
		this.m.Texts[0] = "Opowiedz o Ślubach.";
		this.m.Texts[1] = "Opowiedz o Młodym Anselmie.";
		this.m.Texts[2] = "Opowiedz o tych cholernych typach.";
		this.m.Texts[3] = "Powiedzieliśmy już wszystko.";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Ludzie z %townname% cieszą się na widok %companyname%. To niezwykłe przyjęcie dla bandy najemników, ale wygląda na to, że ślubne aspekty waszej działalności są wysoko cenione przez lud.%SPEECH_ON%Nareszcie ktoś przywrócił honor i dumę tym ziemiom.%SPEECH_OFF%Mówi jeden z chłopów. Kobiety przyozdabiają was kwiatami i innymi przysługami. Gdy zatrzymujesz wóz, gromada dzieci podbiega, chcąc dotknąć czaszki Młodego Anselma.%SPEECH_ON%Czy da nam siły? Czy mnie rozchoruje?%SPEECH_OFF%Inny dzieciak podchodzi i odpycha go łokciem.%SPEECH_ON%Niech nam już powie, co robią i czym są! Śluby, ta czaszka, a ostatnio słyszeliśmy o Ślubodawcach, więc czym się tak różnicie?%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_97.png[/img]{Kładąc dłoń na głowie Anselma, wyjaśniasz Śluby.%SPEECH_ON%Każdego dnia, gdy wstajemy i ofiarowujemy się temu światu, składamy ślub. Ślub wobec siebie, wobec bliskich, wobec sąsiadów, nawet wobec ziemi i zwierząt, które ją zdobią. Składamy ślub całemu światu.%SPEECH_OFF%Dzieciak gryzie jabłko. Mówi.%SPEECH_ON%Jeśli wszyscy składają śluby, co czyni was Świętobiorcami? Czy wszyscy nie jesteśmy Świętobiorcami?%SPEECH_OFF%Uśmiechasz się i kiwasz głową.%SPEECH_ON%Dokładnie. Wszyscy jesteśmy Świętobiorcami. Jednak jeśli mogę zdradzić wam małą tajemnicę...%SPEECH_OFF%Dzieci zbierają się wokół, uciszając się nawzajem. Wyjaśniasz.%SPEECH_ON%Kiedy się urodziliście, nie wiedzieliście wszystkiego, prawda? Tak samo jest z naszymi ślubami. Starzy bogowie chcą, byśmy poznali ten świat w całości, a nie dostali jego tajemnicę na tacy. Gdyby je nam podano, czy bylibyśmy tu, gdzie jesteśmy? Czy nasza beztroska zostawiłaby nas w pierwszych siedzibach? My, Świętobiorcy, badamy, jak bardzo starzy bogowie nas wzmocnili, ale i osłabili, a szukając wszystkich naszych granic, zbliżymy się do starych bogów i do wszystkich innych.%SPEECH_OFF%Jedno z dzieci kopie ziemię. Pyta, czy masz w wozie jakieś słodkie placki.}",
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
			Text = "[img]gfx/ui/events/event_97.png[/img]{Stukasz w czaszkę Młodego Anselma.%SPEECH_ON%Młody Anselm był Pierwszym Świętobiorcą, początkiem Świętobiorców. Jako pierwszy zrozumiał, że prawdziwa natura człowieka wymaga poświęcenia. Wierzył, i słusznie, że gdy człowiek po raz pierwszy wędrował po ziemi, czynił to w stanie cierpienia, i to w nim dokonywał największych postępów. To, co mamy teraz, jest bardzo dalekie od tego, jak było. Teraz jest po prostu za dobrze.%SPEECH_OFF%Jedno z dzieci drapie czarną strupkę i strzepuje ją na twarz innego. Drugie dziecko wyciera to, wyciska krostę i rozsmarowuje ropę po tamtym. Gdy się kłócą, ty kontynuujesz.%SPEECH_ON%Młody Anselm zrozumiał, że ten świat musi wrócić do życia poświęcenia, zrezygnować z części tego, co lubimy, zahartować się o kamień cierpienia. Naturalnie, to uczyniło Młodego Anselma wrogiem wielu.%SPEECH_OFF%Jedno z dzieci podnosi wzrok i pyta, jak zmarł Młody Anselm. Uśmiechasz się i mówisz, że to opowieść na inny raz.}",
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
			Text = "[img]gfx/ui/events/event_97.png[/img]{Jedno z dzieci się odzywa.%SPEECH_ON%Mieliśmy w mieście grupę ludzi takich jak wy. Mówili, że są \'Ślubodawcami.\' Są jak wasi bracia czy co?%SPEECH_OFF%Zaczynasz odpowiadać, gdy %oathtaker% się wtrąca.%SPEECH_ON%Ślubodawcy to bluźniercy! To poganie, nie strażnicy ślubów, lecz ich łamacze! Ukradli szczękę Młodego Anselma i ślubujemy zabić każdego Ślubodawcę, by ją odzyskać.%SPEECH_OFF%Chłopiec mówi, że Ślubodawcy chcieli zabrać wam czaszkę, bo to wy, Świętobiorcy, jesteście prawdziwymi poganami. Gniew %oathtaker% sięga zenitu.%SPEECH_ON%Ślubodawcy gadają mnóstwo bzdur! To handlarze kłamstwami, bredniami i histerią zamiast towarem, a ich dobrem są okrutne urojenia!%SPEECH_OFF%Patrzysz na Świętobiorcę przez chwilę, potem kładziesz mu dłoń na ramieniu i mówisz, że może powinien pójść policzyć zapasy, żeby trochę ostygnąć.}",
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

