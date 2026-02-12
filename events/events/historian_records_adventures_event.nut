this.historian_records_adventures_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null
	},
	function create()
	{
		this.m.ID = "event.historian_records_adventures";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_15.png[/img]Niosąc w dłoniach oprawiony w skórę tom, %historian% wsuwa się do twojego namiotu. Bez słowa kładzie książkę na stole i cofa się o krok. Odkładasz pióro i pytasz, co to jest. Mówi, żebyś ją otworzył. Wzdychając, otwierasz księgę i widzisz strony pełne imion oraz wydarzeń, które dobrze znasz. To historia kompanii i jej przygód. Przerzucasz kartki, widząc dawne opowieści, które grzeją serce, i takie, które je łamią. Zamykasz książkę i przesuwasz ją z powrotem przez stół. Historyk pyta, czy wszystko w porządku, a ty kiwasz głową. Mówisz, by dać ją ludziom do czytania przy ogniskach, bo na pewno podniesie ich na duchu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Czyny %companyname% nie zostaną zapomniane.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) >= 90)
					{
						continue;
					}

					bro.improveMood(1.0, "Proud of the company\'s achievements");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 9 && bro.getBackground().getID() == "background.historian")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Historian = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Historian = null;
	}

});

