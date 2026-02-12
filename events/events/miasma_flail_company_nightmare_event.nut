this.miasma_flail_company_nightmare_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.miasma_flail_company_nightmare";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Śnisz o swojej matce. Od dawna nie widziałeś jej twarzy i sądziłeś, że już ją zapomniałeś, bo świat starł większość wspomnień. Jest tak piękna, jak byś się spodziewał, i przyciąga cię do siebie, dłonią gładząc włosy i splatając w nie palce, a miękki szept jej dotyku miesza się z najłagodniejszymi szmerami. Chwilę później oferuje ci pierś, a ty cofasz się niepewnie, i kiedy podnosisz wzrok, stoi tam Wielki Wróżbita, szczerząc szalony uśmiech.%SPEECH_ON%Bezłonny, wstępuję, najemniku. Wielka karmicielka...%SPEECH_OFF%Mięsisty golem owija czerwone wyrostki wokół jego barków, zaciskając na tobie tłusty uścisk.%SPEECH_ON%Znajdź w mym łonie surową moc tego świata, najemniku! Pozwól mi ukształtować cię w mężczyznę, którym powinieneś był być!%SPEECH_OFF%Z warknięciem wyrywasz się ze snu, zeskakujesz z pryczy i uderzasz o ziemię, łapiąc powietrze i okładając się po twarzy, jakby to, co śniłeś, wróciło z tobą. Reszta kompanii jest w podobnym stanie rozsypki, każdy najemnik doświadczył tego samego koszmaru. Zerkasz do ekwipunku i widzisz cep Wielkiego Wróżbity, który iskrzy jaskrawozielonym blaskiem, po czym znika z twojego spojrzenia, a za nim podąża ledwie słyszalny chichot...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Matkojebca.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.worsenMood(0.75, "Miał niepokojący koszmar z udziałem Wielkiego Wróżbity");

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

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local haveFlail = false;

		foreach( bro in brothers )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && item.getID() == "weapon.miasma_flail")
			{
				haveFlail = true;
			}
		}

		if (!haveFlail)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && item.getID() == "weapon.miasma_flail")
				{
					haveFlail = true;
					break;
				}
			}
		}

		if (!haveFlail)
		{
			return;
		}

		this.m.Score = 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

