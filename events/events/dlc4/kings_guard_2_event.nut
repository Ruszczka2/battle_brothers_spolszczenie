this.kings_guard_2_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.kings_guard_2";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 9999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]{Zastajesz %guard% rozciągającego się z zaskakującą gibkością. W niczym nie przypomina zamarzającego, zlodowaciałego człowieka, którego znalazłeś porzuconego w lodzie przez tamtych barbarzyńców. Gdy cię dostrzega, kiwa głową i podchodzi cichym głosem.%SPEECH_ON%Cieszę się, że mi zaufałeś, kapitanie. Może zrobiłeś to z dobroci serca, ale muszę ci coś pokazać.%SPEECH_OFF%Pokazuje ci emblemat, o którym wiele słyszałeś, lecz nigdy go nie widziałeś: nosi znak Gwardii Królewskiej i jest tak nieskazitelny, że nie mógłby być fałszerstwem. Mężczyzna uśmiecha się do ciebie.%SPEECH_ON%Myślę, że jestem w dobrym zdrowiu i gotów służyć ci tak, jak służyłem mojemu seniorowi.%SPEECH_OFF%Królowie tych ziem dawno upadli, zastąpieni przez skłóconych lordów i możnych. Jeśli ten człowiek potrafi walczyć dla ciebie tak, jak walczył dla królów, to %companyname% na pewno czekają jaśniejsze dni.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cieszę się, że znaleźliśmy cię tamtego dnia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				local bg = this.new("scripts/skills/backgrounds/kings_guard_background");
				bg.m.IsNew = false;
				_event.m.Dude.getSkills().removeByID("background.cripple");
				_event.m.Dude.getSkills().add(bg);
				_event.m.Dude.getBackground().m.RawDescription = "Znalazłeś %name% na północy, zamarzniętego na pół śmierci. Z twoją pomocą były członek Gwardii Królewskiej odzyskał siły i teraz walczy dla ciebie.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.improveMood(1.0, "Znów jest sobą");

				if (_event.m.Dude.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}

				_event.m.Dude.getBaseProperties().MeleeSkill += 12;
				_event.m.Dude.getBaseProperties().MeleeDefense += 7;
				_event.m.Dude.getBaseProperties().RangedDefense += 7;
				_event.m.Dude.getBaseProperties().Hitpoints += 15;
				_event.m.Dude.getBaseProperties().Stamina += 10;
				_event.m.Dude.getBaseProperties().Initiative += 10;
				_event.m.Dude.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Dude.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+7[/color] Obrony w zwarciu"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.Dude.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+7[/color] Obrony dystansowej"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Dude.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+12[/color] Umiejętności walki wręcz"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Dude.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+10[/color] maks. zmęczenia"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Dude.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+10[/color] Inicjatywy"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.Dude.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+15[/color] Punktów życia"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidate;

		foreach( bro in brothers )
		{
			if (bro.getDaysWithCompany() >= 30 && bro.getFlags().get("IsKingsGuard"))
			{
				candidate = bro;
				break;
			}
		}

		if (candidate == null)
		{
			return;
		}

		this.m.Dude = candidate;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"guard",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

