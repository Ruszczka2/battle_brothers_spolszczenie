this.sellsword_vs_bees_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Wildman = null
	},
	function create()
	{
		this.m.ID = "event.sellsword_vs_bees";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Pustynia nie jest domem dla niczego poza piaskami. Tym bardziej niezwykłe jest spotkać samotne drzewo stojące w oddali, a jeszcze dziwniejsze, że z gałęzi zwisa gruby ul, wokół którego krąży chmura robotnic otaczających jego bulwiasty kształt. Nawet z pewnej odległości widać złoty żar ich miodu...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Niech ktoś to przyniesie!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "Good" : "Fail";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Wygląda na to, że %wildmanfull% chce tego spróbować.",
						function getResult( _event )
						{
							return "Wildman";
						}

					});
				}

				this.Options.push({
					Text = "Ruszajmy. Z tego nic dobrego nie będzie.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "%terrainImage%{%chosen% podchodzi pewnie do drzewa, a pszczoły zdają się ustępować na samą jego obecność. Szum ich skrzydeł gęstnieje od gniewnych wibracji, lecz poza tym nie robią nic więcej. Ostrożnie nabiera trochę miodu do słoja, po czym cofa się i odchodzi. Wraca do kompanii.%SPEECH_ON%Bułka z miodem, chłopy.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Buczcie ile chcecie, ten miód jest nasz!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.75, "Zjadł trochę miodu na pustyni");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Fail",
			Text = "%terrainImage%{%chosen% splata palce i strzela kostkami, przeciągając się długo.%SPEECH_ON%Jak zabieranie cukierka dziecku.%SPEECH_OFF%Podchodzi do drzewa i staje pod ulem. Pozuje i wskazuje go, śmieje się, po czym wyciąga ręce i - ku szokowi wszystkich - po prostu chwyta cały ul. Pszczoły natychmiast obsiadają najemnika, ten upuszcza ul i pędzi, a chmura gniewnego bzyczenia goni go po wydmie. Turlika się i turlika, jego krzyki słychać za każdym razem, gdy wynurza się z piasku, aż w końcu ląduje na dole, a lawina piasku przykrywa go i chroni przed dalszymi użądleniami. Czekasz chwilę, zanim go wyciągniesz, żeby pszczoły nie kojarzyły cię z tą próbą kradzieży.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie róbmy tego więcej.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.addHeavyInjury();
				_event.m.Dude.worsenMood(2.0, "Został poturbowany przez pszczoły");
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Dude.getName() + " cierpi z powodu ciężkich ran"
				});

				if (_event.m.Dude.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Wildman",
			Text = "%terrainImage%{Jesteś pewien, że %wildman% Dziki widział niejeden ul w czasach, gdy żył z dala od lasów. Warczy, wskazuje na ul, a potem na siebie. Kiwasz głową. Warczy znowu i idzie po wydmie do drzewa, a ty obserwujesz z bezpiecznej odległości. Gdy staje pod ulem, znów pohukuje, przykładając dłoń do ust, żebyś go usłyszał. Wskazuje na ul. Kiwasz głową i agresywnie wskazujesz na ul. To jedyny ul na wiele mil, co tu może być niejasne? \n\n Dziki odwraca się do ula. Odsuwa ramię. To... to nie jest to, co chciałeś zobaczyć. Mierzy się z ulem, język na wierzchu, oczy zmrużone. Ruszasz w jego stronę, krzycząc, ale on już jest skupiony. Wyprowadza cios i doszczętnie rozgniata pszczoły. Plastry miodu klejąco wiją się wokół jego nadgarstka, jakby owłosione ramię było prowizorycznym słupem majowym. Dziki spokojnie schodzi z wydmy. Gdy się zbliża, widzisz pszczoły pełzające po jego twarzy i kąsające jak wściekłe dzikusy, ale on zdaje się nawet ich nie czuć. Wyciąga chrupiące resztki swojego miodowego dzieła zniszczenia, jakby trzymał serce dzikiej bestii.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra... robota",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				_event.m.Wildman.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Wildman.getName() + " cierpi z powodu lekkich ran"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50 || bro.getID() == _event.m.Wildman.getID())
					{
						bro.improveMood(0.75, "Zjadł trochę miodu na pustyni");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local candidates_wildman = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];

		if (candidates_wildman.len() != 0)
		{
			this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
		_vars.push([
			"wildmanfull",
			this.m.Wildman != null ? this.m.Wildman.getName() : ""
		]);
		_vars.push([
			"chosen",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Wildman = null;
	}

});

