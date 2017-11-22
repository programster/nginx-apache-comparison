<?php

/*
 * This script is to *simulate* handling an API GET request to fetch some data from a database
 * and return it in JSON format.
 */


/**
 * Loops through the CSV file and puts the data into an array. You can specify whether
 * the CSV has a header and if keys is not provided then we will use these as indexes. If there 
 * is no header and no keys, then an array list of rows is returned. If keys are provided then
 * these are always used as the indexes even if it has to override the header.
 * WARNING - this can be a memory hog.
 * @param string $filepath - the path to the file, including the name.
 * @param bool $hasHeader - specify whether the CSV file has a header which it will have to
 *                          skip for values, and may or may not be used for indexes of the
 *                          rows depending on whether $keys is provided.
 * @param array $keys - optional parameter to specify the indexes to use in the rows. If not
 *                      provided and there is a header, then we will use the header columns
 *                      as indexes.
 *                        
 * @return array - an array list of indexed rows that the CSV has been converted into.
 */
function convertCsvToArray($filepath, $hasHeader, $keys=null)
{
    $file = fopen($filepath, 'r');
    $output = array();
    $firstRow = true;
    
    while ($row = fgetcsv($file))
    {
        // Skip empty lines (users may accidentally put one at the end
        // libre calc wont strip this either.
        if (count($row) == 0 || $row[0] === "")
        {
            continue;
        }
        
        if ($firstRow)
        {
            $firstRow = false;
            
            if ($hasHeader)
            {
                if ($keys == null)
                {
                    $keys = $row;
                }
                
                continue;
            }
        }
        
        if ($keys != null)
        {
            if (count($keys) != count($row))
            {
                $msg = "Cannot convert csv to array. Number of keys: " . count($keys) . 
                       " is not the same as the number of values: " . count($row);
                throw new \Exception($msg);
            }
            $output[] = array_combine($keys, $row);
        }
        else
        {
            $output[] = $row;
        }
    }
    
    return $output;
}


function main()
{
    $data = convertCsvToArray(__DIR__ . '/data.csv', true);
    
    // Sleep for 0.01 seconds to simulate non blocking behaviour like connecting or waiting on db
    usleep(10000);
    
    // Return the data in JSON form.
    $jsonString = json_encode($data);
    header('Content-Type: application/json');
    echo json_encode($data);
}

main();

