this.master_no_use_apprentice_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.master_no_use_apprentice";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%Spacerując po %townname%, natykasz się na starca, który ciągnie młodzieńca za ucho.%SPEECH_ON%Chcesz być mistrzem, to wymaga czasu! Krwi! Potu! Łez, jeśli jesteś z płaczących, i nie ma w tym wstydu, jeśli jesteś. O, patrz! Najemnik! Jak tak chcesz walczyć, to czemu nie pójdziesz do niego?%SPEECH_OFF%Wyciągasz ręce i prosisz o wyjaśnienie, zanim zrzuci na ciebie jakiegoś irytującego gnoja. Starszy mężczyzna uspokaja się i puszcza ucho chłopaka.%SPEECH_ON%Aye, pewnie należy ci się wyjaśnienie. Jestem mistrzem fechtunku w tym mieście, ale uczę dyscypliny i cierpliwości, zanim ktokolwiek w ogóle dotknie miecza! A ten mój przeklęty uczeń nie ma ani jednego, ani drugiego! Więc powiedziałem mu: jak tak chcesz walczyć, to wynocha!%SPEECH_OFF%Patrzysz na chłopaka. Ma świeżą twarz, ale w oczach widać niecierpliwą gorliwość. Pytasz go, czy to, co mówi mistrz miecza, jest prawdą. Chłopak kiwa głową.%SPEECH_ON%Tak, panie. I chętnie będę walczył także dla ciebie.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobrze, weźmiemy go.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Nie, dzięki. Zostaje z tobą.",
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
					"apprentice_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% to niecierpliwy uczeń mistrza fechtunku i miecza, któremu zabrakło hartu ducha, by przejść próby i trudy stawania się mistrzem ostrza. Ale to, czego brakuje mu w wytrwałości, nadrabia wysiłkiem. \'Zatrudniłeś\' go, po prostu zdejmując go z barków starego człowieka.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() <= 1)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"town",
			this.m.Town.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Town = null;
	}

});

