import os 
import json 

def load_data_file(path, filename):
    """Load data file for ability scores"""
    file_path = os.path.join(path, filename)
    data = json.load(open(file_path, 'r', encoding='utf-8'))
    return data

    