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