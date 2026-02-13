this.addict_steals_potion_event <- this.inherit("scripts/events/event", {
	m = {
		Addict = null,
		Other = null,
		Item = null
	},
	function create()
	{
		this.m.ID = "event.addict_steals_potion";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
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
						return 0;
					}

				},
				{
					Text = "To musi się skończyć, %addict%.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 33 ? "C" : "D";
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
				local items = this.World.Assets.getStash().getItems();

				foreach( i, item in items )
				{
					if (item == null)
					{
						continue;
					}

					if (item.getID() == _event.m.Item.getID())
					{
						items[i] = null;
						break;
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_38.png[/img]{Każesz odprowadzić %addict%a do prowizorycznego pala do chłosty. Zwisa bezwładnie na drewnie, palce ma rozpostarte, zaciska i rozluźnia. Wygląda, jakby gonił motyle, i ma nieobecne spojrzenie, gdy %otherbrother% smaga go zaciekle batem.\n\n Początkowo chłosta nic nie daje, nawet gdy bicz trzaska po jego plecach, zostawiając krwiste półksiężyce. Lecz po kilku razach wraca do rzeczywistości i zaczyna krzyczeć. Podchodzisz i pytasz, czy połknie swoje uzależnienie. Gorączkowo kiwa głową. Pozwalasz go chłostać ponownie i pytasz znów, a on znów kiwa. Kolejna chłosta, kolejne pytanie, kolejna odpowiedź. Tak to trwa, aż zostaje złamany i to, co go trapiło, znika.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zabierzcie go sprzed moich oczu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				_event.m.Addict.addLightInjury();
				this.List = [
					{
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Addict.getName() + " doznaje obrażeń"
					}
				];
				_event.m.Addict.getSkills().removeByID("trait.addict");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_29.png",
					text = _event.m.Addict.getName() + " nie jest już uzależniony"
				});
				_event.m.Addict.worsenMood(2.5, "Został wychłostany na twoje rozkazy");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Addict.getMoodState()],
					text = _event.m.Addict.getName() + this.Const.MoodStateEvent[_event.m.Addict.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Addict.getID())
					{
						continue;
					}

					if (!bro.getBackground().isOffendedByViolence() || bro.getLevel() >= 7)
					{
						continue;
					}

					bro.worsenMood(1.0, "Zaszokowany twoim rozkazem, by wychłostać " + _event.m.Addict.getName());

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
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Wyciągasz %addict%a z beczki i rzucasz go na ziemię. Chwieje się, jakby ziemia była schodami, a on patrzył w przepaść najwyższego stopnia.%SPEECH_ON%Oj, panie, ostrożnie, to tylko w dół i w dół!%SPEECH_OFF%Na początku masz ochotę skopać mu tyłek, ale odpuszczasz. Kucasz i siadasz obok, gdy przewraca się, by patrzeć w chmury. Mija czas i po chwili %addict% zaciska usta, a w jego oczach widać powracającą jasność.%SPEECH_ON%Mam problem, panie.%SPEECH_OFF%Kiwasz głową i mówisz mu, by ograniczył mikstury, że nie możesz mu ufać w takim stanie. Jeśli ma problem z byciem najemnikiem, jeśli dlatego jest taki, to w porządku, ale to problem. Znów zaciska usta i kiwa głową.%SPEECH_ON%Dziękuję, panie. Zrobię, co mogę, żeby się odfarkować i wszystko naprostować.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Miło się rozmawiało.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				_event.m.Addict.getSkills().removeByID("trait.addict");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_62.png",
					text = _event.m.Addict.getName() + " nie jest już uzależniony"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Wyciągasz %addict%a z beczki i rzucasz go na ziemię. Chwieje się, jakby ziemia była schodami, a on patrzył w przepaść najwyższego stopnia.%SPEECH_ON%Oj, panie, ostrożnie, to tylko w dół i w dół!%SPEECH_OFF%Na początku masz ochotę skopać mu tyłek, ale odpuszczasz. Kucasz i siadasz obok, gdy przewraca się, by patrzeć w chmury. Po chwili spogląda na ciebie.%SPEECH_ON%Próbujesz mi pomóc?%SPEECH_OFF%Kiwasz głową, że tak, ale %addict% tylko się uśmiecha i kręci głową.%SPEECH_ON%Nie mówię do ciebie, mówię do ciebie!%SPEECH_OFF%Wskazuje za ciebie na beczkę, a gdy się odwracasz, mężczyzna już stoi i szarżuje.%SPEECH_ON%Gruby skurczybyk będzie ze mną zgrywał cwaniaka, co?!%SPEECH_OFF%Najemnik taranuje beczkę, ta rozłupuje się od góry do dołu, a wiele przedmiotów ze środka wypada i roztrzaskuje się. Kilku najemników podbiega, obezwładnia mężczyznę i zabiera go, a ty liczysz straty.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cholera.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				local items = this.World.Assets.getStash().getItems();
				local candidates = [];

				foreach( i, item in items )
				{
					if (item == null || item.isItemType(this.Const.Items.ItemType.Legendary) || item.isItemType(this.Const.Items.ItemType.Named))
					{
						continue;
					}

					if (item.isItemType(this.Const.Items.ItemType.Misc))
					{
						candidates.push(i);
					}
				}

				if (candidates.len() != 0)
				{
					local i = candidates[this.Math.rand(0, candidates.len() - 1)];
					this.List.push({
						id = 10,
						icon = "ui/items/" + items[i].getIcon(),
						text = "Tracisz " + items[i].getName()
					});
					items[i] = null;
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
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
			if (bro.getSkills().hasSkill("trait.addict"))
			{
				candidates_addict.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.player"))
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
		this.m.Score = candidates_addict.len() * 10;
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

