this.greenskins_slayer_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_slayer";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_35.png[/img]Podczas marszu waszą drogę przecina mężczyzna. Jest dobrze opancerzony i wygląda dość rycersko, z jednym wyjątkiem: kościany naszyjnik zwisa mu z szyi. Z każdym krokiem dźwięczy chorym, pustym stukiem o napierśnik. Patrzysz na nieznajomego i jego kościane ozdoby z ostrożnością, by nie zrobił pasa z twojego fiuta i napierśnika z twojego...%SPEECH_ON%Dobry wieczór, najemnicy.%SPEECH_OFF%Wojownik macha ręką. Jest w nim niewidoczny ciężar, jakby otaczało go martwe powietrze albo dusze jego ofiar. Kiwając głową, ciągnie dalej.%SPEECH_ON%Wyglądacie na takich, co skórują zielonoskórych, a towarzystwo tego rodzaju najbardziej mi odpowiada.%SPEECH_OFF%%randombrother% wymienia z tobą spojrzenie i wzrusza ramionami. Szepcze obojętnie.%SPEECH_ON%Jeśli jest problemem, poradzimy sobie z nim.%SPEECH_OFF%Mężczyzna kręci głową.%SPEECH_ON%Och, nie będę problemem. Chcę tylko zabijać orki i gobliny. Czego więcej musisz wiedzieć? Gdy zielonoskórni zostaną załatwieni, zniknę z waszej głowy.%SPEECH_OFF%",
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
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Nie, dzięki, poradzimy sobie.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"orc_slayer_background"
				]);
				_event.m.Dude.getSkills().add(this.new("scripts/skills/traits/hate_greenskins_trait"));
				local necklace = this.new("scripts/items/accessory/special/slayer_necklace_item");
				necklace.m.Name = _event.m.Dude.getNameOnly() + "\'s Necklace";
				_event.m.Dude.getItems().equip(necklace);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isGreenskinInvasion())
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
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

