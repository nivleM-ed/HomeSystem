-- Delete recipe
CREATE OR REPLACE FUNCTION public.F_RECIPE_DELETE(
	IN in_id VARCHAR
)
    RETURNS TABLE(
	done INTEGER
	)
    LANGUAGE 'plpgsql'
AS $$

BEGIN
	DELETE FROM public."recipe" 
	WHERE public."recipe".id = in_id;
	RETURN QUERY
		SELECT 1 AS done;
END;
$$;