# SLACKAI-SlackImages
Store and Analyze Slack Images with Snowflake OpenFlow - Apache NiFi



#### Code

````

CALL "DEMO"."DEMO"."ANALYZESLACKIMAGE"('${filename}','${filename}','${videoid}');


````

<img width="1125" height="907" alt="image" src="https://github.com/user-attachments/assets/032d88d0-9cb1-4678-afb2-54963a8152d6" />

<img width="1647" height="880" alt="image" src="https://github.com/user-attachments/assets/f4cceed6-07c6-4e85-8a5e-7ccc24fd2072" />

<img width="1707" height="1135" alt="image" src="https://github.com/user-attachments/assets/d8049b85-188c-49e8-bbc9-194974bf7902" />

<img width="2073" height="1111" alt="image" src="https://github.com/user-attachments/assets/3bc9cc19-72fc-4ab5-b6a0-18d885f54b6c" />




#### Adding Geo Coding 

````


CREATE OR REPLACE NETWORK RULE nominatim_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('nominatim.openstreetmap.org'); -- Add your target domains here

  CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION nominatim_access_int
  ALLOWED_NETWORK_RULES = (nominatim_network_rule)
  ENABLED = TRUE;

  -- Allow the role to use the integration
GRANT USAGE ON INTEGRATION nominatim_access_int TO ROLE ACCOUNTADMIN;

  -- Allow the role to use the integration
GRANT USAGE ON INTEGRATION nominatim_access_int TO ROLE SYSADMIN;

CREATE OR REPLACE FUNCTION get_lat_long(address STRING)
RETURNS VARIANT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('geopy')
EXTERNAL_ACCESS_INTEGRATIONS = (nominatim_access_int)
HANDLER = 'get_coordinates'
AS
$$
from geopy.geocoders import Nominatim
import time

def get_coordinates(address):
    if not address:
        return None
    
    # Instantiate the client with the specific user_agent requested
    app = Nominatim(user_agent="nifi-AddressToLatLong-nominatim")
    
    try:
        # Perform the geocoding
        # timeout is increased to handle potential network latency
        location = app.geocode(address, timeout=10)
        
        if location:
            # Return a JSON object (Variant in Snowflake)
            return {
                "latitude": location.latitude,
                "longitude": location.longitude,
                "address_found": location.address
            }
        else:
            return {"error": "Address not found"}
            
    except Exception as e:
        return {"error": str(e)}
$$;


-- Test with a single address
SELECT get_lat_long('115 morrison ave, hightstown, nj 08520');


````
