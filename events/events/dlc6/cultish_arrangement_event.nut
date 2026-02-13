this.cultish_arrangement_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null
	},
	function create()
	{
		this.m.ID = "event.cultish_arrangement";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_03.png[/img]{Wspinasz się na wydmę i widzisz pół tuzina mężczyzn. Noszą czarne płaszcze, a dłonie schowane w rękawach trzymają się wzajemnie, tworząc pełny krąg. Choć wszystkie głowy mają spuszczone, zdają się wyczuwać twoją obecność i odwracają się, by patrzeć. Jeden z mężczyzn puszcza dłonie i wychodzi naprzód.%SPEECH_ON%Davkul czeka na nas wszystkich, wędrowcze, nawet pozłacana ścieżka pozwala na jego cierpliwość.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zostawimy was z tym.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "Porozmawiaj z braćmi w wierze, %cultist%.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				this.Options.push({
					Text = "Zarżnijcie tych głupców!",
					function getResult( _event )
					{
						return "B";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_12.png[/img]{Dobywasz miecza i każesz kompanii szybko rozprawić się z kultystami. Idzie to łatwo, kultystom nawet nie przychodzi do głowy podnieść ręki, by stawić opór własnej śmierci. Ocalały kaszle, pozwalając, by otwarta rana krwawiła. Wyciąga dłoń, jakby chciał pokazać ci twoje dzieło.%SPEECH_ON%Całą swoją ciężką pracą nie kupisz czasu, najemniku. Davkul czeka na nas wszystkich.%SPEECH_OFF%Wyciągasz sztylet i kończysz z mężczyzną. Kopiesz jego ciało i przeszukujesz, podobnie jak pozostałe zwłoki, choć niewiele da się znaleźć.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ruszajmy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				local money = this.Math.rand(10, 100);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] koron"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_03.png[/img]{%cultist% wychodzi naprzód, odsłaniając swoją bliznowatą czaszkę, by wszyscy obcy mogli ją zobaczyć. Kiwną i kłaniają się, a ich przywódca mówi, kierując wzrok ku piaskom.%SPEECH_ON%Davkul przemówił.%SPEECH_OFF%%cultist% kiwa głową i odpowiada.%SPEECH_ON%I każdego słowa słucham.%SPEECH_OFF%Przywódca wyciąga dziwne ostrze jakby znikąd i przesuwa je po swoich palcach. Mówi dalej, nie podnosząc wzroku.%SPEECH_ON%Zatem rób, jak prosi.%SPEECH_OFF% %cultist% bierze ostrze i przytakuje.%SPEECH_ON%Davkul czeka na nas wszystkich.%SPEECH_OFF%Dziwni mężczyźni osuwają się na ziemię i wkładają twarze w piasek. Ich klatki piersiowe unoszą się i opadają, drżą, po czym zamierają. Utopili się w samej pustyni. %cultist% wraca, niosąc ze sobą osobliwy sztylet.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local item = this.new("scripts/items/weapons/oriental/qatal_dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
				_event.m.Cultist.improveMood(1.0, "Porozumiał się z braćmi w wierze");

				if (_event.m.Cultist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_03.png[/img]{Skromnie witasz i żegnasz się z czarnymi płaszczami, po czym ruszasz dalej. Nie stawiają oporu ani nie odzywają się do ciebie w żaden sposób. Ostatnie, co widzisz, to ich dłonie znów splecione i głowy pochylone naprzód, wpatrzone w piaski. Nigdzie nie widać ani dzbana z wodą, ani kosza z jedzeniem. Jeśli nie przyszli tu umrzeć, co mogłoby ich ocalić?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Może nie nam to wiedzieć.",
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

		if (this.World.getTime().Days < 10)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 7)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_cultist = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				candidates_cultist.push(bro);
			}
		}

		if (candidates_cultist.len() != 0)
		{
			this.m.Cultist = candidates_cultist[this.Math.rand(0, candidates_cultist.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
	}

});

