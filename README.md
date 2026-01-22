# SLACKAI-SlackImages
Store and Analyze Slack Images with Snowflake OpenFlow - Apache NiFi



#### Code

````

CALL "DEMO"."DEMO"."ANALYZESLACKIMAGE"('${filename}','${filename}','${videoid}');


````



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
