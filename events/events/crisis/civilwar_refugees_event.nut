this.civilwar_refugees_event <- this.inherit("scripts/events/event", {
	m = {
		AggroDude = null,
		InjuredDude = null,
		RefugeeDude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_refugees";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Prawdziwa wojna ma wśród ofiar także wielu żywych i ta nie jest wyjątkiem: idąc ścieżką, natrafiasz na dużą grupę uchodźców skulonych razem. Myli się w strumieniu, gdy ich znajdujesz, półnadzy, półobmyci i wszyscy przerażeni. Głównie kobiety i dzieci, kilku starców oraz kilku mężczyzn, którzy wydają się gotowi oddać życie za resztę, choćby ich obrona była beznadziejna. Jeden z takich mężczyzn występuje naprzód.%SPEECH_ON%Czego chcecie?%SPEECH_OFF%%aggro_bro% podchodzi do ciebie.%SPEECH_ON%Panie, możemy zabrać im wszystko, co mają, ale na pewno nie oddadzą tego dobrowolnie.%SPEECH_OFF%%injured_bro% kręci głową.%SPEECH_ON%Powiedziałbym, że nie warto. Ci ludzie i tak przeszli już dość i niewiele im zostało do dania światu.%SPEECH_OFF% | Natrafiasz na grupę uchodźców. Kobiety, dzieci, starcy i garstka szeroko otwierających oczy mężczyzn. Mają niewiele wartości, ale wciąż posiadają rzeczy warte zabrania, jeśli chciałbyś włożyć w to wysiłek. | Uchodźcy. Ich grupa ciągnie się wzdłuż ścieżki w długim, uporządkowanym szeregu. Na twój widok głowa cierpiącej stonogi zatrzymuje się, a wszystkie ciała powoli zbijają się w przerażony kłąb. %aggro_bro% sugeruje, by ich zabić i zabrać, co mają, choć według ciebie nie wygląda na to, by mieli wiele.}",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Zostawcie tych biednych ludzi w spokoju.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local food = this.World.Assets.getFoodItems();

				if (food.len() > 2)
				{
					this.Options.push({
						Text = "Podzielmy się naszymi zapasami z tymi biedakami.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.RefugeeDude != null && food.len() > 1)
				{
					this.Options.push({
						Text = "%refugee_bro%, sam byłeś uchodźcą. Porozmawiasz z nimi?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Options.push({
					Text = "Przeszukajcie ich w poszukiwaniu kosztowności!",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-3);

						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_59.png[/img]Rozkazujesz swoim ludziom zabrać, co się da. Uchodźcy cofają się z przerażeniem i niektórzy protestują, gdy twoi bracia wchodzą między nich. Nagle jeden z uchodźców chwyta duży kamień i wali %injured_bro% w głowę. Kobiety i dzieci krzyczą, a kilku innych mężczyzn łapie najemników, szarpiąc się o broń jeszcze w pochwach. Ale ci tułacze nie jedli od dni i ich osłabione ciała nie mają szans z twoimi ludźmi. %companyname% bierze, co chce.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Znajcie swoje miejsce, głupcy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.InjuredDude.getImagePath());
				local injury = _event.m.InjuredDude.addInjury(this.Const.Injury.Accident3);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.InjuredDude.getName() + " cierpi na " + injury.getNameOnly()
					}
				];
				_event.addLoot(this.List);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_59.png[/img]Rozkazujesz swoim ludziom zabrać, co się da. Uchodźcy cofają się z przerażeniem. Kobiety krzyczą, dzieci, bardziej zdezorientowane niż rozumiejące, także. Niektórzy zapłakani mężczyźni błagają, byście po prostu odeszli. Niestety dla tej bandy bezużytecznych nędzarzy, %companyname% bierze, co chce. Twoi ludzie swobodnie przeszukują tłum i w końcu wracają z łupami.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Wiedzą lepiej, niż stawiać opór.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.addLoot(this.List);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Mówisz %randombrother%, by dał uchodźcom trochę jedzenia. Zdezorientowana grupa wpatruje się w ciebie z niedowierzaniem, gdy dostają chleb i gąsior wody. Starszy człowiek podchodzi i drżąc, klęka, by pocałować cię w stopy. Podnosisz go i mówisz, że nie ma potrzeby takich teatrów. Kilku najemników chichocze i nazywa cię \"Chleb nad chlebami, Królem Czerstwego Bochna\". | Tych ludzi łatwo byłoby obrabować, ale czujesz, że wieść o tym nie zostałaby przyjęta dobrze, gdyby rozeszła się po okolicy. Zamiast tego każesz %randombrother% rozdawać jedzenie i wodę. Uchodźcy są aż irytująco szczęśliwi, lgną do ciebie, jakbyś był bogiem rzucającym manę z rąk. Masz po prostu trochę starego jedzenia do pozbycia się. Z drugiej strony, niektórzy mówią, że gdy dawni bogowie byli bardziej ludzcy, ludzie byli bardziej boscy.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Podróżujcie bezpiecznie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				local food = this.World.Assets.getFoodItems();

				for( local i = 0; i < 2; i = ++i )
				{
					local idx = this.Math.rand(0, food.len() - 1);
					local item = food[idx];
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Tracisz " + item.getName()
					});
					this.World.Assets.getStash().remove(item);
					food.remove(idx);
				}

				this.World.Assets.updateFood();
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_59.png[/img]Postanawiasz oprzeć się na człowieku, który ma osobiste doświadczenie jako uchodźca: %refugee_bro%.\n\nNajemnik wchodzi w płaczący i modlący się tłum znużonych wędrowców. Rozmawia z nimi przez jakiś czas i dzieli się jedzeniem, a jego przyjazne gesty oraz opowieści o własnej przeszłości stopniowo zjednują mu ludzi. Patrzysz, jak stary człowiek wręcza mu coś owiniętego w owczą skórę, z przewiązanymi rzemieniami. Najemnik kłania się, ściska dłoń starca i wraca.\n\nOdrzuca owczą skórę, odsłaniając miecz, który błyska w świetle tak ostro, jak można sobie wyobrazić jego cięcie. %refugee_bro% uśmiecha się.%SPEECH_ON%Jak mawiała moja matka, odrobina życzliwości nikomu nie zaszkodzi, ale ten miecz na pewno tak!%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Dobra robota z grzecznościami.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				this.Characters.push(_event.m.RefugeeDude.getImagePath());
				local food = this.World.Assets.getFoodItems();
				local item = food[this.Math.rand(0, food.len() - 1)];
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Tracisz " + item.getName()
				});
				this.World.Assets.getStash().remove(item);
				this.World.Assets.updateFood();
				local r = this.Math.rand(1, 2);
				local sword;

				if (r == 1)
				{
					sword = this.new("scripts/items/weapons/arming_sword");
				}
				else if (r == 2)
				{
					sword = this.new("scripts/items/weapons/falchion");
				}

				this.List.push({
					id = 10,
					icon = "ui/items/" + sword.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(sword.getName()) + sword.getName()
				});
				this.World.Assets.getStash().add(sword);
			}

		});
	}

	function addLoot( _list )
	{
		local r = this.Math.rand(1, 3);
		local food;

		if (r == 1)
		{
			food = this.new("scripts/items/supplies/dried_fish_item");
		}
		else if (r == 2)
		{
			food = this.new("scripts/items/supplies/ground_grains_item");
		}
		else
		{
			food = this.new("scripts/items/supplies/bread_item");
		}

		_list.push({
			id = 10,
			icon = "ui/items/" + food.getIcon(),
			text = "Zyskujesz " + food.getName()
		});
		this.World.Assets.getStash().add(food);
		this.World.Assets.updateFood();

		for( local i = 0; i < 2; i = ++i )
		{
			r = this.Math.rand(1, 10);
			local item;

			if (r == 1)
			{
				item = this.new("scripts/items/weapons/wooden_stick");
			}
			else if (r == 2)
			{
				item = this.new("scripts/items/armor/tattered_sackcloth");
			}
			else if (r == 3)
			{
				item = this.new("scripts/items/weapons/knife");
			}
			else if (r == 4)
			{
				item = this.new("scripts/items/helmets/hood");
			}
			else if (r == 5)
			{
				item = this.new("scripts/items/weapons/woodcutters_axe");
			}
			else if (r == 6)
			{
				item = this.new("scripts/items/shields/wooden_shield_old");
			}
			else if (r == 7)
			{
				item = this.new("scripts/items/weapons/pickaxe");
			}
			else if (r == 8)
			{
				item = this.new("scripts/items/armor/leather_wraps");
			}
			else if (r == 9)
			{
				item = this.new("scripts/items/armor/linen_tunic");
			}
			else if (r == 10)
			{
				item = this.new("scripts/items/helmets/feathered_hat");
			}

			this.World.Assets.getStash().add(item);
			_list.push({
				id = 10,
				icon = "ui/items/" + item.getIcon(),
				text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
			});
		}
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
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

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_aggro = [];
		local candidates_other = [];
		local candidates_refugees = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().isCombatBackground() || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute"))
			{
				candidates_aggro.push(bro);
			}
			else if (bro.getBackground().getID() == "background.refugee")
			{
				candidates_refugees.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.player") && bro.getBackground().getID() != "background.slave")
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_aggro.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.AggroDude = candidates_aggro[this.Math.rand(0, candidates_aggro.len() - 1)];
		this.m.InjuredDude = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_refugees.len() != 0)
		{
			this.m.RefugeeDude = candidates_refugees[this.Math.rand(0, candidates_refugees.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"aggro_bro",
			this.m.AggroDude.getName()
		]);
		_vars.push([
			"injured_bro",
			this.m.InjuredDude.getName()
		]);
		_vars.push([
			"refugee_bro",
			this.m.RefugeeDude != null ? this.m.RefugeeDude.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.AggroDude = null;
		this.m.InjuredDude = null;
		this.m.RefugeeDude = null;
	}

});

