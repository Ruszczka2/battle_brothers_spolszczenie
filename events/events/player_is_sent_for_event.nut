this.player_is_sent_for_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.player_is_sent_for";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]{Wygląda na to, że kompania zwróciła uwagę posłańca na drodze.%SPEECH_ON%{Panowie, %settlement% na %direction% pilnie potrzebuje pomocy i wzywa wszystkich zdolnych do walki, zwłaszcza tych od sprzedawania miecza, by przyszli pomóc. | Ach, %companyname%, właśnie was szukałem. %settlement% na %direction% prosi o pomoc w pewnym problemie. Jeśli szukacie roboty, polecam tam wyruszyć. I powiedzcie, że to ja was przysłałem, dostanę za to dwie korony ekstra. | Hej, panowie od miecza, %settlement% na %direction% potrzebuje waszych usług. Sugeruję, byście tam ruszyli, jeśli szukacie pracy. | Szukacie roboty? Nie maszerujecie, jakby was coś prowadziło, więc powiem wam, że %settlement% na %direction% ma kilka zleceń dla waszej grupy. | Ach, najemnik bez roli w tym świecie? O, biada. Cóż, %settlement% niedaleko stąd ma coś dla was. Sugeruję, byś tam wyruszył. | Przyszedłem wam powiedzieć, że %settlement% szuka ludzi. Nie robotników, pamiętaj. Mówię do was nie bez powodu. Weźcie swoje miecze i zabójców tam, jeśli chcecie porządnej monety. | Hej, powinniście wiedzieć, że %settlement% szuka ludzi waszego pokroju. Znajdźcie drogę tam, a może znajdziecie nową robotę. | Szukacie pracy? To ruszajcie do %settlement% na %direction%, to nie tajemnica, że szukają takich jak wy.}%SPEECH_OFF%Dziękując posłańcowi, sprawdzasz mapy, by zobaczyć, czy warto tam iść.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Płatna robota, mówisz?",
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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (this.World.Contracts.getActiveContract() != null)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearestTown;
		local nearestDist = 9000;

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			local d = t.getTile().getDistanceTo(currentTile) + this.Math.rand(0, 10);

			if (d < nearestDist && t.isAlliedWithPlayer() && this.World.FactionManager.getFaction(t.getFaction()).getContracts().len() != 0)
			{
				nearestTown = t;
				nearestDist = d;
			}
		}

		if (nearestTown == null)
		{
			return;
		}

		this.m.Town = nearestTown;

		if (this.World.getTime().Days <= 10)
		{
			this.m.Score = 30;
		}
		else
		{
			this.m.Score = 10;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"settlement",
			this.m.Town.getName()
		]);
		_vars.push([
			"direction",
			this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Town.getTile())]
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

