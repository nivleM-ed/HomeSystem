-- Add new recipe 
CREATE OR REPLACE FUNCTION public.F_RECIPE_ADD(
	IN in_title VARCHAR,
	IN in_description TEXT,
	IN in_pic_path VARCHAR,
	IN in_ingredients JSON,
	IN in_methods JSON
)
    RETURNS TABLE(
	id VARCHAR
	)
    LANGUAGE 'plpgsql'
AS $$
DECLARE
gen_id UUID;

BEGIN
	CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
	SELECT uuid_generate_v4() INTO gen_id;
	INSERT INTO public."recipe"(
		id,
		"createdAt",
		"updatedAt",
		title,
		description,
		pic_path,
		ingredients,
		methods)
	VALUES (
		gen_id,
		current_timestamp,
		current_timestamp,
		UPPER(in_title),
		in_description,
		in_pic_path,
		in_ingredients,
		in_methods
		);
	RETURN QUERY
		SELECT recipe.id FROM public."recipe" AS recipe WHERE recipe.id = CAST(gen_id AS VARCHAR);
END;
$$;