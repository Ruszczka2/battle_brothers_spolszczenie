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
			Text = "[img]gfx/ui/events/event_26.png[/img]{%eunuch% eunuch i %insecure%, raczej oczywiscie niepewny siebie najemnik, siedza i rozmawiaja. Eunuch kreci glowa.%SPEECH_ON%Twoja niesmialosc nie ma dla mnie sensu, %insecure%. Spójrz na mnie. Nie mam nawet jedynego powodu, by zyc jak mezczyzna. Gdy wiatr wieje w moje spodnie, czuje tylko material na wewnetrznej stronie uda. Masz pojecie, jak okropnie to dziwnie jest? A widzisz, zebym narzekal? Nie. Gdy polowa kompanii idzie do burdelu i gniecie dziwke, widzisz mnie siedzacego w kacie i placzacego? Oczywiscie, ze nie!%SPEECH_OFF%%insecure% przytakuje.%SPEECH_ON%Wiesz co, ty bezjajeczny skurczybyku, masz racje. Skoro ty mozesz uderzac w powietrze i byc z tego zadowolony, to ja moge nie byc tak przestraszony i maly.%SPEECH_OFF%Niepewny najemnik wstaje i odchodzi. %eunuch% zaciska usta.%SPEECH_ON%Uderzac w powietrze? Czy ten glupi dureń powiedzial, ze uderzam w powietrze? Hej, hej! Uderze jego matke!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie pozwol, by jego niepewnosc na ciebie przeszla, %eunuch%.",
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
						text = _event.m.Insecure.getName() + " nie jest juz Niepewny siebie"
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

