this.undead_crusader_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_crusader";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_35.png[/img]Mężczyzna w zbroi zatrzymuje cię na ścieżce. Kładziesz dłoń na mieczu i każesz mu ogłosić swoje zamiary, cały czas wypatrując zasadzki. Nieznajomy robi krok do przodu i zdejmuje hełm.%SPEECH_ON%Jestem %crusader%, wojownikiem z ognistej krainy bez imienia. Stałem na wzgórzach złowieszczych rad. Zgładziłem potwory Dev\'ungradu. Dałem spokój duchom w Shellstaya. Gdy starożytni mówią, ja słucham. I oto jestem.%SPEECH_OFF%Odsuwasz rękę od miecza i pytasz go o starożytnych. Kiwając głową, mówi.%SPEECH_ON%Ludzie przed ludźmi, starożytni byli suwerenami wszystkiego, tworząc imperium, które rozciągało się na krainy daleko poza tą. Cały ten chaos to tylko odłamki ich zniszczenia. Człowiek może umrzeć, ale imperium nie. Imperium gnije, kawałek po kawałku, i zabiera ze sobą wszystko, co uważa, że mu się należy.%SPEECH_OFF%Krzyżowiec zakłada hełm i unosi miecz.%SPEECH_ON%Imperium Starożytnych porusza się w swoim grobie. Chcę pomóc je uciszyć. Ofiaruję ci mój miecz, najemniku.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Możesz do nas dołączyć.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Nie, dzięki, poradzimy sobie.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"crusader_background"
				]);
				_event.m.Dude.getSkills().add(this.new("scripts/skills/traits/hate_undead_trait"));
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 3000)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
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
		_vars.push([
			"crusader",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

