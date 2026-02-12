this.aging_swordmaster_paycut_event <- this.inherit("scripts/events/event", {
	m = {
		Swordmaster = null
	},
	function create()
	{
		this.m.ID = "event.aging_swordmaster_paycut";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]%swordmaster% wchodzi do twojego namiotu. Wskazujesz mu krzesło po drugiej stronie stołu. Siada tak powoli i słabo, że obawiasz się, iż podniesienie się zajmie mu dwa razy dłużej. Mężczyzna splata dłonie i opiera łokcie na stole, mrucząc i poruszając się, nie znajdując wygody nawet w bezruchu. Ma suche usta, twarz pomarszczoną. Plamy starcze pokrywają jego głowę, a nawet włosy wokół nosa i uszu są siwe.\n\n Zawsze masz czas dla %swordmaster%, więc pytasz, o czym chce porozmawiać.%SPEECH_ON%To może brzmieć dziwnie z ust najemnego ostrza, ale i tak trzeba to powiedzieć, a mnie pozwoliłoby lepiej spać. Powiem wprost: nie jestem już tym człowiekiem, którego zatrudniłeś dawno temu. Ty to wiesz. Ja to wiem. Niektórzy z ludzi też to wiedzą, ale szanują to, jak dobrzy ludzie potrafią.%SPEECH_OFF%Zgadzasz się, ale nie kiwasz głową. Zamiast tego pytasz, do czego zmierza.%SPEECH_ON%Chcę obniżyć swoją płacę. Nie mów od razu nie, nie musisz mnie oszukiwać. Wezmę cięcie. Pieniądze i tak nigdy nie były problemem. Te korony mogą pomóc uzbroić ludzi albo nawet lepiej im płacić. Bóg wie, że młodym zawsze przyda się dodatkowa korona czy dwie.%SPEECH_OFF%Zanim powiesz kolejne słowo, mężczyzna zrywa się na nogi z zaskakującą szybkością. Kiwa głową i uśmiecha się figlarnie, po czym głośno woła.%SPEECH_ON%Zgadzam się z twoją decyzją, dobry panie. Przyda mi się obniżka!%SPEECH_OFF%Śmiejesz się, gdy mężczyzna wychodzi z namiotu niemal tak szybko, jak do niego wszedł.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Honorowy człowiek, jeśli kiedykolwiek taki istniał.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				_event.m.Swordmaster.getBaseProperties().DailyWage -= _event.m.Swordmaster.getDailyCost() / 2;
				_event.m.Swordmaster.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Swordmaster.getName() + " otrzymuje teraz " + _event.m.Swordmaster.getDailyCost() + " koron dziennie"
				});
				_event.m.Swordmaster.getFlags().add("aging_paycut");
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.swordmaster" && !bro.getFlags().has("aging_paycut") && !bro.getSkills().hasSkill("trait.old"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Swordmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = this.m.Swordmaster.getLevel();
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"swordmaster",
			this.m.Swordmaster.getName()
		]);
	}

	function onClear()
	{
		this.m.Swordmaster = null;
	}

});

