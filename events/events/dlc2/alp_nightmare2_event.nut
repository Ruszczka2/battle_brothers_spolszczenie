this.alp_nightmare2_event <- this.inherit("scripts/events/event", {
	m = {
		Addict = null,
		Other = null,
		Item = null
	},
	function create()
	{
		this.m.ID = "event.alp_nightmare2";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Idziesz sprawdzić zapasy i znajdujesz %addict%a rozłożonego w beczce, półdupkiem, z wszystkimi czterema kończynami zwisającymi przez rant. Na jego brzuchu leży kilka fiol. Patrzy na ciebie matowymi, zaczerwienionymi oczami, a oczodoły są purpurowe, jakby cała krew napłynęła właśnie tam. Pytasz, co do diabła się dzieje, a %addict% tylko się uśmiecha.%SPEECH_ON%Rób, uh, co musisz. Eee, kapitanie. Bo ja już wygrałem.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mam tylko nadzieję, że wyleczysz się na czas.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "To musi się skończyć, %addict%.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Dosyć. Wypędzę z ciebie tego pieprzonego demona batem!",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Item.getIcon(),
					text = "Tracisz " + this.Const.Strings.getArticle(_event.m.Item.getName()) + _event.m.Item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_38.png[/img]{Każesz odprowadzić %addict%a do prowizorycznego pala do chłosty. Zwisa bezwładnie na drewnie, palce ma rozpostarte, zaciska i rozluźnia. Wygląda, jakby gonił motyle, i ma nieobecne spojrzenie, gdy %otherbrother% smaga go zaciekle batem.\n\n Początkowo chłosta nic nie daje, nawet gdy bicz trzaska po jego plecach, zostawiając krwiste półksiężyce. Lecz po kilku razach wraca do rzeczywistości i zaczyna krzyczeć. Podchodzisz i pytasz, czy połknie swoje uzależnienie. Gorączkowo kiwa głową. Pozwalasz go chłostać ponownie i pytasz znów, a on znów kiwa. Kolejna chłosta, kolejne pytanie, kolejna odpowiedź. W końcu %otherbrother% luzuje bicz i zwija go.%SPEECH_ON%Nie żyje, panie.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Co? Pokaż mi!",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				this.Characters.push(_event.m.Other.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Addict.getName() + " zginął"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Addict.getID() || bro.getID() == _event.m.Other.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						continue;
					}

					local mood = this.Math.rand(0, 1);
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[mood],
						text = bro.getName() + this.Const.MoodStateEvent[mood]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_39.png[/img]{Rzucasz się do przodu i chcesz unieść głowę mężczyzny, ale okazuje się, że to dzbanek przywiązany do włóczni. Cofając się, wpadasz na %addict%a, który sortuje zapasy.%SPEECH_ON%Kapitanie, wszystko w porządku?%SPEECH_OFF%Kiwając głową, pytasz, jak stoją zapasy mikstur. Uśmiecha się.%SPEECH_ON%Wszystko policzone. Mam policzyć jeszcze raz?%SPEECH_OFF%Mówisz mu, by policzył coś innego i idziesz do namiotu po drinka. Odwracając się, dostrzegasz bladą postać, która odsuwa się od jednej ze skrzyń. Dobytasz miecza i ruszasz za nią, ale znajdujesz tylko płachtę falującą na wietrze.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Może po prostu potrzebuję odpoczynku.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_39.png[/img]{Wyciągasz %addict%a z beczki i rzucasz go na ziemię. Szybko się odwraca i krzyczy z pełną jasnością.%SPEECH_ON%Co do farka, kapitanie?%SPEECH_OFF%To wcale nie %addict%, tylko %otherbrother%. Odwracając wzrok, widzisz %addict%a ostrzącego ostrze. Blada postać przesuwa się w oddali, ale gdy mrugasz, znika. Pomagasz %otherbrother%owi wstać i mówisz mu, by wypatrywał rabusiów. Kiwa głową posłusznie, być może czując, że coś z tobą nie tak, albo nie chcąc cię konfrontować z pomyłką. Wracasz do namiotu po drinka.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Może powinienem jednak spać.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Zostawiasz mężczyznę, ale gdy tylko się odwracasz, słyszysz brzęk tłuczonego szkła i bulgot człowieka, który je zniszczył. Odwracasz się i widzisz %addict%a zgiętego wpół, z paskami mięsa zamiast szyi, wygrzebującego szkło z odsłoniętego gardła. Rzucasz się na pomoc, kładąc dłoń na krwawieniu, i czujesz, jak jego gardło zaciska się na twoich palcach jak pysk ryby wyrzuconej na brzeg. Mężczyzna osuwa się na ziemię, cały jego ciężar, bezwładny ciężar, martwy ciężar.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powinienem był zareagować...",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Addict.getName() + " zginął"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Addict.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 66)
					{
						continue;
					}

					local mood = this.Math.rand(0, 1);
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[mood],
						text = bro.getName() + this.Const.MoodStateEvent[mood]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_39.png[/img]{Pochylasz głowę ku ziemi, czując tak wielki wstyd, że wracasz myślami do dni, gdy obchodziły cię jeszcze stare bóstwa. Gdy podnosisz wzrok, widzisz, że masz palce w worku zboża, a jego zawartość rozsypuje się wszędzie.%SPEECH_ON%Oj, kapitanie, musimy to wykorzystać.%SPEECH_OFF%Spoglądając w bok, widzisz %addict%a i białą smugę stojącą za nim. Zrywasz się na nogi, ale gdzieś w całym tym zamieszaniu cień znika. Nie znajdujesz go ani śladów, i nie chcąc bardziej straszyć %addict%a, mówisz najemnikowi, by uważnie pilnował obwodu. Sam idziesz do namiotu po drinka.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Może nawet dwa albo trzy drinki.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 20)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_addict = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.addict"))
			{
				candidates_addict.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_addict.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		local items = this.World.Assets.getStash().getItems();
		local candidates_items = [];

		foreach( item in items )
		{
			if (item == null)
			{
				continue;
			}

			if (item.getID() == "misc.potion_of_knowledge" || item.getID() == "misc.antidote" || item.getID() == "misc.snake_oil" || item.getID() == "accessory.recovery_potion" || item.getID() == "accessory.iron_will_potion" || item.getID() == "accessory.berserker_mushrooms" || item.getID() == "accessory.cat_potion" || item.getID() == "accessory.lionheart_potion" || item.getID() == "accessory.night_vision_elixir")
			{
				candidates_items.push(item);
			}
		}

		if (candidates_items.len() == 0)
		{
			return;
		}

		this.m.Addict = candidates_addict[this.Math.rand(0, candidates_addict.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Item = candidates_items[this.Math.rand(0, candidates_items.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"addict",
			this.m.Addict.getName()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
		_vars.push([
			"item",
			this.Const.Strings.getArticle(this.m.Item.getName()) + this.m.Item.getName()
		]);
	}

	function onClear()
	{
		this.m.Addict = null;
		this.m.Other = null;
		this.m.Item = null;
	}

});

