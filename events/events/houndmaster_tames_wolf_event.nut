this.houndmaster_tames_wolf_event <- this.inherit("scripts/events/event", {
	m = {
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.houndmaster_tames_wolf";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]Podczas wędrówki przez śnieżne pustkowia północy królestwa %houndmaster%, psiarz, zaprzyjaźnił się ze stworzeniem, które podążało za marszem kompanii: wilkiem. Psiarz często pozostawał na ariergardzie, przykucnięty nisko, z rękami przy bokach, wpatrzony w samotnego wilka przez długie minuty. Ale dziś, używając resztek mięsa, zwabił bestię prosto do środka obozu. Teraz przykuca obok niej, przytłoczony jej wyraźnym, umięśnionym kłębem, spiczastymi i czujnymi uszami oraz dyszącą paszczą pełną morderczych kłów.\n\n Reszta ludzi stoi za bronią. Jeden krzyczy na psiarza, by przestał. Drugi mówi, że wilk wyczuwa strach. Jeszcze inny rzuca w niego kamieniem. Wilk wzdryga się, ale nie reaguje. Śmiejąc się, psiarz syczy \'tssst!\' i wskazuje. Wilk rusza do przodu, podnosi kamień i przynosi go mężczyźnie. Pieszczy grzywę bestii.%SPEECH_ON%Widzicie? Łatwo się go szkoli, jak każdego psa. Tylko większy, szybszy i silniejszy. I mądrzejszy.%SPEECH_OFF%Jego oczy spotykają się z twoimi. Wilk kładzie się nisko, niemal jak człowiek składający pokłon. %houndmaster% znów się śmieje.%SPEECH_ON%Widzicie? Już wie, kto jest alfą tej watahy.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Szlachetne zwierzę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				local item = this.new("scripts/items/accessory/wolf_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				_event.m.Houndmaster.improveMood(2.0, "Managed to tame a wolf");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Houndmaster.getMoodState()],
					text = _event.m.Houndmaster.getName() + this.Const.MoodStateEvent[_event.m.Houndmaster.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 5 && bro.getBackground().getID() == "background.houndmaster")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Houndmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"houndmaster",
			this.m.Houndmaster.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Houndmaster = null;
	}

});

