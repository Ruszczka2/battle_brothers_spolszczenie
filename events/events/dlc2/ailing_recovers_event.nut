this.ailing_recovers_event <- this.inherit("scripts/events/event", {
	m = {
		Ailing = null,
		Healer = null
	},
	function create()
	{
		this.m.ID = "event.ailing_recovers";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 75.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%ailing% przechadza się po obozie z wyciągniętymi rękami i rozprostowanymi palcami, jakby balansował na linie. Kiwając do siebie głową, zawraca, stawiając stopę przed stopą, i maszeruje z powrotem.%SPEECH_ON%Po raz pierwszy od dawna czuję się naprawdę dobrze. Dzięki, %healer%!%SPEECH_OFF%Wygląda na to, że %healer% znał parę sposobów na pozbycie się tego, co dolegało %ailing%owi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Miło słyszeć.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Ailing.getImagePath());
				this.Characters.push(_event.m.Healer.getImagePath());
				_event.m.Ailing.improveMood(1.5, "Czuje się najlepiej od długiego czasu");

				if (_event.m.Ailing.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Ailing.getMoodState()],
						text = _event.m.Ailing.getName() + this.Const.MoodStateEvent[_event.m.Ailing.getMoodState()]
					});
				}

				_event.m.Ailing.getSkills().removeByID("trait.ailing");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_59.png",
					text = _event.m.Ailing.getName() + " nie jest już schorowany"
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

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_ailing = [];
		local candidates_healer = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() < 4)
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.ailing"))
			{
				candidates_ailing.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_healer.push(bro);
			}
		}

		if (candidates_ailing.len() == 0 || candidates_healer.len() == 0)
		{
			return;
		}

		this.m.Ailing = candidates_ailing[this.Math.rand(0, candidates_ailing.len() - 1)];
		this.m.Healer = candidates_healer[this.Math.rand(0, candidates_healer.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"ailing",
			this.m.Ailing.getName()
		]);
		_vars.push([
			"healer",
			this.m.Healer.getName()
		]);
	}

	function onClear()
	{
		this.m.Ailing = null;
		this.m.Healer = null;
	}

});

