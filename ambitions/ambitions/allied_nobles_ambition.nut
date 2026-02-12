this.allied_nobles_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.allied_nobles";
		this.m.Duration = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Zdobędziemy zaufanie rodu szlacheckiego i zostaniemy ich sojusznikami.\nBez wątpienia podzielą się wtedy zasobami swych dobrze zaopatrzonych zbrojowni.";
		this.m.RewardTooltip = "W nagrodę otrzymasz wyposażenie unikalne dla rodu, z którym się zbratasz";
		this.m.UIText = "Uzyskaj \'Sojusznicze\' relacje z rodem szlacheckim";
		this.m.TooltipText = "Zwiększ relacje z dowolnym rodem szlacheckim do poziomu \'Sojusznicze\' poprzez wypełnianie kontraktów zleconych przez członków danego rodu. Nieudane kontrakty i zdradzanie zaufania ludności obniży twoje relacje.";
		this.m.SuccessText = "[img]gfx/ui/events/event_78.png[/img]Od dawna dochodziły cię słuchy, a twe doświadczenie to potwierdziło, że szlachta to ciężka i zmienna zgraja, jednak twoje relacje z rodem %noblehouse% okazały się dochodowe, a koniec końców, także i miłe. Może i nie uważają cię za równego sobie podczas zasiadania do uczty, ale nie są też równi tobie na polu bitwy. Zyskując ich zaufanie poprzez ciężką pracę i oddanie, kompania wreszcie została uznana na zaufanego sojusznika rodu %noblehouse%.\n\nJedną z korzyści płynących z tego stanu rzeczy jest to, że twoi ludzie mogą bez pośpiechu przeglądać szlachecką zbrojownię. Kilku rozgoryczonych partyzantów może i nazwie was psami na smyczy szlachty, za to, żeście się z nią zbratali i prezentujecie ich barwy na swych tarczach, ale nigdy nie powiedzą wam tego prosto w twarz.";
		this.m.SuccessButtonText = "Doskonale.";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 30)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local hasFriend = false;
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse)
			{
				if (f.getPlayerRelation() >= 90.0)
				{
					return;
				}
				else if (f.getPlayerRelation() >= 60.0)
				{
					hasFriend = true;
				}
			}
		}

		if (!hasFriend)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() >= 90.0)
			{
				return true;
			}
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() >= 90.0)
			{
				_vars.push([
					"noblehouse",
					f.getNameOnly()
				]);
				break;
			}
		}
	}

	function onReward()
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);
		local banner = 1;

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && f.getType() == this.Const.FactionType.NobleHouse && f.getPlayerRelation() >= 90.0)
			{
				banner = f.getBanner();
				break;
			}
		}

		local item;
		local stash = this.World.Assets.getStash();
		item = this.new("scripts/items/helmets/faction_helm");
		item.setVariant(banner);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/armor/special/heraldic_armor");
		item.setFaction(banner);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/shields/faction_heater_shield");
		item.setFaction(banner);
		item.setVariant(2);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/shields/faction_heater_shield");
		item.setFaction(banner);
		item.setVariant(2);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/shields/faction_kite_shield");
		item.setFaction(banner);
		item.setVariant(2);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		item = this.new("scripts/items/shields/faction_kite_shield");
		item.setFaction(banner);
		item.setVariant(2);
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Zdobywasz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
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

