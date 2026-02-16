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
			Text = "[img]gfx/ui/events/event_46.png[/img]{Pozornie znikąd, co sobie wyobrażasz jako jego ulubiony sposób bycia, %killer% mimochodem wspomina, że gdzieś tu zakopał ciało. Wiesz, że to zbieg, ale z grzeczności pytasz, skąd o tym wie. Odpowiada bez owijania:%SPEECH_ON%Bo ja ich zabiłem i ukryłem zwłoki tutaj. Wiesz, to było dobre zabójstwo. Mówię tak, bo ten człowiek cierpiał na choroby.%SPEECH_OFF%Samo słowo \"choroby\" sprawia, że anatomisci podnoszą głowy, jakby jastrzębie zobaczyły mysz. Wkrótce, ku twojej irytacji, medyczna gromada wykopuje zwłoki. Długo dyskutują o tym, co mogło dręczyć ciało. To poza twoją wiedzą, ale grupa zgadza się, że poznanie tego przyniesie duże postępy w ich badaniach. Gdy rozmowy się kończą, %killer% podchodzi do ciebie z drwiną. Mówi, że zabił tę osobę, bo sprawiało mu to przyjemność, i że dobrze było zobaczyć ciało ponownie.%SPEECH_ON%Szkoda tylko, że ci jajogłowi tak je obmacali. Zasłużyłoby na więcej troski, więcej...czasu.%SPEECH_OFF%Oddalasz się od niego i prowadzisz tę dziwną kompanię z powrotem na drogę.}",
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
				_event.m.Killer.improveMood(1.0, "Wspominał dawne zabójstwo");
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
							text = bro.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+50[/color] Doświadczenia"
						});
						bro.improveMood(1.0, "Mógł zbadać interesujące, skażone zwłoki");

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

