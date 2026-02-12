this.quiver_of_coated_arrows <- this.inherit("scripts/items/ammo/ammo", {
	m = {
		BleedDamage = 10,
		BleedSounds = [
			"sounds/combat/cleave_hit_hitpoints_01.wav",
			"sounds/combat/cleave_hit_hitpoints_02.wav",
			"sounds/combat/cleave_hit_hitpoints_03.wav"
		]
	},
	function create()
	{
		this.ammo.create();
		this.m.ID = "ammo.arrows";
		this.m.Name = "Bloodletter\'s Reach";
		this.m.Description = "Ten dziwny kołczan służy do przechowywania zwykłych strzał i jest przeznaczony do strzelania z łuków wszelkiego rodzaju. Na dole znajduje się jakiś mechanizm, który uwalnia dziwny materiał z ukrytego zbiornika, pokrywający groty strzał i powodujący, że tworzą się na nich wyjątkowo paskudne zadziory. Dokładniejsza analiza nie przyniosła żadnego oczywistego wyjaśnienia pochodzenia powłoki ani sposobu na jej usunięcie bez całkowitego rozmontowania kołczanu. Uzupełnia się automatycznie po każdej bitwie, jeśli masz wystarczająco dużo amunicji.";
		this.m.Icon = "ammo/quiver_05.png";
		this.m.IconEmpty = "ammo/quiver_05_empty.png";
		this.m.SlotType = this.Const.ItemSlot.Ammo;
		this.m.ItemType = this.Const.Items.ItemType.Ammo | this.Const.Items.ItemType.Legendary;
		this.m.AmmoType = this.Const.Items.AmmoType.Arrows;
		this.m.ShowOnCharacter = true;
		this.m.ShowQuiver = true;
		this.m.Sprite = "bust_quiver_02";
		this.m.Value = 700;
		this.m.Ammo = 10;
		this.m.AmmoMax = 10;
		this.m.IsDroppedAsLoot = true;
	}

	function getTooltip()
	{
		local result = [
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

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.m.Ammo != 0)
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "Zawiera [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Ammo + "[/color] strzał"
			});
		}
		else
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Jest pusty i bezużyteczny[/color]"
			});
		}

		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Zadaje dodatkowe [color=" + this.Const.UI.Color.DamageValue + "]" + this.m.BleedDamage + "[/color] obrażeń od krwawienia na turę, przez 2 tury"
		});
		return result;
	}

	function onDamageDealt( _target, _skill, _hitInfo )
	{
		if (_skill.getID() != "actives.aimed_shot" && _skill.getID() != "actives.quick_shot")
		{
			return;
		}

		if (!_target.isAlive() || _target.isDying())
		{
			if (this.isKindOf(_target, "lindwurm_tail") || !_target.getCurrentProperties().IsImmuneToBleeding)
			{
				this.Sound.play(this.m.BleedSounds[this.Math.rand(0, this.m.BleedSounds.len() - 1)], this.Const.Sound.Volume.Skill, this.getContainer().getActor().getPos());
			}
		}
		else if (!_target.getCurrentProperties().IsImmuneToBleeding && _hitInfo.DamageInflictedHitpoints >= this.Const.Combat.MinDamageToApplyBleeding)
		{
			local effect = this.new("scripts/skills/effects/bleeding_effect");
			effect.setDamage(this.m.BleedDamage);
			_target.getSkills().add(effect);
			this.Sound.play(this.m.BleedSounds[this.Math.rand(0, this.m.BleedSounds.len() - 1)], this.Const.Sound.Volume.Skill, this.getContainer().getActor().getPos());
		}
	}

});

