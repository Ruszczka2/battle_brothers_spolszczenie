this.beggar_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.beggar";
		this.m.Name = "Żebrak";
		this.m.Icon = "ui/backgrounds/background_18.png";
		this.m.BackgroundDescription = "Żebracy to niezbyt zdeterminowane osoby, a życie na ulicy zdaje się mieć wyniszczający wpływ na ich zdrowie.";
		this.m.GoodEnding = "Having enough of all the fighting, %name% the once-beggar retired from the %companyname%. You know the man made a pretty crown in his time with the mercenary company, yet the other day you saw him out begging again. You asked if he\'d wasted all his money and he laughed. He said he\'d purchased land and was doing just fine. Then he held out his little tin and asked for a crown. You gave him two.";
		this.m.BadEnding = "The fighting life is a rough one, and %name% the once-beggar saw fit to retire from it before it became a deadly one. Unfortunately, he went back to beggaring. Word has it that a nobleman cleaned a city of riff-raff and sent them marching north despite it being winter. Cold and hungry, %name% died on the side of a road, a tin cup frozen to his finger.";
		this.m.HiringCost = 30;
		this.m.DailyCost = 3;
		this.m.Excluded = [
			"trait.iron_jaw",
			"trait.tough",
			"trait.strong",
			"trait.cocky",
			"trait.fat",
			"trait.bright",
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.greedy",
			"trait.athletic"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Bravery
		];
		this.m.Titles = [
			"Brudny",
			"Biedny",
			"Obszarpany",
			"Chory",
			"Kłamca",
			"Bierny",
			"Gnuśny",
			"Bezużyteczny",
			"Żebrak",
			"Leniwy",
			"Śmierdziel",
			"Próżniak",
			"Bezdomny"
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
		return "{Po utraceniu wszystkiego w pożarze | Po tym, jak uzależnienie od hazardu wzięło nad nim górę | Wrobiony w przestępstwo, którego nie popełnił i musząc oddać konstablowi wszystko co miał, by uniknąć zgnicia w lochu | Stając się uchodźcą po tym, jak jego wioska została doszczętnie spalona | Będąc wygnanym ze swego domu po brutalnej kłótni ze swym bratem | Jako człowiek niewielu talentów i żadnych ambicji, | Po uwolnieniu z lochu lorda, gdzie spędził niezliczone lata przykuty do ściany | Po oddaniu wszelkich swoich dóbr doczesnych mrocznemu kultowi, obiecującemu zbawienie jego nieśmiertelnej duszy | Będąc bardzo inteligentnym człowiekiem, póki bandyta nie rąbnął go mocno w łeb}, {%name% znalazł się na ulicy, | %name% trafił na ulicę,} {gdzie musiał żebrać o chleb | stając się zależnym od dobrej woli innych ludzi | zmarnowany i zrezygnowany pogodził się ze swym nędznym losem | a resztki swych pieniędzy przepijał w karczmach  dzień za dniem | gdzie przekopywał śmieci innych ludzi i czmychał przed stróżami prawa | gdzie starał się unikać opryszków i zbirów, podczas żebrania o korony}. {Choć poważnie podchodził do zostania najemnikiem, to nie ma wątpliwości, że cały ten czas spędzony na ulicy ograbił go z jego najlepszych lat życia. | Lata mijały i odbiły się na jego zdrowiu. | Kiedy ktoś taki jak %name% spędzi kilka dni na ulicach, a co dopiero mowa o kilku latach, nawet tak niebezpieczna praca jak bycie najemnikiem wydaje się ziemia obiecaną. | Jedynie bogowie wiedzą, co %name% robił, aby utrzymać się przy życiu, lecz jest teraz bardzo cherlawym człowiekiem. | Na twój widok rzuca się z otwartymi ramionami, by cię przywitać, twierdząc, że znacie doskonale z minionych lat i wspólnych przygód, choć gdzieś mu umknęło, jak masz na imię.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-10
			],
			Bravery = [
				-10,
				-5
			],
			Stamina = [
				-10,
				-10
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

});

