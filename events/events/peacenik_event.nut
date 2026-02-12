this.peacenik_event <- this.inherit("scripts/events/event", {
	m = {
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.peacenik";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_40.png[/img]Na trakcie spotykasz człowieka wpatrzonego w dziurę w ziemi. Naturalnie podchodzisz i pytasz, co robi. Odpowiada, że w dole jest ork. Spoglądasz w dół. Jest. Wyciągasz miecz i pytasz, czy masz się nim zająć. Mężczyzna cofa się.%SPEECH_ON%Co? Nie! Chcę go żywego. Myślę, że możemy spróbować go zrozumieć.%SPEECH_OFF%Zrozumieć go? O czym on w ogóle mówi? Błaga.%SPEECH_ON%Spróbujmy choć raz! Każdy zabija orka na miejscu, ale to nie są zwykłe zwierzęta. Okazują inteligencję, a jeśli mają inteligencję, to mogą się uczyć, a jeśli mogą się uczyć, to może nauczą się współistnieć z nami.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Psy też są bystre, ale co robimy z tymi złymi?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Jasne. Powodzenia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_40.png[/img]%houndmaster% psiarz kiwa głową i wyjaśnia, że zwierzę, bez względu na inteligencję czy tresurę, wciąż jest zwierzęciem. Pacyfista chwilę się zastanawia.%SPEECH_ON%T-to nie jest zwykły pies!%SPEECH_OFF%Twój psiarz kładzie mu dłoń na ramieniu.%SPEECH_ON%Ale zagoniłeś go w róg jak psa, prawda? Co by zrobił człowiek w tej sytuacji, z całą swoją inteligencją i mądrością, z plecami przy ścianie i wrogami dookoła? To nie miejsce ani czas na \"pokój\", przyjacielu, czy to z człowiekiem, czy z bestią.%SPEECH_OFF%Nieznajomy powoli zaczyna kiwać głową. Widzi sens argumentu i na szczęście pozwala ci zabić orka bez żadnych incydentów. Gdy zielonoskóry jest już po wszystkim, mężczyzna wręcza ci sakiewkę koron.%SPEECH_ON%Chciałem spróbować pertraktować z nim za pomocą tych. To już się nie wydarzy, widać, i pewnie byłbym martwy, gdybyś się nie pojawił. Uznaj to za moje podziękowanie, najemniku.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bardzo doceniam.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				this.World.Assets.addMoney(50);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]50[/color] koron"
				});
				_event.m.Houndmaster.getBaseProperties().Bravery += 1;
				_event.m.Houndmaster.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Houndmaster.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinacji"
				});
				_event.m.Houndmaster.improveMood(1.0, "Wygłosił wykład o naturze zwierząt");
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

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.houndmaster")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Houndmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
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

