this.slave_southern_background <- this.inherit("scripts/skills/backgrounds/slave_background", {
	m = {},
	function create()
	{
		this.slave_background.create();
		this.m.GoodEnding = "Kupiłeś %name% jako zadłużonego za niemal bezcen i nadal płaciłeś mu 'niewolniczą' stawkę za jego służbę jako najemnika. Stał się skutecznym wojownikiem, zapewne wierząc, że lepiej dostawać nic i walczyć o życie, niż dostawać nic i poddać się, by zgnić. Po twoim odejściu usłyszałeś, że %companyname% ruszyła na południe na wyprawę, a zadłużony dostał dobrą okazję, by wyrównać rachunki z wieloma dawnymi wrogami. Na szczęście nie zalicza ciebie do nich, mimo że trzymałeś go w zniewoleniu.";
		this.m.BadEnding = "Kupiłeś %name% jako zadłużonego i po twoim odejściu pozostał w %companyname%. Zaczęły napływać wieści o kłopotach najemnej bandy, ale nic o obecnej sytuacji zadłużonego. Znając ten świat, albo został rzucony do awangardy jako mięso armatnie, albo sprzedany, by odzyskać część zysków. Tak czy inaczej, świat nie jest łaskawy ani dla najemnika, ani dla zadłużonego, a on niestety jest jednym i drugim.";
		this.m.Bodies = this.Const.Bodies.SouthernSlave;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.Titles = [
			"Zniewolony",
			"Więzień",
			"Pechowiec",
			"Zadłużony",
			"Zadłużony",
			"Zadłużony",
			"Nie-wolny",
			"Kryminalista",
			"Posłuszny",
			"Zakuty",
			"Związany"
		];
	}

	function onBuildDescription()
	{
		return "{Większość południowych miast-państw zostało wzniesionych na barkach jeńców wojennych, przestępców i zadłużonych - tłumów ludzi, którzy znieważyli Złotnika lub jego zwolenników i muszą \'zasłużyć\' na swoje zbawienie poprzez ciężką pracę. %name% jest jedną z takich nieszczęsnych dusz.} {Podobnie jak wielu innych, %name% nie zawsze był niewolnikiem. Był wędrownym kupcem, dopóki koczownicy nie napadli na jego karawanę. Koczownicy zabrali go przed oblicze Wezyra, wmawiając mu, że to przestępca, i sprzedali w niewolę jako ściganego przez prawo. | Zauważony ze względu na swoją urodę, %name% został porwany z ulic %randomcitystate% i sprzedany bezpośrednio podłemu Wezyrowi. Niewiele mówi o tym, co tam się wydarzyło, ale masz przeczucie, że praca fizyczna nie była jego jedynym obowiązkiem. | Tak wielkie były religijne wykroczenia jego poprzedników, że %name% urodził się w zadłużonej rodzinie i nie wiadomo, jak daleko w przeszłość trzeba by się cofnąć, aby w jego drzewie rodowym odnaleźć wreszcie osobę, która była prawdziwie wolna. | Rozpaczliwie chcąc uratować swoją rodzinę przed długami pokoleniowymi, %name% sam sprzedał się w niewolę kontraktową, aby zapewnić swojej żonie i dzieciom życie w wolności. | %name% zaklina się, że \x200b\x200bpochodzi z północy, jednak pustynie południa i bezlitosne słońce sprawiły, że ma ciemną opaleniznę i szczerze mówiąc, nie masz powodu, aby wierzyć słowom tego byłego jeńca wojennego, bez względu na to, skąd pochodzi. | Dawniej przemierzając morza, %name% spędził lata jako wioślarz, podróżując od portu do portu, aby przewozić towary bogatych kupców. Ci, którzy ci go wydali, twierdzili, że ma kryminalną przeszłość i parał się piractwem. | %name% został oskarżony o gwałt na starej kobiecie i dano mu do wyboru egzekucję lub dożywotnią niewolę. | Przyłapany na kradzieży ze straganu z owocami, %name% został zmuszony do dożywotniej niewoli. | Akty cudzołóstwa z \'nie-kobietami\' doprowadziły do tego, że %name% poddał się niewoli zgodnie z zasadami miasta-państwa, w którym złamał prawo. Miał do wyboru albo to, albo zostanie eunuchem, i trudno dziwić mu się, że w tym wypadku wybrał ciężką pracę.} {Trudności jego życia, co ciekawe, mogą służyć jako doskonały odlew, z którego przy odrobinie szczęścia uda się uformować porządnego najemnika. | Lata ciężkiej służby bez wątpienia nadały temu człowiekowi groźny wygląd, trudno jednak orzec, co dzieje się w tej głowie i dokąd dążą myśli tego człowieka, zmuszonego do najemniczego kontraktu. | Niewolnicy brani na wojowników to powszechny widok w miastach południa, a %name% może posłużyć jeszcze jako użyteczny, choć zniewolony, najemnik. | Żywisz nadzieję, że %name% mógłby zostać dobrym najemnikiem, jednak masz też przeczucie, iż zależy mu tylko na tym, czego chce zasmakować każdy człowiek: wolności.}";
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
				5,
				5
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
				-5,
				-5
			]
		};
		return c;
	}

});

