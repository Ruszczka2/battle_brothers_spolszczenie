this.historian_southern_background <- this.inherit("scripts/skills/backgrounds/historian_background", {
	m = {},
	function create()
	{
		this.historian_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.BeardChance = 90;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{Zawsze był zachłannym czytelnikiem, a wczesne lata %name% to długie noce w wielu bibliotekach %randomcitystate%. | Gnębiony przez silniejszych rówieśników, młody %name% uciekł do świata książek. | Szukając prawdziwego źródła ludzkiej przeszłości, %name% czytał księgi i badał naturę człowieka. | Przy tak wielu zmianach na świecie %name% postanowił je zapisywać. | Szybko uczący się i spragniony dobrych lektur, %name% chciał zobaczyć świat na papierze dla innych. | Uczony z kolegium %randomcitystate%, %name% spisuje dzieje świata dla przyszłych pokoleń. | Zmrożony mrocznymi wydarzeniami, %name% przestał badać rośliny i zaczął spisywać historię ludzi.} {Porządny historyk szuka najbliższych źródeł, jakie może znaleźć, co przywiodło go do kompanii najemników. | Po tym, jak pustynni najeźdźcy zniszczyli jego pisma, zapiął buty i ruszył po nowe badania - osobiście. | Gdy profesor stwierdził, że jego badania to śmieci, historyk ruszył w świat, by mu udowodnić, że się myli. | Oskarżony o plagiat, został wyrzucony z akademii. Szuka odkupienia w świecie tego, co badał: wojny. | Wykorzystując pozycję w akademii do uwodzenia kobiet, w końcu skandale i kontrowersje wypchnęły historyka z jego dziedziny, pozostawiając go bez grosza i gotowego podjąć każdą pracę. | Znudziło go czytanie o poszukiwaczach przygód, więc uznał, że sam założy rynsztunek i zobaczy wszystko z bliska. | Przy tylu bandach najemników krążących po świecie, historyk chciał się do kogoś przyłączyć, by prowadzić badania w terenie.} {%name% ma niewiele wspólnego z prawdziwymi żołnierzami, ale jego wyobraźnia i tak tęskni za dobrą bitwą. | Choć %name% całe życie pisał, dokładnie ani chwili nie spędził na walce. Do teraz. | %name% czuje potrzebę spisania waszych wędrówek. Może pomóc, chwytając za miecz i zakładając zbroję. | Na ramieniu %name% wisi torba pełna książek. Sugerujesz zamianę na cep - podobny, tylko bardziej kłujący i tnący. | %name% często bazgrze notatki, wciąż patrząc na świat oczami badacza. | %name% nosi kieszeń pełną piór. Ich lotki byłyby całkiem niezłymi strzałami. | Możesz zaufać szczerej chęci badawczej %name%, ale niekoniecznie jego umiejętnościom machania mieczem. | Czas %name% w kompanii ma służyć opracowaniu teorii, ale czy przetrwa eksperymenty? | Obiecujesz %name%, że jeśli zginie, znajdziesz sposób, by spisać jego życie. Dziękuje ci i wręcza swój testament. Jest napisany w obcym języku i niczego z niego nie rozumiesz. Uśmiechasz się mimo to.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});

