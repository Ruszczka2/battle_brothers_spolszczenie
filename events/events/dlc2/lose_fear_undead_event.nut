this.lose_fear_undead_event <- this.inherit("scripts/events/event", {
	m = {
		Casualty = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.lose_fear_undead";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%fearful% przerywa przerwę kompanii nagłą przemową.%SPEECH_ON%Zabiłem i pochowałem tylu ludzi, wiecie? A gdyby byli coś warci, to w ogóle nie mieliby okazji wrócić jako nieumarli! A jeśli wracają z dawnych czasów, to niech mnie, uparci są! Ale to nie ja. Ja żyję. Oddycham. I zamierzam tak to utrzymać. A gdy przyjdzie mój czas, zamierzam zostać martwy, bo mam dość rozumu, by wiedzieć, że już wystarczająco uprzykrzałem ten świat.%SPEECH_OFF%Klaszcząc, %otherbrother% podaje talerz jedzenia.%SPEECH_ON%Dobra, dobra, teraz przestań nam zawracać głowę!%SPEECH_OFF%Mężczyźni śmieją się, a %fearful% dołącza do nich.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ten świat należy do żywych.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Casualty.getImagePath());
				local trait = _event.m.Casualty.getSkills().getSkillByID("trait.fear_undead");
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Casualty.getName() + " już nie boi się nieumarłych"
				});
				_event.m.Casualty.getSkills().remove(trait);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID() && this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getID())
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > this.World.getTime().SecondsPerDay * 1.0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (!bro.getSkills().hasSkill("trait.fear_undead") || bro.getLifetimeStats().Battles < 25 || bro.getLifetimeStats().Kills < 50 || bro.getLifetimeStats().BattlesWithoutMe != 0)
			{
				candidates_other.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.Casualty = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = this.m.Casualty.getLifetimeStats().Kills / 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fearful",
			this.m.Casualty.getName()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Casualty = null;
		this.m.Other = null;
	}

});

