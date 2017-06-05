local GUI = {
	-- General
	{type = 'header', 		text = 'General', align = 'center'},
	{type = 'checkbox',		text = 'Multi-Dot',						key = 'multi', 	default = true},
	{type = 'checkbox',		text = 'Sinister Circulation',			key = 'sin', 	default = true},
	{type = 'checkbox',		text = 'Mantle of the Master Assassin',	key = 'mantle', default = true},
	{type = 'ruler'},{type = 'spacer'},
	
	-- Survival
	{type = 'header', 		text = 'Survival', align = 'center'},
	{type = 'spinner', 		text = 'Crimson Vial', 					key = 'cv', 	default_spin = 65},
	{type = 'checkspin', 	text = 'Health Potion', 				key = 'hp', 	default_check = true, default_spin = 25},
	{type = 'checkspin',	text = 'Healthstone', 					key = 'hs', 	default_check = true, default_spin = 25},
	{type = 'ruler'},{type = 'spacer'},
	
	--Cooldowns
	{type = 'header', 		text = 'Cooldowns when toggled on', align = 'center'},
	{type = 'checkbox',		text = 'Vanish',						key = 'van', 	default = true},
	{type = 'checkbox',		text = 'Vendetta',						key = 'ven', 	default = true},
	{type = 'checkbox',		text = 'Potion of the Old War',			key = 'ow', 	default = true},
	{type = 'ruler'},{type = 'spacer'},} 

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- Supported Talents')
	print('|cffADFF2F --- WIP')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {

}

local interrupts = {
	{ 'Consume Magic'},
	{ 'Arcane Torrent', 'target.range <= 8 & spell(Kick).cooldown > gcd & !prev_gcd(Rebuke)'},
}

local survival = {
	{ 'Feint', 'boss1.buff(Blood of the Father) & !player.buff'},

	{ 'Crimson Vial', 'player.health <= UI(cv) & player.energy >= 35'},
	{ 'Feint', 'player.health <= 75 & !player.buff & talent(4,2)'},
	{ 'Feint', '!player.buff & player.health <= UI(cv) & player.xequipped(137069)'},
	
	-- Health Pot
	{ '#Ancient Healing Potion', 'UI(hp_check) & player.health <= UI(hp_spin)'},
	
	-- Healthstones
	{ '#Healthstone', 'UI(hs_check) & player.health <= UI(hs_spin)'},
	
	--------------------------------------
	------------- T19 Bosses -------------
	--------------------------------------
	
	-- Tich
	{ 'Feint', '!player.buff & player.debuff(Carrion Plague)'},
	
	-- Krosus
	{ 'Feint', '!player.buff & target.casting(Slam).percent >= 75 & !player.lastcast'},
	{ 'Feint', '!player.buff & target.casting(Orb of Destruction).percent >= 75 & !player.lastcast'},
	{ 'Feint', '!player.buff & target.casting(Burning Pitch).percent >= 75 & !player.lastcast'},
	{ 'Feint', '!player.buff & boss1.casting(Slam).percent >= 75 & !player.lastcast'},
	{ 'Feint', '!player.buff & boss1.casting(Orb of Destruction).percent >= 75 & !player.lastcast'},
	{ 'Feint', '!player.buff & boss1.casting(Burning Pitch).percent >= 75 & !player.lastcast'},
}

