this.herbs_along_the_way_event <- this.inherit("scripts/events/event", {
	m = {
		Volunteer = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.herbs_along_the_way";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%Podczas marszu do celu %volunteer% podbiega do ciebie z pękiem ziół w dłoni. Wiesz, że ten głupiec nic nie wie o roślinach ani przyrodzie, ale uparcie chce ich spróbować. Coś o tym, że słyszał o magicznych mocach ukrytych w esencji ziół. Ta gadanina przyciąga uwagę kilku innych z kompanii. Wkrótce kilku z nich prosi, by spróbować tego lekarstwa dla dobra braci.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Wyglądają dobrze, jest ochotnik, by je spróbować?",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "C" : "B";
					}

				},
				{
					Text = "{Lepiej nie kuśmy losu. | Głupcy, tylko się otrujecie.}",
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
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%Wygląda na to, że zioła są nie tylko nieszkodliwe, ale wręcz pomagają na dokuczliwe dolegliwości ludzi. Przeziębienie %volunteer% jakby ustąpiło, a bóle żołądka %otherguy% zelżały. Po tym jak sam spróbowałeś, widzisz, jak drzazga wydostaje się z twojego kciuka. Niesamowite!",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Niesamowite!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local amount = this.Math.rand(5, 12);
				this.World.Assets.addMedicine(amount);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_medicine.png",
						text = "Zyskujesz [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Zapasów Medycznych"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_18.png[/img]Z jednej strony lecą wymiociny, z drugiej gówno. Wygląda na to, że zioła jednak nie były warte próby. %volunteer% dzielnie sam zgłosił się do zjedzenia tajemniczych roślin i, krótko mówiąc, ilości, które z niego wychodzą, są zdecydowanie mistyczne w tym dziwnym sensie: czy ciało naprawdę może tyle pomieścić?",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Fuj.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local effect = this.new("scripts/skills/injury/sickness_injury");
				_event.m.Volunteer.getSkills().add(effect);
				this.List = [
					{
						id = 10,
						icon = effect.getIcon(),
						text = _event.m.Volunteer.getName() + " jest chory"
					}
				];
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

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.Swamp)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getHitpoints() > 20 && !bro.getSkills().hasSkill("injury.sickness") && !bro.getSkills().hasSkill("trait.bright") && !bro.getSkills().hasSkill("trait.hesitant"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Volunteer = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = 10;

			do
			{
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];

				if (bro.getID() != this.m.Volunteer.getID())
				{
					this.m.OtherGuy = bro;
				}
			}
			while (this.m.OtherGuy == null);
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		local currentTile = this.World.State.getPlayer().getTile();
		local image;

		if (currentTile.Type == this.Const.World.TerrainType.Swamp)
		{
			image = "[img]gfx/ui/events/event_09.png[/img]";
		}
		else
		{
			image = "[img]gfx/ui/events/event_25.png[/img]";
		}

		_vars.push([
			"volunteer",
			this.m.Volunteer.getName()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
		_vars.push([
			"image",
			image
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Volunteer = null;
		this.m.OtherGuy = null;
	}

});

