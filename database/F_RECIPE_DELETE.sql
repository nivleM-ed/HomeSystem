-- Delete recipe
CREATE OR REPLACE FUNCTION public.F_RECIPE_DELETE(
	IN in_id VARCHAR
)
    RETURNS TABLE(
	done INTEGER,
	remove_file VARCHAR
	)
    LANGUAGE 'plpgsql'
AS $$
DECLARE
remove_file VARCHAR;

BEGIN
	SELECT recipe.pic_path INTO remove_file
	FROM public."recipe" AS recipe
	WHERE recipe.id = in_id; 
	
	DELETE FROM public."recipe" 
	WHERE public."recipe".id = in_id;
	
	RETURN QUERY
		SELECT 1 AS done, remove_file;
END;
$$;