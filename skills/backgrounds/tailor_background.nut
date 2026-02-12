this.tailor_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.tailor";
		this.m.Name = "Krawiec";
		this.m.Icon = "ui/backgrounds/background_48.png";
		this.m.BackgroundDescription = "Krawcy nie są przyzwyczajeni do ciężkiej fizycznej pracy.";
		this.m.GoodEnding = "What was a tailor doing in a mercenary company? A good question, but %name% certainly answered it well by killing so many enemies they could\'ve made an epic tapestry out of story. After a few good years in the company, he eventually left to start up a business creating clothes for nobility. His name is world-renowned, well, the known-world-renowned, and he gets so much business he\'s making a very different killing these days.";
		this.m.BadEnding = "A tailor at heart, it didn\'t take much to compel %name% to bail from the quickly sinking company. He left to go start a business, but was kidnapped along the way by a group of brigands. When they threatened to kill him, he pretended to be a simple and weak tailor and showed his talents in creating clothes. Impressed, the raggedly dressed outlaws took him into their band. A few days later they were all dead and this \'meek\' man walked out of their camp with a bit of red on him. He started his business a week later and is doing well to this day.";
		this.m.HiringCost = 50;
		this.m.DailyCost = 5;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.athletic",
			"trait.deathwish",
			"trait.clumsy",
			"trait.fearless",
			"trait.spartan",
			"trait.brave",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.dumb",
			"trait.brute",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"Osobliwy",
			"Krawiec",
			"Konkretny",
			"Gładki",
			"Jedwabnik"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Thick;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{%name% zawsze interesował się tkaninami, w zwykłym lnianym suknie widząc więcej nauki, niż {wróżbita widziałby w piaskach pustyni. | haruspik widziałby we wnętrznościach ropuchy. | alchemik widziałby w swym moździerzu.} | %name% zawsze był nieco dziwny, gdyż jako nastolatkowi bardziej podobały mu się ładne jedwabne suknie, niż to, co dziewczęta skrywały pod nimi. | Będąc synem {górnika | giermka | rycerza | parobka}, %name% sprawił wszystkim niemałe zaskoczenie, idąc w kierunku szycia ubrań. | Podczas gdy jego siostry wolały zostać wojowniczkami i bohaterkami, %name% myślał o sobie jako o przyszłym krawcem królów. | %name% spędził sporo swej młodości w towarzystwie dziewcząt, jednak nie z powodów, z jakich można by przypuszczać. | %name% od zawsze lubił zwierzęta, a zwłaszcza, jak prezentowały się one jako płaszcz lub szal. | Wraz z tym, jak tuniki i koszule robiły się coraz bardziej powszechne, %name% zaczął parać się krawiectwem, by zarobić trochę koron. | Wraz ze wzrostem popularności pantalonów, %name% przekwalifikował się z garbarza na krawca, aby więcej zarobić. | %name% pochodzi z odleglej krainy, gdzie suknia zdobiąca człowieka jest ważniejsza, niż jego umiejętności bojowe. | Krawiectwo to sztuka doboru kolorów i tkanin, a %name% ze swych niebywałych zdolności w tym zakresie jest dość dobrze znany. | Dobrze sobie radząc z liczeniem i mierzeniem, %name% wykorzystał swe matematyczne umiejętności w krawiectwie, aby zarobić ile tylko zdoła. | %name% są karierę w krawiectwie rozpoczął gdy jego matka załatwiła mu pracę, aby uciekł od poboru do wojska. | %name% podjął się krawiectwa z szacunku do swego ojca, który jako krawiec zginął z rąk niezadowolonego klienta. | %name% stracił ojca na wojnie, a matka, chcąc ustrzec go przed podobną śmiercią, nauczyła go jak szyć, aby nie musiał parać się wojaczką.} {Kiedy najeźdźcy napadli na jego osadę, %name% odział wszystkich w sprytne przebrania. Miasteczko zniszczono, ale nikt nie ucierpiał. | Latami szył ubrania dla rodzin królewskich, aż pewnego dnia fatalne modowe faux pas sprawiło, że został wygnany. | Niestety, %name% był człowiekiem, który cenił sobie tylko porządne tkaniny, przez co w większości wiosek nie zagrzał długo miejsca. | Próbował swoich szans w wielkich miastach, jednak niestety nie był w stanie konkurować z innymi krawcami. | Kiedy lord zbierał armię, %name% zajął się odzieniem, zapewniając żołnierzom odpowiednie mundury. | Jednak zaciekła rywalizacja między krawcami zakończyła się trupem zawiniętym w lniane płótno, a %name% dziwnym zbiegiem okoliczności w tym samym czasie zniknął z okolicy, zostawiają za sobą swój warsztat. | Niestety, rabusie splądrowali jego warsztat, a z toczącą się wokół wojną, niemożliwe było uzupełnienie zapasów. | Kiedy jednak ostrzygł owcę, która do niego nie należała, %name% został wyrzucony z miasta. | Kiedyś udusił potencjalnego złodzieja sznurem z drutu pomiarowego. Tak przynajmniej twierdzi. | Jednak ubieranie niesympatycznej i nieprzyjaznej szlachty w końcu {go znudziło. | stało się niesamowicie męczące.} | Kiedyś zlecono mu wykonanie tuniki zdobionej epickimi dokonaniami i %name% zaczął się zastanawiać, jak naprawdę wygląda świat poza murami miast. | Projektując suknię ozdobioną {epickimi przygodami | heroicznymi czynami}, %name% zaczął się zastanawiać, czy nie powinien zostać kimś, o kim takie historie się układa.} Teraz krawiec szuka nowego życia, nieważne, dokąd go to zaprowadzi. {Być może będzie w stanie dobrze ubrać kompanię, czy coś. | Jest wyjątkowy i osobliwy, zasypuje wszystkich krytyką dotyczącą ubioru.| Nie jest urodzonym żołdakiem, ale ocenia strój innych w taki sposób, jakby miał zamiar iść z nimi na wojnę. | Patrząc na to, jak w krawiectwie przykłada się do obliczeń i zachowania wymiarów, zaiste wielka szkoda, że %name% nie został inżynierem oblężniczym. | Choć %name% nie jest żołnierzem, jego szczera miłość do krawiectwa potrafi wzbudzić podziw. | %name% ma taką wiedzę o różnorakich tkaninach, że doprawdy jest to imponujące. | Będąc chuderlakiem, %name% jest zwinny i zręczny, ale siły nie ma za grosz. | %name% będzie dość dziwnie by wygląda w zbroi, ale na bogów, jakże będzie mu ona potrzebna... | Jak się okazuje, %name% potrafi wykonać jedwabną sakiewkę ze świńskiego ucha. | Niech nie zmyli cię jednak jego zawód, %name% ma dłonie zręczniejsze niż większość {karciarzy | żonglerów | kieszonkowców}. | Krawcowie pozornie wydają się kiepskim materiałem na wojowników, ale tak jest przecież z większością ludzi, których obecnie spotyka się na szlaku. | Krawiec raczej kiepsko nadaje się do walki, a jednak z jakiegoś powodu swych najzdolniejszych żołnierzy werbujesz w różnych dziwnych miejscach. | Mając dobre oko do {obliczeń | wymiarów}, %name% jest znacznie bystrzejszy, niż mogłoby się pozornie wydawać.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-3,
				0
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				-5,
				-5
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
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});

