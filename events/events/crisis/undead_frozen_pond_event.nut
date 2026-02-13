this.undead_frozen_pond_event <- this.inherit("scripts/events/event", {
	m = {
		Lightweight = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.undead_frozen_pond";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]Przemierzając zimne pustkowia, docierasz do brzegu zamarzniętego stawu. %randombrother% dostrzega coś wystającego pośrodku. Widzisz, że to rycerz, którego ciało zamarzło po biodra, ale górna część wciąż się porusza. Oczy świecą na czerwono, a palce, czarne jak smoła od odmrożeń, wciąż potrafią zaciskać się i chwytać. Szczęka trzyma się dzięki lodowym mięśniom, jakby na gnijących, przezroczystych ścięgnach.\n\n%randombrother% wskazuje na ogromnego wiedergangera o zamarzniętej twarzy.%SPEECH_ON%Hej, patrz! Ten drań ma przy sobie wielki miecz. Może warto spróbować go zgarnąć, co?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jacyś ochotnicy?",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
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
				if (_event.m.Lightweight != null)
				{
					this.Options.push({
						Text = "Masz lekką stopę, %lightweightfull%. Spróbujesz?",
						function getResult( _event )
						{
							return "Lightweight";
						}

					});
				}

				this.Options.push({
					Text = "Nie warto.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_143.png[/img]%chosenbrother% postanawia spróbować zdobyć miecz martwego rycerza. Jego pierwszy krok na staw wysyła lodowe drżenie przez spód zamarzniętej tafli. Sprawdza oparcie ponownie. Lód przesuwa się i trzeszczy, ale nie pęka. Z każdym krokiem najemnik waży własny ciężar i prawdopodobieństwo załamania lodu - jednocześnie pilnując, by nie stanąć na jednym z porozrzucanych zwłok.\n\nUdaje mu się dotrzeć do nieumarłego rycerza. Z miecza zwisają sople, a samo ostrze jest uwięzione w warstwie lodu. Najemnik chwyta klingę i szarpie. Ramię nieumarłego rycerza szarpie się do przodu i odrywa w łokciu, posyłając najemnika ślizgiem na tyłku po stawie. Doślizguje do brzegu, gdzie twoi ludzie pomagają mu wstać. Miecz trzeba będzie ogrzać, by zdjąć lód, ale broń jest jak najbardziej użyteczna.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local item = this.new("scripts/items/weapons/greatsword");
				item.setCondition(11.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_143.png[/img]%chosenbrother% sprawdza lód, stawiając stopę na samym brzegu stawu. Miękkie drżenie odbija się echem po zimnym spodzie tafli, jakby ktoś puścił grający kamień po beczkowatej powierzchni. Spogląda na kompanię i wzrusza ramionami.%SPEECH_ON%Wygląda w porządku.%SPEECH_OFF%Jego następny krok kończy się załamaniem lodu. Odłamki układają się w coś na kształt zębatych szczęk, a gdy wyciąga rękę, by się chwycić, przecina sobie dłonie. Ludzie szybko rzucają mu linę i wyciągają go.\n\nZakrwawiony i drżący z zimna, %chosenbrother% kręci głową, gdy owijacie go kocami.%SPEECH_ON%J-j-j-jestem zdania, że to był str-str-straszny. Str-str-straszny pomysł, panie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Próbowałeś najlepiej jak umiałeś.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local injury = _event.m.Other.addInjury([
					{
						ID = "injury.split_hand",
						Threshold = 0.5,
						Script = "injury/split_hand_injury"
					}
				]);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Other.getName() + " cierpi na " + injury.getNameOnly()
					}
				];
				local effect = this.new("scripts/skills/injury/sickness_injury");
				_event.m.Other.getSkills().add(effect);
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Other.getName() + " jest chory"
				});
			}

		});
		this.m.Screens.push({
			ID = "Lightweight",
			Text = "[img]gfx/ui/events/event_143.png[/img]%lightweight% robi krok do przodu.%SPEECH_ON%Lód? Lód to nic. Można po nim sunąć tak.%SPEECH_OFF%Bez najmniejszej pauzy mężczyzna wyskakuje na zamarznięty staw i ślizga się po jego powierzchni. Za nim pojawiają się pęknięcia jak ślad nieuchronnie złych wieści, ale on pozostaje niewzruszony. Mija nieumarłego rycerza i chwyta zamarznięty miecz. Wiederganger jęczy, gdy jego ramię odrywa się w łokciu. Mężczyzna wesoło odślizguje do brzegu i podaje ci miecz. %otherbrother% podchodzi i odłamuje zmarznięte ramię wiedergangera od rękojeści, jakby łamał szczypce kraba.%SPEECH_ON%No, popatrz tylko?%SPEECH_OFF%Rozgniata palce na kawałki, a w sproszkowanych resztkach znajduje się sygnet. Miecz i biżuteria, czego tu nie kochać?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Imponujące.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Lightweight.getImagePath());
				local item = this.new("scripts/items/weapons/greatsword");
				item.setCondition(11.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/signet_ring_item");
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
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (currentTile.HasRoad)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 6)
			{
				nearTown = true;
				break;
			}
		}

		if (nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_lightweight = [];
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getCurrentProperties().getInitiative() >= 130)
			{
				candidates_lightweight.push(bro);
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

		if (candidates_lightweight.len() != 0)
		{
			this.m.Lightweight = candidates_lightweight[this.Math.rand(0, candidates_lightweight.len() - 1)];
		}

		this.m.Other = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"chosenbrother",
			this.m.Other.getNameOnly()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getNameOnly()
		]);
		_vars.push([
			"lightweight",
			this.m.Lightweight != null ? this.m.Lightweight.getNameOnly() : ""
		]);
		_vars.push([
			"lightweightfull",
			this.m.Lightweight != null ? this.m.Lightweight.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Lightweight = null;
		this.m.Other = null;
	}

});

