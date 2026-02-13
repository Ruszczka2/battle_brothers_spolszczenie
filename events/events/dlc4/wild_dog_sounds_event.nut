this.wild_dog_sounds_event <- this.inherit("scripts/events/event", {
	m = {
		Hunter = null,
		Wildman = null,
		Expendable = null
	},
	function create()
	{
		this.m.ID = "event.wild_dog_sounds";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Gdy kompania obozuje, %randombrother% przestaje ostrzyć ostrze i podnosi wzrok.%SPEECH_ON%Słyszeliście to?%SPEECH_OFF%Słyszysz. Dzikie psy skamlą i wyją. Wzruszasz ramionami i mówisz, że to nic, ale w tej chwili rozlega się skowyt, a popiskiwania przechodzą w warkot i słychać wyraźny odgłos zwierzęcej szarpaniny. Warkot zmienia się w skomlenie. Ktoś przegrywa walkę. %randombrother% odwraca się do ciebie.%SPEECH_ON%Brzmi blisko, sprawdzimy? Nie chcę spać z tym w pobliżu.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Po prostu to zignoruj.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Hunter != null)
				{
					this.Options.push({
						Text = "Jesteś myśliwym, %hunter%, idź sprawdź.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Jesteś człowiekiem dziczy, %wildman%, idź sprawdź.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				if (_event.m.Expendable != null)
				{
					this.Options.push({
						Text = "Wygląda na robotę dla nowego. Idź sprawdź, %recruit%!",
						function getResult( _event )
						{
							return this.Math.rand(1, 100) <= 40 ? "F" : "G";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Mówisz kompanii, by zignorowała odgłosy. To trudne, bo skowyt dzikich psów tylko narasta, aż nagle, po prostu, milknie. Twoi ludzie stoją bez ruchu, jakby każdy hałas mógł sprowadzić piekło tego, co czai się tam na zewnątrz. Nic się nie dzieje, ale wielu z nich ma kłopot z przespaniem nocy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nabierzcie odwagi, tchórze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.beast_hunter")
					{
						continue;
					}

					if (bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.barbarian")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.worsenMood(0.5, "Nie wyspał się w nocy");
						local effect = this.new("scripts/skills/effects_world/exhausted_effect");
						bro.getSkills().add(effect);
						this.List.push({
							id = 10,
							icon = effect.getIcon(),
							text = bro.getName() + " jest wyczerpany"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Mówisz kompanii, by zatkali uszy, skoro tak im przeszkadza. Gdy wycie dzikich psów narasta, ludzie biorą się za improwizowane świecowanie uszu, by zagłuszyć dźwięki. W końcu pozbawieni słuchu najemnicy chodzą niezgrabnie jak automaty. Sam chcesz do nich dołączyć, wciskając woskową kulkę do ucha, ale zanim zatkasz drugie, głośny trzask rozlewa zapasy, a namiot nadyma się i zapada. Opróżniasz ucho i wydajesz rozkazy najemnikom rozrzuconym po całym obozie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do broni, głusi głupcy!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.Entities = [];
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Unhold, this.Math.rand(80, 100), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_14.png[/img]{Wygląda na to, że ludzi nie uspokoisz, mówiąc im, by nabrali odwagi. %hunter% postanawia pójść sprawdzić hałas, bo jest pewien, że to tylko dzikie psy kłócą się o przywództwo w stadzie. Wysyłasz go, a człowiek rusza w ciemność samotnie. Zaraz po jego zniknięciu psie wycie milknie i słyszysz pomruk, który zdaje się dochodzić z dużo większej wysokości. Cały obóz zamiera, nie śmiejąc się nawet poruszyć.\n\n Godzinę później myśliwy wraca do obozu, nikt nie słyszał, jak przyszedł. Zakamuflował się błotem oblepionym gałązkami i liśćmi. Wplótł patyki w kaptur, który nosi jak jakaś leśna mniszka. Cicho najemnicy pytają, co widział. Wzrusza ramionami.%SPEECH_ON%No. Widziałem jakieś tuzin martwych psów. Niektóre rozerwane. Kilka leżało w dołach bardzo dużych śladów i nie znalazły śladu, tylko zostały tam zdeptane, wiesz. I widziałem coś, co poruszało się w cieniu między czubkami drzew, poszło w drugą stronę i nie poszedłem za tym. Znalazłem jelenia martwego na nogach, opartego o drzewo. Serce zawiodło od tego, co zobaczył, pewnie. Zebrałem wszystko, co się dało.%SPEECH_OFF%Mężczyzna odwraca się i przerzuca do przodu wieszak mięsa przywiązany do konstrukcji z drewna i liści.%SPEECH_ON%Ktoś głodny?%SPEECH_OFF%} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niezły łup, chyba.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Hunter.getImagePath());
				local item = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zdobywasz " + item.getName()
				});
				_event.m.Hunter.getBaseProperties().Bravery += 1;
				_event.m.Hunter.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Hunter.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinacji"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.beast_hunter")
					{
						continue;
					}

					if (bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.barbarian")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 15)
					{
						bro.worsenMood(0.5, "Niepokoi się, że tam na zewnątrz jest coś dużego");
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Strach ogarnia obóz, ale sprowadzasz do siebie %wildman%. Dziki człowiek prycha i przesuwa dłonią po nosie, jakbyś przeszkodził w jakiejś niezrozumiałej koncepcji jego czasu. Unosi brew, gdy sugerujesz, najlepiej jak potrafisz gestami, by poszedł sprawdzić hałas. Bez dalszych zachęt mruczy i znika w lesie.\n\n Przysiągłbyś, że jest dobrych sto metrów dalej, ale wciąż słyszysz, jak przedziera się przez krzaki, robiąc cały ten cholerny hałas świata. Dzikie psy przestają wyć, a w ich miejsce słyszysz głośny pomruk i pohukiwania mniejszego stworzenia. Odzywają się na przemian, a ty czujesz drżenie ziemi pod stopami. Wibracje słabną i cichną, a krzyki milkną całkiem. Gdy zaczynasz się martwić, dziki człowiek wraca do obozu. Siada przy ognisku, ziewa, przewraca się i zasypia. Jakby w ogóle nie odszedł.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Problem chyba rozwiązany.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				_event.m.Wildman.improveMood(1.0, "Dobrze się wyspał");

				if (_event.m.Wildman.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Wildman.getMoodState()],
						text = _event.m.Wildman.getName() + this.Const.MoodStateEvent[_event.m.Wildman.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Rozglądasz się po kompanii. Młody %recruit% patrzy na ciebie. Spogląda w dół, jakby szukał czegoś w sobie, po czym pospiesznie wstaje.%SPEECH_ON%Nie mów nic więcej, kapitanie. Dowiem się, co to za zamieszanie.%SPEECH_OFF%Świeży rekrut zbiera swoje rzeczy, po czym staje na skraju światła obozu, a bardzo ciemny las patrzy na niego z powrotem. Mężczyzna znów opuszcza wzrok i zaciska oraz rozluźnia dłonie.%SPEECH_ON%Dobrze. Dobrze.%SPEECH_OFF%Podnosi wzrok.%SPEECH_ON%Zróbmy to.%SPEECH_OFF%Mężczyzna już nigdy nie wraca.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Może wysłanie żółtodzioba nie było najlepszym pomysłem.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Expendable.getImagePath());
				local dead = _event.m.Expendable;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Zaginął",
					Expendable = dead.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Expendable.getName() + " zaginął"
				});
				_event.m.Expendable.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.Expendable.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.Expendable);
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Rozglądasz się po kompanii. Młody %recruit% patrzy na ciebie. Spogląda w dół, jakby szukał czegoś w sobie, po czym pospiesznie wstaje.%SPEECH_ON%Nie mów nic więcej, kapitanie. Dowiem się, co to za zamieszanie.%SPEECH_OFF%Świeży rekrut zbiera swoje rzeczy, po czym staje na skraju światła obozu, a bardzo ciemny las patrzy na niego z powrotem. Mężczyzna znów opuszcza wzrok i zaciska oraz rozluźnia dłonie. Prycha, po czym rusza naprzód, natychmiast znikając w cieniach. Mijają godziny. W końcu wraca. Jego ubrania są w strzępach. Broń zniknęła. Wyrzuca z siebie historię za historią. Magiczne pierścienie, wulkany, olbrzymie orły, kompletne bzdury. Cokolwiek zobaczył, jasne jest, że roztrzęsiony najemnik musi oczyścić głowę solidnym snem. Który dostanie, bo cały ten okropny hałas ustał.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Idź spać, chłopcze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Expendable.getImagePath());
				_event.m.Expendable.addXP(200, false);
				_event.m.Expendable.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Expendable.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] doświadczenia"
				});
				_event.m.Expendable.improveMood(3.0, "Przeżył wspaniałą przygodę");

				if (_event.m.Expendable.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Expendable.getMoodState()],
						text = _event.m.Expendable.getName() + this.Const.MoodStateEvent[_event.m.Expendable.getMoodState()]
					});
				}

				local items = _event.m.Expendable.getItems();

				if (items.getItemAtSlot(this.Const.ItemSlot.Mainhand) != null && items.getItemAtSlot(this.Const.ItemSlot.Mainhand).isItemType(this.Const.Items.ItemType.Weapon) && !items.getItemAtSlot(this.Const.ItemSlot.Mainhand).isItemType(this.Const.Items.ItemType.Legendary) && !items.getItemAtSlot(this.Const.ItemSlot.Mainhand).isItemType(this.Const.Items.ItemType.Named))
				{
					this.List.push({
						id = 10,
						icon = "ui/items/" + items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getIcon(),
						text = "Tracisz " + this.Const.Strings.getArticle(items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getName()) + items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getName()
					});
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
				}

				if (items.getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					items.getItemAtSlot(this.Const.ItemSlot.Head).setCondition(this.Math.max(1, items.getItemAtSlot(this.Const.ItemSlot.Head).getConditionMax() * this.Math.rand(10, 40) * 0.01));
				}

				if (items.getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					items.getItemAtSlot(this.Const.ItemSlot.Body).setCondition(this.Math.max(1, items.getItemAtSlot(this.Const.ItemSlot.Body).getConditionMax() * this.Math.rand(10, 40) * 0.01));
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen || !this.Const.DLC.Unhold)
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

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_hunter = [];
		local candidates_wildman = [];
		local candidates_recruit = [];
		local others = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.beast_hunter")
			{
				candidates_hunter.push(bro);
			}
			else if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
			else if (bro.getXP() == 0)
			{
				candidates_recruit.push(bro);
			}
			else
			{
				others.push(bro);
			}
		}

		if (candidates_hunter.len() == 0 && candidates_wildman.len() == 0 && candidates_recruit.len() == 0 || others.len() == 0)
		{
			return;
		}

		if (candidates_hunter.len() != 0)
		{
			this.m.Hunter = candidates_hunter[this.Math.rand(0, candidates_hunter.len() - 1)];
		}

		if (candidates_wildman.len() != 0)
		{
			this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		}

		if (candidates_recruit.len() != 0)
		{
			this.m.Expendable = candidates_recruit[this.Math.rand(0, candidates_recruit.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hunter",
			this.m.Hunter.getName()
		]);
		_vars.push([
			"wildman",
			this.m.Wildman ? this.m.Wildman.getName() : ""
		]);
		_vars.push([
			"recruit",
			this.m.Expendable ? this.m.Expendable.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Hunter = null;
		this.m.Wildman = null;
		this.m.Expendable = null;
	}

});

