this.petrified_scream_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.petrified_scream";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_12.png[/img]{Kilku ludzi wpada do twojego namiotu, każdy z szeroko otwartymi oczami i spocony. Odskakują bezwiednie od dotyku innych albo gwałtownie odpychają. Pytasz, o co chodzi, a oni tłumaczą się jak rozkrzyczany tłum, niczym ptaki wrzeszczące na kogoś, kto chowa przed nimi okruszek chleba. Trzeba chwilę to poskładać, ale wygląda na to, że artefakt przesądnie zwany \'skamieniałym krzykiem\' wywołuje u nich koszmary. Mówisz im, że przedmiot jest w zapasach i nie stanowi zagrożenia. Ludzie cicho wychodzą.\n\n Wracasz do mapy, tylko po to, by zobaczyć coś czarnego schowanego pod papierem. Podnosisz kartę i znajdujesz tam maskę śmierci alpa, z rozwartą paszczą w upiornej, czarnej trwałości. Patrzysz na maskę, słyszysz w niej coś, coś klekoczącego zębami jak rzucone kości, a jej boki zdają się drżeć, przez co skóra wygląda, jakby bulgotała. Wzruszasz ramionami i ze śmiechem kładziesz ją na mapie jako przycisk do papieru. To cholerstwo się zgubi, jeśli ludzie będą je tak przestawiać.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jak wam się udaje to wciąż gubić?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.fearless") || bro.getSkills().hasSkill("trait.brave"))
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.superstitious") || bro.getSkills().hasSkill("trait.paranoid") || bro.getSkills().hasSkill("trait.dastard") || bro.getSkills().hasSkill("trait.craven") || bro.getSkills().hasSkill("trait.mad") || this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(0.75, "Niepokoi go noszenie artefaktu Skamieniałego Krzyku");

						if (bro.getMoodState() <= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local items = 0;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.petrified_scream")
			{
				items = ++items;
				break;
			}
		}

		if (items == 0)
		{
			return;
		}

		this.m.Score = items * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

