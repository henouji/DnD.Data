// D&D 5e Database Schema
// Core game data for Dungeons & Dragons 5th Edition

Table alignment {
  id int [pk, increment]
  name nvarchar(100) [not null]
  abbreviation nvarchar(10)
  description nvarchar(max)
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit
}

Table size {
  id bigint [pk, increment]
  name nvarchar(100) [not null]
  speed int [not null]
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit
}

Table ability_score {
  id int [pk, increment]
  name nvarchar(100) [not null]
  abbreviation nvarchar(10)
  description nvarchar(max)
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit
}

// Classes and Character Creation
Table classes {
  id int [pk, increment]
  name nvarchar(100) [not null]
  description nvarchar(max)
  hit_die int
  primary_ability nvarchar(100)
  saving_throw_proficiencies nvarchar(200)
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit
}

Table level {
  id int [pk, increment]
  level int [not null, note: 'CHECK (level BETWEEN 1 AND 20)']
  class_id int [not null, ref: > classes.id]
  ability_score_bonuses int [default: 0]
  proficiency_bonus int
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit
}

Table level_features {
  id int [pk, increment]
  level_id int [not null, ref: > level.id]
  feature_id int [not null]
}

Table level_class_data {
  id int [pk, increment]
  level_id int [not null, ref: > level.id]
  attribute_name nvarchar(100) [not null]
  attribute_value nvarchar(100) [not null]
  value_type nvarchar(50) [default: 'INT']
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit
}

// Equipment System
Table equipment_categories {
  id int [pk, increment]
  name nvarchar(100) [not null]
  description nvarchar(max)
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit
}

Table equipment {
  id int [pk, increment]
  name nvarchar(256) [not null]
  description nvarchar(max)
  special nvarchar(max)
  equipment_category_id int [ref: > equipment_categories.id]
  gear_category_id int [ref: > equipment_categories.id]
  weapon_category nvarchar(64) [note: 'Simple, Martial']
  armor_category nvarchar(64) [note: 'Light, Medium, Heavy, Shield']
  tool_category nvarchar(128)
  vehicle_category nvarchar(128)
  armor_class_id int
  str_minimum int
  stealth_disadvantage bit
  range_normal int [note: 'Normal range in feet']
  range_long int [note: 'Long range in feet']
  throw_range_normal int
  throw_range_long int
  cost_quantity int
  cost_unit nvarchar(10)
  weight decimal(10,2)
  quantity int [default: 1]
  speed_quantity decimal(5,1)
  speed_unit nvarchar(20)
  capacity nvarchar(50)
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit

  indexes {
    equipment_category_id
    gear_category_id
    weapon_category
    name
  }
}

Table equipment_weapon_property {
  id int [pk, increment]
  equipment_id int [not null, ref: > equipment.id]
  weapon_property_id int [not null]
}

Table equipment_damage {
  id int [pk, increment]
  equipment_id int [not null, ref: > equipment.id]
  damage_id int [not null]
}

// Starting Equipment for Classes
Table class_starting_equipment_choice_group {
  id int [pk, increment]
  class_id int [not null, ref: > classes.id]
  description nvarchar(500)
  choose_count int [default: 1]
  option_set_type nvarchar(50) [default: 'equipment']
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted_at datetime
}

Table class_starting_equipment_choice_option {
  id int [pk, increment]
  choice_group_id int [not null, ref: > class_starting_equipment_choice_group.id]
  option_type nvarchar(50) [not null]
  choice_description nvarchar(500)
  equipment_category_id int [ref: > equipment_categories.id]
  count_quantity int [default: 1]
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted_at datetime
}

Table class_starting_equipment_choice_option_items {
  id int [pk, increment]
  choice_option_id int [not null, ref: > class_starting_equipment_choice_option.id]
  equipment_id int [ref: > equipment.id]
  equipment_category_id int [ref: > equipment_categories.id]
  count_quantity int [default: 1]
  item_order int [default: 1]
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted_at datetime
}

// Direct Starting Equipment
Table class_starting_equipment {
  id int [pk, increment]
  class_id int [not null, ref: > classes.id]
  equipment_id int [not null, ref: > equipment.id]
  quantity int [default: 1]
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit
}