local cooldowns = {
	--# Use Metamorphosis when we are done pooling Fury and when we are not waiting for other cooldowns to sync.
	--actions.cooldown=metamorphosis,if=!(talent.demonic.enabled|variable.pooling_for_meta|variable.waiting_for_nemesis|variable.waiting_for_chaos_blades)|target.time_to_die<25
	--actions.cooldown+=/metamorphosis,if=talent.demonic.enabled&buff.metamorphosis.up&fury<40
	--# If adds are present, use Nemesis on the lowest HP add in order to get the Nemesis buff for AoE
	--actions.cooldown+=/nemesis,target_if=min:target.time_to_die,if=raid_event.adds.exists&debuff.nemesis.down&(active_enemies>desired_targets|raid_event.adds.in>60)
	--actions.cooldown+=/nemesis,if=!raid_event.adds.exists&(buff.chaos_blades.up|buff.metamorphosis.up|cooldown.metamorphosis.adjusted_remains<20|target.time_to_die<=60)
	--actions.cooldown+=/chaos_blades,if=buff.metamorphosis.up|cooldown.metamorphosis.adjusted_remains>60|target.time_to_die<=12
	--actions.cooldown+=/use_item,slot=trinket2,if=!buff.metamorphosis.up&(!talent.first_blood.enabled|!cooldown.blade_dance.ready)&(!talent.nemesis.enabled|cooldown.nemesis.remains>30|target.time_to_die<cooldown.nemesis.remains+3)
	--actions.cooldown+=/potion,name=old_war,if=buff.metamorphosis.remains>25|target.time_to_die<30
}
	
local normal = {
	--# General APL for Non-Demonic Builds
	--actions.normal=pick_up_fragment,if=talent.demonic_appetite.enabled&fury.deficit>=35
	
	--# Vengeful Retreat backwards through the target to minimize downtime.
	--actions.normal+=/vengeful_retreat,if=(talent.prepared.enabled|talent.momentum.enabled)&buff.prepared.down&buff.momentum.down
	--# Fel Rush for Momentum and for fury from Fel Mastery.
	--actions.normal+=/fel_rush,if=(talent.momentum.enabled|talent.fel_mastery.enabled)&(!talent.momentum.enabled|(charges=2|cooldown.vengeful_retreat.remains>4)&buff.momentum.down)&(!talent.fel_mastery.enabled|fury.deficit>=25)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
	--# Use Fel Barrage at max charges, saving it for Momentum and adds if possible.
	--actions.normal+=/fel_barrage,if=(charges=max_charges)&(buff.momentum.up|!talent.momentum.enabled)&(active_enemies>desired_targets|raid_event.adds.in>30)
	--actions.normal+=/throw_glaive,if=talent.bloodlet.enabled&(!talent.momentum.enabled|buff.momentum.up)&charges=2
	--actions.normal+=/felblade,if=fury<15&(cooldown.death_sweep.remains<2*gcd|cooldown.blade_dance.remains<2*gcd)
	{ 'Felblade', 'fury < 15 & { spell(Death Sweep).cooldown < 2 * gcd || spell(Blade Dance).cooldown < 2 * gcd }'},
	--actions.normal+=/death_sweep,if=variable.blade_dance
	--actions.normal+=/fel_rush,if=charges=2&!talent.momentum.enabled&!talent.fel_mastery.enabled
	--actions.normal+=/fel_eruption
	{ 'Fel Eruption'},
	--actions.normal+=/fury_of_the_illidari,if=(active_enemies>desired_targets|raid_event.adds.in>55)&(!talent.momentum.enabled|buff.momentum.up)&(!talent.chaos_blades.enabled|buff.chaos_blades.up|cooldown.chaos_blades.remains>30|target.time_to_die<cooldown.chaos_blades.remains)
	--actions.normal+=/blade_dance,if=variable.blade_dance&(!cooldown.metamorphosis.ready)
	--actions.normal+=/throw_glaive,if=talent.bloodlet.enabled&spell_targets>=2&(!talent.master_of_the_glaive.enabled|!talent.momentum.enabled|buff.momentum.up)&(spell_targets>=3|raid_event.adds.in>recharge_time+cooldown)
	--actions.normal+=/felblade,if=fury.deficit>=30+buff.prepared.up*8
	{ 'Felblade', 'deficit >= 30'},
	--actions.normal+=/eye_beam,if=talent.blind_fury.enabled&(spell_targets.eye_beam_tick>desired_targets|fury.deficit>=35)
	--actions.normal+=/annihilation,if=(talent.demon_blades.enabled|!talent.momentum.enabled|buff.momentum.up|fury.deficit<30+buff.prepared.up*8|buff.metamorphosis.remains<5)&!variable.pooling_for_blade_dance
	--actions.normal+=/throw_glaive,if=talent.bloodlet.enabled&(!talent.master_of_the_glaive.enabled|!talent.momentum.enabled|buff.momentum.up)&raid_event.adds.in>recharge_time+cooldown
	--actions.normal+=/eye_beam,if=!talent.blind_fury.enabled&(spell_targets.eye_beam_tick>desired_targets|(!set_bonus.tier19_4pc&raid_event.adds.in>45&!variable.pooling_for_meta&buff.metamorphosis.down&(artifact.anguish_of_the_deceiver.enabled|active_enemies>1)&!talent.chaos_cleave.enabled))
	--actions.normal+=/throw_glaive,if=buff.metamorphosis.down&spell_targets>=2
	--actions.normal+=/chaos_strike,if=(talent.demon_blades.enabled|!talent.momentum.enabled|buff.momentum.up|fury.deficit<30+buff.prepared.up*8)&!variable.pooling_for_chaos_strike&!variable.pooling_for_meta&!variable.pooling_for_blade_dance
	{ 'Chaos Strike', '{talent(2,2) || !talent(5,1) || player.buff(Momentum) || deficit < 30 } & !variable.pooling_for_chaos_strike & !variable.pooling_for_meta & !variable.pooling_for_blade_dance'},
	--# Use Fel Barrage if its nearing max charges, saving it for Momentum and adds if possible.
	--actions.normal+=/fel_barrage,if=(charges=max_charges-1)&buff.metamorphosis.down&(buff.momentum.up|!talent.momentum.enabled)&(active_enemies>desired_targets|raid_event.adds.in>30)
	--actions.normal+=/fel_rush,if=!talent.momentum.enabled&raid_event.movement.in>charges*10&(talent.demon_blades.enabled|buff.metamorphosis.down)
	--actions.normal+=/demons_bite
	{ 'Demon\'s Bite'},
	--actions.normal+=/throw_glaive,if=buff.out_of_range.up
	{ 'Throw Glaive', '!target.inmelee'},
	--actions.normal+=/felblade,if=movement.distance|buff.out_of_range.up
	--actions.normal+=/fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
	--actions.normal+=/vengeful_retreat,if=movement.distance>15
	--actions.normal+=/throw_glaive,if=!talent.bloodlet.enabled
}
	

