this.caravan_guard_vs_raider_event <- this.inherit("scripts/events/event", {
	m = {
		CaravanHand = null,
		Raider = null
	},
	function create()
	{
		this.m.ID = "event.caravan_guard_vs_raider";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]Choć oczekujesz, że najęci ludzie zostawią stare życie za sobą, czasem tak nie jest. Wygląda na to, że %caravanhand% i %raider% dobrze się znają: przewoźnik kiedyś starł się z najeźdźcą w jakiejś walce, która zakończyła się bez zwycięzcy. Teraz chcą dokończyć to, co zaczęli dawno temu, obaj tarzają się po ziemi, zadając ciosy, łokcie i plując, gdy trzeba sięgnąć oka czy policzka. Rozdzielasz ich sam, wyrywając ich od siebie i wyraźnie pokazując, że teraz są najemnikami, a nie wrogami. Zmuszasz ich do uściśnięcia dłoni i robią to. Przewoźnik kiwa głową.%SPEECH_ON%Dobry lewy, %raider%.%SPEECH_OFF%Najeźdźca kiwa głową, wycierając krew spływającą z nosa.%SPEECH_ON%Jesteś silniejszy, niż pamiętam.%SPEECH_OFF%Obaj odchodzą razem, by się opatrzyć, tak jak robią to mężczyźni, zostawiając swoje problemy równie łatwo.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mały świat...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.CaravanHand.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.CaravanHand.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.CaravanHand.getName() + " doznaje lekkich ran"
					});
				}
				else
				{
					local injury = _event.m.CaravanHand.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.CaravanHand.getName() + " doznaje " + injury.getNameOnly()
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Raider.addLightInjury();
					this.List.push({
						id = 11,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Raider.getName() + " doznaje lekkich ran"
					});
				}
				else
				{
					local injury = _event.m.Raider.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Raider.getName() + " doznaje " + injury.getNameOnly()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img]Choć oczekujesz, że najęci ludzie zostawią stare życie za sobą, czasem tak nie jest. Wygląda na to, że %caravanhand% i %raider% dobrze się znają: przewoźnik kiedyś starł się z nomadzkim najeźdźcą w jakiejś walce, która zakończyła się bez zwycięzcy. Teraz chcą dokończyć to, co zaczęli dawno temu, obaj tarzają się po ziemi, zadając ciosy, łokcie i plując, gdy trzeba sięgnąć oka czy policzka. Rozdzielasz ich sam, wyrywając ich od siebie i wyraźnie pokazując, że teraz są najemnikami, a nie wrogami. Zmuszasz ich do uściśnięcia dłoni i robią to. Przewoźnik kiwa głową.%SPEECH_ON%Dobry lewy, %raider%.%SPEECH_OFF%Nomad kiwa głową, wycierając krew spływającą z nosa.%SPEECH_ON%Jesteś silniejszy, niż pamiętam.%SPEECH_OFF%Obaj odchodzą razem, by się opatrzyć, tak jak robią to mężczyźni, zostawiając swoje problemy równie łatwo.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mały świat...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.CaravanHand.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.CaravanHand.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.CaravanHand.getName() + " doznaje lekkich ran"
					});
				}
				else
				{
					local injury = _event.m.CaravanHand.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.CaravanHand.getName() + " doznaje " + injury.getNameOnly()
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Raider.addLightInjury();
					this.List.push({
						id = 11,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Raider.getName() + " doznaje lekkich ran"
					});
				}
				else
				{
					local injury = _event.m.Raider.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Raider.getName() + " doznaje " + injury.getNameOnly()
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_caravan = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 7 && bro.getBackground().getID() == "background.caravan_hand" && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates_caravan.push(bro);
			}
		}

		if (candidates_caravan.len() == 0)
		{
			return;
		}

		local candidates_raider = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 7 && (bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.nomad") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates_raider.push(bro);
			}
		}

		if (candidates_raider.len() == 0)
		{
			return;
		}

		this.m.CaravanHand = candidates_caravan[this.Math.rand(0, candidates_caravan.len() - 1)];
		this.m.Raider = candidates_raider[this.Math.rand(0, candidates_raider.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onDetermineStartScreen()
	{
		if (this.m.Raider.getBackground().getID() == "background.raider")
		{
			return "A";
		}
		else
		{
			return "B";
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"caravanhand",
			this.m.CaravanHand.getName()
		]);
		_vars.push([
			"raider",
			this.m.Raider.getName()
		]);
	}

	function onClear()
	{
		this.m.CaravanHand = null;
		this.m.Raider = null;
	}

});

