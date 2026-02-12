this.cat_on_tree_event <- this.inherit("scripts/events/event", {
	m = {
		Archer = null,
		Ratcatcher = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.cat_on_tree";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]Znajdujesz chłopca i dziewczynkę wpatrujących się w drzewo. Dziewczynka unosi ręce.%SPEECH_ON%No to siedź tam, aż umrzesz! Zobacz, czy mnie to obchodzi!%SPEECH_OFF%Chłopak, zauważywszy cię, pyta, czy mógłbyś pomóc im zdjąć kota z drzewa. Gdy patrzysz w górę, widzisz kota rozłożonego na gałęzi, wygrzewającego się w słońcu.",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				if (_event.m.Archer != null)
				{
					this.Options.push({
						Text = "%archerfull%, spróbujesz strącić go strzałą?",
						function getResult( _event )
						{
							if (this.Math.rand(1, 100) <= 70)
							{
								return "ArrowGood";
							}
							else
							{
								return "ArrowBad";
							}
						}

					});
				}

				if (_event.m.Ratcatcher != null)
				{
					this.Options.push({
						Text = "%ratcatcherfull% ma coś w zanadrzu.",
						function getResult( _event )
						{
							return "Ratcatcher";
						}

					});
				}

				this.Options.push({
					Text = "To naprawdę nie nasz problem.",
					function getResult( _event )
					{
						return "F";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "ArrowGood",
			Text = "[img]gfx/ui/events/event_97.png[/img]%archer% nakłada strzałę i wystawia język, celując w górę. Dziewczynka i chłopak nie wydają się zachwyceni tym pomysłem i zasłaniają oczy dłońmi. Łucznik wypuszcza strzałę, która pęka o gałąź, łamiąc ją i posyłając kota w dół jak w grze w diabelskie pałeczki. Gdy spada na ziemię, chłopak i dziewczynka rzucają się na niego. Głaszczą go i dziękują ci za pomoc. Dziewczynka mocno przytula kota.%SPEECH_ON%W końcu mamy coś do jedzenia!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Słucham, co?",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer.getImagePath());
				_event.m.Archer.getBaseProperties().RangedSkill += 1;
				_event.m.Archer.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.Archer.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Umiejętność strzelania"
				});
			}

		});
		this.m.Screens.push({
			ID = "ArrowBad",
			Text = "[img]gfx/ui/events/event_97.png[/img]%archer% przygotowuje się, nakłada strzałę i celuje. Kot mruczy, wpatrując się w linię strzału, dość wzniosły w swoim samobójczym bezruchu. Mrużąc jedno oko, łucznik wypuszcza strzałę. Miauczenia nie ma wiele. Kot spada z drzewa jak w grze w diabelskie pałeczki i ląduje na ziemi ze strzałą wystającą do połowy z głowy. Dziewczynka kuca i patrzy na śliski kawałek mózgu kołyszący się na grocie strzały. Spogląda na ciebie, jakby to ty oddał strzał.%SPEECH_ON%To był mój przyjaciel.%SPEECH_OFF%Mówisz jej, że ci przykro i że znajdzie więcej przyjaciół. Chłopak chowa kawałek mózgu do kieszeni i zarzuca tuszę kota na ramię. Ponuro stwierdza.%SPEECH_ON%Przynajmniej mamy teraz coś do jedzenia.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Spoczywaj w pokoju, kiciu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer.getImagePath());
				_event.m.Archer.worsenMood(1.0, "Przypadkowo zastrzelił kota dziewczynki");

				if (_event.m.Archer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer.getMoodState()],
						text = _event.m.Archer.getName() + this.Const.MoodStateEvent[_event.m.Archer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Ratcatcher",
			Text = "[img]gfx/ui/events/event_97.png[/img]%ratcatcher% pstryka palcami.%SPEECH_ON%Oj, mam plan! Wy, małe urwisy, poczekajcie chwilę!%SPEECH_OFF%Szczurołap wyciąga z kieszeni szczura, o którym nie miałeś pojęcia. Cmoka ustami jak miauczący kot i unosi małego gryzonia. Kot zwraca uwagę, nastawia uszy.%SPEECH_ON%No dalej, kocisko, zejdź na obiad.%SPEECH_OFF%Szczurołap przysuwa szczura do ust i szepcze.%SPEECH_ON%Nie, wcale nie, heheh.%SPEECH_OFF%Gdy kot schodzi, %ratcatcher% wysuwa swojego przyjaciela nieco bardziej. Ten zaczyna drapać i wiercić się w jego dłoniach, być może nie ufając, że pan go ochroni. Ale w chwili, gdy kot rzuca się po posiłek, szczurołap chowa szczura i w jednym szybkim ruchu chwyta kota. Dzieci klaszczą i wiwatują, gdy oddaje im kota. Nawet część ludzi jest pod wrażeniem jego kocich odruchów!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mistrzowsko!",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
				_event.m.Ratcatcher.getBaseProperties().Initiative += 2;
				_event.m.Ratcatcher.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Ratcatcher.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Inicjatywę"
				});
				_event.m.Ratcatcher.improveMood(1.0, "Zaimponował wszystkim swoją zwinnością");

				if (_event.m.Ratcatcher.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Ratcatcher.getMoodState()],
						text = _event.m.Ratcatcher.getName() + this.Const.MoodStateEvent[_event.m.Ratcatcher.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_97.png[/img]Mówisz dzieciakom wprost, że powinny sprawić sobie psa, po czym odchodzisz.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Kot i tak nie chce być waszym przyjacielem.",
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
		local candidates_archer = [];
		local candidates_ratcatcher = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.sellsword")
			{
				candidates_archer.push(bro);
			}
			else if (bro.getBackground().getID() == "background.ratcatcher")
			{
				candidates_ratcatcher.push(bro);
			}
		}

		if (candidates_archer.len() == 0 && candidates_ratcatcher.len() == 0)
		{
			return;
		}

		if (candidates_archer.len() != 0)
		{
			this.m.Archer = candidates_archer[this.Math.rand(0, candidates_archer.len() - 1)];
		}

		if (candidates_ratcatcher.len() != 0)
		{
			this.m.Ratcatcher = candidates_ratcatcher[this.Math.rand(0, candidates_ratcatcher.len() - 1)];
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
			"archer",
			this.m.Archer != null ? this.m.Archer.getNameOnly() : ""
		]);
		_vars.push([
			"archerfull",
			this.m.Archer != null ? this.m.Archer.getName() : ""
		]);
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher != null ? this.m.Ratcatcher.getNameOnly() : ""
		]);
		_vars.push([
			"ratcatcherfull",
			this.m.Ratcatcher != null ? this.m.Ratcatcher.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Archer = null;
		this.m.Ratcatcher = null;
		this.m.Town = null;
	}

});

