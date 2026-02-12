this.have_all_provisions_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_all_provisions";
		this.m.Duration = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Wiem, że jesteście znużeni naszym kiepskim losem i czerstwym pożywieniem.\nZdobędziemy jadło i napitek z wszystkich stron świata i zrobimy sobie ucztę!";
		this.m.RewardTooltip = "Znacznie poprawia samopoczucie twoich ludzi.";
		this.m.UIText = "Posiadaj każdy dostępny rodzaj prowiantu";
		this.m.TooltipText = "Posiadaj po jednym z każdego dostępnego rodzaju prowiantu w swoim ekwipunku, aby wydać ucztę.";
		this.m.SuccessText = "[img]gfx/ui/events/event_61.png[/img]Having put in the legwork chasing down provisioners and haggling with farmers, you assemble a selection of foodstuffs that would catch the eye of even the most jaded nobleman. With the larder full, you call a feast for the %companyname% and invite every man to eat his fill. Your brothers waste no time. What they lack in manners, they make up in appetite. %randombrother% uses the opportunity to share his knowledge on meat.%SPEECH_ON%This beast died with joy in its heart, that\'s why it is so tender.%SPEECH_OFF%To the admiration of his comrades, %strongest_brother% gives a thunderous belch.%SPEECH_ON%I am ashamed to say it, but I must wash this down with water, not more grog.%SPEECH_OFF%After this, there is not much in the way of talk, but greasy beards and full bellies guarantee the men will be in good spirits for your next encounter.";
		this.m.SuccessButtonText = "Ludzie na to zasłużyli.";
	}

	function getTooltipText()
	{
		if (this.hasAllProvisions())
		{
			return this.m.TooltipText;
		}

		local fish = false;
		local beer = false;
		local bread = false;
		local cured_venison = false;
		local dried_fish = false;
		local dried_fruits = false;
		local goat_cheese = false;
		local ground_grains = false;
		local mead = false;
		local mushrooms = false;
		local berries = false;
		local smoked_ham = false;
		local wine = false;
		local cured_rations = false;
		local dates = false;
		local rice = false;
		local dried_lamb = false;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (item.getID() == "supplies.beer")
				{
					beer = true;
				}
				else if (item.getID() == "supplies.bread")
				{
					bread = true;
				}
				else if (item.getID() == "supplies.cured_venison")
				{
					cured_venison = true;
				}
				else if (item.getID() == "supplies.dried_fish")
				{
					dried_fish = true;
				}
				else if (item.getID() == "supplies.dried_fruits")
				{
					dried_fruits = true;
				}
				else if (item.getID() == "supplies.goat_cheese")
				{
					goat_cheese = true;
				}
				else if (item.getID() == "supplies.ground_grains")
				{
					ground_grains = true;
				}
				else if (item.getID() == "supplies.mead")
				{
					mead = true;
				}
				else if (item.getID() == "supplies.pickled_mushrooms")
				{
					mushrooms = true;
				}
				else if (item.getID() == "supplies.roots_and_berries")
				{
					berries = true;
				}
				else if (item.getID() == "supplies.smoked_ham")
				{
					smoked_ham = true;
				}
				else if (item.getID() == "supplies.wine")
				{
					wine = true;
				}
				else if (item.getID() == "supplies.dates")
				{
					dates = true;
				}
				else if (item.getID() == "supplies.rice")
				{
					rice = true;
				}
				else if (item.getID() == "supplies.dried_lamb")
				{
					dried_lamb = true;
				}
				else if (item.getID() == "supplies.cured_rations")
				{
					cured_rations = true;
				}
			}
		}

		local ret = this.m.TooltipText + "\n\nBrakuje nam niektórych zapasów.\n";

		if (!beer)
		{
			ret = ret + "\n- Piwo";
		}

		if (!bread)
		{
			ret = ret + "\n- Chleb";
		}

		if (!cured_venison)
		{
			ret = ret + "\n- Solona Dziczyzna";
		}

		if (!dried_fish)
		{
			ret = ret + "\n- Suszona Ryba";
		}

		if (!dried_fruits)
		{
			ret = ret + "\n- Suszone Owoce";
		}

		if (!ground_grains)
		{
			ret = ret + "\n- Ziarno";
		}

		if (!goat_cheese)
		{
			ret = ret + "\n- Kozi Ser";
		}

		if (!mead)
		{
			ret = ret + "\n- Miód Pitny";
		}

		if (!mushrooms)
		{
			ret = ret + "\n- Grzyby";
		}

		if (!berries)
		{
			ret = ret + "\n- Korzenie i Jagody";
		}

		if (!smoked_ham)
		{
			ret = ret + "\n- Wędzona Szynka";
		}

		if (!wine)
		{
			ret = ret + "\n- Wino";
		}

		if (!cured_rations)
		{
			ret = ret + "\n- Zakonserwowane Racje";
		}

		if (this.Const.DLC.Desert)
		{
			if (!dates)
			{
				ret = ret + "\n- Daktyle";
			}

			if (!rice)
			{
				ret = ret + "\n- Ryż";
			}

			if (!dried_lamb)
			{
				ret = ret + "\n- Suszona Jagnięcina";
			}
		}

		return ret;
	}

	function hasAllProvisions()
	{
		local beer = false;
		local bread = false;
		local cured_venison = false;
		local dried_fish = false;
		local dried_fruits = false;
		local goat_cheese = false;
		local ground_grains = false;
		local mead = false;
		local mushrooms = false;
		local berries = false;
		local smoked_ham = false;
		local wine = false;
		local cured_rations = false;
		local dates = false;
		local rice = false;
		local dried_lamb = false;
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (item.getID() == "supplies.beer")
				{
					beer = true;
				}
				else if (item.getID() == "supplies.bread")
				{
					bread = true;
				}
				else if (item.getID() == "supplies.cured_venison")
				{
					cured_venison = true;
				}
				else if (item.getID() == "supplies.dried_fish")
				{
					dried_fish = true;
				}
				else if (item.getID() == "supplies.dried_fruits")
				{
					dried_fruits = true;
				}
				else if (item.getID() == "supplies.goat_cheese")
				{
					goat_cheese = true;
				}
				else if (item.getID() == "supplies.ground_grains")
				{
					ground_grains = true;
				}
				else if (item.getID() == "supplies.mead")
				{
					mead = true;
				}
				else if (item.getID() == "supplies.pickled_mushrooms")
				{
					mushrooms = true;
				}
				else if (item.getID() == "supplies.roots_and_berries")
				{
					berries = true;
				}
				else if (item.getID() == "supplies.smoked_ham")
				{
					smoked_ham = true;
				}
				else if (item.getID() == "supplies.wine")
				{
					wine = true;
				}
				else if (item.getID() == "supplies.dates")
				{
					dates = true;
				}
				else if (item.getID() == "supplies.rice")
				{
					rice = true;
				}
				else if (item.getID() == "supplies.dried_lamb")
				{
					dried_lamb = true;
				}
				else if (item.getID() == "supplies.cured_rations")
				{
					cured_rations = true;
				}
			}
		}

		if (!this.Const.DLC.Desert)
		{
			return beer && bread && cured_venison && dried_fish && dried_fruits && goat_cheese && ground_grains && mead && mushrooms && berries && smoked_ham && wine && cured_rations;
		}
		else
		{
			return beer && bread && cured_venison && dried_fish && dried_fruits && goat_cheese && ground_grains && mead && mushrooms && berries && smoked_ham && wine && cured_rations && dates && rice && dried_lamb;
		}
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getAverageMoodState() > this.Const.MoodState.Concerned)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.battle_standard").isDone())
		{
			return;
		}

		if (this.hasAllProvisions())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.hasAllProvisions())
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.improveMood(1.0, "Ucztował z kompanią");
		}
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

