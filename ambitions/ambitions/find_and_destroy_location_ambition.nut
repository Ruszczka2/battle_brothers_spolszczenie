this.find_and_destroy_location_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.find_and_destroy_location";
		this.m.Duration = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Wyruszmy w dzicz, odkryjmy co nieznane i złupmy je.\nCzy to krypta czarnoksiężnika, czy obóz goblinów, czy na co tam się natkniemy.";
		this.m.UIText = "Odnajdź i zniszcz ruinę lub wrogi obóz";
		this.m.TooltipText = "Odkryj ruiny, obóz lub inną wrogą lokację podczas samodzielnej eksploracji krainy, zniszcz ją i zgarnij łupy.";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]Brzmiało to jak dobry pomysł, ale dreptanie po dziczy bez mapy i bez celu okazało się dość wyczerpującym sposobem na znalezienie bogactw, a nawet walki. Wasza obolała kompania w końcu natrafiła jednak na godny cel i wszyscy musieli przyznać, że wyprawa mimo wszystko była opłacalna. %farmer% niemal promienieje z zadowolenia, gdy ogląda kilka tlących się jeszcze żarów w %recently_destroyed%.%SPEECH_ON%Nie mieli najmniejszego pojęcia, że nadchodzimy. Jak zboże przed naszymi kosami, bracia!%SPEECH_OFF%%notfarmer% unosi brew.%SPEECH_ON%Mów za siebie. Ja nie jestem rolnikiem.%SPEECH_OFF%";
		this.m.SuccessButtonText = "Kolejne wyzwanie ukończone.";
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastLocationDestroyedFaction") != 0 && this.World.Statistics.getFlags().get("LastLocationDestroyedForContract") == false)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastLocationDestroyedFaction") != 0 && this.World.Statistics.getFlags().get("LastLocationDestroyedForContract") == false)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local farmers = [];
		local workers = [];
		local not_farmers = [];

		if (brothers.len() > 2)
		{
			for( local i = 0; i < brothers.len(); i = i )
			{
				if (brothers[i].getSkills().hasSkill("trait.player"))
				{
					brothers.remove(i);
					break;
				}

				i = ++i;
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.farmhand")
			{
				farmers.push(bro);
			}
			else if (bro.getBackground().getID() == "background.shepherd" || bro.getBackground().getID() == "background.miller" || bro.getBackground().getID() == "background.daytaler")
			{
				workers.push(bro);
			}
			else
			{
				not_farmers.push(bro);
			}
		}

		local farmer;

		if (farmers.len() != 0)
		{
			farmer = farmers[this.Math.rand(0, farmers.len() - 1)];
		}
		else if (workers.len() != 0)
		{
			farmer = workers[this.Math.rand(0, workers.len() - 1)];
		}
		else
		{
			farmer = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		local not_farmer;

		if (not_farmers.len() != 0)
		{
			not_farmer = not_farmers[this.Math.rand(0, not_farmers.len() - 1)];
		}
		else
		{
			not_farmer = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		_vars.push([
			"farmer",
			farmer.getName()
		]);
		_vars.push([
			"notfarmer",
			not_farmer.getName()
		]);
		_vars.push([
			"recently_destroyed",
			this.World.Statistics.getFlags().get("LastLocationDestroyedName")
		]);
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

