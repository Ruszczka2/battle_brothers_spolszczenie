this.hate_undead_event <- this.inherit("scripts/events/event", {
	m = {
		Image = "",
		Casualty = null
	},
	function create()
	{
		this.m.ID = "event.hate_undead";
		this.m.Title = "Po bitwie...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%image%{%brother% spluwa i przeciera dłoń pod nosem. Marszczy twarz i wygląda, jakby mówił do siebie, podczas gdy inni patrzą.%SPEECH_ON%Starzy bogowie wezmą nam tyłki, jeśli pozwolimy martwym znów chodzić! Wy, chłopaki, możecie iść w zaświaty, myśląc, że zrobiliście dobrze na tym świecie, ale ja nie pójdę tą leniwą drogą, bo według mnie prowadzi prosto do piekieł. Dopilnuję, by spotkał mnie sprawiedliwy koniec, a zrobię to, kładąc każdą przeklętą, nieumarłą farsę, jaką zobaczę!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "O to chodzi!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Casualty.getImagePath());
				local trait = this.new("scripts/skills/traits/hate_undead_trait");
				_event.m.Casualty.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Casualty.getName() + " teraz nienawidzi nieumarłych"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 8.0)
		{
			return;
		}

		local fallen = [];
		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 2)
		{
			return;
		}

		if (fallen[0].Time < this.World.getTime().Days || fallen[1].Time < this.World.getTime().Days)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID() && this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getID())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && !bro.getSkills().hasSkill("trait.fear_undead") && !bro.getSkills().hasSkill("trait.hate_undead") && !bro.getSkills().hasSkill("trait.dastard") && !bro.getSkills().hasSkill("trait.craven") && !bro.getSkills().hasSkill("trait.fainthearted") && !bro.getSkills().hasSkill("trait.weasel"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Casualty = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 500;
	}

	function onPrepare()
	{
		this.m.Image = "[img]gfx/ui/events/event_46.png[/img]";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"brother",
			this.m.Casualty.getName()
		]);
		_vars.push([
			"image",
			this.m.Image
		]);
	}

	function onClear()
	{
		this.m.Casualty = null;
		this.m.Image = "";
	}

});

