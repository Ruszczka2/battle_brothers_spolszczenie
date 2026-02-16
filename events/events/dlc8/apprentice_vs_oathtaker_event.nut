this.apprentice_vs_oathtaker_event <- this.inherit("scripts/events/event", {
	m = {
		Apprentice = null,
		Oathtaker = null
	},
	function create()
	{
		this.m.ID = "event.apprentice_vs_oathtaker";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%apprentice% uczeń siedzi obok ogniska, gdy %oathtaker% Świętobiorca zaczyna go mierzyć wzrokiem. Uczeń odwzajemnia spojrzenie, wyraźnie zmieszany.%SPEECH_ON%O co chodzi?%SPEECH_OFF%Świętobiorca szczerzy się w uśmiechu.%SPEECH_ON%Młody Anselm, Pierwszy Świętobiorca, był uczniem takim jak ty. Wędrował po ziemiach, szukając wiedzy i odnajdując Ostateczną Ścieżkę. Nawet wyglądasz jak on.%SPEECH_OFF%Uczeń uśmiecha się serdecznie. Wygląda na to, że ta więź z nieżyjącym Świętobiorcą go ośmieliła. Ale według ciebie czaszka Młodego Anselma wcale nie wygląda jak %apprentice%. Nos jest za duży, łuk brwiowy zbyt pofalowany, a zęby Pierwszego Świętobiorcy są nienaganne, podczas gdy %apprentice% wygląda, jakby czyścił je młotem. Ale może %apprentice% będzie wyglądał bardziej odpowiednio, gdy sam stanie się lśniącą czaszką otoczoną opieką nieugiętego kultu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie żebym chciał, żeby do tego doszło.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Oathtaker.getImagePath());
				local resolveBoost = this.Math.rand(1, 3);
				_event.m.Apprentice.getBaseProperties().Bravery += resolveBoost;
				_event.m.Apprentice.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Apprentice.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Determinacji"
				});
				_event.m.Apprentice.getFlags().add("learnedFromOathtaker");
				_event.m.Apprentice.improveMood(1.0, "Uczył się od " + _event.m.Oathtaker.getName());
				_event.m.Oathtaker.improveMood(0.5, "Nauczył " + _event.m.Apprentice.getName() + " czegoś");

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

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local apprentice_candidates = [];
		local teacher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.apprentice" && !bro.getFlags().has("learnedFromOathtaker"))
			{
				apprentice_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.paladin")
			{
				teacher_candidates.push(bro);
			}
		}

		if (apprentice_candidates.len() == 0 || teacher_candidates.len() == 0)
		{
			return;
		}

		this.m.Apprentice = apprentice_candidates[this.Math.rand(0, apprentice_candidates.len() - 1)];
		this.m.Oathtaker = teacher_candidates[this.Math.rand(0, teacher_candidates.len() - 1)];
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
			"oathtaker",
			this.m.Oathtaker.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Apprentice = null;
		this.m.Oathtaker = null;
	}

});

