this.no_food_variety_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.no_food_variety";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_52.png[/img]{Zastajesz najemników zebranych wokół ogniska, ale nie mają prawdziwego jedzenia do położenia nad płomieniami. Jeden rzuca miskę zupy na ziemię. To taka breja, że ledwie się rozlewa, co, szczerze mówiąc, jest obrzydliwe. %randombrother% patrzy na ciebie.%SPEECH_ON%Panie, prosimy, pozwól nam zdobyć trochę mięsa! Albo cokolwiek ponad to gówno!%SPEECH_OFF%Zgadzasz się, że trochę różnorodności by nie zaszkodziło. | %randombrother% podchodzi do ciebie i uderza łyżką w twój stół. Na łyżce coś jest, ale nie potrafisz stwierdzić, co dokładnie. Najemnik odchyla się, wtyka kciuki za pas, pierś unosi mu się wraz z oddechem. Potem wzdycha, bo wie, że nie powinien zachowywać się tak niegrzecznie w twojej obecności. Ale wyjaśnia się.%SPEECH_ON%Panie, ludzie narzekają na jedzenie. Myślę, że byłoby dobrze dla morale, gdybyśmy w następnym mieście kupili trochę mięsa i innych rzeczy. To tylko sugestia, oczywiście.%SPEECH_OFF%Szybko odchodzi. Podnosisz łyżkę i patrzysz na to, co w niej jest. To... to naprawdę nie może być to, co oni tam jedzą, prawda? Może trochę różnorodności nie zaszkodzi... | %randombrother% podchodzi z miską w dłoniach. Przechyla ją, pokazując zawartość, która jest bezbarwna i bardzo powoli spływa po krawędzi. Najemnik kręci głową.%SPEECH_ON%Ludzie są niezadowoleni, panie, i ja również, z obiadów, które jemy. Człowiek może jeść to samo dzień po dniu tylko przez jakiś czas, zwłaszcza gdy wie, że stać go na coś więcej. To tylko sugestia, panie, ode mnie i od wszystkich ludzi, żebyśmy ożywili zapasy, by nie każdy posiłek był... no, taki.%SPEECH_OFF%Stawia miskę i odchodzi. | Kilku twoich najemników narzeka przy ognisku. Trzymasz się w pobliżu, uważnie słuchając, bo mogą mówić rzeczy, których nie powiedzieliby w twojej obecności. Na szczęście to nie bunt, lecz seria kulinarnych uwag. W zapasach brakuje różnorodności. Są zmęczeni jedzeniem w kółko tego samego. Może da się to naprawić w następnym mieście, które odwiedzi %companyname%?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cóż, ciasta nie dostaną.",
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
					if (bro.getBackground().isLowborn() || bro.getSkills().hasSkill("trait.spartan"))
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.gluttonous"))
					{
						bro.worsenMood(1.0, "Jadł przez wiele dni tylko zmielone ziarna");
					}
					else
					{
						bro.worsenMood(0.5, "Jadł przez wiele dni tylko zmielone ziarna");
					}

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
		if (this.World.getTime().Days < 5)
		{
			return;
		}

		if (this.World.State.getEscortedEntity() != null)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local hasBros = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().isLowborn() || bro.getSkills().hasSkill("trait.spartan"))
			{
				continue;
			}

			hasBros = true;
			break;
		}

		if (!hasBros)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local hasOtherFood = false;

		foreach( item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (item.getID() != "supplies.ground_grains")
				{
					hasOtherFood = true;
					break;
				}
			}
		}

		if (hasOtherFood)
		{
			return;
		}

		this.m.Score = 10;
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

