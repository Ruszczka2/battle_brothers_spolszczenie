this.gladiators_food_event <- this.inherit("scripts/events/event", {
	m = {
		Gladiator = null
	},
	function create()
	{
		this.m.ID = "event.gladiators_food";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_155.png[/img]{Gladiatorzy domagają się lepszego jedzenia.%SPEECH_ON%Przepraszam, \'kapitanie\', ale co mam z tym zrobić?%SPEECH_OFF%%gl% unosi bochenek chleba.%SPEECH_ON%Gdzie mięso? Popatrz. POPATRZ. Na to. Kto to zrobił? Piekarz? Chcesz, żebym jadł bochenek piekarza? Chcę jeść to, co się broni. Czy chleb się broni? Nie sądzę.%SPEECH_OFF%Wygląda na to, że gladiatorzy są daleko od areny, ale nie od rozpieszczania, jakie kucharze tam okazywali dzień w dzień. Być może powinieneś poszukać różnorodnego, wysokiej jakości jedzenia, by ich uspokoić. | %SPEECH_START%Gdzie jest dobre żarcie, co?%SPEECH_OFF%%gl% unosi kawałek posiłku. Jest włóknisty i zwisa w jego dłoni.%SPEECH_ON%To nie jest jedzenie gladiatorów, to jedzenie mięczaków!%SPEECH_OFF%Odwraca się i rzuca jedzeniem, które uderza o bok wozu kompanii, odkleja się i zwisa jak odwrócony hak.%SPEECH_ON%Żądamy dobrego jedzenia, kapitanie! Żadnego tego łowieckiego dziadostwa.%SPEECH_OFF%Pewnie powinieneś zadbać o jedzenie dla gladiatorów, bardziej zgodne z ich standardami. | %SPEECH_START%Gdzie wino? Gdzie delikatesy!%SPEECH_OFF%%gl% bierze talerz z jedzeniem i rzuca nim jak dyskiem. Leci imponująco daleko, a kawałki jedzenia rozpryskują się w stożku kalorycznych odpadków.%SPEECH_ON%Żądam delikatesów, kapitanie! Gdzie są moje delikatesy?%SPEECH_OFF%Wygląda na to, że gladiatorzy wymagają jedzenia wyższej jakości.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Już kosztujecie mnie fortunę!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.gladiator" && bro.getFlags().get("IsPlayerCharacter"))
					{
						bro.worsenMood(1.5, "Domaga się lepszego jedzenia");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.gladiators")
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local hasExquisiteFood = false;

		foreach( item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (item.getRawValue() >= 85)
				{
					hasExquisiteFood = true;
					break;
				}
			}
		}

		if (hasExquisiteFood)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gladiator" && bro.getFlags().get("IsPlayerCharacter"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Gladiator = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 40;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gl",
			this.m.Gladiator != null ? this.m.Gladiator.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Gladiator = null;
	}

});

