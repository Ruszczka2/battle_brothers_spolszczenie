this.tailor_southern_background <- this.inherit("scripts/skills/backgrounds/tailor_background", {
	m = {},
	function create()
	{
		this.tailor_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernThick;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
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
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{%name% zawsze interesował się tkaninami, w zwykłym lnianym suknie widząc więcej nauki, niż {wróżbita widziałby w piaskach pustyni. | haruspik widziałby we wnętrznościach ropuchy. | alchemik widziałby w swym moździerzu.} | %name% zawsze był nieco dziwny, gdyż jako nastolatkowi bardziej podobały mu się ładne jedwabne suknie, niż to, co dziewczęta skrywały pod nimi. | Będąc synem {rzeźnika | żołnierza}, %name% sprawił wszystkim niemałe zaskoczenie, idąc w kierunku szycia ubrań. | Podczas gdy jego bracia woleli zostać wojownikami i bohaterami, %name% myślał o sobie jako o przyszłym krawcem wezyrów. | %name% spędził sporo swej młodości w towarzystwie dziewcząt, jednak nie z powodów, z jakich można by przypuszczać. | %name% od zawsze lubił zwierzęta, a zwłaszcza, jak prezentowały się one jako płaszcz lub szal. | Wraz z tym, jak tuniki i koszule robiły się coraz bardziej powszechne, %name% zaczął parać się krawiectwem, by zarobić trochę koron. | Wraz ze wzrostem popularności pantalonów, %name% przekwalifikował się z garbarza na krawca, aby więcej zarobić. | Krawiectwo to sztuka doboru kolorów i tkanin, a %name% ze swych niebywałych zdolności w tym zakresie jest dość dobrze znany. | Dobrze sobie radząc z liczeniem i mierzeniem, %name% wykorzystał swe matematyczne umiejętności w krawiectwie, aby zarobić ile tylko zdoła. | %name% podjął się krawiectwa z szacunku do swego ojca, który jako krawiec zginął z rąk niezadowolonego klienta. | %name% stracił ojca na wojnie, a matka, chcąc ustrzec go przed podobną śmiercią, nauczyła go jak szyć, aby nie musiał parać się wojaczką.} {Kiedy koczownicy napadli na jego osadę, %name% odział wszystkich w sprytne przebrania. Miasteczko zniszczono, ale nikt nie ucierpiał. | Latami szył ubrania dla rodzin królewskich, aż pewnego dnia fatalne modowe faux pas sprawiło, że został wygnany. | Niestety, %name% był człowiekiem, który cenił sobie tylko porządne tkaniny, przez co w większości wiosek nie zagrzał długo miejsca. | Próbował swoich szans w mieście, jednak niestety nie był w stanie konkurować z innymi krawcami. | Kiedy wezyr zbierał armię, %name% zajął się odzieniem, zapewniając poborowym odpowiednie mundury. | Jednak zaciekła rywalizacja między krawcami zakończyła się trupem zawiniętym w lniane płótno, a %name% dziwnym zbiegiem okoliczności w tym samym czasie zniknął z okolicy, zostawiają za sobą swój warsztat. | Kiedyś udusił potencjalnego złodzieja sznurem z drutu pomiarowego. Tak przynajmniej twierdzi. | Kiedyś zlecono mu wykonanie tuniki zdobionej epickimi dokonaniami i %name% zaczął się zastanawiać, jak naprawdę wygląda świat poza murami miast. | Projektując suknię ozdobioną {epickimi przygodami | heroicznymi czynami}, %name% zaczął się zastanawiać, czy nie powinien zostać kimś, o kim takie historie się układa.} Teraz krawiec szuka nowego życia, nieważne, dokąd go to zaprowadzi. {Być może będzie w stanie dobrze ubrać kompanię, czy coś. | Jest wyjątkowy i osobliwy, zasypuje wszystkich krytyką dotyczącą ubioru.| Nie jest urodzonym żołdakiem, ale ocenia strój innych w taki sposób, jakby miał zamiar iść z nimi na wojnę. | Patrząc na to, jak w krawiectwie przykłada się do obliczeń i zachowania wymiarów, zaiste wielka szkoda, że %name% nie został inżynierem oblężniczym. | Choć %name% nie jest żołnierzem, jego szczera miłość do krawiectwa potrafi wzbudzić podziw. | %name% ma taką wiedzę o różnorakich tkaninach, że doprawdy jest to imponujące. | Będąc chuderlakiem, %name% jest zwinny i zręczny, ale siły nie ma za grosz. | %name% będzie dość dziwnie by wygląda w zbroi, ale na bogów, jakże będzie mu ona potrzebna... | Jak się okazuje, %name% potrafi wykonać jedwabną sakiewkę ze świńskiego ucha. | Niech nie zmyli cię jednak jego zawód, %name% ma dłonie zręczniejsze niż większość {karciarzy | żonglerów | kieszonkowców}. | Krawcowie pozornie wydają się kiepskim materiałem na wojowników, ale tak jest przecież z większością ludzi, których obecnie spotyka się na szlaku. | Krawiec raczej kiepsko nadaje się do walki, a jednak z jakiegoś powodu swych najzdolniejszych żołnierzy werbujesz w różnych dziwnych miejscach. | Mając dobre oko do {obliczeń | wymiarów}, %name% jest znacznie bystrzejszy, niż mogłoby się pozornie wydawać.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}

		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});

