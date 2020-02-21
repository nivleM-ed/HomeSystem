-- Update recipe
CREATE OR REPLACE FUNCTION public.F_RECIPE_UPDATE(
	IN in_id VARCHAR,
	IN in_title VARCHAR,
	IN in_pic_path VARCHAR,
	IN in_description TEXT,
	IN in_ingredients JSON,
	IN in_methods JSON
)
    RETURNS TABLE(
	id VARCHAR
	)
    LANGUAGE 'plpgsql'
AS $$

BEGIN
	UPDATE public."recipe" SET
		"updatedAt" = current_timestamp,
		title = UPPER(in_title),
		description = in_description,
		ingredients = in_ingredients,
		pic_path = in_pic_path,
		methods = in_methods
	WHERE public."recipe".id = in_id;
	RETURN QUERY
		SELECT recipe.id FROM public."recipe" AS recipe WHERE recipe.id = in_id;
END;
$$;