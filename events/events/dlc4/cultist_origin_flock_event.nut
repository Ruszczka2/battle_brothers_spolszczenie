this.cultist_origin_flock_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_flock";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_03.png[/img]{%joiner%, wędrujący wyznawca Davkula, przybył, by dołączyć do %companyname%. Kompania zbiera się wokół niego, on kiwa głową, oni również, i tak po prostu jest z wami. | %joiner%, człowiek w łachmanach, a jednak opancerzony w cieniach Davkula, dołącza do %companyname%. | Mężczyzna imieniem %joiner% pokazuje ci swoje oddanie Davkulowi, serię duchowych rytuałów wyrytych na jego czaszce w postaci makabrycznych blizn. Zostaje przyjęty do %companyname%. | %joiner% śledził kompanię przez jakiś czas, zanim podszedł do ciebie bezpośrednio. Jest orędownikiem celu Davkula, a tym samym jego argument został przedstawiony, a ty sam tak samo do niego przychylony. Mężczyzna dołącza do kompanii. | Davkul z pewnością czuwa nad tobą, gdy mężczyzna imieniem %joiner% dołącza do %companyname%. Powiedział, że ma tylko jeden cel: znaleźć cię i dopilnować, by świat ujrzał wszystko, co go czeka. | %joiner% mówi, że widział cienie migoczące za twoim ciałem, jakby były \'z ognia\'. Oświadcza, że dołączy do twojej sprawy, bo Davkul z pewnością osadził w tobie aspekt mroku i nieskończoności. | %joiner% idzie obok ciebie. Nazywa cię aspektem mroku Davkula i twierdzi, że wieczne oczy z pewnością czuwają nad całą twoją kompanią. %companyname% bierze go pod swoje liczne, cieniste skrzydła. | %joiner% odnajduje %companyname% w marszu i dołącza do jego szeregów, jakby nie był obcym. Nikt nie mówi ani słowa, a ty po prostu kierujesz go do ekwipunku, gdzie jego cel może zbierać zęby. | Pokazując swoją zbliznowaciałą głowę, %joiner% oznajmia, że stoi na czubku włóczni celu Davkula. Kiwasz głową i witasz go w %companyname%. | Idąc w cieniu Davkula, musiałeś spotkać takich ludzi jak %joiner%. Chętnie dołączy do kompanii, szczególnie dlatego, że to ty nią dowodzisz, a jeszcze bardziej dlatego, że wierzy, iż Davkul cię wybrał. | %joiner% jednoczy się z kompanią i niewiele jest dyskusji, dlaczego. Zapytany, skąd pochodzi, wzrusza ramionami i mówi o Davkulu, kiwając znacząco głową w twoją stronę.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tak, dołącz do nas.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"cultist_background"
				]);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		this.m.Score = 75;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"joiner",
			this.m.Dude.getName()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

