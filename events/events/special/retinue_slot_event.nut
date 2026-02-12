this.retinue_slot_event <- this.inherit("scripts/events/event", {
	m = {
		LastSlotsUnlocked = 0
	},
	function create()
	{
		this.m.ID = "event.retinue_slot";
		this.m.Title = "Po drodze...";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{Sława i prestiż kompanii rosną. Dokądkolwiek się udasz, ludzie chcą do ciebie dołączyć - nie tylko najemnicy, ale i towarzysze, którzy mogą przydać się do czegoś innego! | Z każdą bitwą, w której walczą twoi najemnicy, wzrasta reputacja kompanii. W raz ze wzrostem sławy, więcej ludzi, nie tylko najemników, będzie chciało do was dołączyć. Być może to już czas, by kompania przyjęła kolejnego towarzysza? | Nasza kompania potrzebuje nie tylko wojowników - - wygląda na to, ze wraz z rosnącą sławą i prestiżem mogą pojawić się inni, którzy chętnie za tobą wyruszą. Być może ci towarzysze przysłużą się kompanii w jakiś sposób, nawet jeśli niekoniecznie staną na polu bitwy.}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przyjrzę się naszej świcie!",
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local unlocked = this.World.Retinue.getNumberOfUnlockedSlots();

		if (unlocked > this.m.LastSlotsUnlocked && this.World.Retinue.getNumberOfCurrentFollowers() < unlocked)
		{
			this.m.Score = 400;
		}
	}

	function onPrepare()
	{
		this.m.LastSlotsUnlocked = this.World.Retinue.getNumberOfUnlockedSlots();
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU8(this.m.LastSlotsUnlocked);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);
		this.m.LastSlotsUnlocked = _in.readU8();
	}

});

