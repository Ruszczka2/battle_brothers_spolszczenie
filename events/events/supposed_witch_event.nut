this.supposed_witch_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null,
		Cultist = null,
		Witchhunter = null
	},
	function create()
	{
		this.m.ID = "event.supposed_witch";
		this.m.Title = "Przy drodze...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]Wchodzisz do małej osady przy drodze. To dość nijakie miejsce, z wyjątkiem kobiety przywiązanej na wierzchu stosu, który lada chwila zapłonie. Otacza ją gromada chłopów, jak to zwykle bywa w takich przypadkach. Mnich z tłumu czyta ze świętej księgi, najwyraźniej obwieszczając wszystkim deontologiczną naturę jej zbrodni. Inny mężczyzna posłusznie stoi obok z pochodnią, a dłonie aż go swędzą, by jej użyć.\n\n Widząc cię, kobieta krzyczy o pomoc.%SPEECH_ON%Spalą mnie! Musicie coś zrobić! Nic złego nie zrobiłam!%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Uwolnijmy ją.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 80)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Witchhunter != null)
				{
					this.Options.push({
						Text = "Co na to łowca czarownic, %witchhunterfull%?",
						function getResult( _event )
						{
							return "Witchhunter";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Co mówią starzy bogowie, %monkfull%?",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "Co o tym sądzi twój dziwny bóg, %cultistfull%?",
						function getResult( _event )
						{
							return "Cultist";
						}

					});
				}

				this.Options.push({
					Text = "To nie nasz problem.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_79.png[/img]Nie zamierzasz stać bezczynnie, gdy niewinną kobietę palą za wyimaginowaną zbrodnię. Z ostrzem w dłoni wspinasz się na drewniane palety i ją uwalniasz. Szybko ucieka, szukając bezpieczeństwa. Rozwścieczony tłum natychmiast rzuca się na kompanię. Bijatyka między chłopami a najemnikami kończy się źle dla tych pierwszych, ale zadają pewne obrażenia.\n\n Za utratę kontroli nad tłumem każesz pobić mnicha, a także mężczyznę z pochodnią. Kilku braci uważa, że to było słuszne i jest zadowolonych z twojej decyzji.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mam nadzieję, że znajdzie bezpieczne miejsce.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							local injury = bro.addInjury(this.Const.Injury.Brawl);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " doznaje " + injury.getNameOnly()
							});
						}
						else
						{
							bro.addLightInjury();
							this.List.push({
								id = 10,
								icon = "ui/icons/days_wounded.png",
								text = bro.getName() + " odnosi lekkie rany"
							});
						}
					}

					if (this.Math.rand(1, 100) <= 25 && bro.getBackground().getID() != "background.witchhunter")
					{
						bro.improveMood(1.0, "Ocaliłeś kobietę przed spaleniem na stosie");

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
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_79.png[/img]Nie zamierzasz stać bezczynnie, gdy niewinną kobietę palą za wyimaginowaną zbrodnię. Z ostrzem w dłoni wspinasz się na drewniane palety i ją uwalniasz. Kiedy jest wolna, pochyla się i ujmuje cię w dłonie. Jej skóra jest gładka i nieskalana.%SPEECH_ON%Dziękuję, najemniku.%SPEECH_OFF%Składa pocałunek i czujesz, jakby jej usta były lodem. Patrzysz, jak unosi się w dół po drewnianych paletach. O nie.\n\n Mnich z miasteczka cofa się, próbując ukryć w tłumie, lecz czarownica krzyczy i rozrywa gromadę, zostawiając duchownego samotnie na ziemi. Powoli sunie po brudzie, po czym wstaje, jakby pchnięty niewidzialną siłą. Próbuje znów się cofnąć, ale nie ma dokąd. Całuje go tak jak ciebie, lecz oczy mężczyzny przewracają się w głowie, a ty widzisz, jak jego żyły nabrzmiewają, gwałtownie purpurowiejąc, a całe ciało, drgając, wypuszcza krew z każdego pora. Krzyczy, ale krzyk ginie w ustach czarownicy, która pochłania go z jękiem. Gdy puszcza, osuwa się na ziemię jako ociekający czerwienią trup.\n\n Mieszkańcy wioski rozbiegają się, a twoi ludzie próbują walczyć z tym złem. Ona śmieje się i kurczy do środka swych ubrań, a jej płaszcz zwija się w kłąb, z którego wystrzela chichoczące widmo. Szybuje ku najbliższej linii drzew, miejmy nadzieję, by nigdy więcej go nie ujrzeć.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "O cholera.",
					function getResult( _event )
					{
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25 || bro.getBackground().getID() == "background.witchhunter" || bro.getBackground().getID() == "background.monk" || bro.getSkills().hasSkill("trait.superstitious") || bro.getSkills().hasSkill("trait.mad"))
					{
						bro.worsenMood(1.0, "Uwolniłeś złego ducha");

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
			}

		});
		this.m.Screens.push({
			ID = "Witchhunter",
			Text = "[img]gfx/ui/events/event_79.png[/img]%witchhunter% wychodzi naprzód ze sceptycznym spojrzeniem. Patrzy na kobietę, która z trudem wypowiada słowo \'proszę\'. Łowca czarownic mierzy ją wzrokiem, po czym odwraca się i wbija ostrze w człowieka trzymającego pochodnię. Ten dławi się ostrzem w gardle, a dłonie próbują je wyrwać.%SPEECH_ON%Dość tej farsy, nie zdołasz mnie oszukać.%SPEECH_OFF%Mówi łowca czarownic. Wyrywa ostrze, a dzierżący pochodnię stoi chwilę, lecz jego szeroko otwarte oczy powoli się uspokajają, a \'krew\' natychmiast ustaje. Twarz mu się rozszerza, skóra napina się jak roztopione oblicze najstraszniejszej lalki. Głos piszczy, każda sylaba w tonie zdychającego kota.%SPEECH_ON%Nie jestem OSTATNIĄ! NIGDY nie pozbędziecie się nas wszystkich!%SPEECH_OFF%I z tym %witchhunter% wbija broń w czaszkę złego ducha. Skóra twardnieje jak pustynna ziemia, po czym kruszy się.\n\n Gdy prawda wychodzi na jaw, kobietę ścina się z powroza i uwalnia. Mnich zostaje obdarty z szat przez wściekły tłum, który nie ma gdzie indziej wyładować gniewu. Nagiego i upokorzonego wypędza się z osady za fałszywe oskarżenia.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prawdziwe zło dobrze się ukrywa.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
				local resolve = 1;
				local initiative = 1;
				_event.m.Witchhunter.getBaseProperties().Bravery += resolve;
				_event.m.Witchhunter.getBaseProperties().Initiative += initiative;
				_event.m.Witchhunter.getSkills().update();
				_event.m.Witchhunter.improveMood(2.0, "Zabił złego ducha");

				if (_event.m.Witchhunter.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Witchhunter.getMoodState()],
						text = _event.m.Witchhunter.getName() + this.Const.MoodStateEvent[_event.m.Witchhunter.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Witchhunter.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] determinacji"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Witchhunter.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] inicjatywy"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Witchhunter.getID() && (this.Math.rand(1, 100) <= 25 || bro.getBackground().getID() == "background.witchhunter" || bro.getBackground().getID() == "background.monk" || bro.getSkills().hasSkill("trait.superstitious")))
					{
						bro.improveMood(1.0, "Widział, jak zły duch znalazł swój koniec");

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
			ID = "Monk",
			Text = "[img]gfx/ui/events/event_79.png[/img]Mnich, %monk%, siada z miejscowym bratem i przez chwilę rozmawia. Gdy kończą, skinienie daje znak człowiekowi z pochodnią, który podpala drewniane palety. Kobieta krzyczy o litość, lecz płomienie jej jej nie okazują, powoli wspinając się od stóp. To przerażający widok i dopiero gdy dym staje się duszącą chmurą, umierająca kobieta milknie. Ogień pochłania ją całkowicie, a reszta osady klaszcze i wiwatuje. %monk% stwierdza, że była wyraźnie czarownicą i trzeba było się jej pozbyć. Nie jesteś pewien. Widziałeś tylko kobietę spaloną żywcem, ale ufasz, że wie więcej od ciebie o wojnie starych bogów z czarami.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wykorzenianie zła nigdy nie jest łatwe.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local resolve = this.Math.rand(2, 3);
				_event.m.Monk.getBaseProperties().Bravery += resolve;
				_event.m.Monk.getSkills().update();
				_event.m.Monk.improveMood(2.0, "Kazał spalić czarownicę");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] determinacji"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Monk.getID() && (bro.getBackground().getID() == "background.witchhunter" || bro.getBackground().getID() == "background.monk" || bro.getSkills().hasSkill("trait.superstitious")))
					{
						bro.improveMood(1.0, "Widział czarownicę płonącą na stosie");

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
			ID = "Cultist",
			Text = "[img]gfx/ui/events/event_79.png[/img]%cultist% wychodzi naprzód i mierzy wzrokiem wieśniaków od góry do dołu. Kręci głową.%SPEECH_ON%Wszyscy powinniście się zabić.%SPEECH_OFF%Mnich z miasteczka strzepuje płaszcz.%SPEECH_ON%P-przepraszam?%SPEECH_OFF%Kultysta zaczyna ścinać kobietę. Kilku twoich najemników podchodzi, by powstrzymać protesty. Gdy jest wolna i ucieka, szukając bezpieczeństwa, %cultist% mówi ponownie.%SPEECH_ON%Zabijcie się. Każdy z was. Tej nocy. Rozgniewaliście Davkula, a jego gniew to dług, który najlepiej spłacić samemu.%SPEECH_OFF%Mnich otwiera usta, by coś powiedzieć, ale jego nos pęka, jakby wgnieciony niewidzialnym kamieniem. Zatacza się, krew tryska mu z nozdrzy. %cultist% kiwa głową.%SPEECH_ON%Hmm, jest bardziej rozgniewany, niż myślałem. Davkul czeka na nas wszystkich, ale teraz stoi u waszych drzwi.%SPEECH_OFF%Krzycząc, mnich pada na ziemię, a jego szczęka obrzydliwie pęka, pozostawiając usta na zawsze rozwarte. Wieśniacy krzyczą i rozbiegają się jak króliki pod cieniem jastrzębia.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niepokojące.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local resolve = 2;
				_event.m.Cultist.getBaseProperties().Bravery += resolve;
				_event.m.Cultist.getSkills().update();
				_event.m.Cultist.improveMood(2.0, "Był świadkiem mocy Davkula");

				if (_event.m.Cultist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Cultist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] determinacji"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Cultist.getID() && (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist"))
					{
						bro.improveMood(1.0, "Był świadkiem mocy Davkula");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().getID() == "background.witchhunter" || bro.getBackground().getID() == "background.monk" || bro.getSkills().hasSkill("trait.superstitious"))
					{
						bro.worsenMood(1.0, _event.m.Cultist.getName() + " uwolnił czarownicę");

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
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
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
		local candidate_witchhunter = [];
		local candidate_monk = [];
		local candidate_cultist = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter")
			{
				candidate_witchhunter.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				candidate_monk.push(bro);
			}
			else if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				candidate_cultist.push(bro);
			}
		}

		if (candidate_witchhunter.len() != 0)
		{
			this.m.Witchhunter = candidate_witchhunter[this.Math.rand(0, candidate_witchhunter.len() - 1)];
		}

		if (candidate_monk.len() != 0)
		{
			this.m.Monk = candidate_monk[this.Math.rand(0, candidate_monk.len() - 1)];
		}

		if (candidate_cultist.len() != 0)
		{
			this.m.Cultist = candidate_cultist[this.Math.rand(0, candidate_cultist.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"witchhunter",
			this.m.Witchhunter != null ? this.m.Witchhunter.getNameOnly() : ""
		]);
		_vars.push([
			"witchhunterfull",
			this.m.Witchhunter != null ? this.m.Witchhunter.getName() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"monkfull",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
		_vars.push([
			"cultistfull",
			this.m.Cultist != null ? this.m.Cultist.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
		this.m.Monk = null;
		this.m.Cultist = null;
	}

});

