this.webknecht_exposition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.webknecht_exposition";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Przy drodze znajdujesz mężczyznę ucierającego liście w moździerzu. Sam też żuje część ziół i spogląda na ciebie z zielonym uśmiechem.%SPEECH_ON%Całe życie zajmowałem się robactwem i owadami, ale te webknechty to zupełnie coś innego. Nigdy nie widziałem, żeby robak tak szybko się ruszał. Ciach i pędzą do przodu, porywają psy i koty i takie tam, wynoszą je. Trzymajcie się z daleka od tych cholernych pająków, słyszycie?%SPEECH_OFF%Nieznajomy spluwa i wraca do pracy, jakbyś w ogóle się nie pojawił. | Kobieta w drzwiach gospodarstwa przygląda się kompanii i kiwa głową. Z kuflem w ręku wskazuje na ciebie, chlupocząc napojem równie mocno, jak gada.%SPEECH_ON%O, pajęcze żarcie idzie? Co? To spadajcie, te ośmionożne cholerstwa nie lubią zabawy w czekanie, znajdą was, jak tylko zgłodnieją, a one są zawsze głodne, panie, zawsze ślinią się tą swoją trucizną, panie, panie.%SPEECH_OFF%Opróżnia kufel i z brzękiem cofa się do drzwi domu. | Spotykasz młodego mężczyznę wysoko na topoli. Jakimś cudem zbudował tam małą chatkę wielkości i kształtu wychodka. Patrzy na ciebie z góry i kiwa głową.%SPEECH_ON%Tak, pewnie nie wierzysz, że tu mieszkam, ale powiem ci jedno, te webknechty są szybkie. Pająki wielkości psa! A wiesz, co na to mówię? Pieprzyć to wszystko. Od teraz znajdziecie mnie na tych drzewach, a jeśli te cholerne bestie wyrosną skrzydła, to sam stąd zniknę, dziękuję bardzo.%SPEECH_OFF%Webknechty doprowadzają miejscowych do szału, choć trudno im się dziwić.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ktoś powinien nam zapłacić za radzenie sobie z nimi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		this.m.Score = 5;
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

