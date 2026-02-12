this.ratcatcher_crafts_net_event <- this.inherit("scripts/events/event", {
	m = {
		Ratcatcher = null
	},
	function create()
	{
		this.m.ID = "event.ratcatcher_crafts_net";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Natrafiasz na %ratcatcher% siedzącego z rękami pełnymi liny. Tak zaciekle ją zapętla - jak tylko linę da się zapętlać - że boisz się postawić stopę zbyt blisko. Ciekawy pytasz go, co robi. Jakby właśnie na to pytanie czekał, szybko unosi swoje dzieło i ogłasza, że zrobił sieć. Ach! Kładziesz dłonie na biodrach.%SPEECH_ON%To będzie świetne na polu bitwy!%SPEECH_OFF%Szczurołap zaciska usta. Powoli opuszcza sieć.%SPEECH_ON%Och, miałem na myśli... żeby jej użyć... do złapania szczura...%SPEECH_OFF%Zawiesza głos, po czym zadziera głowę, a na twarzy pojawia się figlarny, jeśli nie kiczowaty uśmiech.%SPEECH_ON%Ale użyję jej na polu bitwy! Żaden szczur, człowiek, futrzak ani to, co się skrada, nie wymknie mi się!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bardzo dobrze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
				local item = this.new("scripts/items/tools/throwing_net");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.ratcatcher")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Ratcatcher = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Ratcatcher = null;
	}

});

