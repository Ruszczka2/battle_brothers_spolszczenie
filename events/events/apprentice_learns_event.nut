this.apprentice_learns_event <- this.inherit("scripts/events/event", {
	m = {
		Apprentice = null,
		Teacher = null
	},
	function create()
	{
		this.m.ID = "event.apprentice_learns";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Czeladnik %apprentice% najwyraźniej stał się podopiecznym %teacher%. Choć mistrz miecza ma już swoje lata, wydaje się gorliwie pomagać młodemu stać się lepszym wojownikiem. Czeladnik używa prawdziwego miecza, mistrz tylko drewnianego. To właśnie w tej sporej różnicy doboru broni mistrz pokazuje, jak ważne jest ustawienie, wyszukiwanie luk i unikanie zagrożeń.\n\nNawet w podeszłym wieku mężczyzna kręci się i wiruje, stając się dla czeladnika niemożliwym do trafienia. W jednym szczególnie błyskotliwym triku mistrz wyczuwa, że ma zostać trafiony, więc skraca dystans i staje czeladnikowi na stopie. Gdy ten odchyla się, by zyskać przestrzeń, stopa nie idzie z nim. Nagła utrata równowagi przewraca ucznia na ziemię, gdzie widzi drewniany miecz przyłożony do szyi.\n\nCzęsto widzisz, jak otrzepuje z siebie ziemię, ale przynajmniej wstaje po więcej. Powiedzmy, że poprawia się drzazga po drzazdze.",
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
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Teacher.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				local meleeDefense = this.Math.rand(2, 4);
				_event.m.Apprentice.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Apprentice.getBaseProperties().MeleeDefense += meleeDefense;
				_event.m.Apprentice.getSkills().update();
				_event.markAsLearned();
				_event.m.Apprentice.improveMood(1.0, "Nauczył się od " + _event.m.Teacher.getName());
				_event.m.Teacher.improveMood(0.5, "Nauczył " + _event.m.Apprentice.getName() + " czegoś");
				this.List = [
					{
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.Apprentice.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Umiejętności w walce wręcz"
					},
					{
						id = 17,
						icon = "ui/icons/melee_defense.png",
						text = _event.m.Apprentice.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeDefense + "[/color] Obronę w walce wręcz"
					}
				];

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]%teacher%, emerytowany żołnierz, polubił %apprentice%. Widzisz ich ćwiczących, kiedy tylko mogą. Stary żołnierz wierzy w wartość ofensywy i pokazuje czeladnikowi, jak prowadzić miecz, topór lub buzdygan tak, by zadawał jak największe obrażenia. Niestety, używają obozowych naczyń do ustawiania kukiełek do okładania. Młody chłopak na pewno narobił bałaganu w garnkach i patelniach w swoim nieustannym dążeniu do bycia lepszym wojownikiem.",
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
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Teacher.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				local resolve = this.Math.rand(2, 5);
				_event.m.Apprentice.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Apprentice.getBaseProperties().Bravery += resolve;
				_event.m.Apprentice.getSkills().update();
				_event.markAsLearned();
				_event.m.Apprentice.improveMood(1.0, "Nauczył się od " + _event.m.Teacher.getName());
				_event.m.Teacher.improveMood(0.25, "Nauczył " + _event.m.Apprentice.getName() + " czegoś");
				this.List = [
					{
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.Apprentice.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Umiejętności w walce wręcz"
					},
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Apprentice.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Determinację"
					}
				];

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Wygląda na to, że %teacher%, stary najemnik, ma za sobą małą ptaszynę: młodego %apprentice%. Teraz, w kompanii najemników, czeladnik chce uczyć się od tych, którzy mają doświadczenie na drodze i w zarabianiu krwawych pieniędzy. Podczas treningu zauważasz, że najemnik kładzie nacisk na ćwiczenie ciała. Bycie szybszym od przeciwnika i przetrwanie go są równie ważne jak wbicie mu ostrza w głowę. Sumienny chłopak wydaje się coraz bardziej wytrzymały, zyskując krzepę, której wcześniej nie zauważałeś.",
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
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Teacher.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				local initiative = this.Math.rand(4, 6);
				local stamina = this.Math.rand(2, 4);
				_event.m.Apprentice.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Apprentice.getBaseProperties().Initiative += initiative;
				_event.m.Apprentice.getBaseProperties().Stamina += stamina;
				_event.m.Apprentice.getSkills().update();
				_event.markAsLearned();
				_event.m.Apprentice.improveMood(1.0, "Nauczył się od " + _event.m.Teacher.getName());
				_event.m.Teacher.improveMood(0.25, "Nauczył " + _event.m.Apprentice.getName() + " czegoś");
				this.List = [
					{
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.Apprentice.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Umiejętności w walce wręcz"
					},
					{
						id = 17,
						icon = "ui/icons/initiative.png",
						text = _event.m.Apprentice.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] Inicjatywę"
					},
					{
						id = 17,
						icon = "ui/icons/fatigue.png",
						text = _event.m.Apprentice.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] Maksymalne zmęczenie"
					}
				];

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]Kilka razy przyłapałeś %apprentice%, jak z oddali obserwuje %teacher%. Młody czeladnik wydaje się zafascynowany brutalną przemocą rycerza wędrownego. Po kilku dniach rycerz odpuszcza i prosi chłopaka, by przyszedł porozmawiać. Nie wiesz, o czym mówią, ale teraz widzisz, że trenują razem. Rycerz wędrowny nie jest łagodnym nauczycielem. Często bije chłopca, hartując go. Na początku czeladnik wzdrygał się przed każdym ciosem, lecz teraz widać, że okazuje nieco więcej determinacji wobec tak wielkich przeciwności. Rycerz uczy go też, jak zabijać szybko i skutecznie. W tych rozmowach, które podsłuchujesz, niewiele miejsca poświęca się obronie, ale kto musi się bronić przed martwym przeciwnikiem?",
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
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Teacher.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				local hitpoints = this.Math.rand(3, 5);
				local stamina = this.Math.rand(3, 5);
				_event.m.Apprentice.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Apprentice.getBaseProperties().Hitpoints += hitpoints;
				_event.m.Apprentice.getBaseProperties().Stamina += stamina;
				_event.m.Apprentice.getSkills().update();
				_event.markAsLearned();
				_event.m.Apprentice.improveMood(1.0, "Nauczył się od " + _event.m.Teacher.getName());
				_event.m.Teacher.improveMood(0.25, "Nauczył " + _event.m.Apprentice.getName() + " czegoś");
				this.List = [
					{
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.Apprentice.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Umiejętności w walce wręcz"
					},
					{
						id = 17,
						icon = "ui/icons/health.png",
						text = _event.m.Apprentice.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + hitpoints + "[/color] Punkty życia"
					},
					{
						id = 17,
						icon = "ui/icons/fatigue.png",
						text = _event.m.Apprentice.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] Maksymalne zmęczenie"
					}
				];

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
	}

	function markAsLearned()
	{
		this.m.Apprentice.getFlags().add("learned");
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local apprentice_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() > 3 && bro.getBackground().getID() == "background.apprentice" && !bro.getFlags().has("learned"))
			{
				apprentice_candidates.push(bro);
			}
		}

		if (apprentice_candidates.len() < 1)
		{
			return;
		}

		local teacher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() < 6)
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.swordmaster" || bro.getBackground().getID() == "background.old_swordmaster" || bro.getBackground().getID() == "background.retired_soldier" || bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.sellsword")
			{
				teacher_candidates.push(bro);
			}
		}

		if (teacher_candidates.len() < 1)
		{
			return;
		}

		this.m.Apprentice = apprentice_candidates[this.Math.rand(0, apprentice_candidates.len() - 1)];
		this.m.Teacher = teacher_candidates[this.Math.rand(0, teacher_candidates.len() - 1)];
		this.m.Score = (apprentice_candidates.len() + teacher_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"apprentice",
			this.m.Apprentice.getNameOnly()
		]);
		_vars.push([
			"teacher",
			this.m.Teacher.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.m.Teacher.getBackground().getID() == "background.swordmaster" || this.m.Teacher.getBackground().getID() == "background.old_swordmaster")
		{
			return "A";
		}
		else if (this.m.Teacher.getBackground().getID() == "background.retired_soldier")
		{
			return "B";
		}
		else if (this.m.Teacher.getBackground().getID() == "background.sellsword")
		{
			return "C";
		}
		else
		{
			return "D";
		}
	}

	function onClear()
	{
		this.m.Apprentice = null;
		this.m.Teacher = null;
	}

});

