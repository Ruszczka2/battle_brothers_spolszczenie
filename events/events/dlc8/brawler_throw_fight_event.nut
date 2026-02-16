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
			Text = "[img]gfx/ui/events/event_51.png[/img]{Bez uprzedzenia okazuje się, że %brawler% osiłek sam zapisała się do turnieju walk i dotarł już do finału. Tak łatwo rozbił przeciwników w pierwszej rundzie, że jest zdecydowanym faworytem do zwycięstwa.\n\nJednak kilku bardzo wpływowych bukmacherów jest wściekłych, bo %brawler% sprawił, że stracili masę pieniędzy. Wiedząc, że jest z tobą, proszą, byś kazał %brawler% położyć się i przegrać walkę. W zamian dostaniesz procent z ich wygranych, co bez wątpienia będzie spore...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Musisz się położyć.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Nie położy się.",
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
					Text = "Co? Nie będzie żadnej walki!",
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
			Text = "[img]gfx/ui/events/event_06.png[/img]{Rozkazujesz %brawler% położyć się. Jak przewidywano, opiera się pomysłowi, ale przypominasz mu, że jesteś kapitanem kompanii, a choć bijatyki to jego sprawa, to fakt, że strona trzecia weszła z tobą w interes, czyni sprawę osiłka twoją sprawą. Wzdycha i kiwa głową.\n\nGdy dochodzi do walki, %brawler% zgodnie z poleceniem przyjmuje kilka ciosów, po czym \"sprzedaje\" nokaut, odskakując po słabej dzabie. Tłum ryczy, a underdog cieszy się i biega po ringu z uniesionymi rękami. Po walce bukmacherzy przychodzą i wręczają ci %reward% koron za przegraną. Jeden patrzy na %brawler%.%SPEECH_ON%Na bogów, chłopie, mogłeś wywołać zamieszki, gdyby ktoś zwrócił uwagę. Powinieneś poćwiczyć aktorstwo, bo ten zwycięski cios nie rozciąłby nawet wargi dziwki. Następnym razem poczekaj na prosty albo solidny hak, co?%SPEECH_OFF%Osiłek śmieje się, ale to wymuszone. Upokorzył się za kilka koron. Gdzieś w %townname% słyszysz, jak mieszkańcy skandują imię drugiego wojownika.}",
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
				_event.m.Brawler.worsenMood(0.5, "Kazano mu oddać walkę");
				_event.m.Brawler.worsenMood(2.0, "Przegrał turniej walk");

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
			Text = "[img]gfx/ui/events/event_06.png[/img]{Rozkazujesz %brawler% położyć się. Jak przewidywano, opiera się pomysłowi, ale przypominasz mu, że jesteś kapitanem kompanii, a choć bijatyki to jego sprawa, to fakt, że strona trzecia weszła z tobą w interes, czyni sprawę osiłka twoją sprawą. Wzdycha i kiwa głową.\n\nGdy dochodzi do walki, %brawler% robi, co kazałeś, i pada po jednym ciosie. Spogląda na ciebie z podłogi ringu, a ty widzisz ogień w jego oczach. Każesz mu leżeć, ale on wstaje i natychmiast niszczy drugiego wojownika serią haków i uppercutów. Wygrywa walkę i tłum wynosi go z areny. Spieszysz za nimi, by zobaczyć, dokąd poszedł, ale znajdujesz go w zaułku, skopanego na miazgę. Uśmiecha się do ciebie.%SPEECH_ON%Ci bukmacherzy nie byli zadowoleni, ale niech ich diabli. Powinni byli postawić na moją dumę.%SPEECH_OFF%Traci przytomność.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jak na razie mam dość zakładów.",
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
				_event.m.Brawler.worsenMood(0.5, "Kazano mu oddać walkę");
				_event.m.Brawler.improveMood(2.0, "Z łatwością wygrał turniej walk");

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
			Text = "[img]gfx/ui/events/event_06.png[/img]{Mówisz bukmacherom, że %brawler% będzie walczył, jak mu się podoba. Bukmacherzy, nie chcąc wchodzić w konflikt z najemnikami, nie dyskutują dalej. Po prostu odchodzą, zanim zdążysz nawet postawić na swojego człowieka. Wiedząc, że walka się odbędzie, idziesz i oglądasz, jak %brawler% kompletnie miażdży najlepszego osiłka %townname%. Masakra była tak oczywista, że wszyscy postawili na %brawler%, przez co bukmacherzy zaczynają tracić pieniądze. Wybuchają bójki, a niektórzy gracze i bukmacherzy zaczynają się nawzajem okładać. Z walki nie ma zysku, ale %brawler% jest w siódmym niebie jako mistrz %townname%.}",
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
					text = _event.m.Brawler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_skill_boost + "[/color] Umiejętności Walki Wręcz"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Brawler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_defense_boost + "[/color] Obrony w Walce Wręcz"
				});
				_event.m.Brawler.improveMood(0.5, "Pozwolono mu walczyć na swoich zasadach");
				_event.m.Brawler.improveMood(2.0, "Z łatwością wygrał turniej walk");

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
			Text = "[img]gfx/ui/events/event_06.png[/img]{Mówisz bukmacherom, że %brawler% będzie walczył, jak mu się podoba. Nie chcąc zadzierać z kapitanem najemników, tylko przytakują i się wycofują. Jak przewidywano, %brawler% wygrywa walkę, i to bez wątpliwości. Jest o nim głośno w %townname%, więc pozwalasz mu świętować z chłopami. Mija jednak kilka godzin i zdajesz sobie sprawę, że dawno go nie widziałeś. Wchodzisz do miasta i znajdujesz go w zaułku z zmiażdżonymi kolanami, jego prowadząca dłoń jest rozbita na miazgę, a oczy ma spuchnięte i zamknięte. Wołasz go i biegniesz. Podnosi głowę z ziemi.%SPEECH_ON%Kapitanie? Eee, kapitanie, dobrze słyszeć twój głos. Nie martw się o mnie. Było warto.%SPEECH_OFF%Traci przytomność. Niesiesz go z powrotem do kompanii i rozważasz pogoń za bukmacherami, ale wiesz, że nie zrobiliby tego bez przygotowania ucieczki z miasta.}",
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
					text = _event.m.Brawler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_skill_boost + "[/color] Umiejętności Walki Wręcz"
				});
				_event.m.Brawler.improveMood(0.5, "Pozwolono mu walczyć na swoich zasadach");
				_event.m.Brawler.improveMood(2.0, "Z łatwością wygrał turniej walk");

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
			Text = "[img]gfx/ui/events/event_06.png[/img]{Mówisz bukmacherom, że %brawler% będzie walczył, jak mu się podoba. Bukmacherzy, nie chcąc zadzierać z najemnikami, nie dyskutują dalej. Po prostu odchodzą, zanim zdążysz nawet postawić na swojego człowieka. Wiedząc, że walka się odbędzie, idziesz ją obejrzeć. %brawler% zaczyna pojedynek, rzucając haki na lewo i prawo bez żadnego poszanowania umiejętności przeciwnika. Bez żadnego jabu na przygotowanie, rywal się kryje, po czym krzyczy i rzuca jeden desperacki hak, a głowa %brawler% obraca się i pada nieprzytomny na ziemię. Tłum szaleje, przynajmniej ci, którzy nie stracili właśnie kupy koron. Jeden z graczy podchodzi do ciebie, licząc pieniądze. Uśmiecha się.%SPEECH_ON%Lepiej idź po swojego chłopaka.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mogło pójść lepiej.",
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
				_event.m.Brawler.improveMood(0.5, "Pozwolono mu walczyć na swoich zasadach");
				_event.m.Brawler.worsenMood(2.0, "Został ciężko pobity w turnieju walk");

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
			Text = "[img]gfx/ui/events/event_64.png[/img]{Szokujesz obie strony ogłoszeniem, że %brawler% w ogóle nie będzie walczył. Bukmacherzy ocierają czoła i wzdychają. Stracili sporo pieniędzy, ale przynajmniej teraz jest jakiś powód, by zatrzymać krwawienie. Co do %brawler%, jest wściekły na twoją decyzję. Wyjaśniasz mu, że %companyname% potrzebuje wszystkich swoich wojowników w najlepszej formie do prawdziwej pracy najemniczej. Nie możesz ryzykować jego zdrowia w jakimś prowincjonalnym turnieju.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Będzie jeszcze wiele okazji do walki, %brawler%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				_event.m.Brawler.worsenMood(2.0, "Odmówiono mu udziału w turnieju walk");

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

