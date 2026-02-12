this.killer_vs_others_event <- this.inherit("scripts/events/event", {
	m = {
		Killer = null,
		OtherGuy1 = null,
		OtherGuy2 = null
	},
	function create()
	{
		this.m.ID = "event.killer_vs_others";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]Gdy próbujesz studiować kilka marnie narysowanych map, dźwięk dobywanych ostrzy przeszywa twoje uszy. Zwijasz swoją pracę i wkładasz ją do tuby, po czym kierujesz się ku zamieszaniu.\n\n%killerontherun% jest przyciskany kolanem jednego z braci, podczas gdy %otherguy1% i %otherguy2% wyglądają, jakby zaraz mieli odrąbać mu głowę. Na twój widok mężczyźni na chwilę się uspokajają. Wyjaśniają, że zabójca próbował zabić jednego z nich. Rzeczywiście, brat ma nacięcie na szyi. Odrobinę głębiej i zamiast słów z jego ust płynęłoby coś innego. Mężczyźni żądają, by %killerontherun% został powieszony za próbę morderstwa.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Za to każcie go wychłostać.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Za to każcie go powiesić.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "To teraz twoja rodzina. Nie waż się nigdy więcej na coś takiego!",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 3);

						if (r == 1)
						{
							return "D";
						}
						else if (r == 2)
						{
							return "E";
						}
						else
						{
							return "F";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_38.png[/img]Rozkazujesz wychłostać mężczyznę. %killerontherun% pluje na twoje imię, gdy bracia przywiązują go do drzewa. Mówisz, że jeśli zrobi to jeszcze raz, dołożysz więcej razów. Zdzierają z niego koszulę i na zmianę biją go biczem, a ty stoisz z boku, licząc. Po pierwszym uderzeniu z pleców odrywa się prosta smuga skóry. Mężczyzna drga, a ty słyszysz, jak liny, które go krępują, napinają się, gdy zaciska dłonie w pięści. Przy piątym razie już nie stoi. Przy dziesiątym już nie jest przytomny. Po pięciu kolejnych przerywasz i każesz ludziom go odwiązać i opatrzyć rany.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mam nadzieję, że to będzie nauczka.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
				_event.m.Killer.addLightInjury();
				_event.m.Killer.worsenMood(3.0, "Został wychłostany na twój rozkaz");
				this.List = [
					{
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Killer.getName() + " doznaje lekkich ran"
					}
				];

				if (_event.m.Killer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Killer.getMoodState()],
						text = _event.m.Killer.getName() + this.Const.MoodStateEvent[_event.m.Killer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_02.png[/img]Rozkazujesz powiesić mężczyznę. Połowa kompanii wiwatuje, a %killerontherun% wydaje krzyk odpowiedni dla kogoś, kto właśnie usłyszał wyrok śmierci. Ciągną go pod drzewo. Liny są zarzucane na gałęzie raz po raz, zapętlane i napinane. Jeden mężczyzna wiąże stryczek, podczas gdy inni wiwatują, klaszczą i piją piwo. Stawiają stołek i zmuszają skazańca, by na nim stanął. Gdy głowa %killerontherun% trafia do pętli, mówi, że ma do was wszystkich słowo, ale cokolwiek miał powiedzieć, zostaje ucięte, gdy %otherguy1% kopie stołek spod jego nóg.\n\nTo nie jest dobry sposób na śmierć. To robota kata, albo i nie. Zwykle człowiek spadający z platformy łamie kark, a czasem nawet zostaje zdekapitowany. Ten wisi, dławiąc się i kopiąc. Słychać krzyki w jego płucach, ale nie mogą się przebić przez gardło. Mijają minuty, a on wciąż walczy. %otherguy2% podchodzi do konającego, chwyta jedną z jego szarpanych stóp, by go unieruchomić, i wolną ręką wbija %killerontherun% nóż w serce. I tak się to kończy.\n\n{Ku zaskoczeniu, bracia zgadzają się zdjąć mężczyznę i go pochować. | Mężczyzna zostaje tam powieszony, gdy marsz kompanii rusza na nowo.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maszerujemy dalej.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Killer.getName() + " nie żyje"
				});
				_event.m.Killer.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.Killer.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.Killer);
				_event.m.OtherGuy1.improveMood(2.0, "Zaspokoił się egzekucją " + _event.m.Killer.getNameOnly());

				if (_event.m.OtherGuy1.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.OtherGuy1.getMoodState()],
						text = _event.m.OtherGuy1.getName() + this.Const.MoodStateEvent[_event.m.OtherGuy1.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]Gdy próbujesz zaprowadzić pokój między tą gromadą wyrzutków, twoje próby neutralności tylko złoszczą kilku ludzi. Szczególnie mężczyzna z naciętą szyją kipi złością, przeklinając i przewracając rzeczy. Kilku innych głośno martwi się o brak dyscypliny.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maszerujemy dalej.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
				_event.m.OtherGuy1.worsenMood(4.0, "Zły na brak sprawiedliwości pod twoim dowództwem");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.OtherGuy1.getMoodState()],
					text = _event.m.OtherGuy1.getName() + this.Const.MoodStateEvent[_event.m.OtherGuy1.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Killer.getID() || bro.getID() == _event.m.OtherGuy1.getID())
					{
						continue;
					}

					bro.worsenMood(1.0, "Zaniepokojony brakiem dyscypliny");

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getNameOnly() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_64.png[/img]Wezwanie do zachowania zimnej krwi najwyraźniej zawiodło, bo ciało %killerontherun% i tak znaleziono martwe. {Wygląda na to, że ktoś dźgnął go w plecy. | Ktoś udusił mężczyznę mocnym sznurem z lnu. | Został niemal przecięty na pół, robota naprawdę wściekłej osoby. | Jego głowę znaleziono na piersi, dłonie ułożone tak, jakby ją podtrzymywały. | Podkreślamy słowo \"ciało\", bo głowy nigdzie nie było. | Ktoś poderżnął mu nocą gardło. | Siniaki na ciele i rany na dłoniach sugerują walkę, ale ktokolwiek to był, i tak go wypatroszył.} Masz dobrą teorię, kto to zrobił, ale żaden z ludzi nie wydaje się szczególnie przejęty jego śmiercią, a pewny dowód umknąłby jakiejkolwiek dochodzeniu. Mimo wszystko nakazujesz podejrzanemu bratu pomóc w pochówku.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nic już nie da się zrobić.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				local dead = _event.m.Killer;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Zamordowany przez braci z kompanii",
					Expendable = dead.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Killer.getName() + " nie żyje"
				});
				_event.m.Killer.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.Killer.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.Killer);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.OtherGuy1.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						continue;
					}

					bro.worsenMood(1.0, "Zaniepokojony brakiem dyscypliny");

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

		});
		this.m.Screens.push({
			ID = "F",
			Text = "Cóż, %killerontherun% nie jest martwy, ale stoi przed tobą złamany i pobity. Wygląda na to, że mściwa sprawiedliwość i tak go dopadła. Domaga się, by ukarać podejrzanych braci za działanie wbrew twoim rozkazom. Rozważasz to, ale potem pytasz go, co się stanie, jeśli będziecie dalej nakręcać ten cykl przemocy. Trudno dostrzec jego twarz, bo jest spuchnięta i sina, a oczy kryją się za obrzękłymi powiekami, ale ostrożnie przytakuje. Masz rację, mówi. Najlepiej, by to wszystko przycichło, zanim wymknie się spod kontroli.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maszerujemy dalej.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
				local injury = _event.m.Killer.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 13,
					icon = injury.getIcon(),
					text = _event.m.Killer.getName() + " doznaje " + injury.getNameOnly()
				});
				injury = _event.m.Killer.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 13,
					icon = injury.getIcon(),
					text = _event.m.Killer.getName() + " doznaje " + injury.getNameOnly()
				});
				_event.m.Killer.worsenMood(2.0, "Został pobity przez ludzi z kompanii");

				if (_event.m.Killer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Killer.getMoodState()],
						text = _event.m.Killer.getName() + this.Const.MoodStateEvent[_event.m.Killer.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Killer.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50 && bro.getID() != _event.m.OtherGuy1.getID())
					{
						continue;
					}

					bro.worsenMood(1.0, "Zaniepokojony brakiem dyscypliny");

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

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 10)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local killer_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getHireTime() + this.World.getTime().SecondsPerDay * 60 >= this.World.getTime().Time && bro.getBackground().getID() == "background.killer_on_the_run" && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				killer_candidates.push(bro);
			}
		}

		if (killer_candidates.len() == 0)
		{
			return;
		}

		this.m.Killer = killer_candidates[this.Math.rand(0, killer_candidates.len() - 1)];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Killer.getID() && bro.getBackground().getID() != "background.slave")
			{
				other_candidates.push(bro);
			}
		}

		if (other_candidates.len() == 0)
		{
			return;
		}

		this.m.OtherGuy1 = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Killer.getID() && bro.getID() != this.m.OtherGuy1.getID())
			{
				other_candidates.push(bro);
			}
		}

		if (other_candidates.len() == 0)
		{
			return;
		}

		this.m.OtherGuy2 = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"killerontherun",
			this.m.Killer.getName()
		]);
		_vars.push([
			"otherguy1",
			this.m.OtherGuy1.getName()
		]);
		_vars.push([
			"otherguy2",
			this.m.OtherGuy2.getName()
		]);
	}

	function onClear()
	{
		this.m.Killer = null;
		this.m.OtherGuy1 = null;
		this.m.OtherGuy2 = null;
	}

});

