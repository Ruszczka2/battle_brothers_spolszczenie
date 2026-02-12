this.messenger_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.messenger";
		this.m.Name = "Posłaniec";
		this.m.Icon = "ui/backgrounds/background_46.png";
		this.m.BackgroundDescription = "Posłańcy są przyzwyczajeni do długich i męczących podróży.";
		this.m.GoodEnding = "The oddity of having %name% the messenger in your band did not seem so strange after he showed himself to be a killer sellsword. As far as you know, he\'s still with the company, preferring the march of a mercenary to that of a messenger. You don\'t blame him: an errand boy must bend the knee to every nobleman he comes across, but in the company of sellswords he\'ll no doubt get the occasional chance to kill one of them bastards. Not a hard trade off to accept!";
		this.m.BadEnding = "%name% the messenger departed the %companyname% and returned to being an errand boy for the letters of lieges. You tried to find out where the man had gone to and eventually tracked him down - or what was left of him. Unfortunately, \"don\'t shoot the messenger\" is not an adage well followed in these fractured lands.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.paranoid",
			"trait.clubfooted",
			"trait.asthmatic",
			"trait.cocky",
			"trait.craven",
			"trait.deathwish",
			"trait.dumb",
			"trait.fat",
			"trait.gluttonous",
			"trait.brute"
		];
		this.m.Titles = [
			"Posłaniec",
			"Kurier",
			"Biegacz"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{Niektórzy ludzie są tak ważni, że potrzebują, aby inni ludzie przekazywali ich słowa. %name% jest właśnie jednym z takich ludzi - tych drugich, rzecz jasna. | %name% dźwiga na swych ramionach ciężkie torby z listami, których adresaci zwykle okazują się martwi, zanim zdoła do nich dotrzeć. | Aby uciec przed życiem jako służący, %name% przyjął pracę posłańca. | Ponieważ tak wielu ludziom spieszno jest, aby dowiedzieć się co dzieje się z ich krewniakami, %name% na brak zajęcia w zawodzie posłańca narzekać nie może. | %name% kiedyś podróżował po kraju jako skromny posłaniec. | Podobnie jak jego ojciec, a także ojciec jego ojca, %name% przewoził wiadomości przez kraj zarówno dla członków rodziny królewskiej, jak i dla osób świeckich. | Podnosząc torby zmarłego posłańca, %name% wkrótce sam znalazł się w roli niedoszłego posłańca. | Będąc uchodźcą, %name% pomyślał sobie, że skoro już i tak tuła się po kraju, to równie dobrze może dostarczać listy.} {Jednak takie podróżowanie tam i z powrotem staje się w końcu nudne. Teraz doręczyciel szuka nowego zajęcia. | Dostarczając głównie listy miłosne, nasz niedoszły poszukiwacz przygód zaczął się zastanawiać, co on do jasnej cholery robi. | Uważając się obecnie za początkującego bohatera, %name% twierdzi, że dostarczanie poczty jest poniżej jego godności. | Deszcz czy słońce, jasne, śnieg czy śnieg z deszczem, nie ma sprawy, ale rozszalała na całego wojna? Nie, dzięki, może innym razem. | Jednakże po otwarciu listu, który, jak się okazało, zrujnowałby życie dobrodusznego szlachcica, posłaniec postanowił zmienić zajęcie. | Kiedy rabusie zamienili jego życie w piekło, %name% uznał, że lepiej będzie podróżować w towarzystwie uzbrojonych ludzi. | Po tym, jak przespał się z żoną burmistrza, ruszyła za nim w pościg mała armia. Uznał, że dla własnego bezpieczeństwa najlepiej będzie wstąpić w szeregi jakiegoś innego zbrojnego oddziału.} {%name% spędził lata na zapamiętywaniu wiadomości. Teraz będzie musiał pamiętać, jak utrzymać mur tarcz, gdy spadać będą na niego strzały. | Ironią jest, że %name% sam nigdy w życiu niczego nie napisał. | Zakasując rękawy, %name% chełpi się, że ma do przekazania światu ostatnią wiadomość. Normalnie strach się bać. | Być może jego dołączenie do najemników sugeruje, że, pióro wcale nie jest potężniejsze od miecza. | %name% ma tendencję do powtarzania wszystkiego, co mu powiedziano. Stare nawyki posłańca trudno wykorzenić. | Jak na ironię, ten doświadczony posłaniec prawdopodobnie widział więcej okropności na szlaku, niż większość ludzi będąc w kompanii. | %name% niewiele ma umiejętności, które czyniłyby go gotowym do walki. Ma jednak mocne nogi i, miejmy nadzieję, że nadawać się będą one nie tylko do ucieczki.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				5,
				0
			],
			Stamina = [
				15,
				10
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
				2
			],
			RangedDefense = [
				3,
				3
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
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});

