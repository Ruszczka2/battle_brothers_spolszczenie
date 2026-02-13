this.anatomist_vs_dog_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_dog";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_27.png[/img]{%anatomist% anatomista podchodzi do ciebie z okropnym pomyslem: chce wziac jednego z psow kompanii i go rozciac. Dla pewnosci pytasz, czy zamierza psa zabic. Kreci glowa na boki, jakby wazyl opcje.%SPEECH_ON%Uwazam, ze z perspektywy psa najlepiej, by zdechl, zanim zaczniemy go rozcinac.%SPEECH_OFF%Anatomista wyjasnia, ze wykorzystywanie psow do badan nie jest niczym niezwyklym i ze to wymaganie pomoze lepiej zrozumiec wilkory, z ktorymi pies bez watpienia jest spokrewniony. Nie potrafisz sobie wyobrazic, by zabicie psa kompanii spodobalo sie reszcie ludzi, i każesz mu znalezc jednego z setek parszywych kundli włoczacych sie w okolicy. Kreci glowa.%SPEECH_ON%Wszystkie psy sa niemal na pewno kuzynami wilkorów, ale pies bojowy to inna rasa i z pewnoscia najblizsza temu, co nas interesuje.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak, zrob to.",
					function getResult( _event )
					{
						if (_event.m.Houndmaster != null)
						{
							return "E";
						}
						else if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "Nie, tak nie sadze.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_37.png[/img]{Kiwasz glowa i mowisz, by zrobil, co musi. Z twojej perspektywy jestes tu, by pomagac tym anatomistom w ich pracy, a czasem oznacza to naruszenie funduszy kompanii. W tym wypadku pies bojowy akurat je reprezentuje. %anatomist% jest zadowolony i rusza, by to zrobic. Slyszysz brzek obrozy psa, a potem krotkie skomlenie. Pozostale dzwieki zagluszasz w glowie.\n\n%anatomist% w koncu wraca z zakrwawionymi dlonmi. Kiwal glowa i mowi, ze okaz byl zadowalajacy i wiele nauczyli sie z jego bojowego ducha. Kazesz mu pochowac psa. Wyglada na zniesmaczonego, ale ty gromisz go wzrokiem i ustępuje, mowiac, ze zapewni mu godny pochowek.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Spoczywaj w pokoju, psie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.m.XP = this.Const.LevelXP[_event.m.Anatomist.getLevel()];
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/level.png",
					text = _event.m.Anatomist.getName() + " awansuje"
				});
				local numWardogsToLose = 1;
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
					{
						numWardogsToLose = --numWardogsToLose;
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});
						break;
					}
				}

				if (numWardogsToLose != 0)
				{
					local brothers = this.World.getPlayerRoster().getAll();

					foreach( bro in brothers )
					{
						local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

						if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
						{
							numWardogsToLose = --numWardogsToLose;
							bro.getItems().unequip(item);
							this.List.push({
								id = 10,
								icon = "ui/items/" + item.getIcon(),
								text = "Tracisz " + item.getName()
							});
							break;
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_19.png[/img]{Dajesz %anatomist% zgode. Usmiecha sie jak dziecko, ktore dostalo pierwszy prezent. Gdy odchodzi, zastanawiasz sie, czy nie podjales zlej decyzji. Slyszysz, jak anatomista szamocze sie z psem, brzek obrozy i warkniecie, gdy jest szarpany. Czekasz na skomlenie, ale zamiast tego slyszysz glos zdecydowanie ludzki i nawet nieco kobiecy. Gdy pędzisz na miejsce, duzy pies przemyka obok. Zastajesz %anatomist% na ziemi, trzymajacego sie za dlon. Niezrażony, albo szukajac wartości edukacyjnej, anatomista mruczy do siebie slodkie naukowe bzdury.%SPEECH_ON%Ach, to chyba dowodzi, ze jednak mial w sobie troche krwi wilkora.%SPEECH_OFF%Niezaleznie od tego, co %anatomist% mogl wywnioskowac z krwawiacej rany, psa nigdzie nie ma. Bez watpienia nawet on zrozumial, ze taka zdrada nie pojawia sie znikad. Jesli w tym psie jest wilkor, to jest w nim tez zwykly pies, a nawet pies wie, kiedy panowie go zdradzili.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Opatrz te rane.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local injury = _event.m.Anatomist.addInjury([
					{
						ID = "injury.missing_finger",
						Threshold = 0.0,
						Script = "injury_permanent/missing_finger_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " odnosi " + injury.getNameOnly()
				});
				local numWardogsToLose = 1;
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
					{
						numWardogsToLose = --numWardogsToLose;
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});
						break;
					}
				}

				if (numWardogsToLose != 0)
				{
					local brothers = this.World.getPlayerRoster().getAll();

					foreach( bro in brothers )
					{
						local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

						if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
						{
							numWardogsToLose = --numWardogsToLose;
							bro.getItems().unequip(item);
							this.List.push({
								id = 10,
								icon = "ui/items/" + item.getIcon(),
								text = "Tracisz " + item.getName()
							});
							break;
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_27.png[/img]{%anatomist% wzdycha, ale nie protestuje zbyt mocno i ostatecznie godzi sie z twoja odmowa, odchodzac lekko zgarbiony. Zastanawiasz sie, czy gdyby mial ogon, schowalby go teraz miedzy nogi. Wtedy pojawia sie obiekt jego naukowych zapędow - sam pies, machajac ogonem i niosac patyk w pysku. Odkłada patyk u twoich stop, ale gdy sie po niego schylasz, pies warczy i porywa go. Moze te dziwne stworzenia powinny byly byc badane...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra, ty maly kundlu...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.worsenMood(0.5, "Odmowiono mu okazji zbadania psa bojowego.");
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Pozwalasz, by %anatomist% robil, co chce. Jesli twoim zadaniem jest pomagac im w naukowych obowiazkach, to takie incydenty sa tego czescia. Z oddali slyszysz, jak anatomista szamocze sie z psem i probuje go unieruchomic na szybka smierc. Ale potem slyszysz meski glos z boku, a szamotanie nabiera wyraznie ludzkiego charakteru, z krzykami, przeklenstwami i glosami proszacymi o litosc. Uswiadamiasz sobie, ze calkiem zapomniales o psim przewodniku kompanii. Biegniesz i widzisz, jak %houndmaster% smaga anatomiste smycza i od czasu do czasu zadaje ciosy.%SPEECH_ON%Boli, co? A to? Powiedz mi, uczysz sie, kiedy krwawisz? Jak myslisz, jak beda smakowac twoje zeby, jesli przerobie je na przeklety proch, co?%SPEECH_OFF%Wzdychajac, podchodzisz i odciągasz przewodnika psow od anatomisty. %houndmaster% broni sie, mowiac, ze %anatomist% probowal zabic jednego z psow. Zbywasz to machnieciem reki, twierdzac, ze musialo dojsc do jakiegos nieporozumienia. Spogladasz na zakrwawionego anatomiste i kazesz mu trzymac sie z dala od psow, a zanim zdazy wybulgotac protest o tym, ze to ty dales mu zgode, po prostu odwracasz sie i odchodzisz.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ups.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				_event.m.Anatomist.addHeavyInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Anatomist.getName() + " odnosi powazne rany"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local houndmasterCandidates = [];
		local numWardogs = 0;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && bro.getLevel() <= 6)
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.houndmaster")
			{
				houndmasterCandidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
			{
				numWardogs = ++numWardogs;
			}
		}

		if (houndmasterCandidates.len() > 0)
		{
			this.m.Houndmaster = houndmasterCandidates[this.Math.rand(0, houndmasterCandidates.len() - 1)];
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		if (numWardogs < 1)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
				{
					numWardogs = ++numWardogs;

					if (numWardogs >= 1)
					{
						break;
					}
				}
			}
		}

		if (numWardogs < 1)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 8;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster != null ? this.m.Houndmaster.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Houndmaster = null;
	}

});

