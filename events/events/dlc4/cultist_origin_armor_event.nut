this.cultist_origin_armor_event <- this.inherit("scripts/events/event", {
	m = {
		Tailor = null
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_armor";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 15.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_03.png[/img]{%randomcultist% ogarnia nagła pilność. Wstaje, odsuwa się od ogniska kompanii, przechodzi przez obóz i chowa się do swojego namiotu. Tam widzisz go przy pracy, jego sylwetka i cienie poruszają się gorączkowo. I jest tam coś więcej niż tylko on: nieznane kształty pojawiają się i znikają obok niego, wznosząc się w czarnych słupach, macki ciemności smagają i wiją się, by dorównać energii jego własnego pochodu. Potem kończy, a jego sylwetka pochyla się do przodu i wyciąga coś na światło.\n\nWychodzi z namiotu z takim samym pośpiechem, z jakim wszedł, ale tym razem trzyma w ręku skórzaną zbroję na pierś. Rzuca ją na ziemię.%SPEECH_ON%On na nas wszystkich czeka, bracia.%SPEECH_OFF%Napierśnik ma wyjątkowe nacięcia ułożone w pasy, które dla niewierzącego oka byłyby bez znaczenia. Dla ciebie to po prostu język Davkula.}",
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
					if (item != null && (item.getID() == "armor.body.padded_leather" || item.getID() == "armor.body.padded_surcoat" || item.getID() == "armor.body.rugged_surcoat" || item.getID() == "armor.body.thick_tunic" || item.getID() == "armor.body.blotched_gambeson"))
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

				local item = this.new("scripts/items/armor/cultist_leather_robe");
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
			if (item != null && (item.getID() == "armor.body.padded_leather" || item.getID() == "armor.body.padded_surcoat" || item.getID() == "armor.body.rugged_surcoat" || item.getID() == "armor.body.thick_tunic" || item.getID() == "armor.body.blotched_gambeson"))
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

