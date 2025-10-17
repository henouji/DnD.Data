from .data_loader import load_data_file
import json 

def create_data_for_ability_score(path):
    """CREATE DATA FOR ABILITY SCORE IMPORTER"""
    jsonData = load_data_file(path, "5e-SRD-Ability-Scores.json")
    data = []
    for item in jsonData:
        desc = ' '.join(item['desc']) if is_list_type(item['desc']) else item['desc']
        data.append(
            {
            'name' : item['name'],
            'full_name' : item['full_name'],
            'description' : desc,
            'deleted' : 0
        })
    return data

def create_data_for_alignment(path):
    """CREATE DATA FOR ALIGNMENT IMPORTER"""
    jsonData = load_data_file(path, "5e-SRD-Alignments.json")
    data = []
    for item in jsonData:
        desc = ' '.join(item['desc']) if is_list_type(item['desc']) else item['desc']
        data.append(
            {
            'name' : item['name'],
            'abbreviation' : item['abbreviation'],
            'description' : desc,
            'deleted' : 0
        })
    return data

def create_data_for_language(path):
    """CREATE DATA FOR LANGUAGE IMPORTER"""
    jsonData = load_data_file(path, "5e-SRD-Languages.json")
    data = []
    for item in jsonData:
        raw_description = item.get('desc', '')
        desc = ' '.join(raw_description) if is_list_type(raw_description) else raw_description
        data.append(
            {
            'name' : item['name'],
            'type' : item['type'],
            'script' : item.get('script', ''),
            'description' : desc,
            'speakers': ', '.join(item['typical_speakers']) if is_list_type(item['typical_speakers']) else item['typical_speakers'],
            'deleted' : 0
        })
    # print(json.dumps(data, indent=4))
    return data

def create_data_for_background(path):
    """CREATE DATA FOR BACKGROUND IMPORTER"""
    jsonData = load_data_file(path, "5e-SRD-Backgrounds.json")
    data = []
    for item in jsonData:
        desc = ' '.join(item['desc']) if is_list_type(item['desc']) else item['desc']
        data.append(
            {
            'name' : item['name'],
            'description' : desc,
            'deleted' : 0
        })
    return data

def create_data_for_condition(path):
    """CREATE DATA FOR CONDITION IMPORTER"""
    jsonData = load_data_file(path, "5e-SRD-Conditions.json")
    data = []
    for item in jsonData:
        desc = """\n\n""".join(item['desc']) if is_list_type(item['desc']) else item['desc']
        data.append(
            {
            'name' : item['name'],
            'description' : desc,
            'deleted' : 0
        })
    # print(json.dumps(data, indent=4))
    return data

def create_data_for_damage_type(path):
    """CREATE DATA FOR DAMAGE TYPE IMPORTER"""
    jsonData = load_data_file(path, "5e-SRD-Damage-Types.json")
    data = []
    for item in jsonData:
        desc = '\n\n'.join(item['desc']) if is_list_type(item['desc']) else item['desc']
        data.append(
            {
            'name' : item['name'],
            'description' : desc,
            'deleted' : 0
        })
    return data

def create_data_for_equipment_category(path):
    """CREATE DATA FOR EQUIPMENT CATEGORY IMPORTER"""
    jsonData = load_data_file(path, "5e-SRD-Equipment-Categories.json")
    data = []
    for item in jsonData:
        data.append(
            {
            'name' : item['name'],
            'deleted' : 0
        })
    return data

def create_data_for_feats(path):
    """CREATE DATA FOR FEATS IMPORTER"""
    jsonData = load_data_file(path, "5e-SRD-Feats.json")
    data = []
    for item in jsonData:
        desc = '\n\n'.join(item['desc']) if is_list_type(item['desc']) else item['desc']
        data.append(
            {
            'name' : item['name'],
            'description' : desc,
            'prerequisites' : item.get('prerequisites', None),
            'deleted' : 0
        })
    return data

def create_data_for_feats_prerequisites(jsonData):
    """CREATE DATA FOR FEATS PREREQUISITES IMPORTER"""
    data = []
    for item in jsonData:    
        data.append(
            {
            'ability_score' : item['ability_score']['name'],
            'minimum_score': item['minimum_score'],
            'deleted' : 0
        })
    return data

