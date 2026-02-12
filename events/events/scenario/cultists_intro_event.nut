this.cultists_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.cultists_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_71.png[/img]%SPEECH_ON%Złożyłem kobietę i dziecię w stodole, której popioły już zapewne znalazłeś. Byli nieprzytomni, wszak on nie pożądał ich bólu. Nie rozprawiaj proszę nad ich zgonem, bowiem teraz są już z nim, a z ich odejściem zostałem uwolniony z wszelkich zobowiązań, by zrobić to, co zrobić trzeba. Teraz już odejdę. Przyjmę nową rolę, nową twarz, a pod nimi stanę się czymś, czym nie jestem. Będę udawał. Będę grał. Ale tylko w jednym celu. A ty wiesz, jaki to cel. Nie zdradzę go, ale odnajdziesz go w chwilach, gdy zdasz sobie sprawę, że nikt tak naprawdę nie wierzy w to, że umrze. Czystość unicestwienia musi być skryta w odwróceniu uwagi i wesołości. Nie wszyscy mogą go zobaczyć, nie wszyscy powinni, ale w końcu go zobaczą.\n\nBywajcie, nieznajomi, którymi się staliście, wszak Davkul oczekuje nas wszystkich.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Davkul czeka.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Kultyści";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

