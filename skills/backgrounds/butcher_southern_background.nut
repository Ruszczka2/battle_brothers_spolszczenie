this.butcher_southern_background <- this.inherit("scripts/skills/backgrounds/butcher_background", {
	m = {},
	function create()
	{
		this.butcher_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernMale;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.BeardChance = 60;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{Po śmierci ojca %name% przejął rodzinną masarnię w %randomtown%. | Dorastając w biedzie, %name% szybko nauczył się zabijać i rozbierać zwierzęta, ostatecznie zakładając masarnię. | Jako że w %randomtown% nawracające susze ciągle niszczyły pola uprawne, %name% postanowił spróbować szczęścia z masarnią. | %name% od zawsze był nieco dziwny i podjął fach rzeźnika nie tylko dla zysku, ale też i dla przyjemności. | %name% nigdy nie wyglądał na aż tak szczęśliwego, szczerzącego zęby od ucha do ucha, jak wtedy, gdy otwarł swoją masarnię i do magazynu dotarła pierwsza dostawa żywych świń. | Jako rzeźnik %name% spędził długie lata na wyciskaniu wnętrzności z martwych królików i odcinaniu głów nie-zawsze-martwym rybom.} {Jednakże pogłoski o bestialskich torturach wobec zwierząt w końcu zmusiły rzeźnika do zwinięcia interesu. | Kiedy po okolicy zaczęły krążyć plotki o czarnej magii i mrocznych rytuałach, minęło dużo czasu, zanim ludzie zaczęli kwestionować źródło pochodzenia jego mięsa i wygnali go z osady.| Jednak zabijanie zwierząt, z tego czy innego powodu, przestało go ekscytować. Szukał czegoś nowego. | Po tym, jak w jednym z jego pakunków z dziczyzną odnaleziono ludzki palec, został wypędzony z miasta. | Niektórzy twierdzą, że najbardziej podobało mu się jednak zarzynanie dla żołnierzy podczas inwazji orków i że chciałby wrócić do tamtego zajęcia. | Niestety, wojna przetoczyła się przez jego zakład, zostawiając po sobie stosy ciał, których nie odważyłby się rozebrać. | Żyjąc w oblężonym mieście zapewniał mięso głodującym mieszkańcom. Kiedy odkryto, skąd mięso pochodzi, oddano go w ręce oblegających, którzy, nieświadomi tamtych zajść, pozwolili mu żyć. | Kiedy na jaw wyszły jego powiązania z kłusownikami, musiał dać nogę, a na ogonie cały czas siedziała mu rzesza ludzi miejscowych lordów. | Pewnego dnia zaszlachtował maleńką świnię, która, jak się później okazało, była pupilem lokalnego szlachcica. Musiał uciekać z miasta, by ratować własny tuszę.} {%name% ma w sobie coś takiego, że krew i flaki do niego pasują. Cóż, w takim razie witamy na polu bitwy. | %name% patrzy na wszystko jak na potencjalne mięso na sprzedaż, tyle że w oddychającym, ruchomym opakowaniu. | %name% u wielu wzbudza niepokój samą swą obecnością oraz swoimi nazbyt szeroko otwartymi oczami. | %name% znany jest też z tego, że czasami gryzie się w język, aby posmakować krwi. | Uszy %name% zdają się ożywiać za każdym razem, gdy w pobliżu słychać pisk świni. To samo ma miejsce z wrzaskami człowieka. Osobliwe. | %name% jest rzeźnikiem, ale najwyraźniej nie zbyt zainteresowany wpasowywaniem się w kanon.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r <= 1)
		{
			items.equip(this.new("scripts/items/weapons/butchers_cleaver"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/butcher_apron"));
		}
	}

});

