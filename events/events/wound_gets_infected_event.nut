this.wound_gets_infected_event <- this.inherit("scripts/events/event", {
	m = {
		Injured = null,
		Other = null,
		WoundName = ""
	},
	function create()
	{
		this.m.ID = "event.wound_gets_infected";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_34.png[/img]{Odkrywasz %woundedbrother% nieprzytomnego w trawie i nie ma przy nim miodu ani piwa, które mogłyby być winne temu omdleniu. Kucasz i widzisz, że jego oczy są przygaszone, a on nie odpowiada na pytania. Jego klatka piersiowa unosi się i opada w nierównym oddechu. Odsuwasz opatrunki z jego %wound%, odsłaniając zielone, chore mięso. | %woundedbrother% śmieje się z resztą ludzi, gdy nagle przewraca się, a oczy zachodzą mu do tyłu. Reszta mężczyzn rusza mu na pomoc.%SPEECH_ON%Panie, jego rana jest czymś więcej niż bolesna.%SPEECH_OFF%Ciało wokół jego %wound% zrobiło się miękkie, oblepione martwą skórą i pulsującą zielenią zakażenia, gotową do odchodzenia płatami. | %woundedbrother% ma zakażoną %wound%. Mięso wokół rany jest czarne, a to, co ma kolor, jest zielone - oba bardzo złe znaki. | Zakażenie osiada w %woundedbrother% %wound%. Nie da się powiedzieć, czy przeżyje, ale tak czy inaczej przez jakiś czas będzie w kiepskim stanie. | Zastajesz %woundedbrother% opartego o drzewo. Trzęsie się, a ślina spływa mu z ust.%SPEECH_ON%Wszystko w porządku, panie. Moja %wound% jest tylko... trochę zakażona. Dajcie mi czas, wyzdrowieję.%SPEECH_OFF%Zaciskasz usta. Może wydobrzeje sam, ale bez opieki raczej nie będzie w stanie walczyć. | %woundedbrother% nie jest już w dobrej formie do walki. Jego rany się zakaziły. Bez natychmiastowej opieki może minąć trochę czasu, zanim wróci do pełnej formy. | %woundedbrother% zatacza się do twojego namiotu. Kaszle w zgięcie łokcia, a ciągnąca się ślina łączy je z ustami.%SPEECH_ON%Cholera, przepraszam, panie. Ja, ee, chyba jestem trochę chory.%SPEECH_OFF%Spoglądając na niego, wnioskujesz, że jego rany się zakaziły. Może wciąż byłby w stanie walczyć, ale lepiej nie ryzykować, dopóki nie wydobrzeje. | Gdy kompania je przy ognisku, %woundedbrother% nagle wymiotuje. Widzisz pot na jego czole i lekko zamglone oczy. %otherbrother% kręci głową.%SPEECH_ON%Panie, jego rany się zakaziły.%SPEECH_OFF%Ranny brat pada z powrotem w trawę, wymachując rękami.%SPEECH_ON%Nic mi nie jest, wy gamonie. Pobiję was wszystkich.%SPEECH_OFF%Zaciśnięte pięści poruszają się w przód i w tył, aż zapada w głęboki sen. Tak, pewnie nie będzie gotów do walki przez jakiś czas. | Bitwy zbierają żniwo, a czasem ludzie przeżywają rany, które potem ich dopadają. %woundedbrother% jest takim człowiekiem - zakażenie z ran rozprzestrzeniło się po jego ciele. Jest bardzo chory i nie powinien walczyć, chyba że to absolutnie konieczne. | Z każdą bitwą człowiek ryzykuje śmierć. Z każdą raną ryzykuje zakażenie. %woundedbrother% dostał to drugie i może ono wyprzedzić to pierwsze. Jego rany stały się czarne, a tam, gdzie nie są czarne, są zielone. Potrafi chodzić, ale prawdopodobnie powinien trzymać się z dala od pierwszej linii, dopóki nie wydobrzeje. | Człowiek może przeżyć bitwę z okropnymi ranami, ale to tylko początek kolejnej walki z zakażeniem. Rany %woundedbrother% się pogorszyły i mogą potrzebować czasu, by się zagoić. Jeśli nie jest to absolutnie konieczne, powinien trzymać się z dala od pierwszej linii. | Rany %woundedbrother% się pogorszyły, być może są zakażone. Jedni sugerują larwy, by oczyścić zakażenie, inni wspominają o amputacjach i bardziej drastycznych środkach. Jak dla ciebie, trzeba po prostu dać temu czas. To powiedziawszy, najemnik powinien raczej trzymać się z dala od walk, dopóki nie wydobrzeje.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{Mam nadzieję, że dasz radę. | To nie wygląda dobrze. | Idź odpocząć, %woundedbrothershort%.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Injured.getImagePath());
				local injury = _event.m.Injured.addInjury([
					{
						ID = "injury.infection",
						Threshold = 0.25,
						Script = "injury/infected_wound_injury"
					}
				]);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Injured.getName() + " doznaje " + injury.getNameOnly()
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			local injuries = bro.getSkills().query(this.Const.SkillType.TemporaryInjury);
			local next = false;

			foreach( inj in injuries )
			{
				if (inj.getID() == "injury.infection")
				{
					next = true;
					break;
				}
			}

			if (next)
			{
				continue;
			}

			foreach( inj in injuries )
			{
				if (!inj.isTreated() && inj.getInfectionChance() != 0)
				{
					candidates.push(bro);
				}
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Injured = candidates[this.Math.rand(0, candidates.len() - 1)];

		do
		{
			this.m.Other = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
		while (this.m.Other.getID() == this.m.Injured.getID());

		this.m.Score = candidates.len() * 7;
	}

	function onPrepare()
	{
		local injuries = this.m.Injured.getSkills().query(this.Const.SkillType.TemporaryInjury);
		local wound;
		local highest = -1.0;

		foreach( inj in injuries )
		{
			if (!inj.isTreated() && inj.getInfectionChance() > highest)
			{
				wound = inj;
				highest = inj.getInfectionChance();
			}
		}

		this.m.WoundName = wound.getNameOnly().tolower();
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wound",
			this.m.WoundName
		]);
		_vars.push([
			"woundedbrother",
			this.m.Injured.getName()
		]);
		_vars.push([
			"woundedbrothershort",
			this.m.Injured.getNameOnly()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Injured = null;
		this.m.Other = null;
		this.m.WoundName = "";
	}

});

