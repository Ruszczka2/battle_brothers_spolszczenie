this.shortsighted_shoots_bro_event <- this.inherit("scripts/events/event", {
	m = {
		Shortsighted = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.shortsighted_shoots_bro";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_10.png[/img]Przyglądasz się mężczyznom długim, uważnym spojrzeniem, przenosząc wzrok z jednego na drugiego i z powrotem, cały czas kręcąc głową. %shortsightedtarget% trzyma się za głowę, a na linii włosów rośnie spory guz. Patrzy na %shortsighted%, potem na ciebie. Obaj wzruszają ramionami. Pytasz %shortsighted%, co się stało. Wyjaśnia.%SPEECH_ON%Myślałem, że widzę coś, czego nie było.%SPEECH_OFF%%shortsightedtarget% wyrzuca rękę w geście niedowierzania.%SPEECH_ON%Powiedziałem: \'Hej, to ja\', a ty i tak mnie zdzieliłeś.%SPEECH_OFF%%shortsighted% rozkłada ręce i się broni.%SPEECH_ON%\'Hej, to ja\' nie są słowa zarezerwowane dla ciebie! Każdy może je powiedzieć! I powiem ci, że każdy o złej woli właśnie tych słów użyłby, zanim dołożyłby ci mieczem, na pewno!%SPEECH_OFF%Wygląda na to, że słaby wzrok %shortsighted% doprowadził do pewnego wypadku.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech ktoś obejrzy tę ranę, %shortsightedtargetshort%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Shortsighted.getImagePath());
				this.Characters.push(_event.m.OtherGuy.getImagePath());
				local injury = _event.m.OtherGuy.addInjury(this.Const.Injury.PiercingBody, 0.4);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.OtherGuy.getName() + " doznaje " + injury.getNameOnly()
				});
				_event.m.Shortsighted.worsenMood(1.0, "Przypadkowo postrzelił " + _event.m.OtherGuy.getName());
				_event.m.OtherGuy.worsenMood(1.0, "Został postrzelony przez " + _event.m.Shortsighted.getName());

				if (_event.m.OtherGuy.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.OtherGuy.getMoodState()],
						text = _event.m.OtherGuy.getName() + this.Const.MoodStateEvent[_event.m.OtherGuy.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_shortsighted = [];

		foreach( bro in brothers )
		{
			if (!bro.getBackground().isNoble() && bro.getSkills().hasSkill("trait.short_sighted") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates_shortsighted.push(bro);
			}
		}

		if (candidates_shortsighted.len() == 0)
		{
			return;
		}

		this.m.Shortsighted = candidates_shortsighted[this.Math.rand(0, candidates_shortsighted.len() - 1)];
		this.m.Score = candidates_shortsighted.len() * 5;

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Shortsighted.getID() && bro.getBackground().getID() != "background.slave")
			{
				this.m.OtherGuy = bro;
				break;
			}
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"shortsighted",
			this.m.Shortsighted.getName()
		]);
		_vars.push([
			"shortsightedtarget",
			this.m.OtherGuy.getName()
		]);
		_vars.push([
			"shortsightedtargetshort",
			this.m.OtherGuy.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Shortsighted = null;
		this.m.OtherGuy = null;
	}

});

