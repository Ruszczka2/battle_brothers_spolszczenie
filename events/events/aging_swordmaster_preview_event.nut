this.aging_swordmaster_preview_event <- this.inherit("scripts/events/event", {
	m = {
		Swordmaster = null
	},
	function create()
	{
		this.m.ID = "event.aging_swordmaster_preview";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]Zastajesz %swordmaster% siedzącego na pniaku. Patrzy na okolicę.%SPEECH_ON%Wiesz, jako stary człowiek, który zbyt długo działał w tym fachu zabijania, coś sobie uświadomiłem. Jestem dziś o wiele mądrzejszy. Poznałem tyle, że teraz wiem, czego nie wiem. I patrzę wstecz i myślę, jaki byłem głupi za młodu. A potem pomyślałem o wszystkich ludziach, których zabiłem, zatrzymując ich śmiertelną nić, gdy była młoda i gotowa rozkwitnąć.%SPEECH_OFF%Siadasz i wzruszasz ramionami. On kontynuuje.%SPEECH_ON%Zrozumiałem, że jestem zabójcą mądrości. Że wyciągnąłem z tego świata wielu starych ludzi, a razem z nimi odeszło tyle nauki i wiedzy. Zniszczyłem tak wiele światów. Światów, w których ci ludzie żyli i dalej żyli, i dokonywali wielkich rzeczy, o których nawet nie wiedzieli, że w nich są. Gdyby pierwszy człowiek, z którym walczyłem, zabił mnie, ile istnień by ocalił? Ile mądrości by ocalało? Wybacz, nie chcę się rozwodzić.%SPEECH_OFF%Mężczyzna wstaje, klepiąc swoje chwiejne nogi. Chwytasz go za ramię.%SPEECH_ON%A czy rozważałeś, że mogłeś też ocalić światy? Że niektórzy z tych, których zabiłeś, mogliby żyć dalej i stać się potwornymi bestiami?%SPEECH_OFF%Uśmiecha się, ale wiesz, że już to przemyślał i nie chce cię niepokoić odpowiedzią. Po prostu kiwa głową, po czym odchodzi do reszty kompanii.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mam nadzieję, że mu się poprawi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				_event.m.Swordmaster.worsenMood(1.0, "Zrozumiał, że się starzeje");

				if (_event.m.Swordmaster.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Swordmaster.getMoodState()],
						text = _event.m.Swordmaster.getName() + this.Const.MoodStateEvent[_event.m.Swordmaster.getMoodState()]
					});
				}

				_event.m.Swordmaster.getFlags().add("aging_preview");
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.swordmaster" && !bro.getFlags().has("aging_preview") && !bro.getSkills().hasSkill("trait.old") && !bro.getFlags().has("IsRejuvinated"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Swordmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = this.m.Swordmaster.getLevel();
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"swordmaster",
			this.m.Swordmaster.getName()
		]);
	}

	function onClear()
	{
		this.m.Swordmaster = null;
	}

});

