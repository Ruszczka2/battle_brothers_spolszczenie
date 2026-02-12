this.beggar_southern_background <- this.inherit("scripts/skills/backgrounds/beggar_background", {
	m = {},
	function create()
	{
		this.beggar_background.create();
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
	}

	function onBuildDescription()
	{
		return "{Po utraceniu wszystkiego w pożarze | Po tym, jak uzależnienie od hazardu wzięło nad nim górę | Wrobiony w przestępstwo, którego nie popełnił i musząc oddać konstablowi wszystko co miał, by uniknąć zgnicia w lochu | Stając się uchodźcą po tym, jak jego wioska została doszczętnie spalona | Będąc wygnanym ze swego domu po brutalnej kłótni ze swym bratem | Jako człowiek niewielu talentów i żadnych ambicji, | Po uwolnieniu z lochu, gdzie spędził niezliczone lata przykuty do ściany | Po oddaniu wszelkich swoich dóbr doczesnych mrocznemu kultowi, obiecującemu zbawienie jego nieśmiertelnej duszy | Będąc bardzo inteligentnym człowiekiem, póki bandyta nie rąbnął go mocno w łeb}, {%name% znalazł się na ulicy, | %name% trafił na ulicę,} {gdzie musiał żebrać o chleb | stając się zależnym od dobrej woli innych ludzi | zmarnowany i zrezygnowany pogodził się ze swym nędznym losem | a resztki swych pieniędzy przepijał w karczmach  dzień za dniem | gdzie przekopywał śmieci innych ludzi i czmychał przed stróżami prawa | gdzie starał się unikać opryszków i zbirów, podczas żebrania o korony}. {Choć poważnie podchodził do zostania najemnikiem, to nie ma wątpliwości, że cały ten czas spędzony na ulicy ograbił go z jego najlepszych lat życia. | Lata mijały i odbiły się na jego zdrowiu. | Kiedy ktoś taki jak %name% spędzi kilka dni na ulicach, a co dopiero mowa o kilku latach, nawet tak niebezpieczna praca jak bycie najemnikiem wydaje się ziemia obiecaną. | Jedynie bogowie wiedzą, co %name% robił, aby utrzymać się przy życiu, lecz jest teraz bardzo cherlawym człowiekiem. | Na twój widok rzuca się z otwartymi ramionami, by cię przywitać, twierdząc, że znacie doskonale z minionych lat i wspólnych przygód, choć gdzieś mu umknęło, jak masz na imię.}";
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
			local item = this.new("scripts/items/helmets/oriental/nomad_head_wrap");
			item.setVariant(16);
			items.equip(item);
		}
	}

});

