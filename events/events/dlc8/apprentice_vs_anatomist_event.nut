this.apprentice_vs_anatomist_event <- this.inherit("scripts/events/event", {
	m = {
		Apprentice = null,
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.apprentice_vs_anatomist";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Zastajesz %apprentice% ucznia pod skrzydlami %anatomist% anatomisty. To troche niepokojacy widok, bo przez chwile zastanawiasz sie, czy jajoglow nie planuje czegos niecnego. Ale %apprentice% jedynie sie od niego uczy, jak ma w zwyczaju robic z wiekszoscia w kompanii. Tym razem nie chodzi o kwestie bojowe, w ktorych anatomista ma przewage, a uczen nie, lecz o sposoby myslenia, zapamietywania i przypominania. Widzisz, jak %anatomist% puka sie w glowe.%SPEECH_ON%Pamietaj, nawet najslabszy atrament jest nieskonczenie silniejszy od najbardziej niezwyklego umyslu. Wszystko, co pamietasz, zapisuj, ale pamietaj tez to: twoj umysl przypomni sobie rzeczy, o ktorych myslisz, ze je zapomniales. Gdy nadejdzie chwila potrzeby, nie skupiaj sie na swoich myslach, lecz pozwol im wyplynac same, bo one same wyjda na swiatlo bez pomocy, ale gdy ich szukasz, schodza tylko glebiej i chca byc zapomniane.%SPEECH_OFF%Uczen przytakuje uwaznie i notuje. Dopoki te rozmowy nie wykraczaja poza rozcinanie zwierzat i podwazanie starych bogow, nie masz nic przeciwko.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tylko nie spedzajcie razem zbyt wiele czasu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local effect = this.new("scripts/skills/effects_world/new_trained_effect");
				effect.m.Duration = 3;
				effect.m.XPGainMult = 1.35;
				effect.m.Icon = "skills/status_effect_76.png";
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Apprentice.getName() + " zyskuje Doswiadczenie Treningowe"
				});
				_event.m.Apprentice.getSkills().add(effect);
				_event.m.Apprentice.getFlags().add("learnedFromAnatomist");
				_event.m.Apprentice.improveMood(1.0, "Uczyl sie od " + _event.m.Anatomist.getName());
				_event.m.Anatomist.improveMood(0.5, "Nauczyl " + _event.m.Apprentice.getName() + " czegos");

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
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

		local brothers = this.World.getPlayerRoster().getAll();
		local apprentice_candidates = [];
		local teacher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.apprentice" && !bro.getFlags().has("learnedFromAnatomist") && !bro.getSkills().hasSkill("effects.trained"))
			{
				apprentice_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.anatomist")
			{
				teacher_candidates.push(bro);
			}
		}

		if (apprentice_candidates.len() == 0 || teacher_candidates.len() == 0)
		{
			return;
		}

		this.m.Apprentice = apprentice_candidates[this.Math.rand(0, apprentice_candidates.len() - 1)];
		this.m.Anatomist = teacher_candidates[this.Math.rand(0, teacher_candidates.len() - 1)];
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
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Apprentice = null;
		this.m.Anatomist = null;
	}

});

