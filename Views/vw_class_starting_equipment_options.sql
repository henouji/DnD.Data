/*******************************************************************
 * View: vw_class_starting_equipment_options
 * Description: Flattens the complex starting equipment option hierarchy
 *              for easy querying and character creation UI display
 * Dependencies: class_starting_equipment_option_group, 
 *               class_starting_equipment_option,
 *               class_starting_equipment_option_item,
 *               classes, equipment, equipment_categories
 * Usage: SELECT * FROM vw_class_starting_equipment_options WHERE class_name = 'Wizard'
 *******************************************************************/

CREATE VIEW vw_class_starting_equipment_options AS
WITH EquipmentOptionsFlat AS (
    SELECT 
        c.id as class_id,
        c.name as class_name,
        seog.id as option_group_id,
        seog.description as choice_description,
        seog.choose_count,
        seog.option_set_type,
        
        seo.id as option_id,
        seo.option_type,
        seo.choice_description as option_choice_desc,
        seo.count_quantity as option_count,
        
        -- Equipment item details
        seoi.id as item_id,
        seoi.count_quantity as item_count,
        seoi.item_order,
        e.name as equipment_name,
        e.id as equipment_id,
        
        -- Equipment category for "any simple weapon" type choices
        ec.name as equipment_category_name,
        ec.id as equipment_category_id,
        
        -- Create readable option text
        CASE 
            WHEN seo.option_type = 'counted_reference' AND seoi.equipment_id IS NOT NULL THEN
                CONCAT(seoi.count_quantity, 'x ', e.name)
            WHEN seo.option_type = 'choice' AND seo.equipment_category_id IS NOT NULL THEN
                CONCAT(seo.choice_description, ' (from ', ec.name, ')')
            WHEN seo.option_type = 'multiple' AND seoi.equipment_id IS NOT NULL THEN
                CONCAT(seoi.count_quantity, 'x ', e.name)
            ELSE 
                COALESCE(seo.choice_description, 'Unknown option')
        END as option_display_text,
        
        -- Hierarchy path for debugging
        CONCAT(
            'Group_', seog.id, 
            ' > Option_', seo.id,
            CASE WHEN seoi.id IS NOT NULL THEN ' > Item_' + CAST(seoi.item_order AS NVARCHAR) ELSE '' END
        ) as option_path

    FROM classes c
    INNER JOIN class_starting_equipment_choice_group seog ON c.id = seog.class_id
    INNER JOIN class_starting_equipment_choice_option seo ON seog.id = seo.choice_group_id
    LEFT JOIN class_starting_equipment_choice_option_items seoi ON seo.id = seoi.choice_option_id
    LEFT JOIN equipment e ON seoi.equipment_id = e.id
    LEFT JOIN equipment_categories ec ON COALESCE(seo.equipment_category_id, seoi.equipment_category_id) = ec.id
    
    WHERE seog.deleted_at IS NULL
      AND seo.deleted_at IS NULL
      AND (seoi.deleted_at IS NULL OR seoi.id IS NULL)
),
EquipmentOptionsAggregated AS (
    SELECT 
        class_id,
        class_name,
        option_group_id,
        choice_description,
        choose_count,
        option_set_type,
        option_id,
        option_type,
        option_choice_desc,
        
        -- Aggregate multiple items within one option (for "multiple" type)
        STRING_AGG(
            CASE 
                WHEN option_type = 'multiple' AND equipment_name IS NOT NULL THEN
                    CONCAT(item_count, 'x ', equipment_name)
                ELSE option_display_text
            END, 
            ' + '
        ) WITHIN GROUP (ORDER BY item_order) as aggregated_option_text,
        
        -- JSON representation for API responses
        CASE 
            WHEN option_type = 'multiple' THEN
                '[' + STRING_AGG(
                    JSON_QUERY('{"equipment":"' + equipment_name + '","count":' + CAST(item_count AS NVARCHAR) + '}'),
                    ','
                ) WITHIN GROUP (ORDER BY item_order) + ']'
            WHEN option_type = 'choice' THEN
                JSON_QUERY('{"type":"choice","category":"' + equipment_category_name + '","description":"' + option_choice_desc + '"}')
            WHEN option_type = 'counted_reference' THEN
                JSON_QUERY('{"equipment":"' + equipment_name + '","count":' + CAST(COALESCE(item_count, option_count, 1) AS NVARCHAR) + '}')
            ELSE 
                JSON_QUERY('{"type":"' + option_type + '","description":"' + COALESCE(option_choice_desc, 'Unknown') + '"}')
        END as option_json
        
    FROM EquipmentOptionsFlat
    GROUP BY 
        class_id, class_name, option_group_id, choice_description, choose_count, 
        option_set_type, option_id, option_type, option_choice_desc, equipment_category_name
)
SELECT 
    class_id,
    class_name,
    option_group_id,
    choice_description,
    choose_count,
    option_set_type,
    
    -- Aggregated options for this choice group
    STRING_AGG(aggregated_option_text, ' OR ') as available_options,
    
    -- JSON array of all options in this group
    '[' + STRING_AGG(option_json, ',') + ']' as options_json,
    
    -- Metadata
    COUNT(DISTINCT option_id) as option_count,
    MAX(CASE WHEN option_type = 'choice' THEN 1 ELSE 0 END) as has_category_choice,
    MAX(CASE WHEN option_type = 'multiple' THEN 1 ELSE 0 END) as has_multiple_items

FROM EquipmentOptionsAggregated
GROUP BY 
    class_id, class_name, option_group_id, choice_description, 
    choose_count, option_set_type;

GO