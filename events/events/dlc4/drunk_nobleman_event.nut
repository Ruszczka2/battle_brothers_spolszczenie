this.drunk_nobleman_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Servant = null,
		Thief = null,
		Townname = null
	},
	function create()
	{
		this.m.ID = "event.drunk_nobleman";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Podczas marszu znajdujesz pijanego szlachcica chwiejącego się na boki na ścieżce. Włosy ma w nieładzie, pełne liści i trawy oraz czegoś, co wygląda na ptasie gówno, jakby ktoś wymieszał składniki żartu. Ale jego ubrania falują z najdelikatniejszych jedwabi, a palce lśnią biżuterią. W każdej ręce trzyma butelkę i wymachuje nimi, śpiewając bełkotliwe karczemne piosenki.\n\nPod każdym względem jest największym magnesem na rabunek, jakiego kiedykolwiek widziałeś. %randombrother% zaciska usta i wygląda jak wilk wpatrzony w tłustą owcę.%SPEECH_ON%Ja nic nie mówię, sir, ja tylko... ja tylko to widzę. To dużo soku. Dużo soku, co się chwieje po drodze. Ale znowu, nic nie mówię.%SPEECH_OFF%Wiesz, o co mu chodzi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ograbimy go.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Servant != null)
				{
					this.Options.push({
						Text = "Czemu patrzy na %servant%?",
						function getResult( _event )
						{
							return "G";
						}

					});
				}

				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "Może %thief% ulży mu w ciężarze.",
						function getResult( _event )
						{
							return "H";
						}

					});
				}

				this.Options.push({
					Text = "Zostawmy go.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{Podchodzisz do mężczyzny i pomagasz mu usiąść. Uśmiecha się, gdy jedna z jego butelek z brzękiem spada ze ścieżki i toczy się w bok.%SPEECH_ON%Dzięęękuję, sir, jas... no, no, tak.%SPEECH_OFF%Kiwając głową, wyciągasz mu dłoń, spluwasz na palce, po czym zsuwasz biżuterię i chowasz ją do kieszeni. On tylko patrzy, jakbyś był lekarzem leczących dolegliwość. Reszta twoich najemników zdziera z niego ubrania, narzuca kozią skórę i zostawia go tam. Gdy odchodzisz, pyta, czy znasz się na piciu.%SPEECH_ON%Nie, nie zdradzam sekretu, ale, panowie, picie jest dobre.%SPEECH_OFF%O tak, jest. Niestety, gdy wracasz do kompanii, %randombrother% melduje, że dzieciak wszystko widział i dał drapaka. Pytasz, czemu za nim nie pogonił. Spogląda na ciebie przebiegle.%SPEECH_ON%Nie jestem od ganiania, sir.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Spoczywaj spokojnie, nieznajomy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local f = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
				f = f[this.Math.rand(0, f.len() - 1)];
				f.addPlayerRelation(-15.0, "Rumored to have robbed a family member on the road");
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Twoje relacje z " + f.getName() + " ucierpiały"
				});
				local money = this.Math.rand(1, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
				});
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/valuable_furs_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{Podchodzisz do mężczyzny, a on, zaskoczony, cofa się z czknięciem.%SPEECH_ON%Ej, a wy kto?%SPEECH_OFF%Mówiąc, że jesteś dobrym przyjacielem, zbliżasz się, by go ograbić ze wszystkiego, ale gdy robisz kolejny krok, jego oczy stają się trzeźwe, upuszcza obie butelki i nagle sięga do płaszcza, wyciągając kuszę.%SPEECH_ON%Ani kroku, łajdaku. Mam tam ludzi, którzy patrzą. Nie chcę kłopotów. Nie mamy ochoty zadzierać z najemnikami. Jesteśmy tu, by rabować podróżnych, a nie takich podróżnych, by rabować pijaka! To może po prostu ruszysz dalej, a my rozejdziemy się bez przeszkód w naszych zamiarach.%SPEECH_OFF%Kusza skrzypi, gdy drewno drży w jego luźnym uścisku.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zgoda.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Nie ma mowy.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "E" : "F";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%{Kiwasz głową.%SPEECH_ON%No proszę. Zakładam, że wszystko, co masz, to falsyfikaty, co?%SPEECH_OFF%Mężczyzna przytakuje.%SPEECH_ON%Oczywiście. Najlepiej dopasowane falsyfikaty po tej stronie %townname%! Ale dość tej gadaniny. Dzięki, że trzymasz to uczciwie, ale mamy robotę.%SPEECH_OFF%Ponownie kiwasz głową i życzysz mu szczęścia.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Z powrotem na drogę.",
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
			Text = "%terrainImage%{Spoglądasz na kompanię, po czym dobywasz miecza, odwracając się. Zamachujesz się i trafiasz w kuszę, a mężczyzna strzela tuż nad twoim ramieniem. Wbijasz ostrze w szczelinę drewna, przecinasz cięciwę i wbijasz stal w jego pierś. Pada łatwo, a w oddali słyszysz krzyki, ale uciekają - tacy złodzieje wiedzą, by nie walczyć z najemnikami. Zbierasz wszystko, co mężczyzna zdążył już ukraść.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zobaczmy, co miał.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(1, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
				});
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/valuable_furs_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "%terrainImage%{Spoglądasz na kompanię, po czym dobywasz miecza, odwracając się. Zamachujesz się i trafiasz w kuszę, a mężczyzna strzela tuż nad twoim ramieniem. Wbijasz ostrze w szczelinę drewna, przecinasz cięciwę i wbijasz stal w jego pierś. Pada łatwo, a w oddali słyszysz krzyki, ale uciekają - tacy złodzieje wiedzą, by nie walczyć z najemnikami. Niestety, bełt kuszy, który przeleciał nad twoim ramieniem, trafił %hurtbro%. Przeżyje, ale to paskudna rana.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zobaczmy, co miał.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local injury = _event.m.Other.addInjury(this.Const.Injury.PiercingBody);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Other.getName() + " doznaje " + injury.getNameOnly()
				});
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/valuable_furs_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "%terrainImage%{Gdy zbliżasz się do szlachcica, jego oczy rozszerzają się i wskazuje na %servant% sługę.%SPEECH_ON%Chwileczkę, ja cię znam.%SPEECH_OFF%Odwracasz się. On? Szlachcic zatacza się, nogi krzyżują mu się na boki.%SPEECH_ON%Byłeś sługą mojego kuzyna w %randomtown% pewnego wieczoru. Byłeś świetny! Najlepszy. Najleeeepszy. S-sługa. Hargh. No to -hic- możesz wziąć te wszystkie graty, bo chyba -hic- nie wyjaśniliśmy, przepraszam, nie zapłaciliśmy ci.%SPEECH_OFF%Mężczyzna zabiera wszystko, co ma wartość, i oddaje. Wygląda na szczęśliwego, że pozbył się ciężaru.%SPEECH_ON%Jakbyś znów zobaczył mojego k-kuzyna, to, to mu powiedz, że zabiłem jego brata, tym, tym, gzymsem kominka. Bez urazy -hic- uczuć.%SPEECH_OFF%No dobrze.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota z tamtej sprawy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Servant.getImagePath());
				_event.m.Servant.getBaseProperties().Bravery += 2;
				_event.m.Servant.getSkills().update();
				_event.m.Servant.improveMood(1.0, "Wreszcie dostał zapłatę za dawną robotę");
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Servant.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Determinacji"
				});
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "%terrainImage%{Gdy podchodzisz do pijaka, ostry gwizd przecina drogę. Ty i pijak patrzycie, jak %thief% złodziej stoi z bronią przy plecach innego mężczyzny.%SPEECH_ON%To żaden szlachcic i pewnie nie jest nawet pijany. Działają razem, by urządzać zasadzki na podróżnych albo szantażować ich. To rabusie, sir.%SPEECH_OFF%Odwracasz się i widzisz nerwowy uśmiech mężczyzny. Tłumaczy się z nagle wyostrzoną jasnością.%SPEECH_ON%Nie chcieliśmy rabować najemników, sir, p-przysięgam, już miałem wszystko wyjaśnić, gdy tylko zobaczyłem wasze miecze.%SPEECH_OFF%%thief% krzyczy, pytając, gdzie jest skrytka. Odwracasz się do mężczyzny i każesz mu oddać wszystko, co ukradł. Kiwając głową, pyta, czy go poderżniesz, jeśli odmówi. Potwierdzasz, mówiąc, że podcięcie gardła będzie na końcu, a wtedy to już ulga. Mężczyzna nabiera wigoru.%SPEECH_ON%Tak jest, sir, tędy.%SPEECH_OFF%} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Stary złodziej wywąchał to od razu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
				local money = this.Math.rand(1, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
				});
				local item;
				item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/silverware_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_servant = [];
		local candidates_thief = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.servant" || bro.getBackground().getID() == "background.juggler")
			{
				candidates_servant.push(bro);
			}
			else if (bro.getBackground().getID() == "background.thief")
			{
				candidates_thief.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_servant.len() != 0)
		{
			this.m.Servant = candidates_servant[this.Math.rand(0, candidates_servant.len() - 1)];
		}

		if (candidates_thief.len() != 0)
		{
			this.m.Thief = candidates_thief[this.Math.rand(0, candidates_thief.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearest_town_distance = 999999;
		local nearest_town;

		foreach( t in towns )
		{
			local d = t.getTile().getDistanceTo(playerTile);

			if (d < nearest_town_distance)
			{
				nearest_town_distance = d;
				nearest_town = t;
			}
		}

		this.m.Townname = nearest_town.getName();
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hurtbro",
			this.m.Other.getNameOnly()
		]);
		_vars.push([
			"servant",
			this.m.Servant ? this.m.Servant.getNameOnly() : ""
		]);
		_vars.push([
			"thief",
			this.m.Thief ? this.m.Thief.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Townname
		]);
	}

	function onClear()
	{
		this.m.Other = null;
		this.m.Servant = null;
		this.m.Thief = null;
		this.m.Townname;
	}

});

