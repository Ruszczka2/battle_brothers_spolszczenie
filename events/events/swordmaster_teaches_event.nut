this.swordmaster_teaches_event <- this.inherit("scripts/events/event", {
	m = {
		Student = null,
		Teacher = null
	},
	function create()
	{
		this.m.ID = "event.swordmaster_teaches";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]Słychać spokojny głos starego mężczyzny wydającego rozkazy.%SPEECH_ON%Stopa prowadzi, ciało podąża. Jeszcze raz.%SPEECH_OFF%Znajdujesz mistrza miecza %swordmaster% i %swordstudent% ćwiczących na polu. Starszy kręci głową na widok ostatniego popisu fechtunku.%SPEECH_ON%Stopa prowadzi, ciało podąża. Jeszcze raz!%SPEECH_OFF%Uczeń ćwiczy to, czego go uczą. Mistrz miecza kiwa głową i wydaje kolejne polecenie.%SPEECH_ON%Teraz na odwrót. Stopa się cofa, ciało podąża. Nie cofaj się umysłem. Niech twoje stopy myślą za ciebie. Instynkt to przetrwanie! Myślenie to śmierć! Ruszaj się, jakby świat tego żądał. Gdy wieje wiatr, czy jesteś szybszy niż liście, które słyszą jego zew? Widzę. Dobrze... uczysz się. A teraz... jeszcze raz.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Teraz wykorzystaj to w praktyce.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				this.Characters.push(_event.m.Student.getImagePath());
				local meleeDefense = this.Math.rand(1, 4);
				_event.m.Student.getBaseProperties().MeleeDefense += meleeDefense;
				_event.m.Student.getSkills().update();
				_event.m.Student.getFlags().add("taughtBySwordmaster");
				_event.m.Student.improveMood(0.5, "Nauczył się od " + _event.m.Teacher.getName());
				_event.m.Teacher.improveMood(1.0, "Nauczył " + _event.m.Student.getName() + " czegoś");
				this.List = [
					{
						id = 17,
						icon = "ui/icons/melee_defense.png",
						text = _event.m.Student.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeDefense + "[/color] obrony w zwarciu"
					}
				];

				if (_event.m.Teacher.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Teacher.getMoodState()],
						text = _event.m.Teacher.getName() + this.Const.MoodStateEvent[_event.m.Teacher.getMoodState()]
					});
				}

				if (_event.m.Student.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Student.getMoodState()],
						text = _event.m.Student.getName() + this.Const.MoodStateEvent[_event.m.Student.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local teacher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 4 && (bro.getBackground().getID() == "background.swordmaster" || bro.getBackground().getID() == "background.old_swordmaster"))
			{
				teacher_candidates.push(bro);
			}
		}

		if (teacher_candidates.len() < 1)
		{
			return;
		}

		local student_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && !bro.getFlags().has("taughtBySwordmaster") && (bro.getBackground().getID() == "background.squire" || bro.getBackground().getID() == "background.bastard" || bro.getBackground().getID() == "background.adventurous_noble" || bro.getBackground().getID() == "background.disowned_noble" || bro.getBackground().getID() == "background.regent_in_absentia"))
			{
				student_candidates.push(bro);
			}
		}

		if (student_candidates.len() < 1)
		{
			return;
		}

		this.m.Student = student_candidates[this.Math.rand(0, student_candidates.len() - 1)];
		this.m.Teacher = teacher_candidates[this.Math.rand(0, teacher_candidates.len() - 1)];
		this.m.Score = teacher_candidates.len() * 4;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"swordstudent",
			this.m.Student.getName()
		]);
		_vars.push([
			"swordmaster",
			this.m.Teacher.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Student = null;
		this.m.Teacher = null;
	}

});

