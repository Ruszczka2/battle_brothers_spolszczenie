this.fat_guy_gets_fit_event <- this.inherit("scripts/events/event", {
	m = {
		FatGuy = null
	},
	function create()
	{
		this.m.ID = "event.fat_guy_gets_fit";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_75.png[/img]%fatguy%, niegdyś ociężała bryła tłuszczu na dwóch nogach, znacznie schudł, odkąd jest w kompanii. Sama myśl o sparingu nie odbiera mu już tchu. W rzeczywistości ma więcej sprężystości w kroku i pokazuje zwinność, której nigdy u niego nie widziałeś. Wygląda na to, że to całe wędrowanie zdziałało cuda.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Może jednak zrobi się z niego dobry najemnik.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.FatGuy.getImagePath());
				_event.m.FatGuy.getSkills().removeByID("trait.fat");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_10.png",
						text = _event.m.FatGuy.getName() + " nie jest już gruby"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 5 && bro.getSkills().hasSkill("trait.fat"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.FatGuy = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = candidates.len() * 5;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fatguy",
			this.m.FatGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.FatGuy = null;
	}

});

