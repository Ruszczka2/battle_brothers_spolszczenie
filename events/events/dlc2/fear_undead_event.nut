this.fear_undead_event <- this.inherit("scripts/events/event", {
	m = {
		Casualty = null
	},
	function create()
	{
		this.m.ID = "event.fear_undead";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%brother% rozgląda się po ludziach wokół ogniska. Potem przez kilka minut patrzy na ziemię, po czym wybucha.%SPEECH_ON%Czy ja jestem tu jedynym, który jest zdrowy na umyśle? Jak to możliwe, że nikt inny nie traci rozumu przez martwych znów chodzących po ziemi? Co do diabła, gdzie w tym wszystkim są starzy bogowie, oni tylko będą patrzeć na ten pieprzony cyrk?%SPEECH_OFF%Kompania próbuje złagodzić jego lęki, ale on wraca do posępnej ciszy człowieka, który ma zbyt wiele do przemyślenia i nikogo chętnego, by naprawdę słuchać.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To odbija się na ludziach.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Casualty.getImagePath());
				local trait = this.new("scripts/skills/traits/fear_undead_trait");
				_event.m.Casualty.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Casualty.getName() + " teraz boi się nieumarłych"
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
			if (bro.getBackground().getID() == "background.companion" || bro.getBackground().getID() == "background.crusader" || bro.getBackground().getID() == "background.gravedigger" || bro.getBackground().getID() == "background.graverobber" || bro.getBackground().getID() == "background.wildman")
			{
				continue;
			}

			if (bro.getLevel() <= 7 && !bro.getSkills().hasSkill("trait.fear_undead") && !bro.getSkills().hasSkill("trait.hate_undead") && !bro.getSkills().hasSkill("trait.fearless") && !bro.getSkills().hasSkill("trait.brave") && !bro.getSkills().hasSkill("trait.determined") && !bro.getSkills().hasSkill("trait.bloodthirsty"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Casualty = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"brother",
			this.m.Casualty.getName()
		]);
	}

	function onClear()
	{
		this.m.Casualty = null;
	}

});

