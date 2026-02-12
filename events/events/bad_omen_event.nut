this.bad_omen_event <- this.inherit("scripts/events/event", {
	m = {
		Superstitious = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.bad_omen";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_12.png[/img]Krzyki smagają przez kompanię niczym wycie wiatru. Na horyzoncie nie ma wroga, więc nie masz pojęcia, skąd to się bierze. Przechodzisz szeregi i znajdujesz %superstitious% praktycznie szlochającego na ziemi. Jedną ręką ściska pierś, drugą wskazuje niebo, a palec drży w wyraźnym strachu. %otherguy% wyjaśnia, że mężczyzna widział wielki ogień, który przeciął gwiazdy. Ten żałosny głupiec uznał to za omen i oczywiście nie jest to dobry omen. Cokolwiek to jest, nie zaprowadzi cię tam, gdzie musisz być, więc każesz ludziom maszerować. | [img]gfx/ui/events/event_12.png[/img] Cienie zaczynają dziwnie składać się w sobie. Odwracasz się i widzisz, jak słońce ciemnieje, a czarny krąg przesuwa się po nim. Wkrótce nie ma już słońca. %superstitious% krzyczy, że nadchodzą czasy ostateczne, ale zanim jego zawodzenie porwie resztę ludzi, wielki cień znów odsłania słońce i wraca światło, jakby nic się nie stało. Każesz żałosnemu głupcowi wstać. Masz dokąd maszerować, a łzy na pewno cię tam nie zaprowadzą. | [img]gfx/ui/events/event_11.png[/img] %superstitious% szturcha mieczem króliczą norę, gdy nagle krzyczy. Odskakuje od nory i wrzeszczy, że w środku jest dwugłowy królik. Najwyraźniej to zły omen tego, co nadejdzie. Ty myślisz tylko o tym, że dwa łby to więcej mięsa do gulaszu. | [img]gfx/ui/events/event_11.png[/img]Przechodzisz pod drzewem, na którego gałęziach siedzą jednocześnie czarny kot i albinoski kruk. %superstitious% krzyczy na ten widok, mówiąc, że to na pewno znak końca czasów. No tak, oczywiście. Takie rzeczy nigdy nie są znakiem dobrych wydarzeń, prawda? Eee tam. | [img]gfx/ui/events/event_11.png[/img] Natrafiasz na czaszkę jelenia. Na początku nic dla ciebie nie znaczy, ale %superstitious% podnosi ją z powagą. Z wnęki wysypuje się przytłumiony pył, gdy obraca ją w tę i z powrotem. Drżącymi rękami wyrzuca czaszkę z dłoni. Głucho uderza o ziemię, przewracając się na miejsce, gdzie powinny być poroże. Przestraszony mężczyzna twierdzi, że kiedyś wieszcz powiedział mu, iż natknie się na taką czaszkę.\n\nCzaszek jest tu wiele, odpowiadasz, bo rzeczy mają skłonność do umierania. Twoje słowa nic mu nie dają, bo powoli i nerwowo wraca do maszerującego szeregu. | [img]gfx/ui/events/event_11.png[/img] Maszerując, kilku ludzi zaczyna zabawę w szukanie kształtów w chmurach. Przerzucają się żartami o psach, grubych kobietach i nawet o domu, ale zabawa nagle się urywa, gdy %superstitious% dostrzega jedną dziwacznie ukształtowaną chmurę, która powala go na kolana. Krzyczy, że to zły omen, ta chmura, i że wkrótce spadnie na kompanię zguba. Na szczęście strach nie chwyta reszty kompanii, która zamiast drżeć, wkrótce zaczyna kłócić się o to, czy chmura naprawdę przypomina imponujące przyrodzenie %randombrother%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{Weź się w garść! | A myślałem, że tylko dzieci mają takie głupie lęki.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Superstitious.getImagePath());
				local effect = this.new("scripts/skills/effects_world/afraid_effect");
				_event.m.Superstitious.getSkills().add(effect);
				_event.m.Superstitious.worsenMood(1.0, "Widział zły omen");
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Superstitious.getName() + " jest przerażony"
				});

				if (_event.m.Superstitious.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Superstitious.getMoodState()],
						text = _event.m.Superstitious.getName() + this.Const.MoodStateEvent[_event.m.Superstitious.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2 || !this.World.getTime().IsDaytime)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if ((bro.getSkills().hasSkill("trait.superstitious") || bro.getSkills().hasSkill("trait.mad")) && !bro.getSkills().hasSkill("effects.afraid"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Superstitious = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Superstitious.getID())
			{
				this.m.OtherGuy = bro;
				break;
			}
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"superstitious",
			this.m.Superstitious.getName()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onClear()
	{
		this.m.Superstitious = null;
		this.m.OtherGuy = null;
	}

});

