this.anatomist_dissects_beetles_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_dissects_beetles";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{Zastajesz %anatomist% kucającego nad kawałkiem kłody. Ma rozłożone trzy chrząszcze. Jeden jest przyszpilony igłą do drewna, a jego małe nogi bezradnie przebierają w powietrzu. Drugi to tylko tułów, nogi odcięte i odłożone obok. Trzeci jest w małej puszce z wodą, dociśnięty kamieniem. %anatomist% kręci głową.%SPEECH_ON%Odporność tych stworzeń jest imponująca. Uszkodzenia fizyczne nie oznaczają zniszczenia tak jak u nas. Weź te trzy: przebity, rozczłonkowany i topiący się. A jednak wszystkie żyją. Ta wydajność to coś niezwykłego, zgadzasz się?%SPEECH_OFF%Jasne. Pytasz, skąd w ogóle wziął te chrząszcze. Wzrusza ramionami.%SPEECH_ON%Pełzają po nas, gdy śpimy. Po prostu nie śpię, żeby złapać je na gorącym uczynku. Tego pod wodą, na przykład, złapałem, gdy dziobał ci otwór ucha.%SPEECH_OFF%Mówisz mu, by kontynuował badania i łapał tyle chrząszczy, ile tylko zdoła.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Muszę zacząć spać w hełmie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.improveMood(1.0, "Zafascynowany chrząszczami");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
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
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Score = 3 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
	}

});

