this.minstrel_writes_song_event <- this.inherit("scripts/events/event", {
	m = {
		Minstrel = null,
		OtherBrother = null
	},
	function create()
	{
		this.m.ID = "event.minstrel_writes_song";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%minstrel% minstrela podnosi lutnię. Nie masz pojęcia, skąd ją wziął, ale szarpie struny kilka razy, przyciągając uwagę reszty kompanii. Unosi głowę, zamyka oczy i zaczyna śpiewać.%SPEECH_ON%Ja... -brzdęk- dołączyłem do bandy najemników, sakiewki puste już były... -brzdęk-... chcieli wojownika, a ja miałem tylko pieśni. Koniec.%SPEECH_OFF%Kompania się śmieje, gdy błazen przerzuca lutnię przez ramię. | %minstrel% minstrela wyciąga lutnię jakby znikąd, niczym magik króliku. Uderza w struny z wprawą, po czym zaczyna śpiewać.%SPEECH_ON%Był sobie potwór, co dręczył piękne Riggabong... -brzdęk-... Mówili na niego, jeśli dobrze pamiętam, wielki kłopot... -brzdęk brzdęk-...\n\nTa bestia ucztowała tylko na damach, lecz tylko na dziewicach, o tak miała smak!...-figlarny brzdęk-... lecz to oczywiście nie było, dla mężczyzny ni kobiety, pożądanym losem!...-niepewny brzdęk, nowy-...\n\n Więc najęli sir Galicocka, najlepszego miecznika w krainie...-wesoły brzdęk-... i tak chodził od drzwi do drzwi, i pokonał każdą dziewicę, jak dobry szermierz potrafi!...-długi, smutny brzdęk-... a potwór umarł z głodu. Koniec.%SPEECH_OFF% | Gdy ogień trzaska, a ludzie zaczynają robić się senni w jego blasku, %minstrel% minstrela chrząka w sposób, który najlepiej opisać jako \"wszyscy słuchajcie\". Wstaje i unosi dłoń, jakby trzymał w niej kielich do toastu.%SPEECH_ON%Aj, jesteście jednymi z najlepszych mężczyzn, jakich spotkałem. Mówię tak, bo nigdy nie znałem ojca i całe lata spędziłem wśród kobiet.%SPEECH_OFF%Patrzy tęsknie w dal.%SPEECH_ON%Cholera, byłem z wieloma kobietami.%SPEECH_OFF%Po czym siada. Chwila ciszy wisi w powietrzu, aż pęka pod naporem gromkiego śmiechu. | %minstrel% minstrela szuka swojej lutni. Nie mogąc jej znaleźć, sięga po \"powietrzną lutnię\" i figlarnie skubie struny kciukiem.%SPEECH_ON%Czekajcie, to nie zabrzmiało dobrze, już stroję.%SPEECH_OFF%Unosi dłoń i przekręca palec, po czym uderza ponownie.%SPEECH_ON%Co do diabła? To było gorsze niż pierwsze. Moment, ogarnę, obiecuję.%SPEECH_OFF%Próbuje jeszcze raz, ale najwyraźniej i ten \"brzdęk\" był do niczego.%SPEECH_ON%A niech to szlag, kawał gówna!%SPEECH_OFF%Minstrela zrywa się na nogi i kilka razy roztrzaskuje niewidzialną lutnię o ziemię, po czym ciska ją w wysoką trawę. Ociera pot z czoła.%SPEECH_ON%Miałeś rację, drogi ojcze, powinienem był zostać kowalem.%SPEECH_OFF%A potem odchodzi z hukiem, a za nim trzaska zmieszany śmiech kompanii. | Gdy wrzuca ziemię do ognia, %minstrel% minstrela zaczyna mówić, nie wiadomo do kogo.%SPEECH_ON%Starzy bogowie powiedzieli: niech stanie się światło, prawda? To pierwsza rzecz, którą uczynili, więc światło musi być ważne.%SPEECH_OFF%Podnosi grudkę ziemi i zdaje się ją analizować.%SPEECH_ON%Czemu więc tyle przyjemności można znaleźć tam, gdzie kobieta jest najciemniejsza?%SPEECH_OFF%Początkowo zdezorientowani obserwatorzy wybuchają śmiechem. | %minstrel% minstrela wstaje i stuka obcasami.%SPEECH_ON%Mam wam, głupcy, pokazać jak tańczyć?%SPEECH_OFF%Kilku mężczyzn podnosi wzrok i kręci głowami.%SPEECH_ON%No chodźcie. To proste. Patrzcie.%SPEECH_OFF%Mężczyzna unosi nogę, wyginając ją pod kątem, pod jakim żadna noga nie powinna się znaleźć, po czym stawia ją z powrotem na ziemi. Wiruje, ręce nad głową. Potem rozkłada ramiona, jakby miał odlecieć. To naprawdę całkiem piękne, choć nigdy byś się do tego nie przyznał. Patrzysz, jak minstrela kontynuuje, pochylając się, kiedy nagle puszcza potwornego bąka prosto w twarz %otherbrother%.\n\n %minstrel% prostuje się natychmiast, jakby gaz naprawił mu kręgosłup i chciał od razu z tego skorzystać.%SPEECH_ON%Ja, eee... no, to wszystko, ludzie! Mam nadzieję, że już umiecie kroki!%SPEECH_OFF%Ucieka, a za nim goni szczególnie urażony i śmierdzący mężczyzna. Reszta ludzi zwija się ze śmiechu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Brawo!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Minstrel.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Czuł się rozbawiony");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_minstrel = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.minstrel")
			{
				candidates_minstrel.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_minstrel.len() == 0)
		{
			return;
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Minstrel = candidates_minstrel[this.Math.rand(0, candidates_minstrel.len() - 1)];
		this.m.OtherBrother = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = candidates_minstrel.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"minstrel",
			this.m.Minstrel.getNameOnly()
		]);
		_vars.push([
			"otherbrother",
			this.m.OtherBrother.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Minstrel = null;
		this.m.OtherBrother = null;
	}

});

