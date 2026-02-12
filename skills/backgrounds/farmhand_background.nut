this.farmhand_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.farmhand";
		this.m.Name = "Parobek";
		this.m.Icon = "ui/backgrounds/background_09.png";
		this.m.BackgroundDescription = "Parobkowie przywykli do ciężkiej fizycznej pracy na roli.";
		this.m.GoodEnding = "Były parobek, %name%, opuścił kompanię %companyname%. Zarobione pieniądze przeznaczył na zakup ziemi. Spędza resztę swoich dni szczęśliwie uprawiając glebę i zakładając rodzinę ze zdecydowanie zbyt dużą liczbą dzieci.";
		this.m.BadEnding = "Były parobek, %name%, wkrótce opuścił kompanię %companyname%. Kupił trochę ziemi na {południu | północy | wschodzie | zachodzie} i radził sobie całkiem nieźle - dopóki żołnierze szlachty nie powiesili go na drzewie za odmowę oddania wszystkich plonów.";
		this.m.HiringCost = 90;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.clubfooted",
			"trait.asthmatic"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "{Uprawa ziemi to ciężka praca, wymagająca krwi i potu najwytrwalszych mężczyzn. | Każde gospodarstwo w krainie potrzebuje stałego zastępu wytrzymałych mężczyzn do pracy na polach.  | Człowiek przelewa swój pot uprawiając ziemię, aby móc się wyżywić, a żywi się, aby następnego dnia mieć siły na przelewanie potu przy uprawie ziemi. | Bez względu na to jaka jest pogoda, gospodarstwo wymaga rąk do pracy. | Chlewy, stajnie i nieogrodzone pastwiska, to marzenia, ale także i koszmary rolników. | Podczas gdy niektórzy mężczyźni zarabiają na życie zabijając, inni twardo stąpają po ziemi, zastanawiając się, jakież plony może ona wydać. | Spośród rolników i hodowców wywodzi się specjalna rasa mężczyzn. Wytrzymałych, zdecydowanych, ciężko pracujących. | Przy tak dużym zapotrzebowaniu na żywność nic dziwnego, że rolników jest w królestwie aż tak wielu. | Rolnik nienawidzi, gdy jego ziemia splamiona jest krwią, ale w dzisiejszych czasach staje się to coraz bardziej powszechne. | Podczas wojny gospodarstwa rolne są punktem newralgicznym dla armii. Nie tylko z powodu zasobów żywności, dzięki którym można wyżywić, ale także dlatego, że można tu zrekrutować silnych mężczyzn, pracujących na tych ziemiach. | W miarę jak miasta rosną i oddalają się od terenów położonych w głębi lądu, obywatele często zapominają, komu zawdzięczają swoje pełne brzuchy.} %name% {jest krzepkim, wyrzeźbionym przez pot parobkiem. | pochodzi z obrzeży %randomtown%, gdzie zajeżdżał konie prowadząc pług. | zna kilka rodzajów motyk, którymi z łatwością się posługuje. | dorastał na farmie, jednej z wielu w tym królestwie. | spędził wiele lat na zbieraniu plonów, które wyżywiały wszystkich mieszkańców okolicy. | pracował jako parobek w prostym gospodarstwie. | zajął się rolnictwem po tym, jak jego biznes żeglarski upadł. | został parobkiem, aby pomóc wyżywić tuzin swoich dzieci i dwie żony. | zajął się rolnictwem, aby mieć czym wypełnić brzuch. | ma krępą sylwetkę, która dobrze sprawdza się przy sadzeniu, zbieraniu plonów i przetrwaniu zimy.} {Niestety, nie trzeba było długo czekać, aż wojna i zawierucha odnalazły jego farmę. | Słabe zbiory zmusiły go jednak do opuszczenia farmy. | Na nieszczęście, jego farma była jedną z pierwszych zaatakowanych w tych trudnych czasach. | Jednak wieści o nadchodzącej wojnie odwiodły go od spokojnego zawodu rolnika. | Susze, jak zawsze pojawiające się w najgorszym możliwym czasie, zmusiły go do znalezienia innej pracy. | Nie otrzymując zapłaty za swoją pracę, w końcu porzucił życie na farmie. | Jako że wojaczka stała się obecnie tak dochodowa, jak nigdy wcześniej, bez wahania porzucić swe mizerne uprawy. | Pewnego dnia zdał sobie sprawę, że jego dobrze zbudowane ciało ma większą wartość przy ścinaniu głów, niż dojeniu krów. | Po tym, jak najeźdźcy splądrowali jego uprawy, miał dość i na dobre porzucił życie na farmie. | Po tym, jak pogoda zniszczyła jego zbiory, rolnik zdecydował się wybrać zawód, który nie był całkowicie oparty na kaprysach Matki Natury. | Wieść niesie, że naprawdę przespał się z córką właściciela gospodarstwa. Żadne zaskoczenie więc, że nie ma go już na farmie.} {Karmiony kukurydzą i tym, co obora dała, %name% prezentuje sobą zdrowie i formę, jakiej nigdy nie widziałeś. | Tęskni za krowami, to prawda, ale %name% powinien z łatwością poradzić sobie z ciężkim życiem najemnika. | Dorastając na farmie człowiek ma dostęp do wszystkich składników odżywczych, jakie kiedykolwiek byłyby mu potrzebne, a %name% z pewnością to wykorzystał. | Kiedyś %name% został kopnięty w twarz przez muła. Zwierzę miało złamaną nogę i trzeba było je uśpić. | Gdyby ludzie byli drzewami, %name% nigdy nie został by powalony. Albo coś w tym stylu. | Nie daj się zwieść jego prostej przeszłości, %name% z łatwością dorównałby każdemu zapaśnikowi czy wojownikowi. | %name% ma wiele wspólnego ze zwierzętami pociągowymi. Wystarczy skierować go we właściwą stronę. | Sądząc po jego rozmiarach, w kukurydzy, którą %name% jadł przez całe życie, musiało być dużo mięsa. | %name% jest wystarczająco duży, aby ścisnąć kark faceta, jakby to było wymię krowy.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				12,
				10
			],
			Bravery = [
				-2,
				-3
			],
			Stamina = [
				10,
				20
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
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/pitchfork"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/wooden_flail"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});