local demonic = {
	--# Specific APL for the Blind Fury+Demonic Appetite+Demonic build
	--actions.demonic=pick_up_fragment,if=fury.deficit>=35&cooldown.eye_beam.remains>5
	--# Vengeful Retreat backwards through the target to minimize downtime.
	--actions.demonic+=/vengeful_retreat,if=(talent.prepared.enabled|talent.momentum.enabled)&buff.prepared.down&buff.momentum.down
	--# Fel Rush for Momentum.
	--actions.demonic+=/fel_rush,if=(talent.momentum.enabled|talent.fel_mastery.enabled)&(!talent.momentum.enabled|(charges=2|cooldown.vengeful_retreat.remains>4)&buff.momentum.down)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
	--actions.demonic+=/throw_glaive,if=talent.bloodlet.enabled&(!talent.momentum.enabled|buff.momentum.up)&charges=2
	--actions.demonic+=/death_sweep,if=variable.blade_dance
	--actions.demonic+=/fel_eruption
	--actions.demonic+=/fury_of_the_illidari,if=(active_enemies>desired_targets|raid_event.adds.in>55)&(!talent.momentum.enabled|buff.momentum.up)
	--actions.demonic+=/blade_dance,if=variable.blade_dance&cooldown.eye_beam.remains>5&!cooldown.metamorphosis.ready
	--actions.demonic+=/throw_glaive,if=talent.bloodlet.enabled&spell_targets>=2&(!talent.master_of_the_glaive.enabled|!talent.momentum.enabled|buff.momentum.up)&(spell_targets>=3|raid_event.adds.in>recharge_time+cooldown)
	--actions.demonic+=/eye_beam,if=spell_targets.eye_beam_tick>desired_targets|!buff.metamorphosis.extended_by_demonic
	--actions.demonic+=/annihilation,if=(!talent.momentum.enabled|buff.momentum.up|fury.deficit<30+buff.prepared.up*8|buff.metamorphosis.remains<5)&!variable.pooling_for_blade_dance
	--actions.demonic+=/throw_glaive,if=talent.bloodlet.enabled&(!talent.master_of_the_glaive.enabled|!talent.momentum.enabled|buff.momentum.up)&raid_event.adds.in>recharge_time+cooldown
	--actions.demonic+=/chaos_strike,if=(!talent.momentum.enabled|buff.momentum.up|fury.deficit<30+buff.prepared.up*8)&!variable.pooling_for_chaos_strike&!variable.pooling_for_meta&!variable.pooling_for_blade_dance
	--actions.demonic+=/fel_rush,if=!talent.momentum.enabled&buff.metamorphosis.down&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
	--actions.demonic+=/demons_bite
	--actions.demonic+=/throw_glaive,if=buff.out_of_range.up
	--actions.demonic+=/fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
	--actions.demonic+=/vengeful_retreat,if=movement.distance>15
}

