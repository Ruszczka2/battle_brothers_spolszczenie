this.tailor_werewolf_hide_armor_event <- this.inherit("scripts/events/event", {
	m = {
		Tailor = null
	},
	function create()
	{
		this.m.ID = "event.tailor_werewolf_hide_armor";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Gdy zastanawiasz się, dokąd i kiedy ruszyć, krawiec %tailor% wchodzi do twojego namiotu, niosąc na wyciągniętych ramionach coś ciemnego i ciężkiego. Cofasz się o krok, widząc coś na kształt pazurów albo innego podobnego tworu, który błyszczy w świetle świec.\n\nKrawiec wyjaśnia, że zrobił pancerz zszyty ze skóry wilków strasznych. Kładzie go na stole, gdzie kilka pozostałych pazurów stuka o drewno z zabójczym ciężarem. Rozkłada zbroję i pokazuje ją w całości - upiorne coś z czerni i zaostrzonych kości, istota pozbawiona wnętrzności, zostawiona, by wypełnił ją człowiek lub inne stworzenie szukające ciepła w opróżnionej skórze, z głową bestii uniesioną tak, by patrzeć na przyszłego nosiciela. Całość budzi grozę, bez wątpienia, i każe ci się zastanawiać, kiedy i gdzie krawiec wpadł na ten pomysł.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Straszliwy pancerz do podziwiania.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Tailor.getImagePath());
				local stash = this.World.Assets.getStash().getItems();
				local numPelts = 0;

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.werewolf_pelt")
					{
						numPelts = ++numPelts;
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});

						if (numPelts >= 2)
						{
							break;
						}
					}
				}

				local item = this.new("scripts/items/armor/werewolf_hide_armor");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.tailor")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local numPelts = 0;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.werewolf_pelt")
			{
				numPelts = ++numPelts;

				if (numPelts >= 2)
				{
					break;
				}
			}
		}

		if (numPelts < 2)
		{
			return;
		}

		this.m.Tailor = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = numPelts * candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"tailor",
			this.m.Tailor.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Tailor = null;
	}

});

