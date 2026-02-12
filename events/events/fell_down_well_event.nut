this.fell_down_well_event <- this.inherit("scripts/events/event", {
	m = {
		Strong = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.fell_down_well";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_91.png[/img]Kobieta wyskakuje zza linii drzew przy ścieżce.%SPEECH_ON%O, dzięki bogom, moje modlitwy zostały wysłuchane! Proszę, szybko! Mój dziadek wpadł do studni!%SPEECH_OFF%Odwraca się i biegnie, jakbyś już zgodził się jej pomóc. %otherbrother% spogląda na ciebie i wzrusza ramionami.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chyba możemy jej pomóc.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Strong != null)
				{
					this.Options.push({
						Text = "%strongbrother%, jesteś silny. Pomóż jej.",
						function getResult( _event )
						{
							return "Strong";
						}

					});
				}

				this.Options.push({
					Text = "Nie mamy na to czasu.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_91.png[/img]Postanawiasz, że warto poświęcić czas i idziesz zobaczyć, co się stało. Starzec naprawiał zwieńczenie studni, drewnianą konstrukcję zakrywającą otwór, kiedy ta się rozpadła i wysłała go w dół. Wpatrując się do studni, widzisz, że on patrzy z powrotem. Macha ręką.%SPEECH_ON%O, hej tam, chłopaki. Jestem w niezłej opresji. Właściwie to się marynuję, teraz jak o tym myślę...%SPEECH_OFF%Ech, no tak. %otherbrother% rzuca mu linę, a starzec wiąże ją wokół siebie. Ty i najemnik wyciągacie dziadka kobiety na suchy ląd. Ściska ci dłoń i dziękuje uprzejmie.%SPEECH_ON%Cholera, dobrze, że przyszliście, bo już miałem robić w gacie jak nigdy. Powiem wam, to nie pierwszy raz, kiedy wpadam do studni. Pięć lat temu też tak było, gdy naprawiałem zwieńczenie, bo ono często się psuje, rozumiecie. I to w sumie nie jest żadna głowica studni, tak ją tylko nazywamy, bo jesteśmy leniwi. Za moich czasów nazywaliśmy to... no cóż, heh, właściwie zapomniałem. Chyba \"głowica studni\" pasuje, bo ja już nie jestem w głowie zdrów! Ha! Jeszcze to mam. Kiedyś byłem niezłym zawadiaką, wiecie, a nieczęsto mam okazję to przećwiczyć. Moja żona zmarła dziesięć lat temu, a ta przed nią zostawiła mnie dwadzieścia zim temu! Mówię \"zim\", bo wtedy odeszła, zimą. To była sroga zima i prosiłem ją, żeby pomogła rąbać drewno, żebyśmy nie zamarzli. Powiedziała, że nie będzie robić tego gówna i jednocześnie zajmować się dziećmi. Miałem z nią dzieci, tak jak z drugą żoną. Razem pięcioro. Jedno zmarło. Od odry. Drugie zniknęło, więc pewnie nie żyje. Staram się być ze sobą szczery, ale wiesz, jest nadzieja. Skoro przypadkowy nieznajomy mógł się trafić w lesie i uratować mnie w ostatniej chwili, to może mój syn przeżył tę bitwę z zielonoskórymi. Ale nic o nim nie słyszałem. Modlę się do starych bogów, a czasem nawet do tego Davkula. Znasz Davkula? Nie wiem, co o tym myśleć. Raz przyszedł tu facet z blizną na czole i powiedział, że pokaże mi drogę ciemności. Powiedziałem, że widzę ciemność za każdym razem, gdy zdrzemnę się. Ten bliznowaty powiedział, że kiedyś się nie obudzę, a ja na to: dobrze! Ha! No i wtedy ten bliznowaty drań zaczyna się na mnie wściekać...%SPEECH_OFF%Gdy tak ględzi, rozglądasz się za %otherbrother%, ale widzisz go wychodzącego z domu kobiety, która ma na twarzy... wyraźne ciepło. Zabierasz swojego najemnika i odchodzisz, zanim starzec urwie ci głowę najdłuższą i najbardziej jednostronną rozmową w życiu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nikogo nigdy nie ma, by mnie uratować.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.improveMood(2.0, "Got some loving");

				if (_event.m.Other.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_91.png[/img]Starzec naprawiał drewniane zwieńczenie studni, gdy się rozpadło. Niestety, jeśli stoisz na zwieńczeniu studni, gdy pęka, jest tylko jedno miejsce, do którego możesz trafić: w dół. Bardzo, bardzo daleko w dół. Gdy spoglądasz przez krawędź studni, widzisz starca unoszącego się w czymś, co zdecydowanie nie jest żywe. %otherbrother% podchodzi i szepcze, zasłaniając usta dłonią, by nie było słychać.%SPEECH_ON%Eee, on się nie rusza.%SPEECH_OFF%Błyskotliwa obserwacja, naprawdę. Informujesz kobietę o śmierci mężczyzny. Zaciska usta i prosi, byś mimo wszystko wydobył ciało, wyjaśniając krótko, dlaczego.%SPEECH_ON%Nie możemy przecież pić jego brudu.%SPEECH_OFF%Słusznie. %otherbrother% udaje się zahaczyć pętlę liny o zwłoki i wyciągnąć je, a kończyny bezwładnie zwisają jak białe szmaty do prania. Pyta, czy ma go też pochować. Kobieta ociera łzę i kręci głową.%SPEECH_ON%Nie. Sama pochowam tego faceta, jutro popłaczę nad jego grobem, a potem wrócę do życia.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No dobrze.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Strong",
			Text = "[img]gfx/ui/events/event_91.png[/img]Postanawiasz, że warto poświęcić czas i idziesz zobaczyć. Zwieńczenie studni, drewniana konstrukcja zakrywająca otwór, rozpadło się. Najwyraźniej starzec naprawiał je, gdy to się stało, więc wpadł do studni. Patrzy na ciebie z dołu.%SPEECH_ON%O, hej tam, chłopaki. Jestem w niezłej opresji. Właściwie to się marynuję, teraz jak o tym myślę...%SPEECH_OFF%Ech, no tak. %strongbrother% rzuca linę. Starzec wiąże ją wokół siebie. Ty i najemnik wyciągacie dziadka kobiety na suchy ląd. Ściska ci dłoń i dziękuje uprzejmie.%SPEECH_ON%Cholera, dobrze, że przyszliście, bo już miałem robić w gacie jak nigdy.%SPEECH_OFF%Rozmawiasz chwilę ze staruszkiem, poznając sporo o jego życiu. Po pewnym czasie uświadamiasz sobie, że %strongbrother% zniknął. Gdy już masz go szukać, wychodzi z domu kobiety. Ona trzyma się jego mięśni i zachowuje się dość obcesowo.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wkrótce będą tu biegać silne chłopaki, bez wątpienia...",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Strong.getImagePath());
				_event.m.Strong.improveMood(2.0, "Got some loving");

				if (_event.m.Strong.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Strong.getMoodState()],
						text = _event.m.Strong.getName() + this.Const.MoodStateEvent[_event.m.Strong.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_strong = [];
		local candidates_other = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getSkills().hasSkill("trait.strong"))
			{
				candidates_strong.push(b);
			}
			else
			{
				candidates_other.push(b);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_strong.len() != 0)
		{
			this.m.Strong = candidates_strong[this.Math.rand(0, candidates_strong.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
		_vars.push([
			"strongbrother",
			this.m.Strong != null ? this.m.Strong.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Other = null;
		this.m.Strong = null;
	}

});

