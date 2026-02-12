this.running_around_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.running_around";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Chodzenie, bieganie, walczenie, rżnięcie - wszystko dobre dla męskiego serca. Czas spędzony w drodze poprawił witalność i krzepę ludzi. Przyłapałeś nawet jednego z bardziej bezczelnych najemników, jak pręży się nad wodą w stawie, podziwiając swoje odbicie niczym uśmiechnięta dziewka. | To całe bieganie po świecie zwiększyło wytrzymałość ludzi. Jeden biegnie w miejscu, trzymając palec na szyi. Mówi, że tętno wcale mu nie rośnie. Inny brat zauważa, że ten gość nawet nie umie liczyć. Biegacz zatrzymuje się.%SPEECH_ON%Och. Racja.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To wszystko jest tego warte.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local bro = _event.m.Dude;
				this.Characters.push(bro.getImagePath());
				local stamina = this.Math.rand(1, 1);
				bro.getBaseProperties().Stamina += stamina;
				bro.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/fatigue.png",
					text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] Maks. zmęczenia"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		this.m.Dude = brothers[this.Math.rand(0, brothers.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

