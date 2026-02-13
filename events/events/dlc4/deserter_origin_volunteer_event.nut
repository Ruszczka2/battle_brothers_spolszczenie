this.deserter_origin_volunteer_event <- this.inherit("scripts/events/event", {
	m = {
		Dude1 = null,
		Dude2 = null,
		Victim = null
	},
	function create()
	{
		this.m.ID = "event.deserter_origin_volunteer";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Z krzaków przy drodze wychodzi para obdartych i zmęczonych mężczyzn. Unoszą ręce, jakby chcieli się poddać.%SPEECH_ON%Jesteście %companyname%? Słyszeliśmy, że to banda dezerterów. I nie mówię tego jako obelgi. My też uciekamy, ale nie mamy już dokąd iść. Wszędzie, gdzie się obrócimy, są łowcy nagród i kaci. Pozwólcie nam walczyć dla was. To nie walka nas kiedykolwiek przerażała, przysięgamy na to.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przydadzą nam się tacy wojownicy jak wy.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 60 ? "B" : "C";
					}

				},
				{
					Text = "Nie potrzebujemy was.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude1 = null;
						_event.m.Dude2 = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude1 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude1.setStartValuesEx([
					"deserter_background"
				]);
				_event.m.Dude1.getBackground().m.RawDescription = "Od jakiegoś czasu uciekając przed łowcami nagród i katami, %name% wpadł na twoją kompanię na drodze i od razu się zgłosił.";
				_event.m.Dude1.getBackground().buildDescription(true);
				_event.m.Dude2 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude2.setStartValuesEx([
					"deserter_background"
				]);
				_event.m.Dude2.getBackground().m.RawDescription = "%name% zdezerterował z pułku razem z " + _event.m.Dude1.getNameOnly() + " zanim zgłosił się do twojej kompanii.";
				_event.m.Dude2.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude1.getImagePath());
				this.Characters.push(_event.m.Dude2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Prawie satysfakcjonująco ironiczne byłoby powiesić tych ludzi za to, co zrobili, ale nie zamierzasz nadawać takiego tonu kompanii. Witasz ich w bandzie i wysyłasz do ekwipunku. %victim% obserwuje ich przez jakiś czas, ale melduje, że dotrzymują słowa i będą walczyć.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witajcie w %companyname%!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude1);
						this.World.getPlayerRoster().add(_event.m.Dude2);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude1.onHired();
						_event.m.Dude2.onHired();
						_event.m.Dude1 = null;
						_event.m.Dude2 = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude1.getImagePath());
				this.Characters.push(_event.m.Dude2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Prawie satysfakcjonująco ironiczne byłoby powiesić tych ludzi za to, co zrobili, ale nie zamierzasz nadawać takiego tonu kompanii. Witasz ich w bandzie i wysyłasz do ekwipunku, a %victim% ma na nich oko. Tyle że przez podejrzanie długi czas nie widzisz swojego najemnika. Gdy idziesz sprawdzić, znajduje się go nieprzytomnego na ziemi, a zapasy są splądrowane. Tych dwóch nie ma nigdzie!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech ich diabli, łotrów!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.getTemporaryRoster().clear();
				_event.m.Dude1 = null;
				_event.m.Dude2 = null;
				local injury = _event.m.Victim.addInjury(this.Const.Injury.Concussion);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Victim.getName() + " doznaje " + injury.getNameOnly()
				});
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					local food = this.World.Assets.getFoodItems();
					food = food[this.Math.rand(0, food.len() - 1)];
					this.World.Assets.getStash().remove(food);
					this.List.push({
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "Tracisz " + food.getName()
					});
				}
				else if (r == 2)
				{
					local amount = this.Math.rand(20, 50);
					this.World.Assets.addAmmo(-amount);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_ammo.png",
						text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Amunicji"
					});
				}
				else if (r == 3)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addArmorParts(-amount);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_supplies.png",
						text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Narzędzi i Zaopatrzenia"
					});
				}
				else if (r == 4)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addMedicine(-amount);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_medicine.png",
						text = "Tracisz [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Zapasów Medycznych"
					});
				}

				this.Characters.push(_event.m.Victim.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.deserters")
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() + 1 >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local roster = this.World.getPlayerRoster().getAll();
		this.m.Victim = roster[this.Math.rand(0, roster.len() - 1)];
		this.m.Score = 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"victim",
			this.m.Victim.getName()
		]);
	}

	function onClear()
	{
		this.m.Dude1 = null;
		this.m.Dude2 = null;
		this.m.Victim = null;
	}

});

