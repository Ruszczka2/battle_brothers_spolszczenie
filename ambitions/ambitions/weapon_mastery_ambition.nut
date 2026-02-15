this.weapon_mastery_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.weapon_mastery";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Jakiż terror byśmy siali, gdyby wasze umiejętności dorównywały waszemu męstwu.\nWyszkolimy pięciu ludzi, aby osiągnęli mistrzostwo we władaniu bronią!";
		this.m.UIText = "Miej ludzi z mistrzostwem broni";
		this.m.TooltipText = "Miej 5 ludzi z których każdy będzie miał talent mistrzostwa w broni, dowolnego rodzaju.";
		this.m.SuccessText = "[img]gfx/ui/events/event_50.png[/img]Wprowadzenie nowego reżimu treningowego, by bracia opanowali broń do mistrzostwa, dobrze wpływa na morale wszystkich. Ci, którzy ćwiczą, poprawiają swoje umiejętności i szanse przeżycia oraz zyskują podziw towarzyszy, a pozostali mają co oglądać, siedząc na pniu i zapychając się baraniną.\n\nĆwiczący trenują w każdej wolnej chwili z rozmaitymi rodzajami broni, aż twarde ramiona stają się jak dębowe konary, a bystre oczy robią się tak ostre i bezlitosne jak u wielkiego kota.%SPEECH_ON%%weaponbrother% nie tylko sieje grozę wśród naszych wrogów, ale jego szybka praca nóg przywodzi na myśl tańczące dziewczęta.%SPEECH_OFF%%notweaponbrother% zauważa, na co %weaponbrother% odpowiada solidnym szturchnięciem treningowym mieczem.";
		this.m.SuccessButtonText = "Teraz są profesjonalistami.";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(5, this.getBrosWithMastery()) + "/5)";
	}

	function getBrosWithMastery()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local count = 0;

		foreach( bro in brothers )
		{
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInBows)
			{
				count = ++count;
				count = count;
			}
			else if (p.IsSpecializedInCrossbows)
			{
				count = ++count;
				count = count;
			}
			else if (p.IsSpecializedInThrowing)
			{
				count = ++count;
				count = count;
			}
			else if (p.IsSpecializedInSwords)
			{
				count = ++count;
				count = count;
			}
			else if (p.IsSpecializedInCleavers)
			{
				count = ++count;
				count = count;
			}
			else if (p.IsSpecializedInMaces)
			{
				count = ++count;
				count = count;
			}
			else if (p.IsSpecializedInHammers)
			{
				count = ++count;
				count = count;
			}
			else if (p.IsSpecializedInAxes)
			{
				count = ++count;
				count = count;
			}
			else if (p.IsSpecializedInFlails)
			{
				count = ++count;
				count = count;
			}
			else if (p.IsSpecializedInSpears)
			{
				count = ++count;
				count = count;
			}
			else if (p.IsSpecializedInPolearms)
			{
				count = ++count;
				count = count;
			}
			else if (p.IsSpecializedInDaggers)
			{
				count = ++count;
				count = count;
			}
		}

		return count;
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local count = this.getBrosWithMastery();

		if (count >= 3)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local count = this.getBrosWithMastery();

		if (count >= 5)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local not_candidates = [];

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
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInBows)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInCrossbows)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInThrowing)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInSwords)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInCleavers)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInMaces)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInHammers)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInAxes)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInFlails)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInSpears)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInPolearms)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInDaggers)
			{
				candidates.push(bro);
			}
			else
			{
				not_candidates.push(bro);
			}
		}

		if (not_candidates.len() == 0)
		{
			not_candidates = brothers;
		}

		_vars.push([
			"weaponbrother",
			candidates[this.Math.rand(0, candidates.len() - 1)].getName()
		]);
		_vars.push([
			"notweaponbrother",
			not_candidates[this.Math.rand(0, not_candidates.len() - 1)].getName()
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

