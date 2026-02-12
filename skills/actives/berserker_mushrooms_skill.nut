this.berserker_mushrooms_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.berserker_mushrooms";
		this.m.Name = "Zjedz lub Podaj Dziwne Grzybki";
		this.m.Description = "Podaj pobliskiemu sojusznikowi lub zjedz dziwne grzybki, aby wejść w szaleńczy trans, w którym nie będziesz dbać o własne bezpieczeństwo. Może powodować mdłości. Efekt będzie powoli ustępował przez 4 tury. Nie można użyć, gdy wróg zbliży się na odległość walki wręcz, a osoba otrzymująca przedmiot musi mieć wolne miejsce w swojej podręcznej sakwie.";
		this.m.Icon = "skills/active_98.png";
		this.m.IconDisabled = "skills/active_98_sw.png";
		this.m.Overlay = "active_98";
		this.m.SoundOnUse = [
			"sounds/combat/eat_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = true;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 5;
		this.m.MinRange = 0;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Przyznaje [color=" + this.Const.UI.Color.PositiveValue + "]+40%[/color] do obrażeń zadawanych w zwarciu"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "Przyznaje [color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] do Obrony w zwarciu"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "Przyznaje [color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] do Obrony dystansowej"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Brak testów na morale po utraceniu punktów zdrowia"
			}
		];

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Nie można użyć, gdyż wróg zbliżył się na odległość walki wręcz[/color]"
			});
		}

		return ret;
	}

	function getCursorForTile( _tile )
	{
		if (_tile.ID == this.getContainer().getActor().getTile().ID)
		{
			return this.Const.UI.Cursor.Drink;
		}
		else
		{
			return this.Const.UI.Cursor.Give;
		}
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (!this.m.Container.getActor().isAlliedWith(target))
		{
			return false;
		}

		if (target.getID() != _originTile.getEntity().getID() && !target.getItems().hasEmptySlot(this.Const.ItemSlot.Bag))
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local user = _targetTile.getEntity();

		if (_user.getID() == user.getID())
		{
			local shrooms = user.getSkills().getSkillByID("effects.berserker_mushrooms");

			if (shrooms != null)
			{
				shrooms.reset();
			}
			else
			{
				user.getSkills().add(this.new("scripts/skills/effects/berserker_mushrooms_effect"));
			}

			if (!_user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " zjada Dziwne Grzybki");
			}

			if (this.m.Item != null && !this.m.Item.isNull())
			{
				this.m.Item.removeSelf();
			}

			this.Const.Tactical.Common.checkDrugEffect(user);
		}
		else
		{
			if (!_user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " podaje Dziwne Grzybki do: " + this.Const.UI.getColorizedEntityName(user));
			}

			this.spawnIcon("status_effect_67", _targetTile);
			this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
			local item = this.m.Item.get();
			_user.getItems().removeFromBag(item);
			user.getItems().addToBag(item);
		}

		return true;
	}

});