// Spells System
Table spell {
  id bigint [pk, increment]
  name varchar(100) [not null]
  description varchar(max)
  higher_level varchar(max)
  damage varchar(max) [note: 'JSON string']
  range varchar(50)
  attack_type varchar(50)
  components varchar(50) [note: 'JSON string']
  material varchar(max)
  ritual bit
  heal_at_slot_level varchar(max) [note: 'JSON string']
  duration varchar(50)
  concentration bit
  casting_time varchar(50)
  level integer
  dc_ability_score_id int [ref: > ability_score.id]
  dc_success varchar(50)
  dc_description varchar(max)
  area_of_effect varchar(50)
  area_of_effect_size int
  magic_school_id int
}

Table spell_class {
  id bigint [pk, increment]
  spell_id bigint [not null, ref: > spell.id]
  class_id int [not null, ref: > classes.id]
  is_subclass bit [default: false]
}

// Magic Items
Table magic_items {
  id bigint [pk, increment]
  name nvarchar(100) [not null]
  description nvarchar(max)
  variant bit
  rarity nvarchar(50)
  equipment_category nvarchar(50)
  image_url nvarchar(250)
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit [default: false]
}

Table magic_items_variants {
  id bigint [pk, increment]
  magic_items_id bigint [not null, ref: > magic_items.id]
  variant_name nvarchar(100) [not null]
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit [default: false]
}

// Monster System
Table monster_type {
  id bigint [pk, increment]
  name nvarchar(50) [not null]
  is_subtype bit [default: false]
  deleted bit [default: false]
}

Table monster {
  id bigint [pk, increment]
  name nvarchar(100) [not null]
  description nvarchar(max)
  alignment_id int [not null, ref: > alignment.id]
  size_id bigint [not null, ref: > size.id]
  monster_type_id bigint [not null, ref: > monster_type.id]
  sub_monster_type_id bigint [ref: > monster_type.id]
  speed_walk int
  speed_burrow int
  speed_climb int
  speed_fly int
  speed_swim int
  hit_points int
  hit_dice nvarchar(20)
  hit_points_roll nvarchar(50)
  strength int
  dexterity int
  constitution int
  intelligence int
  wisdom int
  charisma int
  armor_class_value int
  armor_class_type nvarchar(50)
  challenge_rating decimal(4,2)
  experience_points int
  proficiency_bonus int
  languages nvarchar(200)
  darkvision nvarchar(50)
  passive_perception int
  blindsight nvarchar(50)
  tremorsense nvarchar(50)
  truesight nvarchar(50)
  image_url nvarchar(250)
  deleted bit [default: false]
}

Table monster_armor_class {
  id bigint [pk, increment]
  monster_id bigint [ref: > monster.id]
  armor_class_type nvarchar(50)
  armor_class_value int
  deleted bit [default: false]
}

Table monster_proficiency {
  id bigint [pk, increment]
  monster_id bigint [ref: > monster.id]
  proficiency_type nvarchar(50)
  proficiency_name nvarchar(100)
  proficiency_bonus int
  deleted bit [default: false]
}

Table monster_damage_data {
  id bigint [pk, increment]
  monster_id bigint [ref: > monster.id]
  damage_type nvarchar(50)
  immunity bit [default: false]
  resistance bit [default: false]
  vulnerability bit [default: false]
  deleted bit [default: false]
}

Table monster_actions {
  id bigint [pk, increment]
  monster_id bigint [ref: > monster.id]
  action_name nvarchar(100)
  action_description nvarchar(max)
  action_type nvarchar(50) [note: 'action, legendary_action, reaction']
  attack_bonus int
  damage_dice nvarchar(50)
  damage_bonus int
  usage_per_day int
  recharge_on_roll nvarchar(10)
  action_data nvarchar(max) [note: 'JSON string for complex actions']
  deleted bit [default: false]
}

// Backgrounds
Table background {
  id int [pk, increment]
  name nvarchar(100) [not null]
  description nvarchar(max)
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit
}

Table background_feature {
  id int [pk, increment]
  background_id int [not null, ref: > background.id]
  feature_name nvarchar(100)
  feature_description nvarchar(max)
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit
}

Table background_proficiency {
  id int [pk, increment]
  background_id int [not null, ref: > background.id]
  proficiency_type nvarchar(50)
  proficiency_name nvarchar(100)
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit
}

Table background_starting_equipment {
  id int [pk, increment]
  background_id int [not null, ref: > background.id]
  equipment_id int [not null, ref: > equipment.id]
  quantity int [default: 1]
  created_at datetime [default: `GETDATE()`]
  updated_at datetime [default: `GETDATE()`]
  deleted bit
}