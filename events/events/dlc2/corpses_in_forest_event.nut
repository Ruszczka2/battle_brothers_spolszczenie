this.corpses_in_forest_event <- this.inherit("scripts/events/event", {
	m = {
		BeastSlayer = null,
		Killer = null
	},
	function create()
	{
		this.m.ID = "event.corpses_in_forest";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_132.png[/img]{Maszerując przez las, natrafiasz na stos spalonych zwłok, zaciśniętych w ostatnim ognistym uścisku. To wijąca się masa czarnych kończyn i pojedynczych twarzy, które gapią się w niebo. Wciąż czuć słaby zapach spalonej wieprzowiny, ale żadnych świń tu nie ma. %randombrother% kiwa głową na ten widok.%SPEECH_ON%To jest jeden wielki stos okropieństwa.%SPEECH_OFF%Kiwasz głową. Właśnie tak.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Może jest tam coś przydatnego.",
					function getResult( _event )
					{
						if (_event.m.BeastSlayer != null && this.Math.rand(1, 100) <= 75)
						{
							return "D";
						}
						else if (_event.m.Killer != null && this.Math.rand(1, 100) <= 75)
						{
							return "E";
						}
						else
						{
							return this.Math.rand(1, 100) <= 50 ? "B" : "C";
						}
					}

				},
				{
					Text = "Lepiej tu nie zostawać.",
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
			Text = "[img]gfx/ui/events/event_132.png[/img]{Najemnicy zaczynają przeszukiwać ciała. Większość zwłok jest zlepiona po trzy lub cztery i trzeba je rozłupywać jak jaja. Do rozdzielenia potrzeba buta lub stalowego klina. Odłupki zwęglonego mięsa fruwają, gdy ludzie pracują. Spalone dzieci odrywają się jak napierśniki, z zapadniętymi klatkami piersiowymi i ramionami sztywno rozstawionymi jak szprychy. Pod ciałami niewiele się znajduje. Co najwyżej kilka kawałków złota. %randombrother% znajduje okropnie wyglądającą maskę. Nie jesteś pewien, czym jest, ale uznajesz, że nie zaszkodzi ją zabrać. Może jakiś handlarz uzna ją za interesującą.}",
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
				local item = this.new("scripts/items/misc/petrified_scream_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_132.png[/img]{%randombrother% kuca przy kuli zwęglonych zwłok i kręci głową.%SPEECH_ON%Nie sądzę, żeby coś tam było, panie.%SPEECH_OFF%Zanim zdążysz odpowiedzieć, czarna dłoń wyskakuje i chwyta go za kostkę. Ciała unoszą się i przesuwają, samotna ofiara wydobywa się z osmalonej groteski z peleryną zwęglonych zwłok na plecach jak pajączki. Usta ma szeroko otwarte, wargi spalone, policzki wydrążone, a oczy płaskie w oczodołach. Jego dłoń ma chwyt kamiennego szponu gargulca i gdy najemnik czołga się w tył, ciągnie ze sobą spalonego człowieka. Cały stos szarpie i przewraca się, a część ciał stacza się z niego z kończynami sztywno wyciągniętymi jak stoliki, inne kołyszą się, by wpatrywać się w niebo, a jeszcze inne pochylają się i uderzają głowami o ziemię, rozgniatając je w pylisty czarny ślad.\n\n Jęcząc, ocalały błaga o wodę. Dobywasz miecza i przebijasz mu szyję, kończąc jego ból natychmiast. %randombrother% odłamuje palce, by uwolnić but z obrzydliwej dłoni. Kilku najemników jest wstrząśniętych tym zdarzeniem.}",
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
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (!bro.getBackground().isOffendedByViolence() || bro.getLevel() >= 7)
					{
						continue;
					}

					bro.worsenMood(0.75, "Wstrząśnięty przerażającą sceną");

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

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_132.png[/img]{%beastslayer% unosi dłoń.%SPEECH_ON%Nie zostali zamordowani, zostali oczyszczeni.%SPEECH_OFF%Kuca przy krawędzi stosu i podnosi zwęglone ramię, wyrywając je w łokciu. Obraca je i ściska. Zielona ropa sączy się z miejsc, gdzie były żyły, spływając równym strumieniem na ziemię. Pogromca bestii wyciąga fiolkę i zbiera, ile się da.%SPEECH_ON%Ci ludzie byli zakażeni jadem Webknechta. Zwykle rozpuszcza narządy i zabija, ale czasem, rzadko, ma inne skutki. Powoduje wyrastanie grubego włosia na ramionach, długich paznokci, łopatki zaczynają boleć i wystawać z pleców. Ohydne. A zatruci, cóż, szaleją.%SPEECH_OFF%Pytasz, czy wszyscy ci ludzie byli zatruci. Pogromca bestii kręci głową.%SPEECH_ON%Tego rozpoznałem po barkach, reszty nie wiem. Gdy choroba ogarnia wieś, ogarnia ją całą, a wkrótce chaos i zamieszanie stają się zarazą, a sama choroba jest tylko zapomnianą iskrą unoszącą się w ognisku, które rozpaliła.%SPEECH_OFF%}",
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
				this.Characters.push(_event.m.BeastSlayer.getImagePath());
				local item = this.new("scripts/items/accessory/spider_poison_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_132.png[/img]{%killer%, morderca w ucieczce, uśmiecha się złośliwie, parska, kiwa głową, pluje i kiwa znowu. Wskazuje na stos ciał.%SPEECH_ON%To okrucieństwo tak zajadłe, że nie sądzę, by jego sprawca przeżył własne dzieło.%SPEECH_OFF%Pytasz, co ma na myśli, ale mężczyzna unosi palec i chodzi po lesie, zaglądając za drzewo po drzewie, aż w końcu się zatrzymuje.%SPEECH_ON%Tak, jak myślałem.%SPEECH_OFF%Podchodzisz i widzisz wiszącego mężczyznę. Ma czarne opuszki palców, popiół na twarzy i pętlę na szyi. W dłoni trzyma notatkę z przeprosinami, choć nie opisuje ona natury jego winy ani nawet czy była winą. Pod jego stopami leżą jego zbroja i broń. Mógł być szlachcicem. Niezależnie od tego, każesz go ściąć, a wszystko złupić.}",
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
				this.Characters.push(_event.m.Killer.getImagePath());
				local item = this.new("scripts/items/weapons/morning_star");
				item.setCondition(this.Math.rand(5, 30) * 1.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/armor/basic_mail_shirt");
				item.setCondition(this.Math.rand(25, 60) * 1.0);
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		local myTile = this.World.State.getPlayer().getTile();

		foreach( s in this.World.EntityManager.getSettlements() )
		{
			local d = s.getTile().getDistanceTo(myTile);

			if (d <= 6)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_beastslayer = [];
		local candidates_killer = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_beastslayer.push(bro);
			}
			else if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				candidates_killer.push(bro);
			}
		}

		if (candidates_beastslayer.len() != 0)
		{
			this.m.BeastSlayer = candidates_beastslayer[this.Math.rand(0, candidates_beastslayer.len() - 1)];
		}

		if (candidates_killer.len() != 0)
		{
			this.m.Killer = candidates_killer[this.Math.rand(0, candidates_killer.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"beastslayer",
			this.m.BeastSlayer != null ? this.m.BeastSlayer.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.BeastSlayer = null;
		this.m.Killer = null;
	}

});

