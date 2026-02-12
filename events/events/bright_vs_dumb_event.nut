this.bright_vs_dumb_event <- this.inherit("scripts/events/event", {
	m = {
		Dumb = null,
		Bright = null
	},
	function create()
	{
		this.m.ID = "event.bright_vs_dumb";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_15.png[/img]%dumb% jest chyba jedną z najgłupszych osób, jakie spotkałeś, ale przez krótką chwilę wydaje się, że %bright% naprawdę do niego dociera i uczy go czegoś o krytycznym myśleniu i zapamiętywaniu. Patrzysz, jak obaj siedzą razem i przeglądają zwoje. Nie wiesz, skąd mądry człowiek wziął te papiery, ale niewykształcony osiłek z pewnością uważnie im się przygląda.\n\nGdy obserwujesz, %dumb% zadaje dość głębokie, poważne pytania. Pytania o ziemię i jej związek z ludźmi oraz o niebo i jego związek z ptakami. Powoli uświadamiasz sobie, że idiota po prostu rozgląda się i opisuje to, co widzi, używając \'dociekliwego\' języka, którego nauczył go %bright% - a dokładnie dodając do końca każdego zdania pytanie wypowiedziane z mędrkującą intonacją. Kiedy kończą, %bright% podchodzi do ciebie z uśmiechem.%SPEECH_ON%Myślę, że naprawdę coś z nim robimy. Uczy się, wiesz? Z takimi uczniami wystarczy cierpliwość i czas.%SPEECH_OFF%Nieopodal %dumb% tłucze mrówki kamieniem. Po prostu kiwasz głową i pozwalasz %bright% spełniać największą fantazję każdego nauczyciela.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "W końcu do niego dotarłeś.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bright.getImagePath());
				this.Characters.push(_event.m.Dumb.getImagePath());
				_event.m.Bright.improveMood(1.0, "Nauczył " + _event.m.Dumb.getName() + " czegoś");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Bright.getMoodState()],
					text = _event.m.Bright.getName() + this.Const.MoodStateEvent[_event.m.Bright.getMoodState()]
				});
				_event.m.Dumb.improveMood(1.0, "Zacieśnił więź z " + _event.m.Bright.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Dumb.getMoodState()],
					text = _event.m.Dumb.getName() + this.Const.MoodStateEvent[_event.m.Dumb.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local dumb_candidates = [];
		local bright_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.dumb"))
			{
				dumb_candidates.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.bright"))
			{
				bright_candidates.push(bro);
			}
		}

		if (dumb_candidates.len() == 0 || bright_candidates.len() == 0)
		{
			return;
		}

		this.m.Dumb = dumb_candidates[this.Math.rand(0, dumb_candidates.len() - 1)];
		this.m.Bright = bright_candidates[this.Math.rand(0, bright_candidates.len() - 1)];
		this.m.Score = (dumb_candidates.len() + bright_candidates.len()) * 2;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dumb",
			this.m.Dumb.getName()
		]);
		_vars.push([
			"dumb_short",
			this.m.Dumb.getNameOnly()
		]);
		_vars.push([
			"bright",
			this.m.Bright.getName()
		]);
		_vars.push([
			"bright_short",
			this.m.Bright.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dumb = null;
		this.m.Bright = null;
	}

});

