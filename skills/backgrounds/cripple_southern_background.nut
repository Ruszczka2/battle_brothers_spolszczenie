this.cripple_southern_background <- this.inherit("scripts/skills/backgrounds/cripple_background", {
	m = {},
	function create()
	{
		this.cripple_background.create();
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
		return "%name% {kuśtyka w twoją stronę jak parszywy pies | macha do ciebie ręką, w której brakuje wielu palców | uśmiecha się do ciebie w bezzębnym grymasie | przyjmuje postawę kogoś, kto wygląda, jakby złamano mu kręgosłup | chwieje się na dwóch bardzo sztywnych, być może nawet drewnianych nogach | używa laski, aby podejść w twoim kierunku | najpierw czołga się w twoim kierunku, ale potem podnosi się na nogi z gracją pijaka na schodach kościoła | ma kości, które skrzypią i trzeszczą przy każdym kroku | nosi rękę na temblaku i ma laskę wspierającą jedną z jego nóg | ma zmiażdżony nos i dwoje podbitych oczu | wygląda, jakby ktoś próbował go oskalpować i spalić żywcem | ma ciało, które pachnie na wpół ugotowanym mięsem, a w jego oczach widać cierpienie z każdym krokiem, który robi w twoją stronę | nie ma obu uszu, chociaż same ziejące po obu stronach głowy dziury wciąż w jakimś stopniu rejestrują dźwięk | cuchnie gównem i moczem | ma tylko jedno oko, które na dodatek wyraźnie błądzi | ma dwoje leniwych oczu i krzywy, pełen szczelin uśmiech}. Wyjaśnia, że {był kiedyś murarzem, ale został zaatakowany przez szaleńca za rzekomą próbę odtworzenia jego pracy | dawniej nosił zbroję jako rycerz, ale okrutny los odebrał mu to wszystko | kiedyś był szlachcicem, ale jego ubogie słownictwo zdradza, że to może być kłamstwo | był kiedyś kupcem, ale sprzedaż pewnego rzadkiego specyfiku zakończyła się dla niego popadnięciem w niełaskę u wściekłego miejskiego motłochu | był wyznawcą kultu, ale kiedy porzucił wiarę, pozostali zemścili się na nim za to | bandyci zemścili się na nim, za ukrzyżowanie jednego z nich} | zwykł walczyć na arenie dla Wezyra, ale walka uczyniła go kaleką | wędrował po krainie w poszukiwaniu turniejów rycerskich, ale fatalny w skutkach turniej zakończył się jego straszliwym kalectwem | okradał groby, ale kiedy został przyłapany, parafianin połamał mu więcej kości, niż sądził, że w ogóle ma | parał się {sztukami tajemnymi | nekromancją}, ale, co wydawało się oczywiste po jego bliskim śmierci stanie, eksperyment ten trwał krótko | był kiedyś odnoszącym sukcesy hazardzistą, ale jak się okazuje, niespłacanie długów szkodzi interesom - i kościom | zarabiał na życie łapiąc szczury, ale najwyraźniej gigantyczny szczur złożył mu w nocy mściwą wizytę | służył kiedyś pewnemu szlachcicowi, ale po upuszczeniu tacy z jedzeniem został wysłany do lochów, gdzie zapomniano o nim na lata | zabił kiedyś człowieka, jasne, ale nie zasłużył na aż tak straszliwy los, jak nieodwracalne w skutkach tortury, na jakie go skazano | polował kiedyś na czarownice, ale okrutna kochanka podstępem zmusiła go do wypicia mikstury, która okaleczyła jego ciało | kiedyś zdezerterował z armii i oczywiście został złapany | żonglował dla rodziny królewskiej, dopóki przypadkowo nie spadł ze schodów w trakcie wykonywania akrobacji. Jak się okazało, schody okazały się aż nazbyt twarde jak na jego wątłe kości | urodził się z potworną deformacją | jego ojciec brutalnie pobił go za to, że nie sprostał jego oczekiwaniom | jego matka naznaczyła go niekończącymi się torturami | jego rodzeństwo torturowało go przez całe życie.} {Ten człowiek wygląda tak mizernie, że niemal widać, jak jego ziemska powłoka powiewa na wietrze. | Zatrudnienie go niemal na pewno oznaczałoby jego zgubę. Jakież to miłosierne! | Nie chcesz być postrzegany jako zatrudniający byle kogo, ale jeśli ten facet jest nikim, czy to nadal liczy się jako \'byle kto\'? | Widziałeś martwych ludzi, którzy wyglądali lepiej niż ten człowiek. | Ten facet jest wilczym obiadem na dwóch nogach. | Dobrą wiadomością jest to, że jeśli powróci z martwych, nie powinno być zbyt trudno ułożyć go do snu po raz drugi. | Sny i przedmioty martwe są bardziej niebezpieczne niż ten biedak. | Szczerze mówiąc, wolałbyś zatrudnić dziecko, ale jako że ludzie krzywo na to patrzą, to stajesz przed takimi wyborami, jak teraz. | A myślałeś, że to %randombrother% brzydko pachnie. | Zatrudnienie takiego człowieka sprawiłoby, że kompas moralny każdej osoby zacząłby się kręcić. | Spójrz na niego! Czy nasza kompania aż tak bardzo potrzebuje świeżych zwłok? | Zatrudnienie tego człowieka nie byłoby w porządku. Cóż, no to lecimy. | Para kul, na których się spiera, ma większą wartość niż ten biedny człowiek. | Ten człowiek jest w tak żałosnym stanie, że na stojąco może udawać martwego.}";
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

