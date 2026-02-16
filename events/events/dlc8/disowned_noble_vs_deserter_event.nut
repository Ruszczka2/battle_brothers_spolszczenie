this.disowned_noble_vs_deserter_event <- this.inherit("scripts/events/event", {
	m = {
		Deserter = null,
		Disowned = null
	},
	function create()
	{
		this.m.ID = "event.disowned_noble_vs_deserter";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%deserter% dezerter i %disowned% wygnany szlachcic wpatrują się w siebie ponad ogniskiem. Ponieważ obóz to raczej mało romantyczne miejsce, taka sytuacja zwykle zapowiada jedno: ostrą bijatykę. Ale zamiast tego, dość niespodziewanie, obaj mężczyźni zaczynają się uśmiechać. %deserter% wskazuje palcem.%SPEECH_ON%Dowodziłeś pospolitym ruszeniem %randomname% na zachodzie, prawda?%SPEECH_OFF%Wygnany szlachcic śmieje się i klepie się w kolano.%SPEECH_ON%Skurczybyk. Wiedziałem, że wyglądasz znajomo! Ty, mały dezerterze, masz pojęcie, jak długo cię szukaliśmy? Cały tydzień! Resztę złapaliśmy, ale ty, ty uciekłeś.%SPEECH_OFF%Dezerter śmieje się.%SPEECH_ON%A teraz popatrz na nas, walczymy dla tej samej kompanii najemników! Jakie szanse, co? A co zrobiliście z tymi, których złapaliście, tak przy okazji?%SPEECH_OFF%%disowned% wzrusza ramionami.%SPEECH_ON%Och, powiesiliśmy ich, oczywiście. W sumie przypomina mi to stary trik, który... no, powiedzmy tylko, że to były czasy!%SPEECH_OFF%%deserter% przez chwilę wpatruje się w ogień. Podnosi wzrok.%SPEECH_ON%Haha, no tak.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Świat jest mały, przynajmniej dla wyrzutków.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Deserter.getImagePath());
				this.Characters.push(_event.m.Disowned.getImagePath());
				_event.m.Deserter.getFlags().add("reminiscedWithDisowned");
				_event.m.Disowned.getFlags().add("reminiscedWithDeserter");
				_event.m.Disowned.improveMood(1.0, "Wspominał stare czasy");

				if (_event.m.Disowned.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Disowned.getMoodState()],
						text = _event.m.Disowned.getName() + this.Const.MoodStateEvent[_event.m.Disowned.getMoodState()]
					});
				}

				local attack_boost = this.Math.rand(1, 3);
				_event.m.Disowned.getBaseProperties().MeleeSkill += attack_boost;
				_event.m.Disowned.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Disowned.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + attack_boost + "[/color] Umiejętności Walki Wręcz"
				});
				_event.m.Deserter.improveMood(1.0, "Wspominał stare czasy");

				if (_event.m.Deserter.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Deserter.getMoodState()],
						text = _event.m.Deserter.getName() + this.Const.MoodStateEvent[_event.m.Deserter.getMoodState()]
					});
				}

				local resolve_boost = this.Math.rand(2, 4);
				_event.m.Deserter.getBaseProperties().Bravery += resolve_boost;
				_event.m.Deserter.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Deserter.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve_boost + "[/color] Determinacji"
				});
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
		local deserter_candidates = [];
		local disowned_candidates = [];

		foreach( bro in brothers )
		{
			if ((bro.getBackground().getID() == "background.disowned_noble" || bro.getBackground().getID() == "background.regent_in_absentia") && !bro.getFlags().has("reminiscedWithDeserter"))
			{
				disowned_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.deserter" && !bro.getFlags().has("reminiscedWithDisowned"))
			{
				deserter_candidates.push(bro);
			}
		}

		if (disowned_candidates.len() == 0 || deserter_candidates.len() == 0)
		{
			return;
		}

		this.m.Deserter = deserter_candidates[this.Math.rand(0, deserter_candidates.len() - 1)];
		this.m.Disowned = disowned_candidates[this.Math.rand(0, disowned_candidates.len() - 1)];
		this.m.Score = 3 * disowned_candidates.len() + 3 * deserter_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"deserter",
			this.m.Deserter.getNameOnly()
		]);
		_vars.push([
			"disowned",
			this.m.Disowned.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Deserter = null;
		this.m.Disowned = null;
	}

});

