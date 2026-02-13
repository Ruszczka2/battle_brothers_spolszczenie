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
			Text = "[img]gfx/ui/events/event_26.png[/img]{%deserter% dezerter i %disowned% wygnany szlachcic wpatruja sie w siebie ponad ogniskiem. Poniewaz oboz to raczej malo romantyczne miejsce, taka sytuacja zwykle zapowiada jedno: ostrą bijatyke. Ale zamiast tego, dość niespodziewanie, obaj mezczyzni zaczynaja sie usmiechac. %deserter% wskazuje palcem.%SPEECH_ON%Dowodziles pospolitym ruszeniem %randomname% na zachodzie, prawda?%SPEECH_OFF%Wygnany szlachcic smieje sie i klepie sie w kolano.%SPEECH_ON%Skurczybyk. Wiedzialem, ze wygladasz znajomo! Ty, maly dezerterze, masz pojecie, jak dlugo cie szukalismy? Caly tydzien! Reszte złapaliśmy, ale ty, ty uciekles.%SPEECH_OFF%Dezerter smieje sie.%SPEECH_ON%A teraz popatrz na nas, walczymy dla tej samej kompanii najemnikow! Jakie szanse, co? A co zrobiliscie z tymi, ktorych złapaliscie, tak przy okazji?%SPEECH_OFF%%disowned% wzrusza ramionami.%SPEECH_ON%Och, powiesilismy ich, oczywiscie. W sumie przypomina mi to stary trick, ktory... no, powiedzmy tylko, ze to byly czasy!%SPEECH_OFF%%deserter% przez chwile wpatruje sie w ogien. Podnosi wzrok.%SPEECH_ON%Haha, no tak.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Swiat jest maly, przynajmniej dla wyrzutkow.",
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
				_event.m.Disowned.improveMood(1.0, "Wspominal stare czasy");

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
					text = _event.m.Disowned.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + attack_boost + "[/color] Umiejetnosci Walki Wrecz"
				});
				_event.m.Deserter.improveMood(1.0, "Wspominal stare czasy");

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

