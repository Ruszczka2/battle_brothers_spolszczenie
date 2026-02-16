this.shadow_dissection_event <- this.inherit("scripts/events/event", {
	m = {
		Talkers = [],
		Anatomist = null,
		Cultist = null,
		Monk = null,
		Mercenary = null,
		Swordmaster = null,
		Minstrel = null,
		OtherBro = null,
		Killer = null
	},
	function create()
	{
		this.m.ID = "event.shadow_dissection";
		this.m.Title = "W trakcie obozu...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_40.png[/img]{Wstając, %monk% mnich wznosi prośbę do starych bogów. Jedna dłoń spoczywa na piersi, druga wznosi się, jakby w wielkim mowie ofiarnym.%SPEECH_ON%Nie cieni winni byśmy się obawiać, lecz ognia, który je stworzył, bo to płomień bogowie nam dali, byśmy mogli przenosić dzień w noc, czynić nasze pracowite nawyki nieustannymi, a nasze oddanie temu, co dobre, nieomylne.%SPEECH_OFF%Ludzie krzyczą: \"hear hear!\"}",
			Banner = "",
			Characters = [],
			Options = [],
			function start( _event )
			{
				if (_event.m.Anatomist != null)
				{
					this.Options.push({
						Text = "Co ma do powiedzenia %anatomist% anatomista?",
						function getResult( _event )
						{
							return "B";
						}

					});
				}

				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "%cultist% kultysta znowu coś mamrocze.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Nasz mnich %monk% chce odpowiedzieć.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Mercenary != null)
				{
					this.Options.push({
						Text = "Czemu wszyscy patrzą na największego najemnika?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				if (_event.m.Swordmaster != null)
				{
					this.Options.push({
						Text = "%swordmaster% mistrz miecza ma coś do powiedzenia.",
						function getResult( _event )
						{
							return "F";
						}

					});
				}

				if (_event.m.Minstrel != null)
				{
					this.Options.push({
						Text = "Oczywiście, %minstrel% minstrel jest gotów gadać.",
						function getResult( _event )
						{
							return "G";
						}

					});
				}

				if (_event.m.Killer != null && this.Options.len() < 6)
				{
					this.Options.push({
						Text = "Co to za hałas?",
						function getResult( _event )
						{
							return "H";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_184.png[/img]{%anatomist% anatomista podnosi wzrok znad ogniska, a jego twarz faluje cieniami, gdy płomienie rosną i opadają.%SPEECH_ON%Nasze cienie to tylko cięcia na świecie, które ranią i goją wszystko w jednym kroku czerni, rozcinając ziemię naszą obecnością i tym samym zacienionym bytem w tak przelotny sposób, że to nie może być niczym innym jak zapowiedzią naszego pobytu tutaj. Ale czy cień myśli o rozcinaniu ciebie? Czy chce uwolnić innych, podobnych do siebie? Na pewno nie jest sam. Na pewno nasze wnętrza mają swoje cienie. Czy rzucają własne sztuczki na nasze wewnętrzne ściany? A kiedy śpimy, czy te rzeczy są w nas, czy uciekają na zewnątrz i wędrują po świecie? Czy są strażnikami naszych umysłów, opuszczając nas nocami i zostawiając na grozę sennych krain, które przecież istnieją, gdy czuwamy? Co lepiej destyluje prawdę porannego światła niż nasz cień rzucony na ziemię i ulotne wspomnienia tego, co powrócił odstraszyć?%SPEECH_OFF%Jeden z najemników wpatruje się w niego.%SPEECH_ON%Co?%SPEECH_OFF%Reszta najemników prycha.%SPEECH_ON%Hej stary, my tylko chcemy robić fiuty i rury i inne bzdury. Patrz na to, jestem cieniem %anatomist%. Blah blah blah blah!%SPEECH_OFF%Mężczyzna udaje usta otwierające się i zamykające w kółko, a kompania wybucha śmiechem.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Przynajmniej anatomista to wytrzymał.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Anatomist.getID())
					{
						bro.improveMood(0.75, "Czuł się intelektualnie lepszy od innych");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(1.0, "Był rozbawiony");

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
			Text = "[img]gfx/ui/events/event_03.png[/img]{%cultist% kultysta nachyla się ku ogniowi, jego twarz niemal dotyka płomieni. Ludzie spoglądają na niego, gdy jego oczy się rozszerzają, wilgoć wysycha i odchodzi, aż na bieli puchną krwawe żyłki. Odchyla się.%SPEECH_ON%Cienie są tylko ambasadorami większej ciemności.%SPEECH_OFF%Ognisko trzaska, a cień mężczyzny rozkwita na ścianie klasztoru i przez moment kompania widzi w tej czerni coś innego, coś pokręconego i pochylonego, byt zupełnie niezależny od kształtu %cultist%. Gdy ogień przygasa, cień rwie się na kawałki i oddala w większą noc, a zostaje tylko cień kultysty, migoczący niepewnie na ścianach klasztoru.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Dziwne cienie na dziwną noc.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						bro.improveMood(1.5, "Davkul czeka");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 20)
					{
						bro.worsenMood(1.0, "Zaniepokojony przez " + _event.m.Cultist.getName());

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
			ID = "D",
			Text = "[img]gfx/ui/events/event_40.png[/img]{Wstając, %monk% mnich wznosi prośbę do starych bogów. Jedna dłoń spoczywa na piersi, druga wznosi się, jakby w wielkim mowie ofiarnym.%SPEECH_ON%Nie cieni winni byśmy się obawiać, lecz ognia, który je stworzył, bo to płomień bogowie nam dali, byśmy mogli przenosić dzień w noc, czynić nasze pracowite nawyki nieustannymi, a nasze oddanie temu, co dobre, nieomylne.%SPEECH_OFF%Ludzie krzyczą: \"hear hear!\"}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Niech nas strzeże.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Monk.getID() || bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(1.0, "Zainspirowany przez " + _event.m.Monk.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}

						if (this.Math.rand(1, 100) <= 33)
						{
							bro.getBaseProperties().Bravery += 1;
							this.List.push({
								id = 16,
								icon = "ui/icons/bravery.png",
								text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinacji"
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_82.png[/img]{Jeden z najemników wstaje, wskazuje przez ognisko i oznajmia, że %mercenary% ma najstraszniejszy cień ze wszystkich. Wielki najemnik spogląda, jakby zirytowało go wypowiedzenie imienia na głos. Zaciska zęby i powoli unosi dłonie, a reszta kompanii cofa się ze strachem. %mercenary% splata palce i wystawia kciuki.%SPEECH_ON%To jest kura. Widzicie?%SPEECH_OFF%Ludzie patrzą na cienie na ścianie. Nie przypomina to wcale kury, ale nikt nie śmie tego powiedzieć. Wszyscy kiwają głowami i się zgadzają.%SPEECH_ON%Szczerze, %mercenary%, to najlepszy kogut, jakiego widziałem.%SPEECH_OFF%Ludzie ryczą ze śmiechu, ale %mercenary% wstaje i śmiech cichnie.%SPEECH_ON%Powiedziałem, że to kura, prawda?%SPEECH_OFF%Drugi mężczyzna szybko kiwa głową i zgadza się, że to faktycznie kura. Napięcie opada, ale zabawa w cienie dobiega końca.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Trochę wyglądało to na robaka.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Mercenary.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Mercenary.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.75, "Cieszy się, że walczy u boku " + _event.m.Mercenary.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(0.5, "Boi się " + _event.m.Mercenary.getName());

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
			ID = "F",
			Text = "[img]gfx/ui/events/event_17.png[/img]{%swordmaster% mistrz miecza kiwa głową i odzywa się.%SPEECH_ON%Od dawna myślałem o cieniu. Gdy walczysz w świetle dnia, czy toczą się dwie bitwy? Jedna z ciała i krwi, a druga z cieni u twoich stóp? Gdy zabijasz człowieka, czy zabijasz też jego cień, czy twój cień zabija jego? Kim w ogóle jesteśmy dla naszych cieni? Bo gdy walczę bez światła, to nie jest żadna walka, lecz bezsens, latające kończyny, tnące miecze. Czysta ślepota. Wygląda na to, że tylko wtedy, gdy cień jest u boku, możemy powiedzieć, że to walka ludzi i ich umiejętności.%SPEECH_OFF%Jeden z najemników unosi kubek z należytym szacunkiem.%SPEECH_ON%Jakkolwiek by to nie było, oby mój cień nigdy źle nie skrzyżował się z twoim, %swordmaster%.%SPEECH_OFF%Kompania unosi napoje. Na zdrowie!}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Jego cień niesie wielkie niebezpieczeństwo.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Swordmaster.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(1.0, "Cieszy się, że walczy z " + _event.m.Swordmaster.getName());

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
			ID = "G",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%minstrel% minstrel wstaje, przechyla głowę na bok, jego krok jest powłóczysty, a oczy przyczepione do własnego cienia na ścianie klasztoru, który z każdym krokiem staje się coraz mniejszy. Wpatruje się w cień jak w ciało, a jego zbliżanie się do niego przypomina rozwiązywanie zagadki jego zabójstwa. Nagle prostuje się, ręce na biodrach.%SPEECH_ON%Na bogów, ludzie, już rozgryzłem! Mój cień to rasowy kobieciarz! Łajdak i włóczęga. Ma wielki młot w spodniach, a każda kobieta to gwóźdź! To łowca przygód! I pijak, żałosny pijaczyna. I... i złodziej! Kradnie korony brudnym, nie może się powstrzymać. I mały psotnik, szczur pełny diabelstw. Dopiero co mój cień nasrał do buta %othersellsword%! Nie mogłem w to uwierzyć!%SPEECH_OFF%%othersellsword% zrywa się na nogi, przewracając ognisko i rozsypując iskry, które zdają się wirować w śmiechu ludzi. Podchodzi.%SPEECH_ON%Wiedziałem, że to nie było pieprzone psie gówno, draniu! Jaki człowiek sra do butów innego człowieka!%SPEECH_OFF%Najemnik poślizguje się i upada, a kompania wybucha aplauzem, a minstrel delikatnie odskakuje, a jego cień z żegnaniem posyła pocałunek i macha ręką.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Cień minstrela ma więcej akcji niż ja.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Minstrel.getID() || bro.getID() == _event.m.OtherBro.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(1.0, "Był rozbawiony");

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
			ID = "H",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Gdy ludzie przerzucają się cieniami, %killer%, rzekomy zabójca w ucieczce, podchodzi do obozu, niosąc naręcza biżuterii i innych dóbr, a ich metal połyskuje karmazynem. Mamrocze do siebie, ale nagle się zatrzymuje i patrzy na resztę kompanii.%SPEECH_ON%O. Wy jeszcze nie śpicie? Ja tylko, eee, byłem na zewnątrz. Robiłem rzeczy.%SPEECH_OFF%Na jego twarzy jest krew, a pod paznokciami zaschnięta. Czując kłopoty, upuszcza fanty.%SPEECH_ON%To dla kompanii, oczywiście. Jestem po prostu, eee, wdzięczny, że mnie przyjęliście. Pomyślałem, że się odwdzięczę, wiecie?%SPEECH_OFF%Ludzie wpatrują się w fanty. Pytasz go, czy ktoś będzie ich szukał. Uśmiecha się.%SPEECH_ON%Nie, proszę pana, oczywiście że nie. Dopilnowałem tego. Och, kapitanie, dopilnowałem, heh, heh, heh.%SPEECH_OFF%Każesz mu schować rzeczy do ekwipunku, ale najpierw je wyczyścić. Gdy odchodzi, reszta ludzi po cichu wymienia spojrzenia. Wygląda na to, że zabawy w cienie już się skończyły.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Czy ktoś może mieć na niego oko?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Killer.getImagePath());
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.World.Assets.getStash().add(item);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local cultist_candidates = [];
		local monk_candidates = [];
		local mercenary_candidates = [];
		local swordmaster_candidates = [];
		local minstrel_candidates = [];
		local killer_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.cultist")
			{
				cultist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				monk_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword")
			{
				mercenary_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.swordmaster")
			{
				swordmaster_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.minstrel")
			{
				minstrel_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				killer_candidates.push(bro);
			}
		}

		local bro;

		if (anatomist_candidates.len() > 0)
		{
			bro = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
			this.m.Anatomist = bro;
			this.m.Talkers.push(bro);
		}

		if (cultist_candidates.len() > 0)
		{
			bro = cultist_candidates[this.Math.rand(0, cultist_candidates.len() - 1)];
			this.m.Cultist = bro;
			this.m.Talkers.push(bro);
		}

		if (monk_candidates.len() > 0)
		{
			bro = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
			this.m.Monk = bro;
			this.m.Talkers.push(bro);
		}

		if (mercenary_candidates.len() > 0)
		{
			bro = mercenary_candidates[this.Math.rand(0, mercenary_candidates.len() - 1)];
			this.m.Mercenary = bro;
			this.m.Talkers.push(bro);
		}

		if (swordmaster_candidates.len() > 0)
		{
			bro = swordmaster_candidates[this.Math.rand(0, swordmaster_candidates.len() - 1)];
			this.m.Swordmaster = bro;
			this.m.Talkers.push(bro);
		}

		if (minstrel_candidates.len() > 0)
		{
			bro = minstrel_candidates[this.Math.rand(0, minstrel_candidates.len() - 1)];

			do
			{
				this.m.OtherBro = brothers[this.Math.rand(0, brothers.len() - 1)];
			}
			while (this.m.OtherBro == null || this.m.OtherBro.getID() == bro.getID());

			this.m.Minstrel = bro;
			this.m.Talkers.push(bro);
		}

		if (killer_candidates.len() > 0)
		{
			bro = killer_candidates[this.Math.rand(0, killer_candidates.len() - 1)];
			this.m.Killer = bro;
			this.m.Talkers.push(bro);
		}

		if (this.m.Talkers.len() <= 0)
		{
			this.m.Score = 0;
		}
		else
		{
			this.m.Score = 3 * this.m.Talkers.len();
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist != null ? this.m.Anatomist.getNameOnly() : ""
		]);
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"mercenary",
			this.m.Mercenary != null ? this.m.Mercenary.getNameOnly() : ""
		]);
		_vars.push([
			"swordmaster",
			this.m.Swordmaster != null ? this.m.Swordmaster.getNameOnly() : ""
		]);
		_vars.push([
			"minstrel",
			this.m.Minstrel != null ? this.m.Minstrel.getNameOnly() : ""
		]);
		_vars.push([
			"othersellsword",
			this.m.OtherBro != null ? this.m.OtherBro.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Talkers = [];
		this.m.Anatomist = null;
		this.m.Cultist = null;
		this.m.Monk = null;
		this.m.Mercenary = null;
		this.m.Swordmaster = null;
		this.m.Minstrel = null;
		this.m.OtherBro = null;
		this.m.Killer = null;
	}

});

