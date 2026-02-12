this.cripple_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.cripple";
		this.m.Name = "Kaleka";
		this.m.Icon = "ui/backgrounds/background_51.png";
		this.m.BackgroundDescription = "Jedyną szybką rzeczą odnośnie kaleki jest jego spodziewany zgon w prawdziwej bitwie.";
		this.m.GoodEnding = "It\'s shocking that a man of %name%\'s stature survived at all, but the cripple did retire from the %companyname% with a sizeable stack of crowns. He runs an orphanage these days, spending his crowns to help the world\'s broken and abandoned children. That, or it\'s just a front for cheap labor. Can\'t be too sure these days.";
		this.m.BadEnding = "When you left the %companyname%, there was one thing you were almost certain of: that damned cripple, %name%, wouldn\'t last long. Despite all odds, he did survive. Long enough in fact to retire himself, albeit departing with about as many crowns as he had when he joined up. You\'ve no idea what became of him, but surely he\'s dead by now. Surely, right?";
		this.m.HiringCost = 30;
		this.m.DailyCost = 3;
		this.m.Excluded = [
			"trait.huge",
			"trait.weasel",
			"trait.lucky",
			"trait.iron_jaw",
			"trait.tough",
			"trait.strong",
			"trait.cocky",
			"trait.fat",
			"trait.greedy",
			"trait.athletic",
			"trait.impatient",
			"trait.quick",
			"trait.swift",
			"trait.dexterous"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Initiative
		];
		this.m.Titles = [
			"Kaleka",
			"Okaleczony",
			"Złamany",
			"Groteskowy"
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
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Nigdy nie przeszkadza mu bycie w rezerwie"
			}
		];
	}

	function onBuildDescription()
	{
		return "%name% {kuśtyka w twoją stronę jak parszywy pies | macha do ciebie ręką, w której brakuje wielu palców | uśmiecha się do ciebie w bezzębnym grymasie | przyjmuje postawę kogoś, kto wygląda, jakby złamano mu kręgosłup | chwieje się na dwóch bardzo sztywnych, być może nawet drewnianych nogach | używa laski, aby podejść w twoim kierunku | najpierw czołga się w twoim kierunku, ale potem podnosi się na nogi z gracją pijaka na schodach kościoła | ma kości, które skrzypią i trzeszczą przy każdym kroku | nosi rękę na temblaku i ma laskę wspierającą jedną z jego nóg | ma zmiażdżony nos i dwoje podbitych oczu | wygląda, jakby ktoś próbował go oskalpować i spalić żywcem | ma ciało, które pachnie na wpół ugotowanym mięsem, a w jego oczach widać cierpienie z każdym krokiem, który robi w twoją stronę | nie ma obu uszu, chociaż same ziejące po obu stronach głowy dziury wciąż w jakimś stopniu rejestrują dźwięk | cuchnie gównem i moczem | ma tylko jedno oko, które na dodatek wyraźnie błądzi | ma dwoje leniwych oczu i krzywy, pełen szczelin uśmiech}. Wyjaśnia, że {był kiedyś murarzem, ale został zaatakowany przez szaleńca za rzekomą próbę odtworzenia jego pracy | dawniej nosił zbroję jako rycerz, ale okrutny los odebrał mu to wszystko | kiedyś był szlachcicem, ale jego ubogie słownictwo zdradza, że to może być kłamstwo | był kiedyś kupcem, ale sprzedaż pewnego rzadkiego specyfiku zakończyła się dla niego popadnięciem w niełaskę u wściekłego miejskiego motłochu | był wyznawcą kultu, ale kiedy porzucił wiarę, pozostali zemścili się na nim za to | był kiedyś mnichem, ale {kultyści zaatakowali jego kościół | ostry spór z innymi mnichami sprawił, że został surowo ukarany | bandyci zemścili się na nim, za ukrzyżowanie jednego z nich} | zwykł bić się dla lordów, ale pobicie przez innych uczyniło go kaleką | wędrował po krainie w poszukiwaniu turniejów rycerskich, ale fatalny w skutkach turniej zakończył się jego straszliwym kalectwem | okradał groby, ale kiedy został przyłapany, parafianin połamał mu więcej kości, niż sądził, że w ogóle ma | parał się {sztukami tajemnymi | nekromancją}, ale, co wydawało się oczywiste po jego bliskim śmierci stanie, eksperyment ten trwał krótko | był kiedyś odnoszącym sukcesy hazardzistą, ale jak się okazuje, niespłacanie długów szkodzi interesom - i kościom | śpiewał kiedyś jako minstrel, ale gdy jego głos załamał się w połowie pieśni, lord kazał go brutalnie torturować | zarabiał na życie łapiąc szczury, ale najwyraźniej gigantyczny szczur złożył mu w nocy mściwą wizytę | służył kiedyś pewnemu lordowi, ale po upuszczeniu tacy z jedzeniem został wysłany do lochów, gdzie zapomniano o nim na lata | zabił kiedyś człowieka, jasne, ale nie zasłużył na aż tak straszliwy los, jak nieodwracalne w skutkach tortury, na jakie go skazano | polował kiedyś na czarownice, ale okrutna kochanka podstępem zmusiła go do wypicia mikstury, która okaleczyła jego ciało | kiedyś zdezerterował z armii i oczywiście został złapany | żonglował dla rodziny królewskiej, dopóki przypadkowo nie spadł ze schodów w trakcie wykonywania akrobacji. Jak się okazało, schody okazały się aż nazbyt twarde jak na jego wątłe kości | urodził się z potworną deformacją | jego ojciec brutalnie pobił go za to, że nie sprostał jego oczekiwaniom | jego matka naznaczyła go niekończącymi się torturami | jego rodzeństwo torturowało go przez całe życie.} {Ten człowiek wygląda tak mizernie, że niemal widać, jak jego ziemska powłoka powiewa na wietrze. | Zatrudnienie go niemal na pewno oznaczałoby jego zgubę. Jakież to miłosierne! | Nie chcesz być postrzegany jako zatrudniający byle kogo, ale jeśli ten facet jest nikim, czy to nadal liczy się on jako \'byle kto\'? | Widziałeś martwych ludzi, którzy wyglądali lepiej niż ten człowiek. | Ten facet jest wilczym obiadem na dwóch nogach. | Dobrą wiadomością jest to, że jeśli powróci z martwych, nie powinno być zbyt trudno ułożyć go do snu po raz drugi. | Sny i przedmioty martwe są bardziej niebezpieczne niż ten biedak. | Szczerze mówiąc, wolałbyś zatrudnić dziecko, ale jako że ludzie krzywo na to patrzą, to stajesz przed takimi wyborami, jak teraz. | A myślałeś, że to %randombrother% brzydko pachnie. | Zatrudnienie takiego człowieka sprawiłoby, że kompas moralny każdej osoby zacząłby się kręcić. | Spójrz na niego! Czy nasza kompania aż tak bardzo potrzebuje świeżych zwłok? | Zatrudnienie tego człowieka nie byłoby w porządku. Cóż, no to lecimy. | Para kul, na których się spiera, ma większą wartość niż ten biedny człowiek. | Ten człowiek jest w tak żałosnym stanie, że na stojąco może udawać martwego.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-20,
				-10
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				-10,
				0
			],
			MeleeSkill = [
				-5,
				-5
			],
			RangedSkill = [
				-5,
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
				-25,
				-10
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
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			local item = this.new("scripts/items/helmets/hood");
			item.setVariant(38);
			items.equip(item);
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.IsContentWithBeingInReserve = true;
	}

});

