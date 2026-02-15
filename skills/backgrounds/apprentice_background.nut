this.apprentice_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.apprentice";
		this.m.Name = "Czeladnik";
		this.m.Icon = "ui/backgrounds/background_40.png";
		this.m.BackgroundDescription = "Czeladnicy często są złaknieni wiedzy i uczą się szybciej od innych.";
		this.m.GoodEnding = "Być może jeden z najbystrzejszych ludzi, jakich kiedykolwiek spotkałeś, %name%, czeladnik, był najszybszym uczniem w %companyname%. Zgromadziwszy niemało koron, wycofał się z walki i przeniósł swoje talenty do świata interesów. Ostatnio słyszałeś, że świetnie sobie radzi w wielu fachach. Jeśli kiedykolwiek będziesz miał syna, to właśnie do niego poślesz go na termin.";
		this.m.BadEnding = "%name%, czeladnik, był zdecydowanie najszybszym uczniem w %companyname%. Nic więc dziwnego, że jako jeden z pierwszych rozpoznał nieunikniony upadek kompanii i odszedł, póki jeszcze mógł. Gdyby urodził się w innym czasie, dokonałby wielkich rzeczy. Zamiast tego liczne wojny, najazdy i plagi rozlewające się po krainie sprawiły, że %name% i wielu innych utalentowanych ludzi poszło na marne.";
		this.m.HiringCost = 90;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.dumb",
			"trait.clumsy",
			"trait.asthmatic",
			"trait.athletic",
			"trait.brute",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"Pojętny",
			"Szybki Umysł",
			"Czeladnik",
			"Aplikant",
			"Dobroręki",
			"Uczeń",
			"Młody",
			"Dzieciak",
			"Bystry"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.YoungMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
				id = 13,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] do zdobywanego doświadczenia"
			}
		];
	}

	function onBuildDescription()
	{
		return "{Ten, kto przychodzi na świat, zawsze stara się być najlepszą wersją siebie samego, | Mistrzowskie opanowanie rzemiosła jest prestiżowe, | Każdy chciałby być taki, jak ci najlepsi,} {ale nikt nie osiąga tego w mgnieniu oka. | więc czy jest lepszy sposób rozwoju, niż szkolenie się pod okiem mistrza? | i nie jest tajemnicą, że większość zwraca się o pomoc do mistrzów.} {%name% miał takie samo zdanie, zostając czeladnikiem w %townname%. | Z całego serca wierząc w prawdziwość tych słów, %name% podjął praktykę w %townname%. | Kiedy uczelnia w %randomtown% szukała praktykantów, %name% był pierwszym, który się zgłosił. | Nakłaniany przez rodziców do rozwinięcia swojego rzemiosła, %name% szukał możliwości rozpoczęcia kariery jako praktykant. | Aby nie dać się prześcignąć w osiągnięciach swojemu bratu, który odnosił ogromne sukcesy, %name% zaczął szukać praktyki zawodowej.} {Niestety, wybór mistrza okazał się porażką: trafił mu się szalony stolarz z zamiłowaniem do rżnięcia, ale bynajmniej nie drewna. Uciekając czym prędzej, aby uniknąć zgubnych w skutkach powiązań z pomyleńcem, %name% trafił do towarzystwa najemników. | Ucząc się wszystkiego, co zdołał, %name% zbudował największe dzieło sztuki, jakie kiedykolwiek powstało w dziedzinie podwodnego wyplatania koszy. Jego mistrz był jednak zazdrosny. Nie chcąc być prześcigniętym przez ucznia, spalił projekt na popiół. %name% migiem pojął: był w stanie szybko przyswajać wiedzę i umiejętności, ale musiał poszukać lepszego mistrza. | Chłonął wszystko, czego można było się nauczyć: sztukę murarstwa, stolarstwa, kowalstwa, uprawiania miłości. Teraz zwrócił swoją uwagę w stronę sztuk walki. I chociaż %name% nie jest jeszcze tak naprawdę wojownikiem, to szybko się uczy.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				0,
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

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/apron"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.XPGainMult *= 1.1;
	}

});

