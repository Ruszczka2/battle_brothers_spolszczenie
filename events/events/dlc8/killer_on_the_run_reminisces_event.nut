this.killer_on_the_run_reminisces_event <- this.inherit("scripts/events/event", {
	m = {
		Killer = null
	},
	function create()
	{
		this.m.ID = "event.killer_on_the_run_reminisces";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Pozornie znikad, co sobie wyobrazasz jako jego ulubiony sposob bycia, %killer% mimochodem wspomina, ze gdzies tu zakopal cialo. Wiesz, ze to zbieg, ale z grzecznosci pytasz, skad o tym wie. Odpowiada bez owijania:%SPEECH_ON%Bo ja ich zabilem i ukrylem zwloki tutaj. Wiesz, to bylo dobre zabojstwo. Mowie tak, bo ten czlowiek cierpial na choroby.%SPEECH_OFF%Samo slowo \"choroby\" sprawia, ze anatomisci podnosza glowy, jakby jastrzabie zobaczyly mysz. Wkrotce, ku twojej irytacji, medyczna gromada wykopuje zwloki. Dugo dyskutuja o tym, co moglo dręczyc cialo. To poza twoja wiedza, ale grupa zgadza sie, ze poznanie tego przyniesie duze postepy w ich badaniach. Gdy rozmowy sie koncza, %killer% podchodzi do ciebie z drwina. Mowi, ze zabil te osobe, bo sprawialo mu to przyjemnosc, i ze dobrze bylo zobaczyc cialo ponownie.%SPEECH_ON%Szkoda tylko, ze ci jajoglowi tak je obmacali. Zasluzyloby na wiecej troski, wiecej...czasu.%SPEECH_OFF%Oddalasz sie od niego i prowadzisz ta dziwna kompanie z powrotem na droge.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Taki to los, z kim gram...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Killer.getImagePath());
				_event.m.Killer.improveMood(1.0, "Wspominal dawne zabojstwo");
				local resolveBoost = this.Math.rand(1, 3);
				_event.m.Killer.getBaseProperties().Bravery += resolveBoost;
				_event.m.Killer.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Killer.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Determinacji"
				});

				if (_event.m.Killer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Killer.getMoodState()],
						text = _event.m.Killer.getName() + this.Const.MoodStateEvent[_event.m.Killer.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.anatomist")
					{
						bro.addXP(50, false);
						bro.updateLevel();
						this.List.push({
							id = 16,
							icon = "ui/icons/xp_received.png",
							text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+50[/color] Doswiadczenia"
						});
						bro.improveMood(1.0, "Mogl zbadac interesujace, skazone zwloki");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local killer_candidates = [];
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				killer_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (killer_candidates.len() == 0 || anatomist_candidates.len() <= 1)
		{
			return;
		}

		this.m.Killer = killer_candidates[this.Math.rand(0, killer_candidates.len() - 1)];
		this.m.Score = killer_candidates.len() * 1000;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"killer",
			this.m.Killer.getName()
		]);
	}

	function onClear()
	{
		this.m.Killer = null;
	}

});

