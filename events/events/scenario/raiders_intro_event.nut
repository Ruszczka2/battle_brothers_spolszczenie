this.raiders_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.raiders_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_94.png[/img]{Po tym, jak ty i twoja drużyna zabiliście połowę z nich, wieśniacy w końcu ulegli. Wzniesiono białą flagę i zaproponowano rozejm, na który z chęcią się zgodziłeś. Gęsiego wychodzili z rynku, na którym odbywał się jarmark. Klejnoty oraz skarby wypełniały ich dłonie i upuszczali wszystko tam, gdzie stałeś, z butem na zmiażdżonej czaszce ich burmistrza. Twoja przednia straż, w której byli %raider1%, %raider2%, %raider3% oraz %raider4%, uważnie obserwowała całą ceremonię, niczym myszołowy obserwujące powolną śmierć.\n\n Na końcu szedł mnich. Nie miał przy sobie złota ni srebra, lecz przemówił do ciebie, a na jego słowa twoi towarzysze natychmiastowo chwycili za broń. Pozwoliłeś mu mówić, a on zaczął rozprawiać o dawnych bogach i jak to skarby niebios detronizują wszelkie te, które oferuje żywot doczesny. Odpowiedziałeś mu, że tą paplaniną wydał na siebie wyrok śmierci. Mnich wydął wargi.%SPEECH_ON%W porządku, jeśli wiec złota szukasz, skończ z tymi śmiesznymi grami. To całe napadanie i plądrowanie jest bezwartościowe w porównaniu z bogactwami, które można znaleźć na południu. Szlachta nie weźmie cię do swych armii, ale zawsze jednak potrzebują najemników i rzadko mogą pozwolić sobie na czas i luksus wybierania, skąd ci wojownicy mają pochodzić. Zarobiłbyś tyle, ile tylko byś chciał. Udajcie się na południe, najeźdźcy, i zostańcie najemnikami.%SPEECH_OFF%%raider3% domaga się głowy mnicha, ale ty wstrzymujesz egzekucję. Przeciwnie, usłuchasz mnicha. Już od dawno słyszysz o bogactwach południa oraz o niesamowitych podróżach ludzi, którzy oferują swe miecze na wynajem. Postanawiasz wyruszyć na południe - o ile mnich ruszy z wami. %raider3% protestuje, ale ty puszczasz to mimo uszu. Jeśli ten blady, zasrany mnich ma być twoim talizmanem przynoszącym szczęście, to zostawienie go byłoby zniewagą wobec dawnych bogów. Najeźdźca oddala się, ale %raider1%, %raider2% i %raider4% nie mają nic przeciwko, by ruszyć z tobą. Reszta oddziału wraca na północ, łupy zostają podzielone. Zostawiacie za sobą to, co zostało z wioski, aby odbudowała się ona i zapewniła nowe towary dla innych silnych klanów, które przybędą tu łupić po was.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Uderzymy na południe.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Północni Najeźdźcy";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"raider1",
			brothers[0].getName()
		]);
		_vars.push([
			"raider2",
			brothers[1].getName()
		]);
		_vars.push([
			"raider3",
			this.Const.Strings.BarbarianNames[this.Math.rand(0, this.Const.Strings.BarbarianNames.len() - 1)]
		]);
		_vars.push([
			"raider4",
			brothers[2].getName()
		]);
	}

	function onClear()
	{
	}

});