def create_data_for_feature(path):
    """CREATE DATA FOR FEATURE IMPORTER"""
    jsonData = load_data_file(path, "5e-SRD-Features.json")
    data = []
    for item in jsonData:
        desc = '\n\n'.join(item['desc']) if is_list_type(item['desc']) else item['desc']
        data.append(
            {
            'name' : item['name'],
            'level': item['level'],
            'description' : desc,
            'class': item['class']['name'],
            'prerequisites' : item.get('prerequisites', None),
            'subclass': item['subclass']['name'] if item.get('subclass', None) else None,
            'parent_feature': item['parent']['name'] if item.get('parent', None) else None,
            'deleted' : 0
        })
    return data

def create_data_for_feature_prerequisites(jsonData):
    """CREATE DATA FOR FEATURE PREREQUISITES IMPORTER"""
    data = []
    for item in jsonData:   
        ref_type = item['prerequisite']['type'] if item.get('prerequisite', None) else None, 
        if ref_type != 'level':
            ref_name = ' '.join(item.get('feature', item.get('spell', '')).split('/')[-1].split('-'))
        else: 
            ref_name = str(item.get('level', ''))
            
        data.append(
            {
            'reference_type' : ref_type,
            'reference_name': ref_name,
            'deleted' : 0
        })
    return data

def create_data_for_level(path):
    """CREATE DATA FOR LEVEL IMPORTER"""
    jsonData = load_data_file(path, "5e-SRD-Levels.json")
    data = []
    for item in jsonData:
        data.append(
            {
            'class' : item['class']['name'],
            'level': item['level'],
            'ability_score_bonuses': item['ability_score_bonuses'],
            'proficiency_bonus': item['prof_bonus'],
            'class_specific': item.get('class_specific', None),
            'spellcasting': item.get('spellcasting', None),
            'deleted' : 0
        })
    return data

def create_data_for_level_specific_features(jsonData, levelId):
    """CREATE DATA FOR LEVEL SPECIFIC FEATURES IMPORTER"""
    data = []
    for item in jsonData:
        # class_specific 
        # spellcasting
        if item.get('class_specific', None):
            data.append(
                {
                'level_id': levelId,
                'attribute_name' : 'class_specific',
                'attribute_value': json.dumps(item['class_specific']),
                'value_type': 'class_specific',
                'deleted' : 0
            })
        if item.get('spellcasting', None):
            data.append(
                {
                'level_id': levelId,
                'attribute_name' : 'spellcasting',
                'attribute_value': json.dumps(item['spellcasting']),
                'value_type': 'spellcasting',
                'deleted' : 0
            })
    return data

def create_data_for_proficiency(path):
    """CREATE DATA FOR PROFICIENCY IMPORTER"""
    jsonData = load_data_file(path, "5e-SRD-Proficiencies.json")
    data = []
    def format_reference(ref_data):
        if not ref_data:
            return None
        return json.dumps({
            'name': ref_data['name'],
            'table_reference': ref_data['url'].split('/')[-2].replace('-', '_')
        })
    for item in jsonData:
        
        data.append(
            {
            'name' : item['name'],
            'type': item['type'],
            'reference': format_reference(item.get('reference', None)),
            'deleted' : 0
        })
    return data

