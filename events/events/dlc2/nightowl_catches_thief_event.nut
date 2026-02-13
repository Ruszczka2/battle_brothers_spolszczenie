this.nightowl_catches_thief_event <- this.inherit("scripts/events/event", {
	m = {
		NightOwl = null,
		FoundItem = null
	},
	function create()
	{
		this.m.ID = "event.nightowl_catches_thief";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Budząc się z dziwnego snu, wychodzisz z namiotu i widzisz, że większość kompanii śpi, poza nocnym markiem %nightowl%. Stoi na skraju obozu, odwrócony plecami, ale najwyraźniej słyszy, że podchodzisz, i mówi bez odwracania się.%SPEECH_ON%Tak to się zaczyna, panie. Wściekłość. Gorączka. Co zmienia dobrych ludzi, hoooo.%SPEECH_OFF%Odwraca się, by pokazać prawdziwą sowę, którą złapał. Jej powieki są przymknięte, pewnie zmęczona ucieczką i teraz po prostu upokorzona, że ją schwytano bez żadnego drapieżnego powodu. Pytasz %nightowl%, jak do diabła ją złapał. Najemnik wypuszcza ptaka i wzrusza ramionami.%SPEECH_ON%Rękami. Złapałem też to.%SPEECH_OFF%Kuca i wyciąga dotąd niewidziane zwłoki.%SPEECH_ON%Zwinny mały złodziejaszek. Napatoczyłem się na niego, eee, że tak powiem, robił nam upust na towarze. Byłem trochę zbyt zmęczony, by gadać, więc pozwoliłem mojemu ostrzu powiedzieć mu, że sklep jest zamknięty. Potem poszedłem jego śladami tam, skąd przyszedł, i znalazłem jego, eee, nazwijmy to ekwipunek.%SPEECH_OFF%Kiwasz głową. Jasne. Oczywiście. Mówisz mu, że wracasz spać, a rano osądzisz jego postępowanie. On także kiwa głową.%SPEECH_ON%Tak jest, panie. Spróbuję sam trochę odpocząć. Minęło parę dni. A może tygodni?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wypocznij dobrze.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.NightOwl.getImagePath());
				_event.m.NightOwl.improveMood(1.0, "Złapał złodzieja w nocy");

				if (_event.m.NightOwl.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.NightOwl.getMoodState()],
						text = _event.m.NightOwl.getName() + this.Const.MoodStateEvent[_event.m.NightOwl.getMoodState()]
					});
				}

				local trait = this.new("scripts/skills/effects_world/exhausted_effect");
				_event.m.NightOwl.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.NightOwl.getName() + " jest wyczerpany"
				});
				local money = this.Math.rand(100, 300);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Koron"
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

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
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
			if (bro.getLevel() >= 3 && bro.getSkills().hasSkill("trait.night_owl"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NightOwl = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"nightowl",
			this.m.NightOwl.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.NightOwl = null;
		this.m.FoundItem = null;
	}

});

