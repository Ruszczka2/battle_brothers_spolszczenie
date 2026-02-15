this.hammer_mastery_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.hammer_mastery";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nasza kompania jest kiepsko przygotowana do walki z opancerzonymi przeciwnikami.\nWyszkolimy dwóch ludzi w młotach, a żaden rycerz nie sprawi nam problemu.";
		this.m.UIText = "Miej ludzi z mistrzostwem w młotach";
		this.m.TooltipText = "Miej 2 ludzi z talentem mistrzostwa w młotach.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]Ludzie zbierają się, by podziwiać kunszt %hammerbrother%, gdy ćwiczy uderzenia w sosnę, trzask-trzask-trzask.%SPEECH_ON%Patrzcie na ten łeb młota! Tym można przebić każdy hełm i zajrzeć, co jest w tej czaszce!%SPEECH_OFF%Zamachuje się raz jeszcze i pień pęka na pół, a górna część spada prosto do obozu. %nothammerbrother% zrywa się z miejsca, rozlewając na siebie zupę, i o włos unika zgniecenia.%SPEECH_ON%Myślałem, że nie ma już na świecie nic nowego do zobaczenia, ale nigdy nie zabiłem człowieka spadającym drzewem!%SPEECH_OFF%%hammerbrother% krzyczy z uśmiechem. Przewidujesz, że następnym razem, gdy staniesz przeciw ciężko opancerzonym wrogom, poradzisz sobie znakomicie.";
		this.m.SuccessButtonText = "Pancerz, jaki pancerz?";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(2, this.getBrosWithMastery()) + "/2)";
	}

	function getBrosWithMastery()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local count = 0;

		foreach( bro in brothers )
		{
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInHammers)
			{
				count = ++count;
				count = count;
			}
		}

		return count;
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 30)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local count = this.getBrosWithMastery();

		if (count >= 2)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local count = this.getBrosWithMastery();

		if (count >= 2)
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

			if (p.IsSpecializedInHammers)
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
			this.candiates = not_candidates;
		}

		_vars.push([
			"hammerbrother",
			candidates[this.Math.rand(0, candidates.len() - 1)].getName()
		]);
		_vars.push([
			"nothammerbrother",
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

