this.raiders_origin_redemption_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null,
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.raiders_origin_redemption_";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_40.png[/img]{%monk% to mnich, który w tym momencie jest bardzo, bardzo daleko od domu. Dni na drodze w pojedynkę są dość ciężkie, a dni poza nią, pełne przemocy i grabieży, jeszcze gorsze. Nic dziwnego, że przyszedł do ciebie z ofertą. Choć od pewnego czasu jest w twojej kompanii, wciąż widać, że to człowiek cywilizacji.\n\n Wyjaśnia stare prawo: jako najeźdźcy jesteście persona non grata, ale jako najeźdźcy z dużą ilością pieniędzy macie szansę wykupić sobie powrót do interesów z tutejszymi możnymi. Mnich mówi, że wie, czyje dłonie trzeba posmarować. Podobno %noblehouse% jest zainteresowany \'otwarciem kanałów\' i doceniłby %crowns% koron, by wejść w nowe układy. Cywilizowanie, doprawdy.}",
			Banner = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Załatw to.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nie potrzebujemy tego.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Zgadzasz się z pomysłami mnicha. Razem spotykacie się z pośrednikiem i jednym z możnych. Spotkanie odbywa się w tajemnicy i na początku jest pełne teatralnych zabaw w płaszcze i sztylety. Ludzie w czerni trzymają ręce przy broni, możni szepczą między sobą, ale gdy wszystko zostaje ustalone... wypijacie razem porządny, długi łyk. W przyszłości %noblehouse% będzie bardziej otwarty na interesy.}",
			Banner = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Praca najemnicza dla nich jeszcze bardziej poprawi relacje.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.World.Flags.set("IsRaidersRedemption", true);
				this.World.Assets.addBusinessReputation(50);
				this.World.Assets.addMoney(-2000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-2000[/color] koron"
				});
				_event.m.NobleHouse.addPlayerRelation(20.0, "Został przekupiony, by prowadzić z tobą interesy");
				this.List.push({
					id = 10,
					icon = "ui/icons/relations.png",
					text = "Twoje relacje z " + _event.m.NobleHouse.getName() + " poprawiają się"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() != "scenario.raiders")
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 500)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 2500)
		{
			return;
		}

		if (this.World.Flags.get("IsRaidersRedemption"))
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local candidates_nobles = [];

		foreach( n in nobles )
		{
			if (n.getPlayerRelation() > 5.0 && n.getPlayerRelation() < 25.0)
			{
				candidates_nobles.push(n);
			}
		}

		if (candidates_nobles.len() == 0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_monk = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk" && bro.getLevel() > 1)
			{
				candidates_monk.push(bro);
			}
		}

		if (candidates_monk.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = candidates_nobles[this.Math.rand(0, candidates_nobles.len() - 1)];
		this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		this.m.Score = 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk.getName()
		]);
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
		_vars.push([
			"crowns",
			"2,000"
		]);
	}

	function onClear()
	{
		this.m.Monk = null;
		this.m.NobleHouse = null;
	}

});

