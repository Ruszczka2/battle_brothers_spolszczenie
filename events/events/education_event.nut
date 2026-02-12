this.education_event <- this.inherit("scripts/events/event", {
	m = {
		DumbGuy = null,
		Scholar = null
	},
	function create()
	{
		this.m.ID = "event.education";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_15.png[/img]W trakcie podróży %scholar% zainteresował się intelektualnymi brakami %dumbguy%. %scholar_short% twierdzi, że przy odrobinie czasu mógłby nauczyć tego człowieka paru rzeczy. %dumbguy_short% potrafi stawiać jedną nogę przed drugą - czasem nawet całkiem pewnie - ale sądzisz, że na tym kończą się jego zdolności do wszystkiego. Na dodatek %scholar_short% w przeszłości łatwo się frustrował. Nauczanie głupszego brata może być jedynie ćwiczeniem w pompowaniu własnego ego.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zobaczymy, czego możesz go nauczyć.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 60 ? "B" : "C";
					}

				},
				{
					Text = "Zostaw %dumbguy% w spokoju.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Scholar.getImagePath());
				this.Characters.push(_event.m.DumbGuy.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_15.png[/img]{Zastajesz %scholar% i %dumbguy% wpatrzonych w skrawek ziemi. Na brunatnym płótnie widzisz, że %scholar_short% narysował figury geometryczne, litery, liczby i coś, co wygląda jak gwiazdozbiory. Wygląda na to, że siedzą nad tym od godzin. \n\nZ kijkiem do nauki w dłoni %scholar% szaleńczo wskazuje jeden z gwiezdnych układów i żąda odpowiedzi, co to jest. %dumbguy%, z bolesnym grymasem, zgaduje owcę. %scholar% łamie kij na pół i kopie ziemię na swoje rysunki. To koń! Koń! %scholar% ciężko wzdycha, po czym odchodzi, wyrzucając z siebie strumień przekleństw. Osobiście sądziłeś, że to krab. | Zastajesz %scholar% stojącego nad %dumbguy%. Licz chrząszcze, nie miażdż ich, mówi uczony z rozdrażnieniem. %dumbguy% spogląda na swoje dłonie ociekające chrząszczami, po których {widać fragmenty pancerzy owadów | widać pancerze dawnych owadów}. Kiwając głową ze zrozumieniem, zaczyna wyrywać im nogi. %scholar% wypuszcza z siebie ciąg przekleństw, jakich nigdy w życiu nie słyszałeś. | Zastajesz %scholar% i %dumbguy% krzyczących na siebie. Wygląda na to, że dotarli do punktu zapalnego. %dumbguy_short% mówi, że nie obchodzi go, że jest głupi, a %scholar_short% twierdzi, że każdy człowiek powinien się uczyć. Cóż, wygląda na to, że %dumbguy_short% woli zostać sam, bo odwraca się do %scholar_short% plecami i odchodzi. Chyba to koniec lekcji dla obu. | Znajdujesz %dumbguy% kucającego przy strumyku i wpatrującego się w migotliwe odbicie. Musi to robić od jakiegoś czasu, bo widać u niego oznaki poparzenia słońcem. Pytasz, czy wszystko w porządku, na co wyjaśnia, że \"nie łapie\" nauk %scholar% i że %scholar% prawie oszalał, zanim w końcu zrezygnował. Wyjaśniasz, że %dumbguy% nie musi być mądry, wystarczy, że umie machać mieczem i strzelać z łuku. Po to go w końcu nająłeś. Mężczyzna próbuje ukryć uśmiech, ale płynąca woda go zdradza. Zabierasz go z powrotem do obozu, gdzie mówisz %scholar%, by przez jakiś czas dał spokój.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{Czemu nie chcesz się uczyć?! | Ignorancja to błogosławieństwo.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Scholar.getImagePath());
				this.Characters.push(_event.m.DumbGuy.getImagePath());
				_event.m.Scholar.worsenMood(2.0, "Failed to teach " + _event.m.DumbGuy.getName() + " anything");

				if (_event.m.Scholar.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List = [
						{
							id = 10,
							icon = this.Const.MoodStateIcon[_event.m.Scholar.getMoodState()],
							text = _event.m.Scholar.getName() + this.Const.MoodStateEvent[_event.m.Scholar.getMoodState()]
						}
					];
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_15.png[/img]{Zastajesz %dumbguy% rozważającego stos monet na stole. Pytasz, co robi, a on mówi, że próbuje obliczyć, ile odłożyć na emeryturę. Po pierwsze, dziwi cię, że w ogóle zna słowo \"emerytura\". Po drugie, liczenie? Wygląda na to, że możesz być winien %scholar% kufel. | Zastajesz %dumbguy% siedzącego na pniu i piszącego na zwoju. Gdy pytasz, co robi, mówi, że pisze list. Kiedy pytasz, do kogo jest adresowany, mężczyzna spogląda w górę z zakłopotanym uśmiechem i pyta: czy to ma znaczenie? W tej samej chwili dostrzegasz %scholar% w oddali, ze skrzyżowanymi ramionami i zadowoleniem na twarzy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fascynujące.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Scholar.getImagePath());
				this.Characters.push(_event.m.DumbGuy.getImagePath());
				_event.m.Scholar.improveMood(2.0, "Taught " + _event.m.DumbGuy.getName() + " something");
				_event.m.DumbGuy.getSkills().removeByID("trait.dumb");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_17.png",
					text = _event.m.DumbGuy.getName() + " nie jest już głupi"
				});

				if (_event.m.Scholar.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Scholar.getMoodState()],
						text = _event.m.Scholar.getName() + this.Const.MoodStateEvent[_event.m.Scholar.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local dumb_candidates = [];
		local scholar_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.dumb"))
			{
				dumb_candidates.push(bro);
			}
			else if ((bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.historian") && !bro.getSkills().hasSkill("trait.hesitant"))
			{
				scholar_candidates.push(bro);
			}
		}

		if (dumb_candidates.len() == 0 || scholar_candidates.len() == 0)
		{
			return;
		}

		this.m.DumbGuy = dumb_candidates[this.Math.rand(0, dumb_candidates.len() - 1)];
		this.m.Scholar = scholar_candidates[this.Math.rand(0, scholar_candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dumbguy",
			this.m.DumbGuy.getName()
		]);
		_vars.push([
			"dumbguy_short",
			this.m.DumbGuy.getNameOnly()
		]);
		_vars.push([
			"scholar",
			this.m.Scholar.getName()
		]);
		_vars.push([
			"scholar_short",
			this.m.Scholar.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.DumbGuy = null;
		this.m.Scholar = null;
	}

});

