this.disowned_noble_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.disowned_noble";
		this.m.Name = "Wydziedziczony Szlachcic";
		this.m.Icon = "ui/backgrounds/background_08.png";
		this.m.BackgroundDescription = "Wydziedziczona szlachta często zdobyła nieco umiejętności w walce wręcz na dworze.";
		this.m.GoodEnding = "A noble at heart, the disowned nobleman %name% returned to his family. Word has it he kicked in the doors and demanded a royal seat. An usurper challenged him in combat and, well, %name% learned a lot in his days with the %companyname% and he now sits on a very, very comfortable throne.";
		this.m.BadEnding = "A man of nobility at heart, %name% the disowned noble returned to his family home. Word has it an usurper arrested him at the gates. His head currently rests on a pike with crows for a crown.";
		this.m.HiringCost = 135;
		this.m.DailyCost = 17;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.clumsy",
			"trait.fragile",
			"trait.spartan",
			"trait.clubfooted"
		];
		this.m.Titles = [
			"Wydziedziczony",
			"Wygnany",
			"Zniesławiony"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Thick;
		this.m.Level = this.Math.rand(1, 3);
		this.m.IsCombatBackground = true;
		this.m.IsNoble = true;
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
		return "{Będąc nieustannym pasmem rozczarowań dla swego ojca z urojeniami | Stając się ofiarą dworskiej intrygi, w której udział wzięły trucizna i ciasto | Po otwartym potępieniu własnego dziedzictwa | Po tym, jak na jaw wyszedł jego kazirodczy związek z siostrą | Po tym, jak nie powiódł się zamach stanu mający na celu pozbycie się jego starszego brata | Po tym, jak jego duma i pycha poprowadziły armię ojca ku całkowitej klęsce | Za przypadkowe zabicie najstarszego brata i następcy tronu podczas polowania | Jako cenę za zły dobór sojuszników w wojnie o sukcesję | Za próbę sprzedania schwytanych kłusowników jako niewolników | Przyłapany w łóżku z innym szlachcicem | Kiedy wyszła na jaw szokująca sprawa i okazało się, ze jest szefem szajki wykradającej chłopom dzieci | Za odwrócenie się od bogów i sprowokowanie świeckich obywateli do zamieszek | Widziany z księgą kultystów Davkula pod pachą}, %name% {został wydziedziczony i wygnany na zawsze z rodzinnej posiadłości. | został pozbawiony tytułów i wygnany ze swych ziem. | został siłą usunięty ze swych ziem i kazano mu nigdy nie wracać. | przekonał się, pod groźbą katowskiego topora, że nie należy już do dworu. | założono mu pętlę kata na szyję i tylko dzięki sprytnej sztuczce udało mu się z niej wyślizgnąć. | został naznaczony symbolem hańby i wygnany ze swoich ziem. | został uznany za umoczonego w zbyt wiele spisków, więc usunięto go z jego ziem. | był postrzegany jako zbyt ambitny, co było niebezpieczną cechą wśród szlachty.} {%name% stara się teraz odkupić swoje winy i nie przynosić już wstydu rodowemu nazwisku. Dość samolubne, jak na członka kompanii najemników, niemniej jednak szlachetne. | Jego postawa skurczyła się nieco, garbiąc się od brzemienia skandalu, a jego odporność na trudności zmalała. | Może i %name% jest utalentowanym wojownikiem, ale rzadko mówi o kimś innym, niż o samym sobie. | Choć %name% szybko macha mieczem, nie sposób oprzeć się wrażeniu, że ktoś taki jak on został wygnany nie bez powodu. | Będą prześladowanym przez zły los i nie mając złamanej korony przy duszy, %name% postanowił wstąpić w szeregi najemników. | Bez tytułu i ziemi, %name% stara się teraz dołączyć do ludzi, nad którymi kiedyś sprawował panowanie. | Chociaż %name%, były szlachcic, może i jest dobrze wyposażony, to zauważyłeś, że najbardziej zużytym elementem jego wyposażenia są buty.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-5,
				-2
			],
			Stamina = [
				-10,
				-5
			],
			MeleeSkill = [
				8,
				10
			],
			RangedSkill = [
				3,
				6
			],
			MeleeDefense = [
				0,
				3
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
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/militia_spear"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/shields/buckler_shield"));
		}

		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/mail_shirt"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/mail_hauberk"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}

		r = this.Math.rand(0, 8);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/padded_nasal_helmet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});

