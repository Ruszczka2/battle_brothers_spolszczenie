this.determined_delivers_peptalk_event <- this.inherit("scripts/events/event", {
	m = {
		Determined = null
	},
	function create()
	{
		this.m.ID = "event.determined_delivers_peptalk";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_58.png[/img]Zaczynasz się martwić, że na ludzi spadło jakieś przygnębienie. Siedzą przy ognisku, bezmyślnie szturchając patykami płomienie. Każda twarz pokazuje utratę kontroli, utratę panowania nad własnym losem. Jeśli człowiek nie wie, czy jutro będzie lepsze od dziś, to jak ma iść dalej? Właśnie gdy masz to skomentować, %determined% wstaje, a nastrój jest tak przybity, że nawet szybki ruch sam w sobie zwraca uwagę kompanii.%SPEECH_ON%Popatrzcie na siebie, banda żałosnych smutasów. Myślicie, że jesteście wyjątkowi? Myślicie, że jako pierwsi czujecie się jak gówno? Nie, oczywiście, że nie. Nie bylibyście też pierwsi, którzy się poddali. Położyli się i nie wstali. To jest łatwe. Tego chce od was świat. Jest już dość skurwysynów, nie potrzeba jeszcze, żeby takie nędzne dupy jak wy wszystko psuły, jeśli nie chcecie brać udziału w tej karze, którą nazywamy życiem.%SPEECH_OFF%Poruszeni tą przemową, widzisz, jak nad kompanią pojawia się iskierka blasku.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ten człowiek ma rację!",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Determined.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_58.png[/img]%determined% ciągnie dalej, niemal wbijając kciuk w swoją pierś.%SPEECH_ON%Nie będę znosił gówna, które oferuje świat. Sprawię, że świat pożałuje, że tu jestem. Nie prosiłem o zaproszenie, więc nie będę grzecznie tańczył na tej pieprzonej imprezie. Do zobaczenia w następnym życiu, chłopaki, a do tego czasu tańczmy w tym!%SPEECH_OFF%Wybucha okrzyk, a ludzie zrywają się na nogi, a euforia wybucha, jakby ziemia trzymała ich wcześniej w kajdanach.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Brawo!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Determined.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getMoodState() <= this.Const.MoodState.Neutral && this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Inspired by " + _event.m.Determined.getNameOnly() + "\'s speech");

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
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getAverageMoodState() >= this.Const.MoodState.Concerned)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getSkills().hasSkill("trait.determined"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Determined = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"determined",
			this.m.Determined.getName()
		]);
	}

	function onClear()
	{
		this.m.Determined = null;
	}

});

