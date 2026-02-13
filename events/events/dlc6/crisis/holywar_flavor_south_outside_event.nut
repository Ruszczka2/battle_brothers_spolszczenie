this.holywar_flavor_south_outside_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_flavor_south_outside";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_132.png[/img]Znajdujesz rozebrane szczątki pola bitwy: stertę bezużytecznych resztek i zwłoki tak skurczone, że trudno rozpoznać, do której strony należały. Złomiarze z pewnością zabrali wszystko, co się dało wykorzystać. | [img]gfx/ui/events/event_132.png[/img]Tlący się wóz z właścicielem leżącym obok, bez głowy, a reszta ciała obgryziona do kości. Biorąc pod uwagę trwającą wojnę, trudno powiedzieć, kto jest za to odpowiedzialny. | [img]gfx/ui/events/event_132.png[/img]Znajdujesz zbezczeszczone resztki sztandaru starych bogów, wbitego w piasek, z bezgłowym ciałem zawieszonym na drągu. Bez wątpienia północniak, ciało wręcz bulgocze, gdy jaszczury piaskowe wężowato kręcą się wokół, próbując dorwać ostatnie smaczne kąski. Po piaskach rozsiane są kolejne zwłoki, większość pełzająca od chrząszczy albo szarpana przez węże i inne padlinożerne stwory. | [img]gfx/ui/events/event_167.png[/img]Znajdujesz martwego północnego mężczyznę podpartego w piasku, z rękami i nogami przywiązanymi do drewnianego krzesła. Przed nim stoi wysoki słup z ramą i linami zwisającymi bezwładnie z narożników. Wygląda na to, że kiedyś trzymały coś dużego i krągłego. Głowa mężczyzny ma przewiercony otwór, a rana jest niepodobna do żadnej, jaką widziałeś: niemal jakby przewiercili ją samym żarem. Może Gilded użyli odbicia wielkiego medalionu, by wzmocnić słońce? Trudno powiedzieć. | [img]gfx/ui/events/event_167.png[/img]Znajdujesz rząd zwłok w piasku, a po bliższym przyjrzeniu się okazuje się, że to same południowe kobiety i mężczyzna, który mógłby być członkiem rady wezyra. Wszystkim odcięto głowy i położono je na plecach, z oczami zwróconymi ku pośladkom. Nie wiesz, co to wszystko znaczy, ale bez wątpienia jest to rezultat wewnętrznych sporów w szeregach wezyra. Nie ma nic wartościowego do zabrania, więc każesz ludziom iść dalej.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wojna nigdy się nie zmienia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.FactionManager.isHolyWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.Type != this.Const.World.TerrainType.Oasis && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills && currentTile.Type != this.Const.World.TerrainType.Steppe)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
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

