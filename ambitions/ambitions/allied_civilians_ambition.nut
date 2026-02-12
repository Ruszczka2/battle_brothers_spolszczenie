this.allied_civilians_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.allied_civilians";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Potrzebujemy sojuszników. Wytworzenie więzi przyjaźni i zaufania z jednym\nz miast zapewni nam lepsze ceny, więcej ochotników i stabilny napływ kontraktów.";
		this.m.UIText = "Uzyskaj \'Przyjazne\' relacje z frakcją cywili";
		this.m.RewardTooltip = "Dobre relacje zapewnią ci lepsze ceny i więcej ludzi do zwerbowania.";
		this.m.TooltipText = "Zwiększ relacje z frakcją cywili jednej z wiosek lub miast do poziomu \'Przyjazny\', poprzez wypełnianie kontraktów w danej osadzie frakcji. Nieudane kontrakty i zdradzanie zaufania ludności obniży twoje relacje. Zwiększanie relacji z państwami-miastami trwa dłużej, niż poprawianie relacji z małymi wioskami. Rody szlacheckie nie zaliczają się do frakcji cywili.";
		this.m.SuccessText = "[img]gfx/ui/events/event_65.png[/img]Uznając, że %friendlytown% jest dobrym miejscem, aby zainwestować w nie swoje starania, decydujesz się zaoferować ochronę kompanii i podejmujesz każdą pracę stosowną do twoich talentów. Wykazujesz się grzecznością, gdy zadajesz się z miejscowymi, a swych ludzi namawiasz do pilnowania swoich manier podczas wizyt w osadzie. Z początku oczywiście były biadolenia. %brawler% był rozczarowany tym, że musi skończyć ze wszczynaniem bójek z rolnikami, zwłaszcza gdy kompania tak wiele czasu spędzała w osadzie %friendlytown%.\n\nPrzekonałeś jednak ludzi, że posiadanie przyjaznej bazy wypadowej jest istotne w waszym zawodzie, gdyż oznacza to lepsze ceny na targu i więcej ludzi skłonnych dołączyć do waszej wesołej bandy. Ponadto nie trzeba się cały czas martwić starciami z miejscową milicją. Zaciągnąłeś też ludzi od wykonania drobnych zadań, w których nagrodą były tylko podziękowania.%SPEECH_ON%Znalazłem tego małego nicponia, który się zawieruszył i zaciągnąłem go prosto do jego domu.%SPEECH_OFF%Przechwala się %randombrother%, po czym %randombrother2% szybko mu się wcina.%SPEECH_ON%Poszedłem na trag dla tej starej panny, narąbałem jej drewna na zimę, a nawet wywiesiłem pranie, ale odmówiłem ratowania kotów z drzew.%SPEECH_OFF%";
		this.m.SuccessButtonText = "To nam pomoże.";
	}

	function onUpdateScore()
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && (f.getType() == this.Const.FactionType.Settlement || f.getType() == this.Const.FactionType.OrientalCityState) && f.getPlayerRelation() >= 70.0)
			{
				this.m.IsDone = true;
				return;
			}
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);

		foreach( a in allies )
		{
			local f = this.World.FactionManager.getFaction(a);

			if (f != null && (f.getType() == this.Const.FactionType.Settlement || f.getType() == this.Const.FactionType.OrientalCityState) && f.getPlayerRelation() >= 70.0)
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

			if (f != null && (f.getType() == this.Const.FactionType.Settlement || f.getType() == this.Const.FactionType.OrientalCityState) && f.getPlayerRelation() >= 70.0)
			{
				_vars.push([
					"friendlytown",
					f.getName()
				]);
				break;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() > 1)
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
			if (bro.getBackground().getID() == "background.brawler")
			{
				_vars.push([
					"brawler",
					bro.getName()
				]);
				return;
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getBackground().isCombatBackground())
			{
				_vars.push([
					"brawler",
					bro.getName()
				]);
				return;
			}
		}

		_vars.push([
			"brawler",
			brothers[this.Math.rand(0, brothers.len() - 1)].getName()
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

