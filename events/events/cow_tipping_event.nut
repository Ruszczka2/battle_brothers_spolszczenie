this.cow_tipping_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Strong = null,
		Cocky = null
	},
	function create()
	{
		this.m.ID = "event.cow_tipping";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_72.png[/img]Podczas marszu natrafiasz na samotną krowę stojącą na polu. Niewiele w tym: to po prostu krowa.\n\nAle wtedy %randombrother% podchodzi do ciebie. Gryzie źdźbło słomy i kręci je w palcach, gdy mówi.%SPEECH_ON%No i kto twoim zdaniem da radę?%SPEECH_OFF%Pytasz: \"da radę z czym?\" Uśmiecha się.%SPEECH_ON%Oj, sorry, kap\'. Nie wiedziałem, że nie słyszałeś. Sprawdzamy, czy ktoś potrafi przewrócić tę krowę! Skoro da się to zrobić tylko raz, co powiesz na to, żebyś wybrał, kto spróbuje?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Wybierz, kogo uważasz za najlepszego.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				});

				if (_event.m.Strong != null)
				{
					this.Options.push({
						Text = "Założę się, że %strong% jest wystarczająco silny.",
						function getResult( _event )
						{
							return "Strong";
						}

					});
				}

				if (_event.m.Cocky != null)
				{
					this.Options.push({
						Text = "Ten pyszałek %cocky% aż się pali, by spróbować.",
						function getResult( _event )
						{
							return "Cocky";
						}

					});
				}

				this.Options.push({
					Text = "Zostawcie tę krowę w spokoju.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_72.png[/img]Mówisz ludziom, żeby sami to rozstrzygnęli. Szybko wybierają %cowtipper%, który po pewnym namawianiu zgadza się spróbować.\n\nNajemnik ostrożnie przechodzi przez pole, starając się omijać krowie placki. Sama krowa obojętnie zerka. Muczy raz, po czym wraca do krótkiej, bydlecej uwagi na trawie. Z chichotem ludzie popychają %cowtipper% do przodu, mamrocząc \"dawaj!\" i \"na co czekasz?\" W końcu, stojąc kilka kroków od krowy, %cowtipper% rusza z szarżą.%SPEECH_ON%Jaaahh!%SPEECH_OFF%Wpada w bok krowy i równie dobrze mógłby wpaść w dom: nogi wysuwają mu się spod niego i ślizga się pod zwierzęciem, a poślizg doskonale smaruje świeże gówno. Kompania wybucha śmiechem.%SPEECH_ON%Nie da się przewrócić krowy, głupku! Są cholernie ciężkie!%SPEECH_OFF%%cowtipper% na pewno ma teraz nową urazę do tych dowcipnisiów, ale jego \"poświęcenie\" było warte łatwej rozrywki.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ale przedstawienie!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.worsenMood(0.5, "Upokorzył się przed kompanią");

				if (_event.m.Other.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Other.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Bawił się próbą przewrócenia krowy przez " + _event.m.Other.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_72.png[/img]Mówisz ludziom, żeby sami to rozstrzygnęli. Szybko wybierają %cowtipper%. Najemnik ostrożnie przechodzi przez pole, starając się omijać krowie placki. Sama krowa obojętnie zerka i muczy raz, po czym wraca do trawy. Z chichotem ludzie popychają %cowtipper% do przodu, mamrocząc \"dawaj!\" i \"szybciej!\". W końcu, stojąc kilka kroków od krowy, %cowtipper% rusza.%SPEECH_ON%Jaaahh!%SPEECH_OFF%Krzyk płoszy krowę. Opuszcza kłąb i kopie, trafiając %cowtipper% kopytem. Ten gwałtownie obraca się i wpada prosto w trawę. Ludzie śmieją się chwilę, po czym orientują się, że to poważna sprawa. Krowa muczy i odchodzi truchtem, a najemnik zostaje \"uratowany\". Choć jest mocno poobijany, przeżyje tę niemal krowią zbrodnię.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Koniec zabawy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local injury = _event.m.Other.addInjury(this.Const.Injury.Accident3);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Other.getName() + " doznaje " + injury.getNameOnly()
				});
				_event.m.Other.worsenMood(0.5, "Upokorzył się przed kompanią");

				if (_event.m.Other.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Strong",
			Text = "[img]gfx/ui/events/event_72.png[/img]Uznajesz, że silny i barczysty %strong% mógłby przewrócić krowę. Samo twoje niezręczne sformułowanie wywołuje śmiech, ale %strong% z szacunkiem się kłania.%SPEECH_ON%To dla mnie zaszczyt, panie.%SPEECH_OFF%Podwija rękawy i rusza przez pole, omijając krowie placki jak kupiec omija bezdomnych. Krowa spogląda, unosząc ciekawie brew. %strong% kiwa głową.%SPEECH_ON%Tak, idę po ciebie.%SPEECH_OFF%Kolejne niefortunne słowa. Mimo śmiechu kompanii %strong% rusza na krowę. Na początku tylko napiera na jej bok, naprężając mięśnie i ciężko oddychając. Ludzie śmieją się, bo nic z tego nie wychodzi, ale szybko milkną, gdy krowa zaczyna się przesuwać po błocie i trawie. Z potężnym rykiem %strong% napiera, a krowa przewraca się na bok, zdezorientowanie mucząc.\n\n%otherbrother% stoi z rozdziawioną gębą.%SPEECH_ON%To był żart... nie sądziłem, że to w ogóle możliwe...%SPEECH_OFF%Kompania wybucha okrzykami na cześć niesamowitego wyczynu siłacza!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Brawo!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Strong.getImagePath());
				_event.m.Strong.getBaseProperties().Stamina += 1;
				_event.m.Strong.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Strong.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] maks. zmęczenie"
				});
				_event.m.Strong.improveMood(0.5, "Popisał się swoją siłą fizyczną");

				if (_event.m.Other.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Strong.getMoodState()],
						text = _event.m.Strong.getName() + this.Const.MoodStateEvent[_event.m.Strong.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Strong.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "Widział niesamowity wyczyn " + _event.m.Strong.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Cocky",
			Text = "[img]gfx/ui/events/event_72.png[/img]Zanim zdążysz dokończyć zdanie, %cocky% bije się w pierś i wychodzi do przodu.%SPEECH_ON%Powalę tę marną krowę!%SPEECH_OFF%Przypominasz mu, że kompania nie ma nic do bydła i że to tylko zabawa. Stoi z rękami jak namiot, pięści na biodrach.%SPEECH_ON%Bzdura. Kompania się śmieje i uważa to za niemożliwe, ale ja pokażę im, jak bardzo się mylą!%SPEECH_OFF%Pyszałek wchodzi na pole i od razu rozmazuje butem krowi placek. Sunie bokiem, machając rękami dla równowagi, ale na nic się to zdaje, bo wali na ziemię. Ludzie wybuchają śmiechem. Krowa zerka i po prostu odchodzi. %cocky% otrzepuje się.%SPEECH_ON%Drobna wpadka. Ale spójrzcie! Tchórzliwa krowa nie chce mieć ze mną nic wspólnego!%SPEECH_OFF%%otherbrother% śmieje się i wskazuje na zabrudzone ubranie najemnika.%SPEECH_ON%Może, ale wygląda na to, że kawałek jej jednak masz.%SPEECH_OFF%Pyszałek szybko ściera gówno z koszuli. Mimo porażki nie zniechęca się, a ludzie niemal mdleją ze śmiechu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wystarczyło.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				_event.m.Cocky.getBaseProperties().Bravery += 1;
				_event.m.Cocky.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/bravery.png",
					text = _event.m.Cocky.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinację"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Cocky.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "Widział zabawną porażkę " + _event.m.Cocky.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Plains && currentTile.Type != this.Const.World.TerrainType.Steppe)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidate_strong = [];
		local candidate_cocky = [];
		local candidate_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.strong") || bro.getSkills().hasSkill("trait.tough"))
			{
				candidate_strong.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.cocky"))
			{
				candidate_cocky.push(bro);
			}
			else
			{
				candidate_other.push(bro);
			}
		}

		if (candidate_other.len() == 0)
		{
			return;
		}

		if (candidate_strong.len() != 0)
		{
			this.m.Strong = candidate_strong[this.Math.rand(0, candidate_strong.len() - 1)];
		}

		if (candidate_cocky.len() != 0)
		{
			this.m.Cocky = candidate_cocky[this.Math.rand(0, candidate_cocky.len() - 1)];
		}

		this.m.Other = candidate_other[this.Math.rand(0, candidate_other.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"strong",
			this.m.Strong != null ? this.m.Strong.getNameOnly() : ""
		]);
		_vars.push([
			"strongfull",
			this.m.Strong != null ? this.m.Strong.getName() : ""
		]);
		_vars.push([
			"cocky",
			this.m.Cocky != null ? this.m.Cocky.getNameOnly() : ""
		]);
		_vars.push([
			"cockyfull",
			this.m.Cocky != null ? this.m.Cocky.getName() : ""
		]);
		_vars.push([
			"cowtipper",
			this.m.Other != null ? this.m.Other.getNameOnly() : ""
		]);
		_vars.push([
			"cowtipperfull",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"otherbrother",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Strong = null;
		this.m.Cocky = null;
		this.m.Other = null;
	}

});

