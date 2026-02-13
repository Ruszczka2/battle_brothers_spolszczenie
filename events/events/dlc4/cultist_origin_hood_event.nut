this.cultist_origin_hood_event <- this.inherit("scripts/events/event", {
	m = {
		Tailor = null
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_hood";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 15.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_03.png[/img]{%randomcultist%, jeden z twoich wyznawców, wchodzi do twojego namiotu i równie szybko wychodzi. Wstajesz, by zobaczyć, dokąd poszedł, ale znajdujesz na stole skórzany półhełm. Skóra jest zszyta włosami nieznanego pochodzenia i ściśnięta czymś, co wygląda jak haki i paznokcie. Otwory hełmu są zupełnie czarne, i masz wrażenie, że nawet gdybyś je wypełnił, ciemność nigdy by nie odeszła. Wpatrując się w te puste oczodoły, wiesz, że coś patrzy z powrotem. Kiwasz głową z aprobatą.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Davkul czeka.",
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

				foreach( i, item in stash )
				{
					if (item != null && (item.getID() == "armor.head.hood" || item.getID() == "armor.head.aketon_cap" || item.getID() == "armor.head.open_leather_cap" || item.getID() == "armor.head.full_aketon_cap" || item.getID() == "armor.head.full_leather_cap"))
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Tracisz " + item.getName()
						});
						break;
					}
				}

				local item = this.new("scripts/items/helmets/cultist_leather_hood");
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
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local numItems = 0;

		foreach( item in stash )
		{
			if (item != null && (item.getID() == "armor.head.hood" || item.getID() == "armor.head.aketon_cap" || item.getID() == "armor.head.open_leather_cap" || item.getID() == "armor.head.full_aketon_cap" || item.getID() == "armor.head.full_leather_cap"))
			{
				numItems = ++numItems;
			}
		}

		if (numItems == 0)
		{
			return;
		}

		this.m.Tailor = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = numItems * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"randomcultist",
			this.m.Tailor.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Tailor = null;
	}

});

