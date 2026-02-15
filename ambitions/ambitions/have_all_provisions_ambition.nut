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
		this.m.SuccessText = "[img]gfx/ui/events/event_61.png[/img]Po trudach gonienia dostawców i targowania się z rolnikami składasz wybór jadła, który zwróciłby uwagę nawet najbardziej zblazowanego szlachcica. Gdy spiżarnia jest pełna, urządzasz ucztę dla %companyname% i zapraszasz każdego, by najadł się do syta. Bracia nie tracą czasu. Czego im brakuje w manierach, nadrabiają apetytem. %randombrother% korzysta z okazji, by podzielić się wiedzą o mięsie.%SPEECH_ON%Ta bestia umarła z radością w sercu, dlatego jest taka krucha.%SPEECH_OFF%Ku zachwytowi towarzyszy %strongest_brother% wydaje potężne beknięcie.%SPEECH_ON%Wstyd się przyznać, ale muszę to popić wodą, nie kolejnym grogiem.%SPEECH_OFF%Po tym niewiele już zostaje do rozmów, ale tłuste brody i pełne brzuchy gwarantują, że ludzie będą w dobrych nastrojach przed następnym spotkaniem.";
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

