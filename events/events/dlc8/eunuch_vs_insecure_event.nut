this.eunuch_vs_insecure_event <- this.inherit("scripts/events/event", {
	m = {
		Eunuch = null,
		Insecure = null
	},
	function create()
	{
		this.m.ID = "event.eunuch_vs_insecure";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%eunuch% eunuch i %insecure%, raczej oczywiście niepewny siebie najemnik, siedzą i rozmawiają. Eunuch kręci głową.%SPEECH_ON%Twoja nieśmiałość nie ma dla mnie sensu, %insecure%. Spójrz na mnie. Nie mam nawet jedynego powodu, by żyć jak mężczyzna. Gdy wiatr wieje w moje spodnie, czuję tylko materiał na wewnętrznej stronie uda. Masz pojęcie, jak okropnie to dziwnie jest? A widzisz, żebym narzekał? Nie. Gdy połowa kompanii idzie do burdelu i gniecie dziwkę, widzisz mnie siedzącego w kącie i płaczącego? Oczywiście, że nie!%SPEECH_OFF%%insecure% przytakuje.%SPEECH_ON%Wiesz co, ty bezjajeczny skurczybyku, masz rację. Skoro ty możesz uderzać w powietrze i być z tego zadowolony, to ja mogę nie być tak przestraszony i mały.%SPEECH_OFF%Niepewny najemnik wstaje i odchodzi. %eunuch% zaciska usta.%SPEECH_ON%Uderzać w powietrze? Czy ten głupi dureń powiedział, że uderzam w powietrze? Hej, hej! Uderzę jego matkę!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie pozwól, by jego niepewność na ciebie przeszła, %eunuch%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Insecure.getImagePath());
				this.Characters.push(_event.m.Eunuch.getImagePath());
				_event.m.Insecure.getSkills().removeByID("trait.insecure");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_03.png",
						text = _event.m.Insecure.getName() + " nie jest już Niepewny siebie"
					}
				];
				_event.m.Eunuch.worsenMood(1.0, "Okazano mu brak szacunku");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Eunuch.getMoodState()],
					text = _event.m.Eunuch.getName() + this.Const.MoodStateEvent[_event.m.Eunuch.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local eunuch_candidates = [];
		local insecure_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() != "background.eunuch" && bro.getSkills().hasSkill("trait.insecure"))
			{
				insecure_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.eunuch" && bro.getLevel() >= 4 && !bro.getSkills().hasSkill("trait.insecure"))
			{
				eunuch_candidates.push(bro);
			}
		}

		if (insecure_candidates.len() == 0 || eunuch_candidates.len() == 0)
		{
			return;
		}

		this.m.Eunuch = eunuch_candidates[this.Math.rand(0, eunuch_candidates.len() - 1)];
		this.m.Insecure = insecure_candidates[this.Math.rand(0, insecure_candidates.len() - 1)];
		this.m.Score = 5 * insecure_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"eunuch",
			this.m.Eunuch.getNameOnly()
		]);
		_vars.push([
			"insecure",
			this.m.Insecure.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Eunuch = null;
		this.m.Insecure = null;
	}

});

