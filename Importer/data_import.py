import json
import pyodbc
import os
import logging
from pathlib import Path
from typing import Dict, List, Any, Optional
from datetime import datetime

from importers.data_formatter import create_data_for_ability_score, create_data_for_alignment, create_data_for_damage_type, create_data_for_equipment, create_data_for_feats, create_data_for_feats_prerequisites, create_data_for_feature, create_data_for_language, create_data_for_condition, create_data_for_level, create_data_for_level_specific_features, create_data_for_magic_school, create_data_for_proficiency, create_data_for_spells
from importers.data_formatter import create_data_for_equipment_category

class DnDDataImporter:
    """
    D&D 5e Reference Data Importer
    Imports JSON reference data into SQL Server database
    """
    
    def __init__(self, connection_string: str, reference_data_path: str):
        self.connection_string = connection_string
        self.reference_data_path = Path(reference_data_path)
        self.setup_logging()
        
    def setup_logging(self):
        """Setup logging configuration"""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler('data_import.log'),
                logging.StreamHandler()
            ]
        )
        self.logger = logging.getLogger(__name__)

    def get_connection(self):
        """Get database connection"""
        return pyodbc.connect(self.connection_string)

    def load_json_file(self, filename: str) -> List[Dict]:
        """Load JSON file and return data"""
        file_path = self.reference_data_path / "2014" / filename
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            self.logger.info(f"Loaded {len(data)} records from {filename}")
            return data
        except Exception as e:
            self.logger.error(f"Error loading {filename}: {str(e)}")
            return []

    def extract_index_from_url(self, url: str) -> str:
        """Extract index from API URL"""
        if not url:
            return ""
        return url.split('/')[-1]

    def extract_name_from_desc(self, desc_array: List[str]) -> str:
        """Convert description array to single string"""
        if not desc_array:
            return ""
        return "\n\n".join(desc_array)

    def check_if_exists(self, cursor, table: str, column: str, value: Any) -> bool:
        """Check if a record exists in the database"""
        query = f"SELECT COUNT(*) FROM {table} WHERE {column} = ?"
        cursor.execute(query, (value,))
        return cursor.fetchone()[0] > 0
    
    def get_id_if_exists(self, cursor, table: str, column: str, value: Any) -> Optional[int]:
        """Get the ID of a record if it exists in the database"""
        query = f"SELECT id FROM {table} WHERE {column} = ?"
        cursor.execute(query, (value,))
        result = cursor.fetchone()
        return result[0] if result else None
    
    def get_id_if_exists_case_insensitive(self, cursor, table: str, column: str, value: str) -> Optional[int]:
        """Get the ID of a record if it exists in the database (case insensitive)"""
        query = f"SELECT id FROM {table} WHERE LOWER({column}) = LOWER(?)"
        cursor.execute(query, (value,))
        result = cursor.fetchone()
        return result[0] if result else None
    
    def import_ability_scores(self):
        """Import ability scores data"""
        table_name = "ability_score"
        self.logger.info(f"Starting {table_name} import...")
        
        data = create_data_for_ability_score(self.reference_data_path)
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            for item in data:
                try:
                    exists = self.check_if_exists(cursor, table_name, "name", item.get('name', ''))
                    if exists:
                        self.logger.info(f"{table_name} {item.get('name', 'Unknown')} already exists. Skipping.")
                        continue
                    
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys())})
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info(f"{table_name} import completed")

    def import_alignment(self):
        """Import alignment data"""
        table_name = "alignment"
        self.logger.info(f"Starting {table_name} import...")
        
        data = create_data_for_alignment(self.reference_data_path)
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            for item in data:
                try:
                    # Check if alignment already exists
                    exists = self.check_if_exists(cursor, table_name, "name", item.get('name', ''))
                    if exists:
                        self.logger.info(f"{table_name} {item.get('name', 'Unknown')} already exists. Skipping.")
                        continue
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys())})
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info("Alignment import completed")

    def import_languages(self):
        """Import languages data"""
        table_name = "language"
        self.logger.info(f"Starting {table_name} import...")
        
        data = create_data_for_language(self.reference_data_path)
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            for item in data:
                try:
                    # Check if language already exists
                    exists = self.check_if_exists(cursor, table_name, "name", item.get('name', ''))
                    if exists:
                        self.logger.info(f"{table_name} {item.get('name', 'Unknown')} already exists. Skipping.")
                        continue
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys())})
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info(f"{table_name} import completed")
        
    def import_damage_type(self):
        """Import damage types data"""
        table_name = "damage_type"
        self.logger.info(f"Starting {table_name} import...")
        
        data = create_data_for_damage_type(self.reference_data_path)
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            for item in data:
                try:
                    # Check if damage type already exists
                    exists = self.check_if_exists(cursor, table_name, "name", item.get('name', ''))
                    if exists:
                        self.logger.info(f"{table_name} {item.get('name', 'Unknown')} already exists. Skipping.")
                        continue
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys())})
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info(f"{table_name} import completed")
            
    def import_conditions(self):
        """Import conditions data"""
        table_name = "condition"
        self.logger.info(f"Starting {table_name} import...")
        
        data = create_data_for_condition(self.reference_data_path)
        if not data:
            return
        
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            # cursor.execute(f"TRUNCATE TABLE dbo.{table_name}")
            
            for item in data:
                try:
                    # Check if condition already exists
                    exists = self.check_if_exists(cursor, table_name, "name", item.get('name', ''))
                    if exists:
                        self.logger.info(f"{table_name} {item.get('name', 'Unknown')} already exists. Skipping.")
                        continue
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys())})
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info(f"{table_name} import completed")
    
    def import_feats(self):
        """Import feats data"""
        table_name = "feat"
        self.logger.info(f"Starting {table_name} import...")
        
        data = create_data_for_feats(self.reference_data_path)
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            cursor.execute(f"TRUNCATE TABLE dbo.{table_name}")
            for item in data:
                try:
                    # Check if feat already exists
                    exists = self.check_if_exists(cursor, table_name, "name", item.get('name', ''))
                    if exists:
                        self.logger.info(f"{table_name} {item.get('name', 'Unknown')} already exists. Skipping.")
                        continue
                    prerequisites = item.pop('prerequisites')
                                                
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys()) })
                        OUTPUT Inserted.ID
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                    
                    id = cursor.fetchone()[0]
                    
                    self.import_feats_prerequisites(id, prerequisites, item.get('name', ''))
                    
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info(f"{table_name} import completed")
    
    def import_feats_prerequisites(self, id, data, feat_name):
        """Import feats prerequisites data"""
        table_name = "feat_prerequisite"
        self.logger.info(f"Starting {table_name} import...")
    
        if not data:
            return
        
        processed_data = create_data_for_feats_prerequisites(data)
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            cursor.execute(f"TRUNCATE TABLE dbo.{table_name}")
            for item in processed_data:
                try:
                    
                    # Get Ability Score ID
                    ability_score_id = self.get_id_if_exists(cursor, "ability_score", "name", item.pop('ability_score', ''))
                    
                    if ability_score_id is None:
                        self.logger.error(f"Ability Score {item.get('ability_score', 'Unknown')} not found. Skipping prerequisite.")
                        continue
                    
                    item['ability_score_id'] = ability_score_id
                    item['feat_id'] = id
                    
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys())})
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} for feat {feat_name}: {str(e)}")
            
            conn.commit()
            self.logger.info(f"{table_name} import completed")
    
    def import_magic_schools(self):
        """Import magic schools data"""
        table_name = "magic_school"
        self.logger.info(f"Starting {table_name} import...")
        
        data = create_data_for_magic_school(self.reference_data_path)
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            for item in data:
                try:
                    # Check if magic school already exists
                    exists = self.check_if_exists(cursor, table_name, "name", item.get('name', ''))
                    if exists:
                        self.logger.info(f"{table_name} {item.get('name', 'Unknown')} already exists. Skipping.")
                        continue
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys())})
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info(f"{table_name} import completed")
            
    def import_spell(self):
        """Import magic data"""
        table_name = "spell"
        self.logger.info(f"Starting {table_name} import...")
        
        data = create_data_for_spells(self.reference_data_path)
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            for item in data:
                try:
                    # Check if magic already exists
                    exists = self.check_if_exists(cursor, table_name, "name", item.get('name', ''))
                    if exists:
                        self.logger.info(f"{table_name} {item.get('name', 'Unknown')} already exists. Skipping.")
                        continue
                    
                    magic_school_name = item.pop('magic_school', None)
                    if magic_school_name:
                        magic_school_id = self.get_id_if_exists(cursor, "magic_school", "name", magic_school_name)
                        item['magic_school_id'] = magic_school_id
                        
                    dc_ability = item.pop('dc_ability', None)
                    if dc_ability:
                        dc_ability_id = self.get_id_if_exists(cursor, "ability_score", "name", dc_ability)
                        item['dc_ability_score_id'] = dc_ability_id
                        
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys())})
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info(f"{table_name} import completed")
    
    def import_equipment(self):
        """Import equipment data"""
        table_name = "equipment"
        self.logger.info(f"Starting {table_name} import...")
        
        data = create_data_for_equipment(self.reference_data_path)
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            for item in data:
                try:
                    # Check if equipment already exists
                    exists = self.check_if_exists(cursor, table_name, "name", item.get('name', ''))
                    if exists:
                        self.logger.info(f"{table_name} {item.get('name', 'Unknown')} already exists. Skipping.")
                        continue
                        
                    equipment_category = item.pop('equipment_category', None)
                    if equipment_category:
                        equipment_category_id = self.get_id_if_exists(cursor, "equipment_category", "name", equipment_category)
                        item['equipment_category_id'] = equipment_category_id
                        
                    gear_category = item.pop('gear_category', None)
                    if gear_category:
                        gear_category_id = self.get_id_if_exists(cursor, "equipment_category", "name", gear_category)
                        item['gear_category_id'] = gear_category_id
                        
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys())})
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info(f"{table_name} import completed")
    
    # TODO: TEST THIS, NOT YET TESTED
    def import_feature(self):
        """Import feature data"""
        table_name = "feature"
        self.logger.info(f"Starting {table_name} import...")
        
        data = create_data_for_feature(self.reference_data_path)
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            for item in data:
                try:
                    # Check if feature already exists
                    exists = self.check_if_exists(cursor, table_name, "name", item.get('name', ''))
                    if exists:
                        self.logger.info(f"{table_name} {item.get('name', 'Unknown')} already exists. Skipping.")
                        continue
                    
                    prerequisites = item.pop('prerequisites', None)
                    
                    parent_feature_name = item.pop('parent_feature', None)
                    if parent_feature_name:
                        parent_feature_id = self.get_id_if_exists(cursor, table_name, "name", parent_feature_name)
                        item['parent_feature_id'] = parent_feature_id
                    
                    className = item.pop('class', None)
                    if className:
                        class_id = self.get_id_if_exists(cursor, "classes", "name", className)
                        item['class_id'] = class_id
                        
                    subclassName = item.pop('subclass', None)
                    if subclassName:
                        subclass_id = self.get_id_if_exists(cursor, "class", "name", subclassName)
                        item['subclass_id'] = subclass_id
                        
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys())})
                        OUTPUT Inserted.ID
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                    
                    feature_id = cursor.fetchone()[0]
                    
                    if prerequisites:
                        self.import_feature_prerequisites(feature_id, prerequisites)
                    
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info(f"{table_name} import completed")
    
    # TODO: TEST THIS, NOT YET TESTED 
    def import_feature_prerequisites(self, feature_id, prerequisites):
        """Import feature prerequisites data"""
        table_name = "feature_prerequisite"
        self.logger.info(f"Starting {table_name} import...")
        processed_data = create_data_for_feats_prerequisites(prerequisites)
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            cursor.execute(f"TRUNCATE TABLE dbo.{table_name}")
            for item in processed_data:
                try:
                    # Get Reference Table 
                    refTable = item.get('reference_type', None)
                    if refTable: 
                        reference_id = self.get_id_if_exists_case_insensitive(cursor, refTable, "name", item.pop('reference_name', ''))
                        item['reference_id'] = reference_id
                    
                    item['feature_id'] = feature_id
                    
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys())})
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} for feature ID {id}: {str(e)}")
            
            conn.commit()
            self.logger.info(f"{table_name} import completed")
    
    # TODO: TEST THIS, NOT YET TESTED
    def import_level(self):
        """Import level data"""
        table_name = "level"
        self.logger.info(f"Starting {table_name} import...")
        
        data = create_data_for_level(self.reference_data_path)
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            cursor.execute(f"TRUNCATE TABLE dbo.{table_name}")
            for item in data:
                try:
                    className = item.pop('class', None)
                    if className:
                        class_id = self.get_id_if_exists(cursor, "class", "name", className)
                        item['class_id'] = class_id
                        
                    child_data = {}
                    if 'class_specific' in item:
                        child_data['class_specific'] = item.pop('class_specific')
                    
                    if 'spellcasting' in item:
                        child_data['spellcasting'] = item.pop('spellcasting')
                                                
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys()) })
                        OUTPUT Inserted.ID
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                    
                    id = cursor.fetchone()[0]

                    self.import_level_class_data(child_data, id)
                    
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info(f"{table_name} import completed")
        
    # TODO: TEST THIS, NOT YET TESTED
    def import_level_class_data(self, rawData, levelId):
        """Import level specific data"""
        table_name = "level_class_data"
        self.logger.info(f"Starting {table_name} import...")
    
        if not rawData:
            return
        
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            cursor.execute(f"TRUNCATE TABLE dbo.{table_name}")
            for item in rawData:
                try:
                    processed_data = create_data_for_level_specific_features(item, levelId)
                    
                    for data_item in processed_data:
                        cursor.execute(f"""
                            INSERT INTO dbo.{table_name} ({', '.join(data_item.keys())})
                            VALUES ({', '.join(['?'] * len(data_item))})
                        """, (
                            [data_item[k] for k in data_item.keys()]
                        ))
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} for level ID {item['id']}: {str(e)}")
    
    def import_equipment_categories(self):
        """Import equipment categories data"""
        table_name = "equipment_category"
        self.logger.info(f"Starting {table_name} import...")
        
        data = create_data_for_equipment_category(self.reference_data_path)
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            for item in data:
                try:
                    # Check if equipment category already exists
                    exists = self.check_if_exists(cursor, table_name, "name", item.get('name', ''))
                    if exists:
                        self.logger.info(f"{table_name} {item.get('name', 'Unknown')} already exists. Skipping.")
                        continue
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys())})
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info(f"{table_name} import completed")
        
    def import_proficiencies(self):
        """Import proficiencies data"""
        table_name = "proficiency"
        self.logger.info(f"Starting {table_name} import...")
        
        data = create_data_for_proficiency(self.reference_data_path)
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            cursor.execute(f"TRUNCATE TABLE dbo.{table_name}")
            
            for item in data:
                try:
                    # Check if proficiency already exists
                    exists = self.check_if_exists(cursor, table_name, "name", item.get('name', ''))
                    if exists:
                        self.logger.info(f"{table_name} {item.get('name', 'Unknown')} already exists. Skipping.")
                        continue
                    cursor.execute(f"""
                        INSERT INTO dbo.{table_name} ({', '.join(item.keys())})
                        VALUES ({', '.join(['?'] * len(item))})
                    """, (
                        [item[k] for k in item.keys()]
                    ))
                except Exception as e:
                    self.logger.error(f"Error inserting {table_name} {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info(f"{table_name} import completed")
          
    def import_classes(self):
        """Import character classes data"""
        self.logger.info("Starting classes import...")
        
        data = self.load_json_file("5e-SRD-Classes.json")
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            cursor.execute("DELETE FROM classes")
            
            for item in data:
                try:
                    # Extract proficiencies as JSON string
                    proficiencies = json.dumps(item.get('proficiencies', []))
                    starting_equipment = json.dumps(item.get('starting_equipment', []))
                    
                    cursor.execute("""
                        INSERT INTO classes (name, description, hit_die, primary_ability, 
                                           saving_throw_proficiencies, proficiencies_data, 
                                           starting_equipment_data)
                        VALUES (?, ?, ?, ?, ?, ?, ?)
                    """, (
                        item.get('name', ''),
                        self.extract_name_from_desc(item.get('desc', [])),
                        item.get('hit_die', 8),
                        str(item.get('primary_ability', [])),
                        str(item.get('saving_throws', [])),
                        proficiencies,
                        starting_equipment
                    ))
                except Exception as e:
                    self.logger.error(f"Error inserting class {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info("Classes import completed")

    def import_magic_items(self):
        """Import magic items data"""
        self.logger.info("Starting magic items import...")
        
        data = self.load_json_file("5e-SRD-Magic-Items.json")
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            cursor.execute("DELETE FROM magic_items")
            cursor.execute("DELETE FROM magic_items_variants")
            
            for item in data:
                try:
                    # Extract rarity and equipment category
                    rarity_name = ""
                    if item.get('rarity'):
                        rarity_name = item['rarity'].get('name', '')
                    
                    equipment_category = ""
                    if item.get('equipment_category'):
                        equipment_category = self.extract_index_from_url(
                            item['equipment_category'].get('url', '')
                        )
                    
                    # Insert magic item
                    cursor.execute("""
                        INSERT INTO magic_items (name, description, variant, rarity, 
                                               equipment_category, image_url)
                        VALUES (?, ?, ?, ?, ?, ?)
                    """, (
                        item.get('name', ''),
                        self.extract_name_from_desc(item.get('desc', [])),
                        item.get('variant', False),
                        rarity_name,
                        equipment_category,
                        item.get('image', '')
                    ))
                    
                    # Get the magic item ID
                    magic_item_id = cursor.execute("SELECT @@IDENTITY").fetchone()[0]
                    
                    # Insert variants
                    for variant in item.get('variants', []):
                        variant_name = self.extract_index_from_url(variant.get('url', ''))
                        cursor.execute("""
                            INSERT INTO magic_items_variants (magic_items_id, variant_name)
                            VALUES (?, ?)
                        """, (magic_item_id, variant_name))
                        
                except Exception as e:
                    self.logger.error(f"Error inserting magic item {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info("Magic items import completed")

    def import_monsters(self):
        """Import monsters data"""
        self.logger.info("Starting monsters import...")
        
        data = self.load_json_file("5e-SRD-Monsters.json")
        if not data:
            return
            
        with self.get_connection() as conn:
            cursor = conn.cursor()
            
            cursor.execute("DELETE FROM monster")
            cursor.execute("DELETE FROM monster_actions")
            
            for item in data:
                try:
                    # Extract basic monster data
                    alignment_index = ""
                    if item.get('alignment'):
                        alignment_index = item['alignment'].get('index', '')
                    
                    size_index = ""
                    if item.get('size'):
                        size_index = item['size'].get('index', '')
                    
                    type_index = ""
                    if item.get('type'):
                        type_index = item['type'].get('index', '')
                    
                    # Extract armor class
                    ac_value = 0
                    ac_type = ""
                    if item.get('armor_class') and len(item['armor_class']) > 0:
                        ac_data = item['armor_class'][0]
                        ac_value = ac_data.get('value', 0)
                        ac_type = ac_data.get('type', '')
                    
                    # Extract speed
                    speed_data = item.get('speed', {})
                    
                    # Extract senses
                    senses_data = item.get('senses', {})
                    
                    # Insert monster
                    cursor.execute("""
                        INSERT INTO monster (name, description, alignment_index, size_index, 
                                           monster_type_index, speed_walk, speed_burrow, 
                                           speed_climb, speed_fly, speed_swim, hit_points, 
                                           hit_dice, hit_points_roll, strength, dexterity, 
                                           constitution, intelligence, wisdom, charisma,
                                           armor_class_value, armor_class_type, challenge_rating,
                                           experience_points, proficiency_bonus, languages,
                                           darkvision, passive_perception, image_url)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """, (
                        item.get('name', ''),
                        self.extract_name_from_desc(item.get('desc', [])),
                        alignment_index,
                        size_index,
                        type_index,
                        self.extract_speed_value(speed_data.get('walk', '')),
                        self.extract_speed_value(speed_data.get('burrow', '')),
                        self.extract_speed_value(speed_data.get('climb', '')),
                        self.extract_speed_value(speed_data.get('fly', '')),
                        self.extract_speed_value(speed_data.get('swim', '')),
                        item.get('hit_points', 0),
                        item.get('hit_dice', ''),
                        item.get('hit_points_roll', ''),
                        item.get('strength', 10),
                        item.get('dexterity', 10),
                        item.get('constitution', 10),
                        item.get('intelligence', 10),
                        item.get('wisdom', 10),
                        item.get('charisma', 10),
                        ac_value,
                        ac_type,
                        item.get('challenge_rating', 0),
                        item.get('xp', 0),
                        item.get('proficiency_bonus', 0),
                        item.get('languages', ''),
                        senses_data.get('darkvision', ''),
                        senses_data.get('passive_perception', 0),
                        item.get('image', '')
                    ))
                    
                    # Get the monster ID
                    monster_id = cursor.execute("SELECT @@IDENTITY").fetchone()[0]
                    
                    # Insert actions
                    for action in item.get('actions', []):
                        self.insert_monster_action(cursor, monster_id, action, 'action')
                    
                    # Insert legendary actions
                    for action in item.get('legendary_actions', []):
                        self.insert_monster_action(cursor, monster_id, action, 'legendary_action')
                    
                    # Insert reactions
                    for action in item.get('reactions', []):
                        self.insert_monster_action(cursor, monster_id, action, 'reaction')
                    
                    # Insert special abilities
                    for ability in item.get('special_abilities', []):
                        self.insert_monster_action(cursor, monster_id, ability, 'special_ability')
                        
                except Exception as e:
                    self.logger.error(f"Error inserting monster {item.get('name', 'Unknown')}: {str(e)}")
            
            conn.commit()
            self.logger.info("Monsters import completed")

    def insert_monster_action(self, cursor, monster_id: int, action_data: Dict, action_type: str):
        """Insert a monster action"""
        try:
            cursor.execute("""
                INSERT INTO monster_actions (monster_id, action_name, action_description, 
                                           action_type, attack_bonus, damage_dice, 
                                           damage_bonus, usage_per_day, recharge_on_roll, 
                                           action_data)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                monster_id,
                action_data.get('name', ''),
                action_data.get('desc', ''),
                action_type,
                action_data.get('attack_bonus'),
                action_data.get('damage', [{}])[0].get('damage_dice') if action_data.get('damage') else None,
                action_data.get('damage', [{}])[0].get('damage_bonus') if action_data.get('damage') else None,
                action_data.get('usage', {}).get('times') if action_data.get('usage') else None,
                action_data.get('usage', {}).get('dice') if action_data.get('usage') else None,
                json.dumps(action_data)
            ))
        except Exception as e:
            self.logger.error(f"Error inserting action {action_data.get('name', 'Unknown')}: {str(e)}")

    def extract_speed_value(self, speed_string: str) -> Optional[int]:
        """Extract numeric speed value from string like '30 ft.'"""
        if not speed_string:
            return None
        try:
            return int(speed_string.split()[0])
        except (ValueError, IndexError):
            return None

    def run_full_import(self):
        """Run complete data import"""
        self.logger.info("Starting full D&D 5e data import...")
        
        start_time = datetime.now()
        
        try:
            # self.import_ability_scores()
            # self.import_alignment()
            # self.import_languages()
            # self.import_conditions()
            # self.import_damage_type()
            # self.import_equipment_categories()
            # self.import_feats()
            # self.import_proficiencies()
            # self.import_magic_schools()
            # self.import_spell()
            self.import_equipment()
            end_time = datetime.now()
            duration = end_time - start_time
            self.logger.info(f"Full import completed in {duration}")
            
        except Exception as e:
            self.logger.error(f"Error during full import: {str(e)}")
            raise

def main():
    """Main execution function"""
    
    # Configuration
    connection_string = (
        "DRIVER={ODBC Driver 17 for SQL Server};"
        "SERVER=tcp:hnj-dnd.database.windows.net,1433;"
        "DATABASE=hnj-dbd;"
        "PWD=Henneko21?;"
        "Authentication=SqlPassword;"
        "UID=dndadmin;"
    )
    
    reference_data_path = r"..\\Reference Data\\2014"
    
    # Create importer and run
    importer = DnDDataImporter(connection_string, reference_data_path)
    importer.run_full_import()

if __name__ == "__main__":
    main()