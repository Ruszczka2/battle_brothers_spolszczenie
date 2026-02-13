this.brawler_throw_fight_event <- this.inherit("scripts/events/event", {
	m = {
		Brawler = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.brawler_throw_fight";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Bez uprzedzenia okazuje sie, ze %brawler% osiłek sam zapisala sie do turnieju walk i dotarł już do finału. Tak latwo rozbil przeciwnikow w pierwszej rundzie, ze jest zdecydowanym faworytem do zwyciestwa.\n\nJednak kilku bardzo wplywowych bukmacherow jest wscieklych, bo %brawler% sprawil, ze stracili mase pieniedzy. Wiedzac, ze jest z toba, prosza, bys kazal %brawler% polozyc sie i przegrac walke. W zamian dostaniesz procent z ich wygranych, co bez watpienia bedzie spore...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Musisz sie polozyc.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Nie polozy sie.",
					function getResult( _event )
					{
						local outcome = this.Math.rand(1, 100);

						if (outcome <= 39 + _event.m.Brawler.getLevel())
						{
							return "D";
						}
						else if (outcome <= 80)
						{
							return "E";
						}
						else
						{
							return "F";
						}
					}

				},
				{
					Text = "Co? Nie bedzie zadnej walki!",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Rozkazujesz %brawler% polozyc sie. Jak przewidywano, opiera sie pomyslowi, ale przypominasz mu, ze jestes kapitanem kompanii, a choc bijatyki to jego sprawa, to fakt, ze strona trzecia weszla z toba w interes, czyni sprawe osiłka twoja sprawa. Wzdycha i kiwa glowa.\n\nGdy dochodzi do walki, %brawler% zgodnie z poleceniem przyjmuje kilka ciosow, po czym \"sprzedaje\" nokaut, odskakujac po slabej dzabie. Tlum ryczy, a underdog cieszy sie i biega po ringu z uniesionymi rekami. Po walce bukmacherzy przychodza i wręczaja ci %reward% koron za przegrana. Jeden patrzy na %brawler%.%SPEECH_ON%Na bogow, chlopie, mogles wywolac zamieszki, gdyby ktos zwrocil uwage. Powinienes poćwiczyc aktorstwo, bo ten zwycieski cios nie rozcialby nawet wargi dziwki. Nastepnym razem poczekaj na prosty albo solidny hak, co?%SPEECH_OFF%Osiłek smieje sie, ale to wymuszone. Upokorzyl sie za kilka koron. Gdzies w %townname% slyszysz, jak mieszkancy skanduja imie drugiego wojownika.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przejdzie mu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				this.World.Assets.addMoney(400);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]400[/color] Koron"
				});
				_event.m.Brawler.worsenMood(0.5, "Kazano mu oddac walke");
				_event.m.Brawler.worsenMood(2.0, "Przegral turniej walk");

				if (_event.m.Brawler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Rozkazujesz %brawler% polozyc sie. Jak przewidywano, opiera sie pomyslowi, ale przypominasz mu, ze jestes kapitanem kompanii, a choc bijatyki to jego sprawa, to fakt, ze strona trzecia weszla z toba w interes, czyni sprawe osiłka twoja sprawa. Wzdycha i kiwa glowa.\n\nGdy dochodzi do walki, %brawler% robi, co kazales, i pada po jednym ciosie. Spoglada na ciebie z podlogi ringu, a ty widzisz ogien w jego oczach. Kazesz mu lezec, ale on wstaje i natychmiast niszczy drugiego wojownika serią hakow i uppercutow. Wygrywa walke i tlum wynosi go z areny. Spieszysz za nimi, by zobaczyc, dokad poszedl, ale znajdujesz go w zaułku, skopanego na miazge. Usmiecha sie do ciebie.%SPEECH_ON%Ci bukmacherzy nie byli zadowoleni, ale niech ich diabli. Powinni byli postawic na moja dume.%SPEECH_OFF%Traci przytomnosc.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jak na razie mam dosc zakladow.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				_event.m.Brawler.addHeavyInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Brawler.getName() + " odnosi powazne rany"
				});
				_event.m.Brawler.worsenMood(0.5, "Kazano mu oddac walke");
				_event.m.Brawler.improveMood(2.0, "Z latwoscia wygral turniej walk");

				if (_event.m.Brawler.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Mowisz bukmacherom, ze %brawler% bedzie walczyl, jak mu sie podoba. Bukmacherzy, nie chcac wchodzic w konflikt z najemnikami, nie dyskutuja dalej. Po prostu odchodza, zanim zdazysz nawet postawic na swojego czlowieka. Wiedzac, ze walka sie odbedzie, idziesz i ogladasz, jak %brawler% kompletnie miazdzy najlepszego osiłka %townname%. Masakra byla tak oczywista, ze wszyscy postawili na %brawler%, przez co bukmacherzy zaczynaja tracic pieniadze. Wybuchaja bójki, a niektorzy gracze i bukmacherzy zaczynaja sie nawzajem okładac. Z walki nie ma zysku, ale %brawler% jest w siodmym niebie jako mistrz %townname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				local resolve_boost = this.Math.rand(2, 4);
				local initiative_boost = this.Math.rand(2, 4);
				local melee_skill_boost = this.Math.rand(1, 3);
				local melee_defense_boost = this.Math.rand(1, 3);
				_event.m.Brawler.getBaseProperties().Bravery += resolve_boost;
				_event.m.Brawler.getBaseProperties().Initiative += initiative_boost;
				_event.m.Brawler.getBaseProperties().MeleeSkill += melee_skill_boost;
				_event.m.Brawler.getBaseProperties().MeleeDefense += melee_defense_boost;
				_event.m.Brawler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Brawler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve_boost + "[/color] Determinacji"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Brawler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative_boost + "[/color] Inicjatywy"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Brawler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_skill_boost + "[/color] Umiejetnosci Walki Wrecz"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Brawler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_defense_boost + "[/color] Obrony w Walce Wrecz"
				});
				_event.m.Brawler.improveMood(0.5, "Pozwolono mu walczyc na swoich zasadach");
				_event.m.Brawler.improveMood(2.0, "Z latwoscia wygral turniej walk");

				if (_event.m.Brawler.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Mowisz bukmacherom, ze %brawler% bedzie walczyl, jak mu sie podoba. Nie chcac zadzierac z kapitanem najemnikow, tylko przytakują i sie wycofuja. Jak przewidywano, %brawler% wygrywa walke, i to bez watpliwosci. Jest o nim glosno w %townname%, wiec pozwalasz mu swietowac z chlopami. Mija jednak kilka godzin i zdajesz sobie sprawe, ze dawno go nie widziales. Wchodzisz do miasta i znajdujesz go w zaułku z zmiazdzonymi kolanami, jego prowadzaca dlon jest rozbita na miazge, a oczy ma spuchniete i zamkniete. Wołasz go i biegniesz. Podnosi glowe z ziemi.%SPEECH_ON%Kapitanie? Eee, kapitanie, dobrze slyszec twoj glos. Nie martw sie o mnie. Bylo warto.%SPEECH_OFF%Traci przytomnosc. Niesiesz go z powrotem do kompanii i rozwazasz pogon za bukmacherami, ale wiesz, ze nie zrobiliby tego bez przygotowania ucieczki z miasta.}",
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
				this.Characters.push(_event.m.Brawler.getImagePath());
				local injury = _event.m.Brawler.addInjury(this.Const.Injury.Concussion);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Brawler.getName() + " odnosi " + injury.getNameOnly()
				});
				injury = _event.m.Brawler.addInjury([
					{
						ID = "injury.broken_knee",
						Threshold = 0.0,
						Script = "injury_permanent/broken_knee_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Brawler.getName() + " odnosi " + injury.getNameOnly()
				});
				local initiative_boost = this.Math.rand(2, 4);
				local melee_skill_boost = this.Math.rand(1, 3);
				_event.m.Brawler.getBaseProperties().Initiative += initiative_boost;
				_event.m.Brawler.getBaseProperties().MeleeSkill += melee_skill_boost;
				_event.m.Brawler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Brawler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative_boost + "[/color] Inicjatywy"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Brawler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_skill_boost + "[/color] Umiejetnosci Walki Wrecz"
				});
				_event.m.Brawler.improveMood(0.5, "Pozwolono mu walczyc na swoich zasadach");
				_event.m.Brawler.improveMood(2.0, "Z latwoscia wygral turniej walk");

				if (_event.m.Brawler.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Mowisz bukmacherom, ze %brawler% bedzie walczyl, jak mu sie podoba. Bukmacherzy, nie chcac zadzierac z najemnikami, nie dyskutuja dalej. Po prostu odchodza, zanim zdazysz nawet postawic na swojego czlowieka. Wiedzac, ze walka sie odbedzie, idziesz ja obejrzec. %brawler% zaczyna pojedynek, rzucajac haki na lewo i prawo bez zadnego poszanowania umiejetnosci przeciwnika. Bez zadnego jabu na przygotowanie, rywal sie kryje, po czym krzyczy i rzuca jeden desperacki hak, a glowa %brawler% obraca sie i pada nieprzytomny na ziemie. Tlum szaleje, przynajmniej ci, ktorzy nie stracili wlasnie kupy koron. Jeden z graczy podchodzi do ciebie, liczac pieniadze. Usmiecha sie.%SPEECH_ON%Lepiej idz po swojego chlopaka.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Moglo pojsc lepiej.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				local injury = _event.m.Brawler.addInjury(this.Const.Injury.Concussion);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Brawler.getName() + " odnosi " + injury.getNameOnly()
				});
				_event.m.Brawler.improveMood(0.5, "Pozwolono mu walczyc na swoich zasadach");
				_event.m.Brawler.worsenMood(2.0, "Zostal ciezko pobity w turnieju walk");

				if (_event.m.Brawler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Szokujesz obie strony ogloszeniem, ze %brawler% w ogole nie bedzie walczyl. Bukmacherzy ocieraja czola i wzdychaja. Stracili sporo pieniedzy, ale przynajmniej teraz jest jakis powod, by zatrzymac krwawienie. Co do %brawler%, jest wsciekly na twoja decyzje. Wyjasniasz mu, ze %companyname% potrzebuje wszystkich swoich wojownikow w najlepszej formie do prawdziwej pracy najemniczej. Nie mozesz ryzykowac jego zdrowia w jakims prowincjonalnym turnieju.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bedzie jeszcze wiele okazji do walki, %brawler%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				_event.m.Brawler.worsenMood(2.0, "Odmowiono mu udzialu w turnieju walk");

				if (_event.m.Brawler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local brawler_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.brawler" && !bro.getSkills().hasSkill("injury.severe_concussion") && !bro.getSkills().hasSkill("injury.broken_knee"))
			{
				brawler_candidates.push(bro);
			}
		}

		if (brawler_candidates.len() == 0)
		{
			return;
		}

		this.m.Brawler = brawler_candidates[this.Math.rand(0, brawler_candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 3 * brawler_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"brawler",
			this.m.Brawler.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"reward",
			400
		]);
	}

	function onClear()
	{
		this.m.Brawler = null;
		this.m.Town = null;
	}

});

