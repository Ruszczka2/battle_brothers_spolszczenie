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
			Text = "[img]gfx/ui/events/event_80.png[/img]{Siedzisz w namiocie i obracasz pióro w palcach. Jakiś czas temu widziałeś, jak skryba to robił, ale nie potrafisz zrozumieć, jak mógł to robić tak szybko i nie upuszczać tego cholerstwa. Nawet lekki powiew wychodzi z twoich poruszających się palców. %randombrother% kręci głową.%SPEECH_ON%Czy kiedykolwiek odbijemy finansowo po tym wszystkim?%SPEECH_OFF%Wzdychasz i podnosisz wzrok. Miałeś nadzieję, że ludzie będą trzymać się kupy i nie będą roztrząsać strat, ale po całej serii ostatnich wydarzeń kompania zdaje się być o krok od nieodwracalnych szkód. Morale jest niskie, skarbiec jest pusty, a nawet gdybyś miał pieniądze, wygląda na to, że wielu i tak nie chciałoby dołączyć do kompanii przez jej marne wyniki. Wtedy do obozu wchodzi najemnik prowadząc trzech ludzi. Ten na przedzie przedstawia się i przechodzi do rzeczy.%SPEECH_ON%Znaleźliśmy %companyname% po reputacji i przeszliśmy kawał drogi, by zobaczyć was na własne oczy. Teraz, jeśli mogę powiedzieć szczerze, wyglądacie na dojechanych i wcale nie jak z opowieści, ale, cholera, wiemy, że ten świat daje ludziom w kość i jedyne co można zrobić to zrobić z tego użytek. Nie szliśmy tyle, żeby się obrazić o drobną ryskę, rozumiesz?%SPEECH_OFF%Ludzie oferują swoje usługi bez opłaty z góry, a do tego reszta kompanii podnosi się na duchu, bo świat wciąż wysoko ocenia ich i ich wysiłki. Cała ta praca nad renomą %companyname% w końcu się opłaciła.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witamy na pokładzie.",
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
					Text = "Damy radę, dzięki.",
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

