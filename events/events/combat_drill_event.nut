this.combat_drill_event <- this.inherit("scripts/events/event", {
	m = {
		Teacher = null
	},
	function create()
	{
		this.m.ID = "event.combat_drill";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Wychodzisz z namiotu, by obejrzeć ludzi. Wielu z nich to świeżo najęte żółtodzioby, nerwowo trzymające się w grupkach albo próbujące swoich sił z bronią. %oldguard% staje obok ciebie.%SPEECH_ON%Wiem, co myślisz. Myślisz, że zatrudniłeś kupę mięsa na rzeź. Co powiesz na to, żebym ukształtował tych chłopaków, by nie nadziali się na orkowe ostrze przy pierwszym wyjściu w pole?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, naucz ich walczyć człowiek przeciw człowiekowi.",
					function getResult( _event )
					{
						return "B1";
					}

				},
				{
					Text = "Dobrze, niech nauczą się używać łuku.",
					function getResult( _event )
					{
						return "C1";
					}

				},
				{
					Text = "Dobrze, przygotuj ich do noszenia prawdziwego pancerza.",
					function getResult( _event )
					{
						return "D1";
					}

				},
				{
					Text = "Nie, muszą zachować resztki sił na walkę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_05.png[/img]%oldguard% każe rekrutom chwycić broń. Gdy wszyscy biorą miecze, stary gwardzista krzyczy, że nie każdy wróg, który chce zobaczyć was w grobie, będzie miał to samo ostrze. Kilku kiwa głowami i w pośpiechu zamienia miecze na topory i włócznie. Gdy ekipa jest uzbrojona, zaczyna się trening. Głównie %oldguard% uczy podstaw, jak choćby tego, że szyk ułatwia obronę nie tylko towarzyszy, ale i siebie.%SPEECH_ON%Nie musisz pilnować wszystkich stron, jeśli wiesz, że brat stoi obok. Ale jeśli się rozdzielicie i zostaniesz sam, to będzie z tobą krucho, chyba że masz jakiś nieznany talent do miecza, którego, założę się, nie masz.%SPEECH_OFF%Trening przechodzi do ofensywy, gdzie %oldguard% pokazuje kilka sztuczek z różnymi broniami.%SPEECH_ON%Mieczem możesz ciąć, rąbać, pchać i ripostować. Trudno nim chybić, bo każda strona ostrza zabija. Jeśli zobaczę, że ktoś próbuje przeciąć strzałę mieczem, jak w bajkach, sam mu dam w mordę. To nieprawda, więc przestańcie marzyć!\n\nWłócznie są dobre do trzymania dystansu. Zbroi wiele nie zrobią, ale utrzymają was bezpiecznymi. Po prostu trzymajcie ostry koniec z dala od siebie. Jeśli opancerzony bydlak przejdzie ten ostry koniec, to będzie z wami krucho, więc nie dopuśćcie do tego.\n\nWreszcie topór. Udawajcie, że drugi człowiek to drzewo, i rozłupcie go. A teraz ćwiczymy!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pokażcie, co potraficie!",
					function getResult( _event )
					{
						return "B2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				_event.m.Teacher.improveMood(0.5, "Wyszkolił nowych rekrutów");
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_50.png[/img]Trening idzie całkiem nieźle, choć ludzie wychodzą z tego z kilkoma guzami i siniakami.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getLevel() > 3)
					{
						continue;
					}

					local meleeSkill = this.Math.rand(0, 2);
					local meleeDefense = meleeSkill == 0 ? this.Math.rand(0, 2) : 0;
					bro.getBaseProperties().MeleeSkill += meleeSkill;
					bro.getBaseProperties().MeleeDefense += meleeDefense;
					bro.getSkills().update();

					if (meleeSkill > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/melee_skill.png",
							text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Umiejętność walki wręcz"
						});
					}

					if (meleeDefense > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/melee_defense.png",
							text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeDefense + "[/color] Obronę wręcz"
						});
					}

					local injuryChance = 33;

					if (bro.getSkills().hasSkill("trait.clumsy") || bro.getSkills().hasSkill("trait.drunkard"))
					{
						injuryChance = injuryChance * 2.0;
					}

					if (bro.getBackground().isCombatBackground())
					{
						injuryChance = injuryChance * 0.5;
					}

					if (bro.getSkills().hasSkill("trait.dexterous"))
					{
						injuryChance = injuryChance * 0.5;
					}

					if (this.Math.rand(1, 100) <= injuryChance)
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							bro.addLightInjury();
							this.List.push({
								id = 10,
								icon = "ui/icons/days_wounded.png",
								text = bro.getName() + " doznaje lekkich ran"
							});
						}
						else
						{
							local injury = bro.addInjury(this.Const.Injury.Accident1);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " doznaje " + injury.getNameOnly()
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C1",
			Text = "[img]gfx/ui/events/event_05.png[/img] %oldguard% zbiera ludzi i zaczyna rozdawać im treningowe łuki.%SPEECH_ON%Te nie służą do zabijania, chyba że macie coś do wyjaśnienia noworodkowi, co wątpię, ale na razie będziemy na nich ćwiczyć.\n\nTak działa ta zabawka. Och, już wiecie? Nie jesteście bandą głupców? No to pokażcie, co potraficie, strzelcy.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zobaczmy, czy traficie w cokolwiek.",
					function getResult( _event )
					{
						return "C2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				_event.m.Teacher.improveMood(0.5, "Has drilled the new recruits");
			}

		});
		this.m.Screens.push({
			ID = "C2",
			Text = "[img]gfx/ui/events/event_10.png[/img]Ludzie oddają ćwiczebne strzały, a strzały zasypują okolice tarcz, zaledwie kilka szczęśliwych trafia tam, gdzie powinno. %oldguard% spędza resztę dnia, każąc im strzelać i strzelać, aż szczęście przestaje mieć znaczenie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getLevel() > 3)
					{
						continue;
					}

					local rangedSkill = this.Math.rand(0, 2);
					bro.getBaseProperties().RangedSkill += rangedSkill;
					bro.getSkills().update();

					if (rangedSkill > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/ranged_skill.png",
							text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + rangedSkill + "[/color] Umiejętność strzelania"
						});
					}

					local exhaustionChance = 33;

					if (bro.getSkills().hasSkill("trait.asthmatic"))
					{
						exhaustionChance = exhaustionChance * 4.0;
					}

					if (bro.getSkills().hasSkill("trait.athletic"))
					{
						exhaustionChance = exhaustionChance * 0.0;
					}

					if (bro.getSkills().hasSkill("trait.iron_lungs"))
					{
						exhaustionChance = exhaustionChance * 0.0;
					}

					if (this.Math.rand(1, 100) <= exhaustionChance)
					{
						local effect = this.new("scripts/skills/effects_world/exhausted_effect");
						bro.getSkills().add(effect);
						this.List.push({
							id = 10,
							icon = effect.getIcon(),
							text = bro.getName() + " jest wyczerpany"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D1",
			Text = "[img]gfx/ui/events/event_05.png[/img]%oldguard% gwiżdże ostro, zbierając nowych rekrutów wokół siebie. Rozgląda się, uśmiecha i kiwa głową.%SPEECH_ON%Dobra, wy, miękkopytne, cyckosysiące, makaronorękie koźlojebce, idziemy na marsz!%SPEECH_OFF%Weteran spędza resztę dnia, bezlitośnie pędząc rekrutów, aż ostatni pada z wyczerpania.%SPEECH_ON%Oddychaj, dzieciaku, oddychaj! Wciągaj wszystko. Dla reszty z nas jest dość, nie przejmuj się! Połykaj to, jakby twoja matka powinna była połknąć ciebie. Widziałem plamy, które biegały szybciej niż wy, więc zobaczymy się jutro o porządnym czasie. To znaczy przed wschodem słońca, łachudry.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powtórzymy to jutro!",
					function getResult( _event )
					{
						return "D2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				_event.m.Teacher.improveMood(0.5, "Has drilled the new recruits");
			}

		});
		this.m.Screens.push({
			ID = "D2",
			Text = "%oldguard% nie okazuje litości i każe ludziom biegać raz za razem w kolejnych dniach. W końcu, jak mówi, to dla ich własnego dobra.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra robota.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getLevel() > 3)
					{
						continue;
					}

					local stamina = this.Math.rand(0, 3);
					local initiative = stamina == 0 ? this.Math.rand(0, 3) : 0;
					bro.getBaseProperties().Stamina += stamina;
					bro.getBaseProperties().Initiative += initiative;
					bro.getSkills().update();

					if (stamina > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/fatigue.png",
							text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] maks. zmęczenie"
						});
					}

					if (initiative > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/initiative.png",
							text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] Inicjatywę"
						});
					}

					local exhaustionChance = 75;

					if (bro.getSkills().hasSkill("trait.asthmatic"))
					{
						exhaustionChance = exhaustionChance * 2.0;
					}

					if (bro.getSkills().hasSkill("trait.athletic"))
					{
						exhaustionChance = exhaustionChance * 0.5;
					}

					if (bro.getSkills().hasSkill("trait.iron_lungs"))
					{
						exhaustionChance = exhaustionChance * 0.5;
					}

					if (this.Math.rand(1, 100) <= exhaustionChance)
					{
						local effect = this.new("scripts/skills/effects_world/exhausted_effect");
						bro.getSkills().add(effect);
						this.List.push({
							id = 10,
							icon = effect.getIcon(),
							text = bro.getName() + " jest wyczerpany"
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local numRecruits = 0;

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().isCombatBackground() && !bro.getBackground().isNoble())
			{
				candidates.push(bro);
			}
			else if (bro.getLevel() <= 3 && !bro.getBackground().isCombatBackground())
			{
				numRecruits = ++numRecruits;
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		if (numRecruits < 3)
		{
			return;
		}

		this.m.Teacher = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10 + numRecruits * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oldguard",
			this.m.Teacher.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Teacher = null;
	}

});

