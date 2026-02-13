this.volunteers_event <- this.inherit("scripts/events/event", {
	m = {
		Dude1 = null,
		Dude2 = null,
		Dude3 = null
	},
	function create()
	{
		this.m.ID = "event.volunteers";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Siedzisz w namiocie i obracasz pioro w palcach. Jakis czas temu widziales, jak skryba to robil, ale nie potrafisz zrozumiec, jak mogl to robic tak szybko i nie upuszczac tego cholerstwa. Nawet lekki powiew wychodzi z twoich poruszajacych sie palcow. %randombrother% kreci glowa.%SPEECH_ON%Czy kiedykolwiek odbijemy finansowo po tym wszystkim?%SPEECH_OFF%Wzdychasz i podnosisz wzrok. Miales nadzieje, ze ludzie beda trzymac sie kupy i nie beda roztrzasac strat, ale po calej serii ostatnich wydarzen kompania zdaje sie byc o krok od nieodwracalnych szkod. Morale jest niskie, skarbiec jest pusty, a nawet gdybys mial pieniadze, wyglada na to, ze wielu i tak nie chcialoby dolaczyc do kompanii przez jej marne wyniki. Wtedy do obozu wchodzi najemnik prowadzac trzech ludzi. Ten na przedzie przedstawia sie i przechodzi do rzeczy.%SPEECH_ON%Znalismy %companyname% po reputacji i przeszlismy kawal drogi, by zobaczyc was na wlasne oczy. Teraz, jesli moge powiedziec szczerze, wygladacie na dojechanych i wcale nie jak z opowiesci, ale, cholera, wiemy, ze ten swiat daje ludziom w kosc i jedyne co mozna zrobic to zrobic z tego uzytek. Nie szlismy tyle, zeby sie obrazic o drobna ryske, rozumiesz?%SPEECH_OFF%Ludzie oferuja swoje uslugi bez oplaty z gory, a do tego reszta kompanii podnosi sie na duchu, bo swiat wciaz wysoko ocenia ich i ich wysilki. Cala ta praca nad renoma %companyname% w koncu sie oplacila.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witamy na pokladzie.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude1);
						this.World.getPlayerRoster().add(_event.m.Dude2);
						this.World.getPlayerRoster().add(_event.m.Dude3);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude1.onHired();
						_event.m.Dude2.onHired();
						_event.m.Dude3.onHired();
						return 0;
					}

				},
				{
					Text = "Damy rade, dzieki.",
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
				_event.m.Dude1 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude1.setStartValuesEx([
					"bastard_background",
					"caravan_hand_background",
					"deserter_background",
					"houndmaster_background"
				]);
				_event.m.Dude1.getBackground().buildDescription(true);
				_event.m.Dude2 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude2.setStartValuesEx([
					"killer_on_the_run_background",
					"gambler_background",
					"graverobber_background",
					"poacher_background",
					"thief_background"
				]);
				_event.m.Dude2.getBackground().buildDescription(true);
				_event.m.Dude3 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude3.setStartValuesEx([
					"butcher_background",
					"gravedigger_background",
					"mason_background",
					"miller_background",
					"miner_background",
					"peddler_background",
					"ratcatcher_background",
					"shepherd_background",
					"tailor_background"
				]);
				_event.m.Dude3.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude1.getImagePath());
				this.Characters.push(_event.m.Dude2.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1800 || this.World.Assets.getMoney() > 1500)
		{
			return;
		}

		local fallen = [];
		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 5)
		{
			return;
		}

		if (fallen[0].Time > this.World.getTime().Days + 7 || fallen[1].Time > this.World.getTime().Days + 7 || fallen[2].Time > this.World.getTime().Days + 7 || fallen[3].Time > this.World.getTime().Days + 7 || fallen[4].Time > this.World.getTime().Days + 7)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() < 2)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() + 3 >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		this.m.Score = 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude1 = null;
		this.m.Dude2 = null;
		this.m.Dude3 = null;
	}

});