def create_data_for_spells(path):
    """CREATE DATA FOR SPELLS IMPORTER"""
    def format_damage(damage_data):
        if not damage_data:
            return None
        return json.dumps({
            'damage_type': damage_data['damage_type']['name'] if damage_data.get('damage_type', None) else None,
            'damage_at_slot_level': json.dumps(damage_data.get('damage_at_slot_level', None))
        })
    jsonData = load_data_file(path, "5e-SRD-Spells.json")
    data = []
    for item in jsonData:
        desc = '\n\n'.join(item['desc']) if is_list_type(item['desc']) else item['desc']
        higher_level = ''
        if item.get('higher_level', None):
            higher_level = '\n\n'.join(item['higher_level']) if is_list_type(item['higher_level']) else item['higher_level']
        data.append(
            {
            'name' : item['name'],
            'description' : desc,
            'higher_level' : higher_level,
            'damage' : format_damage(item.get('damage', None)),
            
            'range': item.get('range', ''),
            'attack_type': item.get('attack_type', ''),
            'components': ', '.join(item['components']) if is_list_type(item['components']) else item['components'],
            
            'material': item.get('material', ''),
            'ritual': int(item.get('ritual', False)),
            'heal_at_slot_level': json.dumps(item.get('heal_at_slot_level', {})),
            'duration': item.get('duration', ''),
            'concentration': int(item.get('concentration', False)),
            'casting_time': item.get('casting_time', ''),
            'level': item.get('level', None),
            'dc_ability': item['dc']['dc_type']['name'] if item.get('dc', None) else None,
            'dc_success': item['dc']['dc_success'] if item.get('dc', None) else None,
            'dc_description': item['dc']['desc'] if item.get('dc', None) and item['dc'].get('desc', None) else None,
            'area_of_effect': item['area_of_effect']['type'] if item.get('area_of_effect', None) else None,
            'area_of_effect_size': item['area_of_effect']['size'] if item.get('area_of_effect', None) else None,
            'magic_school': item['school']['name'] if item.get('school', None) else None,  # REFERENCE 
            'deleted' : 0
        })
    return data

def create_data_for_magic_school(path):
    """CREATE DATA FOR MAGIC SCHOOL IMPORTER"""
    jsonData = load_data_file(path, "5e-SRD-Magic-Schools.json")
    data = []
    for item in jsonData:
        desc = '\n\n'.join(item['desc']) if is_list_type(item['desc']) else item['desc']
        data.append(
            {
            'name' : item['name'],
            'description' : desc,
            'deleted' : 0
        })
    return data

def create_data_for_equipment(path):
    """CREATE DATA FOR EQUIPMENT IMPORTER"""
    jsonData = load_data_file(path, "5e-SRD-Equipment.json")
    data = []
    for item in jsonData:
        desc = '\n\n'.join(item['desc']) if is_list_type(item.get('desc', '')) else item.get('desc', '')
        special = '\n\n'.join(item['special']) if is_list_type(item.get('special', '')) else item.get('special', '')
        data.append(
            {
            'name' : item['name'],
            'description' : desc,
            'special': special,
            'armor_category': item.get('armor_category', None),
            'tool_category': item.get('tool_category', None),
            'weapon_category': item.get('weapon_category', None),
            'vehicle_category': item.get('vehicle_category', None),
            
            # REFERENCE
            'equipment_category': item['equipment_category']['name'] if item.get('equipment_category', None) else None, 
            'gear_category': item['gear_category']['name'] if item.get('gear_category', None) else None,
            
            'armor_class_base': item['armor_class']['base'] if item.get('armor_class', None) else None,
            'armor_class_dex_bonus': int(item['armor_class']['dex_bonus']) if item.get('armor_class', None) else None,
            'str_minimum': parse_int(item.get('str_minimum', None)) ,
            'range_normal': parse_int(item['range']['normal']) if item.get('range', None) else None,
            'range_long': parse_int(item['range'].get('long', None)) if item.get('range', None) else None,
            'throw_range_normal': parse_int(item['throw_range']['normal']) if item.get('throw_range', None) else None,
            'throw_range_long': parse_int(item['throw_range'].get('long', None)) if item.get('throw_range', None) else None,
            
            'cost_quantity': item['cost']['quantity'] if item.get('cost', None) else None,
            'cost_unit': item['cost']['unit'] if item.get('cost', None) else None,
            'speed_quantity': item['speed']['quantity'] if item.get('speed', None) else None,
            'speed_unit': item['speed']['unit'] if item.get('speed', None) else None,
            
            'weight': parse_float(item.get('weight', None)),
            'quantity': parse_int(item.get('quantity', None)),
            
            'deleted' : 0
        })
    return data

def is_list_type(value):
    """Check if the value is a list type"""
    return isinstance(value, list)

def parse_int(value):
    try:
        return int(value)
    except (ValueError, TypeError):
        return None
    
def parse_float(value):
    try:
        return float(value)
    except (ValueError, TypeError):
        return None

if __name__ == "__main__":  
    path = r"..\Reference Data\2014"
    create_data_for_equipment(path)
    
    
    