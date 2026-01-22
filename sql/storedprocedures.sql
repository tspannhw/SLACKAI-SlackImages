CREATE OR REPLACE PROCEDURE DEMO.DEMO.ANALYZESLACKIMAGE("IMAGE_NAME" VARCHAR, "FILENAME" VARCHAR, "UUID" VARCHAR)
RETURNS OBJECT
LANGUAGE SQL
EXECUTE AS OWNER
AS '
DECLARE
  result VARIANT;
BEGIN
   ALTER STAGE SLACKIMAGES REFRESH; 
    
   SELECT AI_COMPLETE(''llama4-scout'', 
    ''Analyze this image and describe what you see. Respond in JSON only, do not include the word json, plain text, make it clean or preinformation'',
    TRY_TO_FILE(''@SLACKIMAGES'', :IMAGE_NAME)) INTO :result;

   INSERT INTO DEMO.DEMO.RAWSLACKIMAGES 
   (json_data, filename, uuid)
   SELECT :result as json_data, :filename, :uuid;
   -- PARSE_JSON( 
   RETURN result;
EXCEPTION
    WHEN OTHER THEN
        RETURN ''Error: '' || SQLSTATE || '' - ''|| SQLERRM;   
END;
';
