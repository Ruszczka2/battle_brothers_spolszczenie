this.horse_race_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Fat = null,
		Athletic = null,
		Dumb = null,
		Reward = 0
	},
	function create()
	{
		this.m.ID = "event.horse_race";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Natrafiasz na mężczyznę trzymającego wodze chudego konia, którego łysawa grzywa widziała lepsze dni. Konio tworzy się siwa broda, a suche, spękane wargi mlaskają rozpaczliwie za wodą. Na twój widok właściciel macha.%SPEECH_ON%No, no! Mam zakład dla odważnych i szybkich, którzy sądzą, że go wygrają!%SPEECH_OFF%Ciekaw, pytasz, o co chodzi w zakładzie. Mężczyzna klepie konia, wzbija się pióropusz kurzu i widać odcisk dłoni na łopatce.%SPEECH_ON%Ścigaj się z moim koniem! Nie z innym koniem, tylko na własnych nogach! Jeśli przegrasz, dasz mi %reward% koron. Jeśli wygrasz, zapłacę ci potrójnie. Wchodzisz w to?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze. Niech ktoś wystąpi i ściga się z tym koniem!",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Athletic != null)
				{
					this.Options.push({
						Text = "Nasz najsprawniejszy, %athlete%, pobiegnie z tym koniem.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				if (_event.m.Fat != null)
				{
					this.Options.push({
						Text = "Nasz najtłuściejszy, %fat%, pobiegnie dla naszej uciechy.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Dumb != null)
				{
					this.Options.push({
						Text = "Tylko %dumb% jest na tyle tępy, by ścigać się z koniem.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Options.push({
					Text = "Nie, dzięki.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{Wskazujesz %randombrother%, by spróbował i zobaczył, czy da radę bestii. Zasady wyścigu są proste: pierwszy do jabłoni, a zanim zdążysz zacząć kibicować najemnikowi, koń kompletnie go rozbija. Dociera do mety i zaczyna wyskubywać z gałęzi jabłka. Kompania siedzi w całkowitej ciszy, ale gdy %randombrother% przekracza linię mety na odległym ostatnim miejscu, wybuchają radością, jakby właśnie wygrał klucze do najlepszego burdelu w królestwie. Właściciel konia śmieje się.%SPEECH_ON%Nie bierz tego do siebie, panie. Frajda jest w samej szansie.%SPEECH_OFF%Rzeczywiście wygląda na to, że widowisko wysiłków tego człowieka rozbawiło kompanię.} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To była niezła rozrywka.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				this.World.Assets.addMoney(-_event.m.Reward);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Reward + "[/color] koron"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Other.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 40)
					{
						bro.improveMood(1.0, "Bawił się, oglądając jak " + _event.m.Other.getName() + " ściga się z koniem");

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
			Text = "%terrainImage%{%athlete% występuje naprzód. Łydki wypychają mu skarpety, a on kręci ramionami, by się rozgrzać.%SPEECH_ON%Jasne, pobiegnę z tym lichym koniem.%SPEECH_OFF%Zakład stoi, a właściciel konia prowadzi was na ścieżkę. Gdy wyścig jest gotowy, unosi parę drewnianych szczypiec trzymanych na dystans odwróconym zębem. Kiedy przecina sznur, szczypce z trzaskiem się zamykają i dają start. Choć wygląda jak brodawka zostawiona na deszczu, koń natychmiast uzyskuje przewagę nad zwinnym najemnikiem. Dopiero w połowie trasy wytrzymałość najemnika zdaje się włączyć go z powrotem do wyścigu, lecz na mecie ostatecznie przegrywa. Właściciel klaszcze w dłonie.%SPEECH_ON%Och, to było blisko! Najbliżej, jak widziałem!%SPEECH_OFF%Kiwasz głową i płacisz mu, co mu się należy. %athlete% przegrał, ale mimo to wygląda na to, że porażka w czymś go poprawiła, a kompania na pewno bawiła się świetnie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niezła próba.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Athletic.getImagePath());
				this.World.Assets.addMoney(-_event.m.Reward);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Reward + "[/color] koron"
				});
				_event.m.Athletic.getBaseProperties().Stamina += 1;
				_event.m.Athletic.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Athletic.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] maks. zmęczenia"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Athletic.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Bawił się, oglądając jak " + _event.m.Athletic.getName() + " ściga się z koniem");

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
			ID = "D",
			Text = "%terrainImage%{Czując się dość odważnie, wyznaczasz najtłuściejszego człowieka w kompanii do wyścigu. %fat% występuje z uniesioną brwią, pytając, czy na pewno chcesz go jako mistrza wyścigów. Kładziesz dłoń na jego ramieniu i mówisz, że jest najtłuściejszym draniem, jakiego widziałeś wśród najemników, ale w niego wierzysz. Wierzysz też, że koń to zmęczony koń pociągowy na ostatnich nogach, ale to zachowujesz dla siebie.\n\n Mężczyzna i koń stają obok siebie. W oddali stoi jabłoń, a pierwszy przy niej wygrywa. Gdy zasady są ustalone, wyścig się zaczyna. Nie jest specjalnie wyrównany. %fat% niemal od razu zostaje z tyłu i człapie po torze z purpurową twarzą i sapiącym oddechem, a ludzie niemal umierają ze śmiechu na ten widok. Tłusty najemnik i posępny koń spotykają się przy jabłoni i tam dzielą owoce swoich trudów. Płacisz właścicielowi konia, co mu się należy. Uśmiecha się, licząc monety.%SPEECH_ON%Zwykle wyścig nie ma takiego widowiska, sir.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Może byś zrzucił trochę kilogramów?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Fat.getImagePath());
				this.World.Assets.addMoney(-_event.m.Reward);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Reward + "[/color] koron"
				});
				_event.m.Fat.getBaseProperties().Bravery += 1;
				_event.m.Fat.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Fat.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinacji"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Fat.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Bawił się, oglądając jak " + _event.m.Fat.getName() + " ściga się z koniem");

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
			ID = "E",
			Text = "%terrainImage%{Wybierasz %dumb%, największego idiotę w kompanii, na waszego mistrza wyścigów. Właściciel konia rzuca na niego okiem i unosi brwi.%SPEECH_ON%Cóż. Dobrze.%SPEECH_OFF%Zasady wyścigu są jasne: pierwszy do odległej jabłoni wygrywa. Człowiek i zwierzę ustawiają się na torze. Udając, że wie, co robi, %dumb% przykuca w trójpunktowej pozycji. Właściciel krzyczy i klepie bestię po zadzie. %dumb% rusza w ładnym tempie i, co szokujące, wyprzedza konia, ale nie potrafi opanować swojej prędkości, wpada na drugi tor i zderza się z bestią. Koń ugina się w kolanach i przelatuje przez łeb, a %dumb% jakoś ląduje w zagłębieniu jego lędźwi i przy obrocie zostaje wystrzelony w powietrze. To przeklęty widok i na pewno już takiego nie zobaczysz. Koń wraca na nogi i rozgląda się zdezorientowany, podczas gdy nieprzytomne ciało %dumb% przelatuje nad linią mety. Rozkładasz dłonie do właściciela konia, który trzyma się za głowę.%SPEECH_ON%Na starych bogów, człowieku, czy nie martwisz się o swojego najemnika?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nic mu nie będzie. Płać.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dumb.getImagePath());
				this.World.Assets.addMoney(_event.m.Reward * 3);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zdobywasz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + _event.m.Reward * 3 + "[/color] koron"
				});
				local injury = _event.m.Dumb.addInjury(this.Const.Injury.Concussion);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Dumb.getName() + " doznaje " + injury.getNameOnly()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 1000)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_fat = [];
		local candidates_athletic = [];
		local candidates_dumb = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.fat"))
			{
				candidates_fat.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.athletic"))
			{
				candidates_athletic.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.dumb") && !bro.getSkills().hasSkill("injury.severe_concussion"))
			{
				candidates_dumb.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_fat.len() != 0)
		{
			this.m.Fat = candidates_fat[this.Math.rand(0, candidates_fat.len() - 1)];
		}

		if (candidates_athletic.len() != 0)
		{
			this.m.Athletic = candidates_athletic[this.Math.rand(0, candidates_athletic.len() - 1)];
		}

		if (candidates_dumb.len() != 0)
		{
			this.m.Dumb = candidates_dumb[this.Math.rand(0, candidates_dumb.len() - 1)];
		}

		this.m.Reward = this.Math.rand(3, 6) * 100;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"randombrother",
			this.m.Other.getNameOnly()
		]);
		_vars.push([
			"fat",
			this.m.Fat ? this.m.Fat.getNameOnly() : ""
		]);
		_vars.push([
			"athlete",
			this.m.Athletic ? this.m.Athletic.getNameOnly() : ""
		]);
		_vars.push([
			"dumb",
			this.m.Dumb ? this.m.Dumb.getNameOnly() : ""
		]);
		_vars.push([
			"reward",
			this.m.Reward
		]);
	}

	function onClear()
	{
		this.m.Other = null;
		this.m.Fat = null;
		this.m.Athletic = null;
		this.m.Dumb = null;
		this.m.Reward = 0;
	}

});

