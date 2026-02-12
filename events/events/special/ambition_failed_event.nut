this.ambition_failed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.ambition_failed";
		this.m.Title = "Podczas obozowania...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%randombrother% marudzi.%SPEECH_ON%Poddawanie się nie jest w naszym stylu, a przynajmniej nie sądziłem, że jest.%SPEECH_OFF%Ludzie snują się dziś z kąta w kąt, głośno przeklinając z byle powodu i mamrocząc coś przy kuflu. Są niezadowoleni z tego, że kompania nie osiągnęła celu, który wszyscy zgodnie sobie wyznaczyli.%SPEECH_ON%Oczywiście moglibyśmy gonić za tym zadaniem po całym świecie, tam i z powrotem, tak jak i moglibyśmy marnować swe dni na gonieniu za motylami, lecz jeśli tego nie da się zrobić, zostawmy to niepowodzenie za sobą i zajmijmy się tym, co wychodzi nam najlepiej: walczenie, picie i wydawanie naszych ciężko zarobionych monet!%SPEECH_OFF%%highestexperience_brother% pociesza swych towarzyszy broni. Te słowa nieco uspakajają ludzi i cieszysz się, że nie musisz się mierzyć z buntem. | Gdy przechodzisz się obok namiotów obozu, zbliża się %randombrother%, by się pożalić%SPEECH_ON%O ile dobrze pamiętam, zaciągałem się do bandy bezlitosnych wojowników. Ludzi, na których drodze nic nie mogło stanąć. Teraz kompania %companyname% wydaje się być raczej grupką zmęczonych dzieci, niż siłą nie do zatrzymania.%SPEECH_OFF%Przerywa i przygryza wargi.%SPEECH_ON%Znaczy, kapitanie.%SPEECH_OFF%Przytakujesz i ruszasz dalej. Najwyraźniej jest rozgoryczony tym, że kompania nie zdołała wypełnić celu, który niedawno ogłosiłeś ludziom. | Pomimo swych najlepszych starań, zawiodłeś w wypełnieniu swej niedawnej ambicji na drodze kompanii do wspaniałości. Nawet gorzej, wszyscy twoi ludzie doskonale zdają sobie z tego sprawę i są bardziej przygaszeni tą porażką, niż ty sam. Widać powłóczenie nogami, opuszczone głowy oraz biadolenia i narzekania głośniejsze, niż zwykle.\n\nNadal jednak słońce tak samo wstaje i przejmowanie się jedną porażką to marnowanie czasu, który można poświęcić na nowe sposobności. Wiesz, że kompania %companyname% przezwycięży te chwilowe niedogodności i znów ruszy dziarskim krokiem naprzód ścieżką ku chwale. Albo zginie próbując. | Po wielu staraniach i próbach, musisz w końcu zrezygnować z ambicji, którą próbowała spełnić kompania. Kompania najemników musi się zmierzyć z wieloma komplikacjami w swej drodze ku chwale, jednak ta ostatnia porażka była niezwykle gorzka dla ludzi. Mądrze byłoby zająć się jakimś dochodowym kontraktem, albo czymś innym odciągnąć uwagę ludzi od ich niezadowolenia. | Po tym, jak powiedziałeś swym ludziom, że kompania nie da radę osiągnąć tego, co tak dumnie ogłaszałeś, wszyscy nagle spochmurnieli. Niczym nadąsane dzieci odwracają się na pięcie, gdy przechodzisz obok i narzekają szeptem za twymi plecami.%SPEECH_ON%Jak mamy stać się sławni, gdy nawet nie potrafimy skończyć tego, co zaczynamy? Chcę być znany wszędzie, dokądkolwiek się udamy, i żeby napełniano nam kufle zanim jeszcze przekroczymy próg gospody.%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{Nie wszystko idzie zgodnie z planem. | No cóż. | Ludzie to zrozumieją. | To nie powstrzyma naszej kompanii. | Najważniejsze jest to, że posuwamy się naprzód. | Nowe wyzwania oczekują.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(this.Const.MoodChange.AmbitionFailed, "Utracił przekonanie co do twego przywództwa");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
		return;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local lowest_hiretime = 100000000.0;
		local lowest_hiretime_bro;
		local highest_hiretime = -9999.0;
		local highest_hiretime_bro;
		local highest_bravery = 0;
		local highest_bravery_bro;
		local lowest_hitpoints = 9999;
		local lowest_hitpoints_bro;

		foreach( bro in brothers )
		{
			if (bro.getHireTime() < lowest_hiretime)
			{
				lowest_hiretime = bro.getHireTime();
				lowest_hiretime_bro = bro;
			}

			if (bro.getHireTime() > highest_hiretime)
			{
				highest_hiretime = bro.getHireTime();
				highest_hiretime_bro = bro;
			}

			if (bro.getCurrentProperties().getBravery() > highest_bravery)
			{
				highest_bravery = bro.getCurrentProperties().getBravery();
				highest_bravery_bro = bro;
			}

			if (bro.getHitpoints() < lowest_hitpoints)
			{
				lowest_hitpoints = bro.getHireTime();
				lowest_hitpoints_bro = bro;
			}
		}

		_vars.push([
			"highestexperience_brother",
			lowest_hiretime_bro.getName()
		]);
		_vars.push([
			"strongest_brother",
			lowest_hiretime_bro.getName()
		]);
		_vars.push([
			"lowestexperience_brother",
			highest_hiretime_bro.getName()
		]);
		_vars.push([
			"bravest_brother",
			highest_bravery_bro.getName()
		]);
		_vars.push([
			"lowesthp_brother",
			lowest_hitpoints_bro.getName()
		]);
		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearest_town_distance = 999999;
		local nearest_town;

		foreach( t in towns )
		{
			local d = t.getTile().getDistanceTo(playerTile);

			if (d < nearest_town_distance)
			{
				nearest_town_distance = d;
				nearest_town = t;
			}
		}

		_vars.push([
			"currenttown",
			nearest_town.getName()
		]);
		_vars.push([
			"nearesttown",
			nearest_town.getName()
		]);
	}

	function onClear()
	{
	}

});

