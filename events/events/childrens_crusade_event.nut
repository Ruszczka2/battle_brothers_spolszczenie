this.childrens_crusade_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null,
		Traveller = null
	},
	function create()
	{
		this.m.ID = "event.childrens_crusade";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 300.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]W drodze natrafiasz na małą armię dzieci. Najstarszy i największy ma chyba najwyżej piętnaście lat, z potarganą czupryną rudych włosów i włócznią za broń. Prowadzi gromadę, małą siłę zbrojną, bardziej związaną z traktem niż z jakimkolwiek miastem. Gdy mijacie się, ten mały przywódca kiwa ci głową.%SPEECH_ON%Z drogi! Jesteśmy na świętym marszu i nie damy się zatrzymać!%SPEECH_OFF%Ciekawy, pytasz, dokąd zmierzają. Dzieciak odpowiada, jakby nie mógł uwierzyć, że nie wiesz.%SPEECH_ON%No to ci powiem, najemniku. Idziemy na północ przez lodowe pustkowia. Dzicy i nieucywilizowani muszą poznać starych bogów, słowem albo mieczem.%SPEECH_OFF%Unosi włócznię. Z armii podnosi się dość wesoły "okrzyk bojowy". Wygląda na to, że religijny zapał ogarnął tę wędrującą i nieszkodliwą, a więc samobójczą, grupę.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Powinniście wrócić do rodziców, dzieciaki.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "%monk%, przemawiasz w imieniu starych bogów. Co powiesz?",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				if (_event.m.Traveller != null)
				{
					this.Options.push({
						Text = "%walker%, byłeś tam. Powiedz coś.",
						function getResult( _event )
						{
							return "Traveller";
						}

					});
				}

				this.Options.push({
					Text = "Oszczędzę wam długiej wędrówki i pozbawię was kosztowności tutaj.",
					function getResult( _event )
					{
						return "C";
					}

				});
				this.Options.push({
					Text = "Powodzenia, chyba.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_97.png[/img]Mówisz dzieciom, by wróciły do rodziców. Przywódca śmieje się, a reszta dołącza, jak małe dzieci z łatwością ulegające wpływowi starszego brata. Kręci głową.%SPEECH_ON%Myślisz, że po co zaszliśmy tak daleko? Nasi rodzice wiedzą, gdzie jesteśmy, i wiedzą, że to, gdzie jesteśmy, jest słuszne. Starych bogów trzeba poznać w całym kraju! A teraz z drogi!%SPEECH_OFF%Dzieci ruszają dalej. Mały sztandar trzepocze obok ciebie, słychać brzęk ich małych broni, głównie butelek, proc i kuchennych naczyń.\n\nNie ma wątpliwości, że maszerują ku pewnej zagładzie. Najeźdźcy i włóczędzy na pewno na nich zapolują, jak jastrzębie na lemingi, a handlarzom niewolników nie przeszkadza sprawić, by pozornie osierocone dzieci "zniknęły". Jeśli przejdą dalej niż te zagrożenia, północne pustkowia zapewnią im lodową trumnę.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Szczęść wam Boże.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(1);
			}

		});
		this.m.Screens.push({
			ID = "Monk",
			Text = "[img]gfx/ui/events/event_97.png[/img]%monk% mnich występuje do przodu i zbiera dzieci w gromadkę. Natychmiast okazują mu szacunek, bo reprezentuje w pewnym sensie sprawę, którą chcą szerzyć. Klęka na jedno kolano.%SPEECH_ON%Czy to starzy bogowie kazali ci wyruszyć i zrobić to?%SPEECH_OFF%Mały przywódca kiwa głową.%SPEECH_ON%Przemówili do mnie we śnie.%SPEECH_OFF%Mnich kiwa głową, pocierając brodę i rozważając sprawę. Klepie chłopca po głowie.%SPEECH_ON%Starsi bogowie mówią do mnie, a ja do nich. Zrozumienie ich przesłania wymaga lat nauki, mówię ci! Czy na pewno to ty, maluchu, miałeś nieść ten ciężar? Może miałeś być posłańcem, co? Spójrz na nas, jesteśmy wojownikami. Sprawnymi, walczącymi mężczyznami, którzy potrafią zabić tych, którzy gardzą i odrzucają starych bogów. Ty jeszcze nie jesteś jak my, ale masz silny głos i zadatki na prawdziwego przywódcę. Wierzę, że starzy bogowie chcieli wykorzystać twoją charyzmę, a nie twoje mięśnie.%SPEECH_OFF%Mnich żartobliwie szturcha chłopca. Ten uśmiecha się, pojmując prawdę słów zakonnika. Mały przywódca mówi swojej grupie, że mają wrócić do domu, bo mnich ma z pewnością rację. Niektórzy ludzie są wdzięczni, że dzieci odwiedziono od pewnej zguby.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Głupie dzieci.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.World.Assets.addMoralReputation(2);
				local resolve = this.Math.rand(1, 2);
				_event.m.Monk.getBaseProperties().Bravery += resolve;
				_event.m.Monk.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Determinację"
				});
				_event.m.Monk.improveMood(1.0, "Uratował dzieci przed pewną zgubą");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Monk.getID() && this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(0.5, "Cieszy się, że " + _event.m.Monk.getName() + " uratował dzieci przed pewną zgubą");

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
		this.m.Screens.push({
			ID = "Traveller",
			Text = "[img]gfx/ui/events/event_97.png[/img]%walker% zdejmuje buty i pokazuje dzieciom spody stóp. Cofają się z odrazą, dławiąc się i zasłaniając usta. Mała dziewczynka wydaje długie "eeee", by dobitnie podkreślić punkt. Mężczyzna macha stopą, pokazując obrzydliwie zrogowaciałą skórę.%SPEECH_ON%Spędziłem lata w drodze i większość z nich bez porządnych butów. Wiem, jak tam jest. Widziałem zagrożenia. Ludzie dźgający się we śnie. Zabijanie za kęs ciastka. Obcy się z tobą zaprzyjaźniają, by cię potem zdradzić. A to wszystko, kiedy idzie dobrze! Kiedy idzie źle, robi się... cóż, naprawdę źle. Dzieciaki, nie macie tu czego szukać. Zostaniecie zgwałceni, zamordowani, zniewoleni, torturowani, rzuceni psom, zjedzeni przez dziki, niedźwiedzie, wilki - przez wszystko, co patrzy na was, jakby właśnie nadeszła pora obiadu na dwóch nogach. Wracajcie do domu. Wszyscy.%SPEECH_OFF%Gromada dzieci szemrze między sobą. Jedno ogłasza, że wraca do mamy. Mała dziewczynka stwierdza, że wcale nie chciała tu iść i nigdy nie dostała obiecanych smakołyków. Wyczuwając załamanie morale, mały przywódca próbuje zagonić dzieci, ale nic z tego. Grupa rozpada się i, na szczęście, zaczyna wracać do domu. Niektórzy ludzie odczuwają ulgę, bo nie chcieli patrzeć, jak maluchy idą ku zgubie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powinieneś sprawdzić te stopy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Traveller.getImagePath());
				this.World.Assets.addMoralReputation(2);
				local resolve = this.Math.rand(1, 2);
				_event.m.Traveller.getBaseProperties().Bravery += resolve;
				_event.m.Traveller.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Traveller.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Determinację"
				});
				_event.m.Traveller.improveMood(1.0, "Uratował dzieci przed pewną zgubą");

				if (_event.m.Traveller.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Traveller.getMoodState()],
						text = _event.m.Traveller.getName() + this.Const.MoodStateEvent[_event.m.Traveller.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Traveller.getID() && this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(0.5, "Cieszy się, że " + _event.m.Traveller.getName() + " uratował dzieci przed pewną zgubą");

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
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_97.png[/img]Wątpisz, by dało się wybić z tych dzieci zapał słowami, ale jeśli wychowanie twojego ojca jest jakąkolwiek wskazówką, to pewnie da się go z nich wybić. Szybkim rozkazem każesz kompanii napaść na dzieci, poobijać je i zabrać ich rzeczy. Mały przywódca próbuje dźgnąć najemnika włócznią i za to dostaje solidny cios.\n\nTo nie jest najładniejsza rzecz na świecie i wyglądałoby fatalnie, gdyby ktoś zobaczył kompanię bijącą dzieci, ale taki "koniec" ich krucjaty jest lepszy niż gorsze rzeczy, które czekają na nich na drodze.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jedzcie ziemię, małe szczeniaki.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-4);
				local item = this.new("scripts/items/loot/silverware_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				item = this.new("scripts/items/weapons/militia_spear");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 11,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.worsenMood(1.0, "Był oburzony twoim rozkazem rabowania dzieci");

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
		if (this.World.FactionManager.isGreaterEvil())
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

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_monk = [];
		local candidates_traveller = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				candidates_monk.push(bro);
			}
			else if (bro.getBackground().getID() == "background.messenger" || bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.refugee")
			{
				candidates_traveller.push(bro);
			}
		}

		if (candidates_monk.len() != 0)
		{
			this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		}

		if (candidates_traveller.len() != 0)
		{
			this.m.Traveller = candidates_traveller[this.Math.rand(0, candidates_traveller.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
		_vars.push([
			"walker",
			this.m.Traveller != null ? this.m.Traveller.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Monk = null;
		this.m.Traveller = null;
	}

});

