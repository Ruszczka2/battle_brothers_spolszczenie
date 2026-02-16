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
			Text = "[img]gfx/ui/events/event_27.png[/img]{%anatomist% anatomista podchodzi do ciebie z okropnym pomysłem: chce wziąć jednego z psów kompanii i go rozciąć. Dla pewności pytasz, czy zamierza psa zabić. Kręci głową na boki, jakby ważył opcje.%SPEECH_ON%Uważam, że z perspektywy psa najlepiej, by zdechł, zanim zaczniemy go rozcinać.%SPEECH_OFF%Anatomista wyjaśnia, że wykorzystywanie psów do badań nie jest niczym niezwykłym i że to wymaganie pomoże lepiej zrozumieć wilkory, z którymi pies bez wątpienia jest spokrewniony. Nie potrafisz sobie wyobrazić, by zabicie psa kompanii spodobało się reszcie ludzi, i każesz mu znaleźć jednego z setek parszywych kundli włóczących się w okolicy. Kręci głową.%SPEECH_ON%Wszystkie psy są niemal na pewno kuzynami wilkorów, ale pies bojowy to inna rasa i z pewnością najbliższa temu, co nas interesuje.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak, zrób to.",
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
					Text = "Nie, tak nie sądzę.",
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
			Text = "[img]gfx/ui/events/event_37.png[/img]{Kiwasz głową i mówisz, by zrobił, co musi. Z twojej perspektywy jesteś tu, by pomagać tym anatomistom w ich pracy, a czasem oznacza to naruszenie funduszy kompanii. W tym wypadku pies bojowy akurat je reprezentuje. %anatomist% jest zadowolony i rusza, by to zrobić. Słyszysz brzęk obroży psa, a potem krótkie skomlenie. Pozostałe dźwięki zagłuszasz w głowie.\n\n%anatomist% w końcu wraca z zakrwawionymi dłońmi. Kiwał głową i mówi, że okaz był zadowalający i wiele nauczyli się z jego bojowego ducha. Każesz mu pochować psa. Wygląda na zniesmaczonego, ale ty gromisz go wzrokiem i ustępuje, mówiąc, że zapewni mu godny pochówek.}",
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
			Text = "[img]gfx/ui/events/event_19.png[/img]{Dajesz %anatomist% zgodę. Uśmiecha się jak dziecko, które dostało pierwszy prezent. Gdy odchodzi, zastanawiasz się, czy nie podjąłeś złej decyzji. Słyszysz, jak anatomista szamocze się z psem, brzęk obroży i warknięcie, gdy jest szarpany. Czekasz na skomlenie, ale zamiast tego słyszysz głos zdecydowanie ludzki i nawet nieco kobiecy. Gdy pędzisz na miejsce, duży pies przemyka obok. Zastajesz %anatomist% na ziemi, trzymającego się za dłoń. Niezrażony, albo szukając wartości edukacyjnej, anatomista mruczy do siebie słodkie naukowe bzdury.%SPEECH_ON%Ach, to chyba dowodzi, że jednak miał w sobie trochę krwi wilkora.%SPEECH_OFF%Niezależnie od tego, co %anatomist% mógł wywnioskować z krwawiącej rany, psa nigdzie nie ma. Bez wątpienia nawet on zrozumiał, że taka zdrada nie pojawia się znikąd. Jeśli w tym psie jest wilkor, to jest w nim też zwykły pies, a nawet pies wie, kiedy panowie go zdradzili.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Opatrz tę ranę.",
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
			Text = "[img]gfx/ui/events/event_27.png[/img]{%anatomist% wzdycha, ale nie protestuje zbyt mocno i ostatecznie godzi się z twoją odmową, odchodząc lekko zgarbiony. Zastanawiasz się, czy gdyby miał ogon, schowałby go teraz między nogi. Wtedy pojawia się obiekt jego naukowych zapędów - sam pies, machając ogonem i niosąc patyk w pysku. Odkłada patyk u twoich stóp, ale gdy się po niego schylasz, pies warczy i porywa go. Może te dziwne stworzenia powinny były być badane...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra, ty mały kundlu...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.worsenMood(0.5, "Odmówiono mu okazji zbadania psa bojowego.");
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Pozwalasz, by %anatomist% robił, co chce. Jeśli twoim zadaniem jest pomagać im w naukowych obowiązkach, to takie incydenty są tego częścią. Z oddali słyszysz, jak anatomista szamocze się z psem i próbuje go unieruchomić na szybką śmierć. Ale potem słyszysz męski głos z boku, a szamotanie nabiera wyraźnie ludzkiego charakteru, z krzykami, przekleństwami i głosami proszącymi o litość. Uświadamiasz sobie, że całkiem zapomniałeś o psim przewodniku kompanii. Biegniesz i widzisz, jak %houndmaster% smaga anatomistę smyczą i od czasu do czasu zadaje ciosy.%SPEECH_ON%Boli, co? A to? Powiedz mi, uczysz się, kiedy krwawisz? Jak myślisz, jak będą smakować twoje zęby, jeśli przerobię je na przeklęty proch, co?%SPEECH_OFF%Wzdychając, podchodzisz i odciągasz przewodnika psów od anatomisty. %houndmaster% broni się, mówiąc, że %anatomist% próbował zabić jednego z psów. Zbywasz to machnięciem ręki, twierdząc, że musiało dojść do jakiegoś nieporozumienia. Spoglądasz na zakrwawionego anatomistę i każesz mu trzymać się z dala od psów, a zanim zdąży wybulgotać protest o tym, że to ty dałeś mu zgodę, po prostu odwracasz się i odchodzisz.}",
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
					text = _event.m.Anatomist.getName() + " odnosi poważne rany"
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

