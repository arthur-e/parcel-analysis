SELECT 'unformatted_apn' AS field_name, count(*)
  FROM los_angeles.assessments
 WHERE unformatted_apn IS NOT NULL AND NOT unformatted_apn = ''
UNION
SELECT 'formatted_apn' AS field_name, count(*)
  FROM los_angeles.assessments
 WHERE formatted_apn IS NOT NULL AND NOT formatted_apn = ''
UNION
SELECT 'original_apn' AS field_name, count(*)
  FROM los_angeles.assessments
 WHERE original_apn IS NOT NULL AND NOT original_apn = ''
UNION
SELECT 'p_id_iris_frmtd' AS field_name, count(*)
  FROM los_angeles.assessments
 WHERE p_id_iris_frmtd IS NOT NULL AND NOT p_id_iris_frmtd = ''
UNION
SELECT 'map_reference_1' AS field_name, count(*)
  FROM los_angeles.assessments
 WHERE map_reference_1 IS NOT NULL AND NOT map_reference_1 = ''
UNION
SELECT 'map_reference_2' AS field_name, count(*)
  FROM los_angeles.assessments
 WHERE map_reference_2 IS NOT NULL AND NOT map_reference_2 = ''
UNION
SELECT 'apn_sequence_nbr' AS field_name, count(*)
  FROM los_angeles.assessments
 WHERE apn_sequence_nbr IS NOT NULL;