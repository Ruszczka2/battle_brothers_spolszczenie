this.mountains_are_dangerous_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.mountains_are_dangerous";
		this.m.Title = "W górach...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_42.png[/img]Choć jesteś głęboko w górach, widzisz szczyty pasma ciągnące się dalej, każdy wystający między dolinami kolejnego. To piękny widok, ale i męczący. Wędrówka przez przełęcze - a czasem odnajdywanie własnych przejść - dała ludziom w kość. Stoki z krzemienia, osadów i niesfornego żwiru zmuszają twoich ludzi do wspinaczki na rękach i kolanach. Każde śliskie piargowisko zsuwa strudzonych w dół, skąd przyszli, wystawiając na próbę determinację tych, którzy nie mają ochoty na tyle powtórek tej samej drogi.\n\n A jednak dookoła biegają górskie kozy. Jedna niemożliwie wspina się po fałdzie z drwiącą łatwością, a inna skubie suchą trawę między zdezorientowanym beczeniem. Kamienne mosty, wspornikowe pod jurajską geologią, niosą mrugające łby ciekawskich pum. Masz wrażenie, że już widziały takich jak wy. Wiedzą, by nie atakować, ale i tak podążają. Może któryś z was upadnie i coś złamie, a okaleczony zostanie z tyłu, bo niesienie rannego w takim miejscu to śmierć dla dwóch.\n\nGdy robisz przegląd ludzi, widzisz, że wielu ma obrażenia. Ból piszczeli. Zakwasy w łydkach. Pulsujące kolana. Pewnie jakieś złamane kości, ale nic śmiertelnego. Tylko silni i zwinni potrafią bezpiecznie przebyć takie miejsce i faktycznie to oni zwykle pierwsi docierają na szczyt każdego podejścia.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech to miejsce szlag trafi!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveEffect();
			}

		});
	}

	function giveEffect()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local result = [];
		local lowestChance = 9000;
		local lowestBro;
		local applied = false;

		foreach( bro in brothers )
		{
			local chance = bro.getHitpoints() + 20;

			if (bro.getSkills().hasSkill("trait.dexterous"))
			{
				chance = chance + 20;
			}

			if (bro.getSkills().hasSkill("trait.sure_footing"))
			{
				chance = chance + 20;
			}

			if (bro.getSkills().hasSkill("trait.strong"))
			{
				chance = chance + 20;
			}

			for( ; this.Math.rand(1, 100) < chance;  )
			{
				if (chance < lowestChance)
				{
					lowestChance = chance;
					lowestBro = bro;
				}
			}

			applied = true;
			local injury = bro.addInjury(this.Const.Injury.Mountains);
			result.push({
				id = 10,
				icon = injury.getIcon(),
				text = bro.getName() + " doznaje " + injury.getNameOnly()
			});
		}

		if (!applied && lowestBro != null)
		{
			local injury = lowestBro.addInjury(this.Const.Injury.Mountains);
			result.push({
				id = 10,
				icon = injury.getIcon(),
				text = lowestBro.getName() + " doznaje " + injury.getNameOnly()
			});
		}

		return result;
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Mountains || this.World.Retinue.hasFollower("follower.scout"))
		{
			return;
		}

		this.m.Score = 25;
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

