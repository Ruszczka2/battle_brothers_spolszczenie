this.eunuch_southern_background <- this.inherit("scripts/skills/backgrounds/eunuch_background", {
	m = {},
	function create()
	{
		this.eunuch_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernThick;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = null;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.weasel",
			"trait.lucky",
			"trait.cocky",
			"trait.athletic",
			"trait.brute",
			"trait.bloodthirsty",
			"trait.deathwish",
			"trait.impatient"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{Kiedy bandyci najechali jego wioskę, %name% walczył dzielnie, lecz po porażce w ramach kary oderżnięto mu kutasa i jaja. | Oskarżony o dokonanie ohydnej zbrodni w łożnicy z kobietą, która swej chęci na swawole nie wyraziła, %name% miał do wyboru albo śmierć, albo życie jako eunuch. Nie potrzeba fizycznych dowodów, by dociec, którą z tych opcji wybrał. | Gdy %name% był jeszcze dzieckiem, jego pijan{a matka ucięła | y ojciec uciął | a starsza siostra ucięła | y starszy brat uciął} mu jego kutasa {tępawym toporkiem | zardzewiałym nożem}, {gdy spał | w ramach okrutnych tortur}. | Kiedy %name% przemierzał bezkresne pustynie, zaatakowała go zdziczała hiena, który pozbawiła go sporych połaci ciała. Uszedł z życiem, choć niewiele brakowało. Dopiero po dłuższej chwili zorientował się, że bestia pozbawiła go także genitaliów. | %name% wywodzi się z burdeli %randomcitystate%, gdzie okaleczenia jego ciała dokonano, aby zadowolić żądania pewnego dość wybrednego klienta.} {Był wrakiem, kiedy się na niego natknąłeś. Teraz wydaje się, że chce jedynie uciec od świata, nawet jeśli oznacza to dołączenie do grupy najemników. Choć nie życzyłbyś nikomu losu, jaki go spotkał, jest raczej spokojnym człowiekiem. | Natknąłeś się na niego w chwili, gdy dokuczała i wyśmiewała go grupka dzieciaków. Widząc twój miecz, grzecznie poprosił, czy może dołączyć do twej kompanii, w której czyjaś przeszłość, ani też fizyczne deformacje, nie mają znaczenia. Przywykł już do ciężkich życiowych wyzwań, i to zapewne w sposób, w jaki niewielu by potrafiło. | O dziwo, stoi bardziej dumy i wyprostowany, niż większość ludzi. Wygląda na bardzo spokojnego i opanowanego, jak na kogoś, kto utracił tak cenną dla siebie rzecz. | Choć przerażająca przeszłość tego człowieka jeży ci włosy na karku, a pewne części ciała poniżej pasa aż na samą myśl się kurczą, eunuch wydaje się niewzruszony tym, co go spotkało. Jest spokojną, niemalże pasywną osobą. | Ten człowiek ma w swoich ruchach więcej stoicyzmu, niż większość mnichów, których widziałeś. Wygląda, że pogodził się ze swą tragiczną przeszłością. | Nie będąc już w stanie zaspokoić swoich cielesnych pragnień, wydaje się raczej łagodny i spokojny. Można by wręcz rzec, że jest wyjątkowo pewny siebie i opanowany, widząc w świecie więcej, niż jego fizyczność początkowo zdawał się oferować.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/padded_vest"));
		}
	}

});

