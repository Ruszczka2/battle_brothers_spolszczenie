this.bad_reputation_event <- this.inherit("scripts/events/event", {
	m = {
		Superstitious = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.bad_reputation";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Kilku Świętobiorców przynosi ci kartkę. Widnieje na niej nazwa %companyname%, dość zabawny rysunek ciebie samego, zupełnie nieproporcjonalny, i kilka dosadnych określeń twojego mizernego charakteru. Wygląda na to, że twoja reputacja w tym świecie nie jest tak wzniosła, jak sądziłeś.%SPEECH_ON%Musimy to naprawić, kapitanie! To wielka zniewaga dla Świętobiorców, a zwłaszcza dla Młodego Anselma!%SPEECH_OFF%Zgadzasz się. | Gdy kompania obozuje, kilku Świętobiorców narzeka na reputację %companyname%.%SPEECH_ON%Młody Anselm nie byłby zadowolony z tego, jak świat nas postrzega. Powinniśmy dawać przykład, jak się zachowywać!%SPEECH_OFF%Zgadzasz się, choć naprawa honoru Świętobiorców może potrwać. | Młody Anselm założył Świętobiorców z przekonaniem, że powinni być wzorami, przywracającymi prymat honoru, cnoty i prawości - elementów, które, jak uważał, świat zagubił. Niestety trudno ci było utrzymać te ideały, a reputacja %companyname% spadła odrobinę niżej, niż powinna. Kilku ludzi słusznie narzeka, a nawet jeśli nie narzekają otwarcie, oczywiste jest, że te wady i tak obniżają morale. Uznajesz, że najlepiej zacząć naprawiać reputację %companyname% tak szybko, jak to możliwe, by ludzie nie stracili wiary w ostateczny cel.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Będę lepszym przywódcą.",
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
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(1.0, "Jest zmartwiony złą reputacją kompanii");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.5, "Jest zmartwiony złą reputacją kompanii");
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
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.Assets.getMoralReputation() >= 40.0)
		{
			return;
		}

		this.m.Score = 15;
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

