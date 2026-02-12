this.drunkard_loses_stuff_event <- this.inherit("scripts/events/event", {
	m = {
		Drunkard = null,
		OtherGuy = null,
		Item = null
	},
	function create()
	{
		this.m.ID = "event.drunkard_loses_stuff";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Podczas wczorajszej inwentaryzacji %drunkard% wypił odrobinę za dużo i w efekcie zgubił %item%!\n\nSprowadzono go do ciebie, a mężczyzna, chwiejąc się na nogach, wciąż cuchnie alkoholem. Czkając próbuje się tłumaczyć, ale najlepsze, na co go stać, to zwalić się na ziemię w pijanej kupie. Śmieje się i śmieje, ale tobie nie jest do śmiechu. %otherguy% pyta, co chcesz z nim zrobić.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Każdemu zdarzają się błędy.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Służba przy latrynie przez miesiąc!",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Jeśli nie odstawi trunku, zmuszę go do tego. Przynieść bicz.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "D" : "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Drunkard.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Item.getIcon(),
					text = "Tracisz " + this.Const.Strings.getArticle(_event.m.Item.getName()) + _event.m.Item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]Pijak pada na plecy, bezmyślnie wpatrując się w niebo. Widzisz łzy w jego oczach i zakrywa twarz, próbując ukryć wstyd. Jest w nim i w jego przeszłości coś, czego nie znasz, może coś, co doprowadziło go do alkoholu. Nie możesz karać człowieka za coś, nad czym nie ma kontroli.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zabierzcie go mi z oczu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Drunkard.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Chwytasz łopatę, wiadro i zeschnięty kawałek wełny owinięty wokół kija.%SPEECH_ON%Służba przy latrynie. Miesiąc.%SPEECH_OFF%Pijak patrzy na ciebie z szeroko otwartymi oczami i próbuje błagać.%SPEECH_ON%Panie, proszę. Ja -hic- nie... ludzie, panie, oni -hic-...%SPEECH_OFF%Podnosisz rękę, zatrzymując go. Mężczyzna kołysze się, próbując stanąć prosto. Strzelając knykciami, wyjaśniasz mu drugą opcję.%SPEECH_ON%Jeśli nie chcesz tych obowiązków, możemy przyspieszyć karę biczem. Co wolisz?%SPEECH_OFF%Co zadziwiające, pijak rzeczywiście przez chwilę to rozważa, jego brwi unoszą się i opadają, a grymas przesuwa się po ustach w rytmie uświadamiania sobie, że nie ma wyjścia. W końcu wybiera bardziej śmierdzącą z dwóch opcji. Zaskoczony, że wybór w ogóle zajął mu tyle czasu, zaczynasz się zastanawiać, jak fatalna stała się dieta kompanii.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zabierzcie go mi z oczu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Drunkard.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_38.png[/img]Mężczyznę pchnął do alkoholu los, więc postanawiasz go z niego wypędzić. Każesz go wychłostać. Kilku braci broni ciągnie pijaka w bok. Czkając i jęcząc, kiwa głową bezwładnie, jakby nie zdawał sobie sprawy, co się dzieje. Wieszają go pod drzewem i zdzierają mu ubranie z pleców. Po kilku razach pijak dochodzi do siebie i zaczyna krzyczeć bez opanowania. Błaga o litość językiem zamazanym alkoholem i bólem, jak człowiek walczący o wolność od koszmaru. Jedno jest pewne: tej pomyłki już nie popełni.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To go nauczy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Drunkard.getImagePath());
				_event.m.Drunkard.addLightInjury();
				this.List = [
					{
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Drunkard.getName() + " doznaje urazu"
					}
				];
				_event.m.Drunkard.getSkills().removeByID("trait.drunkard");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_29.png",
					text = _event.m.Drunkard.getName() + " nie jest już pijakiem"
				});
				_event.m.Drunkard.worsenMood(2.5, "Was flogged on your orders");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Drunkard.getMoodState()],
					text = _event.m.Drunkard.getName() + this.Const.MoodStateEvent[_event.m.Drunkard.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Drunkard.getID())
					{
						continue;
					}

					if (!bro.getBackground().isOffendedByViolence() || bro.getLevel() >= 7)
					{
						continue;
					}

					bro.worsenMood(1.0, "Appalled by your order to have " + _event.m.Drunkard.getName() + " flogged");

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
			ID = "E",
			Text = "[img]gfx/ui/events/event_38.png[/img]Mężczyznę pchnął do alkoholu los, więc postanawiasz go z niego wypędzić. Każesz go wychłostać. Kilku ludzi ciągnie pijaka w bok. Czkając i jęcząc, kiwa głową bezwładnie, jakby nie zdawał sobie sprawy, co się dzieje. Wieszają go pod drzewem i zdzierają mu ubranie z pleców. Po kilku razach pijak dochodzi do siebie i zaczyna krzyczeć bez opanowania. Błaga o litość językiem zamazanym alkoholem i bólem, jak człowiek walczący o wolność od koszmaru.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To go nauczy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Drunkard.getImagePath());
				_event.m.Drunkard.addLightInjury();
				this.List = [
					{
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Drunkard.getName() + " receives an injury"
					}
				];
				_event.m.Drunkard.worsenMood(2.5, "Was flogged on your orders");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Drunkard.getMoodState()],
					text = _event.m.Drunkard.getName() + this.Const.MoodStateEvent[_event.m.Drunkard.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Drunkard.getID())
					{
						continue;
					}

					if (!bro.getBackground().isOffendedByViolence() || bro.getLevel() >= 7 || bro.getBackground().getID() == "background.flagellant")
					{
						continue;
					}

					bro.worsenMood(1.0, "Appalled by your order to have " + _event.m.Drunkard.getName() + " flogged");

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
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.drunkard"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local items = this.World.Assets.getStash().getItems();
		local hasItem = false;

		foreach( item in items )
		{
			if (item == null)
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Legendary))
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Weapon) || item.isItemType(this.Const.Items.ItemType.Shield) || item.isItemType(this.Const.Items.ItemType.Armor) || item.isItemType(this.Const.Items.ItemType.Helmet))
			{
				hasItem = true;
				break;
			}
		}

		if (!hasItem)
		{
			return;
		}

		this.m.Drunkard = candidates[this.Math.rand(0, candidates.len() - 1)];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Drunkard.getID())
			{
				other_candidates.push(bro);
			}
		}

		if (other_candidates.len() == 0)
		{
			return;
		}

		this.m.OtherGuy = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
		local items = this.World.Assets.getStash().getItems();
		local candidates = [];

		foreach( item in items )
		{
			if (item == null)
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Legendary) || item.isIndestructible())
			{
				continue;
			}

			if (item.isItemType(this.Const.Items.ItemType.Weapon) || item.isItemType(this.Const.Items.ItemType.Shield) || item.isItemType(this.Const.Items.ItemType.Armor) || item.isItemType(this.Const.Items.ItemType.Helmet))
			{
				candidates.push(item);
			}
		}

		this.m.Item = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.World.Assets.getStash().remove(this.m.Item);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"drunkard",
			this.m.Drunkard.getName()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
		_vars.push([
			"item",
			this.Const.Strings.getArticle(this.m.Item.getName()) + this.m.Item.getName()
		]);
	}

	function onClear()
	{
		this.m.Drunkard = null;
		this.m.OtherGuy = null;
		this.m.Item = null;
	}

});

