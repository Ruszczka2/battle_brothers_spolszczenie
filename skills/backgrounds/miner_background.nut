this.miner_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.miner";
		this.m.Name = "Górnik";
		this.m.Icon = "ui/backgrounds/background_45.png";
		this.m.BackgroundDescription = "Górnik będzie przyzwyczajony do pracy fizycznej, choć oddychanie przez lata zapylonym powietrzem prawdopodobnie odbiło się jego zdrowiu.";
		this.m.GoodEnding = "%name% the miner never did return to the mines, thankfully. If there\'s one life that could be worse than that of fighting for a living, it very well may be digging into mountains for a living! Apparently, the miner built a home by the sea, spending the rest of his days peacefully fishing for dinner and enjoying sunrises or some such sappy shite.";
		this.m.BadEnding = "If there\'s one life that\'s more rough than that of being a sellsword, it is that of being a miner. Sadly, %name% returned to that life, going back into the mines to dig out metals and ores to fill some rich man\'s pockets. A recent earthquake collapsed many such mines. You\'re not sure if the ol\' brother survived, but it\'s looking pretty grim.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.night_blind",
			"trait.swift",
			"trait.iron_lungs",
			"trait.bright",
			"trait.fat",
			"trait.clumsy",
			"trait.fragile",
			"trait.strong",
			"trait.craven",
			"trait.dastard"
		];
		this.m.Titles = [
			"Górnik",
			"Pełzacz",
			"Kopidół"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onBuildDescription()
	{
		return "{Aby wesprzeć swą pozbawioną ojca rodzinę, %name% ruszył do kopalni w bardzo młodym wieku. | Będąc sierotą, jedyną pracą, jaką %name% mógł znaleźć, była praca w podziemnych kopalniach. | Bycie górnikiem ciężka praca i garną się do niej głównie ludzie tacy, jak %name%. | Mimo iż jego ojciec zginął w kopalni, %name% czuł się zobowiązany, aby też w nich pracować, jak większość mężczyzn za czasów jego młodości. | %name% pracował w kopalni w ramach rodzinnej tradycji, ciągnącej się od wielu pokoleń. | Gdy tylko wybucha wojna, górnicy tacy jak %name% są niezwykle potrzebni, chyba że armia planuje obejść się bez stali. | Solidny hełm i kilof to narzędzia, które %name% przez długie lata zabierał ze sobą, ruszając głęboko pod ziemię.} {Jednak, jak to zwykle bywa, kopalnia nie przetrwała długo i ów górnik ledwie uszedł z życiem podczas tąpnięcia. | Niestety, był jedynym ocalały podczas zawalenia się szybu i nie było szans, aby samodzielnie dokopał się do pozostałych. | Po tragicznym w skutkach tąpnięciu w kopalni, widok dziesiątek zapłakanych wdów tak nim wstrząsnął, że zaczął rozmyślać o zmianie zawodu. | Po kolejnym tąpnięciu w kopalni, jego żona zażądała, aby poszukał innej pracy, jakakolwiek by ona nie była. | Jednak schylanie się i bieganie po ciemku staje się nudne, więc mężczyzna zaczął szukać innego powołania. | Pracował w środowisku tak ciemnym, że przypadkowo zabł swego współpracownika. Ta tragedia wypchnęła go z zawodu. | PO tym, jak jego własny syn stracił życie w kopalni, na zawsze już zrezygnował z tej pracy. | Jednak cierpiąc na uporczywe ataki kaszlu, uznał, że być może kariera na świeżym powietrzu lepiej będzie mu służyć.} {%name% ma krępą sylwetkę górnika. Niestety, ma też płuca górnika. |  %name% jest twardy i silny, to fakt, jedna wydaje z siebie dźwięki, jakby dwa zardzewiałe miecze ocierały się o siebie. | Odnosisz wrażenie, że %name% ma płuca tak zapchane metalowym pyłem, iż można by z tego wykuć miecz, lub nawet dwa. | %name% ma oddech tak pylisty, że zostawiłby brudny ślad nawet na bryle węgla. | %name% spędził lata wypracowując zysk dla kompanii górniczej. Teraz chce zarabiać prawdziwe pieniądze. | %name% nie może się doczekać, by wreszcie i do jego kieszeni zaczęło trafiać nieco tego złota, które to własnoręcznie przez lata wydobywał z ziemi. | Dość irytujące jest to, że %name% wskazuje palcem na połowę twego ekwipunku - głównie metalowego - i przypomina wszem i wobec, komu zawdzięczasz to, że go masz. | %name% ma niemalże koci wzrok w ciemnościach. Byłby z niego świetny skrytobójca, gdyby tylko tak nie świszczał. | %name% kilkukrotnie oszukał śmierć, więc czemu nie spróbować tego samego jeszcze kilka razy, teraz jednak jako najemnik? | %name% dosłownie był już kilka stóp pod ziemią, więc rzeczy, które po niej stąpają, nie wzbudzają w nim strachu. | Jeżeli ciemność to naprawdę ambasador śmierci, to %name% rozmawiał już z nim przez wiele lat. | Idiotycznie odważni ludzie, tacy jak %name%, zdecydowanie pasować będą do oddziału takiego, jak ten. | %name% chełpi się, że dawniej potrafił grać w karty w kompletnych ciemnościach. Nie wątpisz w to. | Jeśli %name% potrafi machać mieczem równie zręcznie, co kilofem, to wszystko będzie w porządku.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				10,
				10
			],
			Bravery = [
				5,
				8
			],
			Stamina = [
				-10,
				-10
			],
			MeleeSkill = [
				5,
				0
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/pickaxe"));
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/mouth_piece"));
		}
	}

});

