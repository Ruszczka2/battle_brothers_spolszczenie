this.enter_unfriendly_town_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.enter_unfriendly_town";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Mieszkańcy %townname% witają cię {kilkoma zgniłymi jajami, rzuconymi z taką siłą i celnością, że nie możesz nie pomyśleć, iż nie są zbyt przychylni twojej obecności. | lalką posmarowaną smołą i obsypaną pierzem, zwisającą z pobliskiego drzewa. Jej twarz jest uderzająco podobna do twojej, ale uznajesz to za zwykły zbieg okoliczności. | kilkorgiem rozbrykanych dzieci, bez wątpienia wypuszczonych przez rodziców, by robiły zło, które w świecie dorosłych spotkałoby się z jakąś brutalną reakcją. Gdy małe bękarty rzucają się na ciebie, powodując chaos, rozkazujesz ludziom ruszyć butami. Kilka solidnych kopniaków i stompnięć odpędza drani, ale na jak długo? | płonącą kukłą przedstawiającą ciebie. Chłopi gaszą ją w świńskim korycie. Stoją wokół, upewniając się, że nie widzisz, co zostało z tej drewnianej postaci w twoim kształcie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nie znoszę tego miasta.",
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

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearTown = false;
		local town;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer() && t.getFactionOfType(this.Const.FactionType.Settlement).getPlayerRelation() <= 35)
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
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

