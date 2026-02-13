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
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Kilku Swietobiorcow przynosi ci kartke. Widnieje na niej nazwa %companyname%, dosc zabawny rysunek ciebie samego, zupelnie nieproporcjonalny, i kilka dosadnych okreslen twojego mizernego charakteru. Wyglada na to, ze twoja reputacja w tym swiecie nie jest tak wzniosla, jak sadziles.%SPEECH_ON%Musimy to naprawic, kapitanie! To wielka zniewaga dla Swietobiorcow, a zwlaszcza dla Mlodego Anselma!%SPEECH_OFF%Zgadzasz sie. | Gdy kompania obozuje, kilku Swietobiorcow narzeka na reputacje %companyname%.%SPEECH_ON%Mlody Anselm nie bylby zadowolony z tego, jak swiat nas postrzega. Powinnismy dawac przyklad, jak sie zachowywac!%SPEECH_OFF%Zgadzasz sie, choc naprawa honoru Swietobiorcow moze potrwac. | Mlody Anselm zalozyl Swietobiorcow z przekonaniem, ze powinni byc wzorami, przywracajacymi prymat honoru, cnoty i prawosci - elementow, ktore, jak uwazal, swiat zagubil. Niestety trudno ci bylo utrzymac te ideały, a reputacja %companyname% spadla odrobine nizej, niz powinna. Kilku ludzi slusznie narzeka, a nawet jesli nie narzekaja otwarcie, oczywiste jest, ze te wady i tak obnizaja morale. Uznajesz, ze najlepiej zaczac naprawiac reputacje %companyname% tak szybko, jak to mozliwe, by ludzie nie stracili wiary w ostateczny cel.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bede lepszym przywodca.",
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
						bro.worsenMood(1.0, "Jest zmartwiony zla reputacja kompanii");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.5, "Jest zmartwiony zla reputacja kompanii");
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

