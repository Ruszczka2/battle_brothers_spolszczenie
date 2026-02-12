this.eunuch_ladies_event <- this.inherit("scripts/events/event", {
	m = {
		Eunuch = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.eunuch_ladies";
		this.m.Title = "W %town%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_85.png[/img]W mieście krąży wieść o eunuchu %eunuch%. Podobno on i kilku braci odwiedzili miejscowy burdel. Zarówno dziwki, jak i bracia początkowo kpili z eunucha, ale on zażądał zaledwie pięciu minut z najbardziej doświadczoną z pań. Wyszła po dwóch minutach, a plotki o łóżkowych umiejętnościach %eunuch% tylko od tego wybuchły.\n\nTeraz połowa miasta, a dokładniej jego kobiety, mówi dobrze o %companyname% i chętnie widziałaby was ponownie. Sam %eunuch% posyła ci mrugnięcie i uśmiech. Zauważasz, że ma dość brodawkowate usta.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ukryty talent.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Eunuch.getImagePath());

				if (_event.m.Town.isSouthern())
				{
					_event.m.Town.getOwner().addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "One of your men got a reputation with the ladies");
				}
				else
				{
					_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "One of your men got a reputation with the ladies");
				}

				_event.m.Eunuch.improveMood(1.5, "Got friendly with some ladies in " + _event.m.Town.getName());

				if (_event.m.Eunuch.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Eunuch.getMoodState()],
						text = _event.m.Eunuch.getName() + this.Const.MoodStateEvent[_event.m.Eunuch.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.eunuch")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isMilitary())
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

		this.m.Eunuch = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = candidates.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"eunuch",
			this.m.Eunuch.getNameOnly()
		]);
		_vars.push([
			"town",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Eunuch = null;
		this.m.Town = null;
	}

});

