this.kid_blacksmith_event <- this.inherit("scripts/events/event", {
	m = {
		Juggler = null,
		Apprentice = null,
		Killer = null,
		Other = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.kid_blacksmith";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Spacerując po sklepach w %townname%, czujesz szarpnięcie za rękaw. Odwracasz się i widzisz dziecko z twarzą umazaną na czarno, z której świecą dwie jasne, białe oczy. Pyta, czy znasz się na mieczach. Wskazujesz na ten, który masz u boku w pochwie. Klaska w dłonie.%SPEECH_ON%Świetnie! Pracuję u tamtego kowala, ale poszedł po sztaby żelaza. Kazał mi pilnować tego wyjątkowego miecza, który robił, ale on, eee, spadł. I pękł. Sam spadł i sam się złamał. Pomożesz mi go poskładać?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Niech ktoś pomoże dzieciakowi.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 70)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Juggler != null)
				{
					this.Options.push({
						Text = "Wygląda na to, że %juggler% chce ci pomóc.",
						function getResult( _event )
						{
							return "Juggler";
						}

					});
				}

				if (_event.m.Apprentice != null)
				{
					this.Options.push({
						Text = "Wygląda na to, że %apprentice% chce ci pomóc.",
						function getResult( _event )
						{
							return "Apprentice";
						}

					});
				}

				if (_event.m.Killer != null)
				{
					this.Options.push({
						Text = "Wygląda na to, że %killer% chce ci pomóc.",
						function getResult( _event )
						{
							return "Killer";
						}

					});
				}

				this.Options.push({
					Text = "Nie. Idź sobie, dzieciaku.",
					function getResult( _event )
					{
						return "No";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "No",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Mówisz dzieciakowi, żeby spadał. Pewnie i tak jest sprytnym kieszonkowcem. Skoro o tym mowa, sprawdzasz kieszenie, aby upewnić się, że wszystko jest na miejscu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co za ulga, niczego nie brakuje.",
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
			ID = "Good",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Po %other%a idzie się, by pomógł dzieciakowi. Pomaga złożyć rękojeść i ostrze miecza, a chłopiec robi swoją magię, z łatwością składając miecz z powrotem w całość. Jesteś pod wrażeniem jego umiejętności i zastanawiasz się, jak dobry musi być sam kowal, skoro to jego uczeń. Po zakończeniu pracy chłopak proponuje naprawić część broni dla %companyname%, co z radością przyjmujesz.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota!",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local stash = this.World.Assets.getStash().getItems();
				local items = 0;

				foreach( item in stash )
				{
					if (item != null && item.isItemType(this.Const.Items.ItemType.Weapon) && item.getCondition() < item.getConditionMax())
					{
						item.setCondition(item.getConditionMax());
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Twój " + item.getName() + " został naprawiony"
						});
						items = ++items;

						if (items > 3)
						{
							break;
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_97.png[/img]{%other% wzdycha, gdy prosisz go, by pomógł dzieciakowi w jego obowiązkach. Leniwie podchodzi do kowalskiego kowadła, które ma kształt trzonowca i spoczywa na cienkich żelaznych nogach. Towary kowala wiszą na prowizorycznych ścianach zrobionych ze starych żelaznych ogrodzeń, a pręty są wygięte na zewnątrz, by łapać metalowe wyroby. Dzieciak klaszcze w dłonie.%SPEECH_ON%Nie dotykaj niczego innego, tylko pomóż mi z tym.%SPEECH_OFF% %other% odwraca się zdezorientowany i w pół zdania wytrąca nogę kowadła. Zaczyna się przewracać na bok, a chłopiec rzuca się, by je złapać, choćby tylko po to, by zatrzymać falę kłopotów, która spadła na jego dzień. Szalony ciężar przykleja go płasko do bruku, jego kończyny na chwilę rozciągają się jak świerszcz zgnieciony pod kciukiem. Widzisz to z daleka i gwiżdżesz na najemnika, by wracał, zanim będą kłopoty. Ucieka w chwili, gdy kilku przechodniów zaczyna coś zauważać. Wzrusza ramionami.%SPEECH_ON%Nic nie zrobiliśmy, prawda, panie?%SPEECH_OFF%Kiwasz głową.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lepiej przyczaj się na jakiś czas.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.worsenMood(1.5, "Przypadkowo okaleczył małego chłopca");

				if (_event.m.Other.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Juggler",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Twoje podejrzenia, że kuglarz zgłosił się do pomocy z własnych pobudek, szybko się potwierdzają, gdy widzisz, jak rzuca w powietrze sztylety i topory, zachwycając tłum. Gdy ludzie się zbierają, kładzie kapelusz na bruku i kontynuuje pokaz. Wrzucają sporo monet, a oklaski są ogłuszające, gdy wykonuje swój finałowy numer z pięcioma buzdyganami naraz. Kłania się, podnosi kapelusz i pędzi z powrotem.%SPEECH_ON%Dobra robota na dziś, co, panie?%SPEECH_OFF%Kiwasz głową i pytasz o złamany miecz chłopca. Ociera pot z czoła.%SPEECH_ON%Co mówisz, panie? Wrócić do kompanii? Tak, panie, już wracam do kompanii.%SPEECH_OFF%Zaciskasz usta i spoglądasz z powrotem w stronę kuźni, widząc chłopca pochylonego nad kowadłem i dostającego solidne lanie skórzanym pasem od wróconego kowala.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Występ to występ.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				_event.m.Juggler.improveMood(1.0, "Kąpał się w podziwie tłumu");

				if (_event.m.Juggler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}

				local money = this.Math.rand(10, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Koron"
				});
			}

		});
		this.m.Screens.push({
			ID = "Apprentice",
			Text = "[img]gfx/ui/events/event_97.png[/img]{%apprentice%, młody czeladnik, zostaje wysłany do pomocy dzieciakowi. Przechadza się do kuźni i zaczyna mu pomagać. Robi jednak więcej niż tylko pomaga: składa miecz w taki sposób, że jest mocniejszy niż na początku. Kowal wraca, widzi dzieło i domaga się, by mu zdradzić, jak to zrobił, niemal błagając o wyjaśnienie. %apprentice% śmieje się.%SPEECH_ON%Daj mi ten miecz, a ja dam ci sekret, który mój majster mi przekazał.%SPEECH_OFF%Nie miałeś pojęcia, że czeladnik potrafi to zrobić, ale chłopak jest niczym gąbka w butach. Z kowalem dochodzi do wymiany i obie strony odchodzą bardziej niż zadowolone.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Myślałem, że uczyłeś się wyplatać kosze?",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				_event.m.Apprentice.improveMood(1.0, "Wykorzystał swoje umiejętności kowalskie");

				if (_event.m.Apprentice.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}

				local item = this.new("scripts/items/weapons/arming_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Killer",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Prosisz %killer%a, mordercę, by pomógł dzieciakowi. Mężczyzna zgadza się z uśmiechem, który dziecko instynktownie odbiera jako obraźliwy. Cofa się o kilka kroków i macha ręką, by zrezygnować z pomocy.%SPEECH_ON%Nie, panie, chyba sobie poradzę. D-dziękuję. W końcu chłop musi robić to, co musi, prawda?%SPEECH_OFF%Morderca uśmiecha się, kuca, przykłada kciuk do policzka chłopca i zostawia go tam.%SPEECH_ON%Właśnie tak, chłopcze. Właśnie tak. Człowiek robi, co musi.%SPEECH_OFF%Teraz to ty jesteś oburzony i prosisz %killer%a, by poszedł liczyć zapasy. Potrze włosy chłopca, po czym wstaje i odchodzi. Dzieciak ucieka, ale szybko wraca ze sztyletem.%SPEECH_ON%T-tutaj, weź to. Trzymaj tego faceta, do diabłów, z dala ode mnie, proszę pana. Jasne? Nie chcę mieć z nim nic wspólnego i prędzej schowam się u kowala, niż kiedykolwiek go znowu zobaczę. Weź broń, trzymaj go z dala. Zgoda? Zgoda, tak? Weź to!%SPEECH_OFF%Wnioskujesz, że dzieciak nigdy w życiu się nie targował, albo że to pierwszy raz, gdy czuł, że jego życie wisi na włosku. Tak czy inaczej, przyjmujesz sztylet. Chłopiec wzdycha z ulgą, wraca do kuźni, tam pracuje i zawsze zerka przez ramię.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jesteś zabójczo dobry z dzieciakiem, %killer%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Killer.getImagePath());
				local item = this.new("scripts/items/weapons/rondel_dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
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

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_other = [];
		local candidates_juggler = [];
		local candidates_apprentice = [];
		local candidates_killer = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.juggler")
			{
				candidates_juggler.push(b);
			}
			else if (b.getBackground().getID() == "background.apprentice")
			{
				candidates_apprentice.push(b);
			}
			else if (b.getBackground().getID() == "background.killer_on_the_run")
			{
				candidates_killer.push(b);
			}
			else
			{
				candidates_other.push(b);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_juggler.len() != 0)
		{
			this.m.Juggler = candidates_juggler[this.Math.rand(0, candidates_juggler.len() - 1)];
		}

		if (candidates_apprentice.len() != 0)
		{
			this.m.Apprentice = candidates_apprentice[this.Math.rand(0, candidates_apprentice.len() - 1)];
		}

		if (candidates_killer.len() != 0)
		{
			this.m.Killer = candidates_killer[this.Math.rand(0, candidates_killer.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"other",
			this.m.Other.getName()
		]);
		_vars.push([
			"juggler",
			this.m.Juggler != null ? this.m.Juggler.getName() : ""
		]);
		_vars.push([
			"apprentice",
			this.m.Apprentice != null ? this.m.Apprentice.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Juggler = null;
		this.m.Apprentice = null;
		this.m.Killer = null;
		this.m.Other = null;
		this.m.Town = null;
	}

});

