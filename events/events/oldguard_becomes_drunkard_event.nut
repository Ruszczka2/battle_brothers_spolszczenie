this.oldguard_becomes_drunkard_event <- this.inherit("scripts/events/event", {
	m = {
		Oldguard = null,
		Casualty = null,
		OtherCasualty = null
	},
	function create()
	{
		this.m.ID = "event.oldguard_becomes_drunkard";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_39.png[/img]Zastajesz %oldguard% przy ognisku, piastującego całkiem spory kufel. Właściwie to nie kufel, tylko drewniane wiadro wypełnione ale. Kilka skromniejszych kubków leży porozrzucanych u jego stóp. Odchyla głowę i pije z brzegu wiadra. Gdy cię widzi, próbuje się pozbierać, strząsa pianę z twarzy i próbuje uśmiechu, który szybko opada w pijacki grymas.%SPEECH_ON%Hej, kapitanie. Nie chciałem, byś widział mnie w takim stanie.%SPEECH_OFF%Siadasz obok niego i pytasz, jak się trzyma.%SPEECH_ON%Jestem pijany.%SPEECH_OFF%Kiwając głową, sięgasz po wiadro, a on je oddaje, choć jego dłonie układają się tak, jakby wciąż je trzymały. Odkładasz wiadro i znów pytasz, jak się czuje. W końcu opuszcza ręce na kolana.%SPEECH_ON%Jak gówno. Tak się czuję. Najpierw padł %casualty%. Potem %othercasualty%. Wiem, że było jeszcze co najmniej pięciu czy sześciu. Po prostu martwi ludzie. Przyszli i odeszli. Mam wspomnienia ich rozmów i wspomnienia ich krzyków, i nie potrafię mieć jednych bez drugich. Ale teraz jest w porządku, bo teraz nawet nie myślę jasno. Jeśli nie potrafię oduczyć się wspomnienia, to je utopię. Ale mi służy, heh.%SPEECH_OFF%Z westchnieniem oddajesz mu wiadro. Oczy utkwione w ogniu, myśli w przeszłości, nie mówi już nic.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Za nieobecnych przyjaciół...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Oldguard.getImagePath());
				local trait = this.new("scripts/skills/traits/drunkard_trait");
				_event.m.Oldguard.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Oldguard.getName() + " stał się pijakiem"
				});
				_event.m.Oldguard.worsenMood(1.0, "Stracił zbyt wielu przyjaciół");

				if (_event.m.Oldguard.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Oldguard.getMoodState()],
						text = _event.m.Oldguard.getName() + this.Const.MoodStateEvent[_event.m.Oldguard.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 7)
		{
			return;
		}

		local numFallen = 0;

		foreach( f in fallen )
		{
			if (!f.Expendable)
			{
				numFallen = ++numFallen;
			}
		}

		if (numFallen < 7)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist" || bro.getBackground().getID() == "background.slave")
			{
				continue;
			}

			if (bro.getLevel() >= 8 && !bro.getSkills().hasSkill("trait.drunkard") && this.World.getTime().Days - bro.getDaysWithCompany() < fallen[0].Time && this.World.getTime().Days - bro.getDaysWithCompany() < fallen[1].Time && !bro.getSkills().hasSkill("trait.player") && !bro.getFlags().get("IsPlayerCharacter"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Oldguard = candidates[this.Math.rand(0, candidates.len() - 1)];

		for( local i = 0; i < fallen.len(); i = ++i )
		{
			if (fallen[i].Expendable)
			{
			}
			else if (this.m.OtherCasualty == null)
			{
				this.m.OtherCasualty = fallen[i].Name;
			}
			else if (this.m.Casualty == null)
			{
				this.m.Casualty = fallen[i].Name;
			}
			else
			{
				break;
			}
		}

		this.m.Score = numFallen - 2;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oldguard",
			this.m.Oldguard.getName()
		]);
		_vars.push([
			"casualty",
			this.m.Casualty
		]);
		_vars.push([
			"othercasualty",
			this.m.OtherCasualty
		]);
	}

	function onClear()
	{
		this.m.Oldguard = null;
		this.m.Casualty = null;
		this.m.OtherCasualty = null;
	}

});

