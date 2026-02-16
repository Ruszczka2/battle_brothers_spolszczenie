this.oathtakers_all_oaths_complete_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.oathtakers_all_oaths_complete";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Ostatnie Śluby Młodego Anselma zostały wypełnione. Świętobiorcy naprawdę zasłużyli na swoje imię! Pozostaje tylko jedno pytanie: co dalej? Nigdy nie byliście pewni, co się stanie, gdy śluby Pierwszego Świętobiorcy zostaną wypełnione, a teraz, gdy to zrobiliście, coś dociera do ciebie i reszty kompanii: trzeba iść dalej. Czemu zawracać teraz? Kto chce wracać do starego, nieprowadzonego życia? Otępiałego i bezwolnego, dryfującego bez celu? Na pewno nie o to chodziło Młodemu Anselmowi, gdy zaczynał Ostateczną Ścieżkę. Mówisz ludziom, że każdy Ślub ma swoje znaczenie, a może to wszystkie Śluby razem tworzą znaczenie własne. Ścieżka Świętobiorcy kończy się wtedy, gdy Świętobiorca tego chce. Patrzysz na grupę ludzi.%SPEECH_ON%Jeśli uważacie się za wolnych od potrzeby Ślubów, proszę, odejdźcie.%SPEECH_OFF%Fala zamyślonych spojrzeń na ziemię przechodzi przez grupę. W końcu jeden podnosi wzrok.%SPEECH_ON%Jest tylko jeden sposób, by wyjść spod przewodnictwa Młodego Anselma, a to dołączyć do niego!%SPEECH_OFF%Grupa wiwatuje. Za Młodego Anselma, za odnalezienie jego szczęki i za zabicie wszystkich Ślubodawców!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Za Młodego Anselma!",
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
					bro.improveMood(2.0, "Ukończył wszystkie śluby Młodego Anselma");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}

					bro.getBaseProperties().Bravery += 1;
					this.List.push({
						id = 16,
						icon = "ui/icons/bravery.png",
						text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinacji"
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local all_oaths_complete = this.World.Ambitions.getAmbition("ambition.oath_of_camaraderie").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_distinction").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_dominion").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_endurance").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_fortification").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_honor").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_humility").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_righteousness").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_sacrifice").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_valor").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_vengeance").isDone() && this.World.Ambitions.getAmbition("ambition.oath_of_wrath").isDone();

		if (!all_oaths_complete)
		{
			return;
		}

		this.m.Score = 600;
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

