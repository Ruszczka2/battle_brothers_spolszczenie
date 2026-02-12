this.juggler_tempts_fate_event <- this.inherit("scripts/events/event", {
	m = {
		Juggler = null,
		NonJuggler = null
	},
	function create()
	{
		this.m.ID = "event.juggler_tempts_fate";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%juggler%, lekki na nogach i szybkoręki kuglarz, chodzi po obozie i prosi braci, by rzucali mu noże. Wygląda na to, że chce popisać się swoim numerem.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pokaż, co potrafisz!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "C" : "Fail1";
					}

				},
				{
					Text = "Nie za to ci płacę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				_event.m.Juggler.getFlags().add("juggler_tempted_fate");
			}

		});
		this.m.Screens.push({
			ID = "Fail1",
			Text = "[img]gfx/ui/events/event_05.png[/img]%nonjuggler% rzuca nożem przez obóz. Ostrze obraca się w słońcu i widzisz błysk odbitego światła przecinający oczy kuglarza. Mruga na tyle długo, że broń wbija się w jego bark. Mruga ponownie, wystarczająco długo, by ból zaczął go dopadać. Po chwili %juggler% pada na ziemię, ściskając ranę i wyjąc z bólu. Kilku ludzi mu pomaga, a inni mogą się tylko śmiać.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To musiało boleć!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local injury = _event.m.Juggler.addInjury([
					{
						ID = "injury.injured_shoulder",
						Threshold = 0.25,
						Script = "injury/injured_shoulder_injury"
					}
				]);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Juggler.getName() + " doznaje " + injury.getNameOnly()
					}
				];
				_event.m.Juggler.worsenMood(1.0, "Nie udał mu się numer i zranił się");

				if (_event.m.Juggler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Fail2",
			Text = "[img]gfx/ui/events/event_05.png[/img]Topór, o który prosił %juggler%, zostaje podniesiony i rzucony w jego stronę. Obraca się pod dziwnym kątem, jakby rzucający celowo wprawił go w nieokreślone kołysanie. Nie spodziewając się tego, kuglarz poprawia chwyt, by złapać rozchwiany trzonek, ale broń uderza w jeden z sztyletów i rozcina mu ramię. Pada na ziemię w jednej chwili, a deszcz noży spada wokół niego. Gdy jedni opatrują jego rany, inni nie potrafią ukryć radości z jego cierpienia.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wszystko z nim w porządku?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local injury = _event.m.Juggler.addInjury(this.Const.Injury.Accident4);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Juggler.getName() + " doznaje " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "Fail3",
			Text = "[img]gfx/ui/events/event_05.png[/img]%nonjuggler% podnosi żądany cep i po chwili wahania ciska go w stronę %juggler%. W locie łańcuch owija się wokół trzonka. Kuglarz wydaje się do tego dopasowywać, ale w ostatniej chwili łańcuch się rozwija i smaga z zabójczym impetem. Widzisz, jak oczy mężczyzny rozszerzają się, gdy dostrzega katastrofę, której nie potrafi powstrzymać. Cep rozbija jego metalowy wir i zahacza go w twarz. Pada nieprzytomny, obraca się na piętach i osuwa na ziemię. Spadający sztylet przebija mu nogę, a topór wpada prosto w biodro. Ludzie z przerażeniem wzdychają i wkrótce każdy z nich zrywa się, by udzielić mu pomocy.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czy on żyje?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local injury = _event.m.Juggler.addInjury(this.Const.Injury.BluntHead);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Juggler.getName() + " doznaje " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Siadasz i pozwalasz ludziom rzucać %juggler% kilka noży i sztyletów. Nadlatują z każdej strony, w różnych kształtach i rozmiarach, ale on łapie je bez trudu i zaczyna podrzucać w powietrze, a ich obroty błyszczą i migoczą w słońcu. Ponieważ każda broń ma inną wagę, imponuje ci, jak potrafi utrzymać je wszystkie w płynnym rytmie.\n\n Oczywiście nie mogło się na tym skończyć. Jedną ręką, między kolejnymi podrzutami, przywołuje ludzi i prosi, by ktoś rzucił mu topór.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To powinno być ciekawe!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 60 ? "D" : "Fail2";
					}

				},
				{
					Text = "Wystarczy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 10)
					{
						bro.improveMood(1.0, "Czuł się rozbawiony");

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
			Text = "[img]gfx/ui/events/event_05.png[/img]%nonjuggler% wstaje i ciska topór w orbitę niesamowitego numeru %juggler%. Krąg niebezpiecznej broni zdaje się pożerać topór w mgnieniu oka, a broń po prostu dołącza do reszty noży i sztyletów w płynnym przejściu. Ludzie klaszczą i wiwatują, choć kilku widać z uśmiechami, jakby czekali, aż ta talia niezwykle ostrych kart w końcu runie.\n\n Ale to najwyraźniej nie koniec występu. Tym razem, nie przywołując nikogo, a skupiając się na świszczącej broni krążącej wokół niego, kuglarz prosi o cep. Ktoś wstaje.%SPEECH_ON%Czy on powiedział: cep?%SPEECH_OFF%Kuglarz tupie nogą.%SPEECH_ON%Tak, cep! Rzućcie mi cep!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niemożliwe, a jednak... chcę to zobaczyć!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "E" : "Fail3";
					}

				},
				{
					Text = "Dość. Kończ to.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				_event.m.Juggler.getBaseProperties().Bravery += 1;
				_event.m.Juggler.getBaseProperties().MeleeSkill += 1;
				_event.m.Juggler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Juggler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinacji"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Juggler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Umiejętności walki wręcz"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 20)
					{
						bro.improveMood(1.0, "Czuł się rozbawiony");

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
			Text = "[img]gfx/ui/events/event_05.png[/img]Wyciąga się cep i ciska w stronę %juggler%. Wszyscy krzywią się, gdy cep wije się, kręci i faluje ku wirującej burzy broni, którą kuglarz nazywa swoim \"numerem\". Ale, tak jak topór, szybko zostaje wchłonięty przez metalowy wir. Głośniej niż kiedykolwiek ludzie podrywają się, by wiwatować i klaskać. Kilku wzdycha z ulgą, wycierając pot z czoła, inni mogą się tylko uśmiechać i klaskać, rozczarowani, że nie stało się nic spektakularnie strasznego, ale mimo to pod wrażeniem.",
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
				this.Characters.push(_event.m.Juggler.getImagePath());
				_event.m.Juggler.getBaseProperties().Bravery += 2;
				_event.m.Juggler.getBaseProperties().RangedDefense += 2;
				_event.m.Juggler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Juggler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Determinacji"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.Juggler.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Obrony dystansowej"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 30)
					{
						bro.improveMood(1.0, "Czuł się rozbawiony");

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

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local juggler_candidates = [];
		local nonjuggler_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.juggler")
			{
				if (!bro.getFlags().has("juggler_tempted_fate"))
				{
					juggler_candidates.push(bro);
				}
			}
			else if (bro.getBackground().getID() != "background.slave")
			{
				nonjuggler_candidates.push(bro);
			}
		}

		if (juggler_candidates.len() == 0 || nonjuggler_candidates.len() == 0)
		{
			return;
		}

		this.m.Juggler = juggler_candidates[this.Math.rand(0, juggler_candidates.len() - 1)];
		this.m.NonJuggler = nonjuggler_candidates[this.Math.rand(0, nonjuggler_candidates.len() - 1)];
		this.m.Score = juggler_candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"juggler",
			this.m.Juggler.getNameOnly()
		]);
		_vars.push([
			"nonjuggler",
			this.m.NonJuggler.getName()
		]);
	}

	function onClear()
	{
		this.m.Juggler = null;
		this.m.NonJuggler = null;
	}

});