local simCraft = {
	--actions=auto_attack
	--actions+=/variable,name=waiting_for_nemesis,value=!(!talent.nemesis.enabled|cooldown.nemesis.ready|cooldown.nemesis.remains>target.time_to_die|cooldown.nemesis.remains>60)
	--actions+=/variable,name=waiting_for_chaos_blades,value=!(!talent.chaos_blades.enabled|cooldown.chaos_blades.ready|cooldown.chaos_blades.remains>target.time_to_die|cooldown.chaos_blades.remains>60)
	--# "Getting ready to use meta" conditions, this is used in a few places.
	--actions+=/variable,name=pooling_for_meta,value=!talent.demonic.enabled&cooldown.metamorphosis.remains<6&fury.deficit>30&(!variable.waiting_for_nemesis|cooldown.nemesis.remains<10)&(!variable.waiting_for_chaos_blades|cooldown.chaos_blades.remains<6)
	--# Blade Dance conditions. Always if First Blood is talented or the T20 2pc set bonus, otherwise at 5+ targets with Chaos Cleave or 3+ targets without.
	--actions+=/variable,name=blade_dance,value=talent.first_blood.enabled|set_bonus.tier20_2pc|spell_targets.blade_dance1>=3+(talent.chaos_cleave.enabled*2)
	--# Blade Dance pooling condition, so we don't spend too much fury when we need it soon. No need to pool on
	--# single target since First Blood already makes it cheap enough and delaying it a tiny bit isn't a big deal.
	--actions+=/variable,name=pooling_for_blade_dance,value=variable.blade_dance&fury-40<35-talent.first_blood.enabled*20&(spell_targets.blade_dance1>=3+(talent.chaos_cleave.enabled*2))
	--# Chaos Strike pooling condition, so we don't spend too much fury when we need it for Chaos Cleave AoE
	--actions+=/variable,name=pooling_for_chaos_strike,value=talent.chaos_cleave.enabled&fury.deficit>40&!raid_event.adds.up&raid_event.adds.in<2*gcd
	--actions+=/consume_magic
	
	--actions+=/call_action_list,name=cooldown,if=gcd.remains=0
	{ cooldowns, 'gcd = 0'},
	--actions+=/run_action_list,name=demonic,if=talent.demonic.enabled&talent.demonic_appetite.enabled&talent.blind_fury.enabled
	{ demonic, 'talent(7,3) & talent(2,3) & talent(1,3)'},
	--actions+=/run_action_list,name=normal
	{ normal}
}

local utility = {

}

local preCombat = {

}

local inCombat = {
	{ '/targetenemy [dead][noharm]', '{target.dead || !target.exists} & !player.area(40).enemies=0'},
	{ '/startattack', '!isattacking & target.enemy'},
	{ utility},
	{ keybinds},
	{ utility},
	{ keybinds},
	{ interrupts, 'target.interruptAt(35)'},
	{ survival},
	{ simCraft, 'target.enemy'},
}

local outCombat = {
	{ keybinds},
	{ preCombat}
}

NeP.CR:Add(577, {
	name = '[Silver] Demon Hunter - Havoc',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})