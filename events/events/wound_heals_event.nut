this.wound_heals_event <- this.inherit("scripts/events/event", {
	m = {
		Injured = null
	},
	function create()
	{
		this.m.ID = "event.wound_heals";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{Dobrze, że już wróciłeś. | Jak nowy.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local bg = _event.m.Injured.getBackground().getID();

				if (bg == "background.monk" || bg == "background.flagellant" || bg == "background.pacified_flagellant" || bg == "background.monk_turned_flagellant" || bg == "background.cultist")
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]{Idziesz sprawdzić %hurtbrother% - niedawno doznał strasznej rany, a czasem może to podnieść mężczyźnie na duchu, gdy wie, że inni się o niego troszczą. Myśląc, że znajdziesz go pielęgnującego swoje obrażenia, jesteś zaskoczony widząc go w dobrym zdrowiu. Rany najwyraźniej zagoiły się tak szybko, że inni mogliby nazwać to cudem. | %hurtbrother% został ranny w bitwie i uznałeś, że najlepiej będzie sprawdzić, jak się ma. O dziwo, czuje się całkiem nieźle. Jego rany zagoiły się tak szybko, że prawie chciałbyś uwierzyć, że konsultował się z ciemnymi mocami, gdy nikt nie patrzył. Nie ma śladów czarnej magii, tylko jeden wytrzymały i trudny do zabicia człowiek z krwi i kości. | %hurtbrother% wchodzi do twojego namiotu i pokazuje swoją ranę - lub to, co z niej zostało. Ta okropna rzecz najwyraźniej całkowicie się zagoiła. Najemnik patrzy na ciebie z radosnym uśmiechem.%SPEECH_ON%Będą musieli się bardziej postarać, żeby mnie stąd zabrać, kapitanie.%SPEECH_OFF% | %hurtbrother% wchodzi do twojego namiotu i pokazuje starą ranę. Mówi z ekscytacją.%SPEECH_ON%Czy to nie cud?%SPEECH_OFF%Obrażenie prawie całkowicie się zagoiło. Mówisz mu, że jest zrobiony z twardszego materiału i bogowie nie mieli z tym nic wspólnego. Kręci głową.%SPEECH_ON%Musisz mieć więcej wiary.%SPEECH_OFF% | Szukasz %hurtbrother% - ostatnio widziałeś, jak najemnik doznał sporego urazu. Mężczyzna jednak jest w dobrym humorze. Odwraca się do ciebie, robiąc przerwę od ostrzenia stali.%SPEECH_ON%Potrzebujesz czegoś, panie?%SPEECH_OFF%Pytasz o jego ranę. Wzrusza ramionami.%SPEECH_ON%Nie umieram łatwo. {Jadłem dużo tych pomarańczowych spiczastych rzeczy, gdy byłem młody. | Jadłem dużo sałaty dorastając. Można powiedzieć, że jestem trudny do... zabicia.}%SPEECH_OFF%}";
				}
				else
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]{Idziesz sprawdzić %hurtbrother% - niedawno doznał strasznej rany, a czasem może to podnieść mężczyźnie na duchu, gdy wie, że inni się o niego troszczą. Myśląc, że znajdziesz go pielęgnującego swoje obrażenia, jesteś zaskoczony widząc go w dobrym zdrowiu. Rany najwyraźniej zagoiły się tak szybko, że inni mogliby nazwać to cudem. | %hurtbrother% został ranny w bitwie i uznałeś, że najlepiej będzie sprawdzić, jak się ma. O dziwo, czuje się całkiem nieźle. Jego rany zagoiły się tak szybko, że prawie chciałbyś uwierzyć, że konsultował się z ciemnymi mocami, gdy nikt nie patrzył. Nie ma śladów czarnej magii, tylko jeden wytrzymały i trudny do zabicia człowiek z krwi i kości. | %hurtbrother% wchodzi do twojego namiotu i pokazuje swoją ranę - lub to, co z niej zostało. Ta okropna rzecz najwyraźniej całkowicie się zagoiła. Najemnik patrzy na ciebie z radosnym uśmiechem.%SPEECH_ON%Będą musieli się bardziej postarać, żeby mnie stąd zabrać, kapitanie.%SPEECH_OFF% | %hurtbrother% wchodzi do twojego namiotu i pokazuje starą ranę. Mówi z ekscytacją.%SPEECH_ON%Czy to nie cud?%SPEECH_OFF%Obrażenie prawie całkowicie się zagoiło. Mówisz mu, że jest zrobiony z twardszego materiału i bogowie nie mieli z tym nic wspólnego. Kiwa głową.%SPEECH_ON%Tak, wiem. Ale byłoby miło, gdyby również na mnie patrzyli. Tak na wszelki wypadek...%SPEECH_OFF% | Szukasz %hurtbrother% - ostatnio widziałeś, jak najemnik doznał sporego urazu. Mężczyzna jednak jest w dobrym humorze. Odwraca się do ciebie, robiąc przerwę od ostrzenia stali.%SPEECH_ON%Potrzebujesz czegoś, panie?%SPEECH_OFF%Pytasz o jego ranę. Wzrusza ramionami.%SPEECH_ON%Nie umieram łatwo. {Jadłem dużo tych pomarańczowych spiczastych rzeczy, gdy byłem młody. | Jadłem dużo sałaty dorastając. Można powiedzieć, że jestem trudny do... zabicia.}%SPEECH_OFF%}";
				}

				this.Characters.push(_event.m.Injured.getImagePath());
				local injuries = _event.m.Injured.getSkills().query(this.Const.SkillType.TemporaryInjury);
				local injury = injuries[this.Math.rand(0, injuries.len() - 1)];
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Injured.getName() + " nie cierpi już na " + injury.getNameOnly()
					}
				];
				injury.removeSelf();
				_event.m.Injured.updateInjuryVisuals();
				_event.m.Injured.getSkills().update();
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() != "background.slave" && bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Injured = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hurtbrother",
			this.m.Injured.getName()
		]);
	}

	function onClear()
	{
		this.m.Injured = null;
	}

});

