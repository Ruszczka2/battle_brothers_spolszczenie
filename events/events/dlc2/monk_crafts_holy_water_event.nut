this.monk_crafts_holy_water_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.monk_crafts_holy_water";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%monk%, skromny mnich, wchodzi do twojego namiotu z fiolką w dłoni. Naczynie jest zamknięte korkiem z kory, a pod wieńcem zieleni zwisają jagody. Wewnątrz fiolki chlupocze złotawy płyn. Czymkolwiek jest, łapie każdy promień światła i zdaje się go więzić, wirując w środku. Podaje ją.%SPEECH_ON%Woda święcona, panie, do walki z martwymi, którzy znów chodzą.%SPEECH_OFF%Pytasz, czy to dar starych bogów. Kiwa głową. Pytasz, czy to naprawdę dar starych bogów. Zaciska usta.%SPEECH_ON%Nie, nie do końca. Monastyry wiedzą, jak ją zrobić, ale to starożytna receptura chroniona pod karą śmierci.%SPEECH_OFF%Oczywiście. Dziękujesz mu za podjęcie takiego ryzyka i każesz włożyć ją do zapasów.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nawet święci ludzie mają swoje sztuczki.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local item = this.new("scripts/items/tools/holy_water_item");
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_monk = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				candidates_monk.push(bro);
			}
		}

		if (candidates_monk.len() == 0)
		{
			return;
		}

		this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Monk = null;
	}

});

