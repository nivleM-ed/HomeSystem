-- find user based on name or date
CREATE OR REPLACE FUNCTION public.F_RECIPE_SEARCH(
	IN in_str VARCHAR,
	IN in_recipe_id VARCHAR,
	IN in_page INTEGER,
	IN in_limit INTEGER
)
    RETURNS TABLE(
	totalrecords INTEGER,
	id VARCHAR, 
	title VARCHAR,
	pic_path VARCHAR,
	description TEXT, 
	ingredients JSON, 
	methods JSON 
	)
    LANGUAGE 'plpgsql'
AS $$
BEGIN
	RETURN QUERY
	SELECT
		inn2.totalrecords,
		inn2.id,
		inn2.title,
		inn2.pic_path,
		inn2.description,
		inn2.ingredients,
		inn2.methods
	FROM (
		SELECT	
			inn.*
		FROM (
			SELECT 
				row_number() OVER (ORDER BY recipe."createdAt" DESC) AS rn,
				CAST(COUNT(*) OVER() AS INTEGER) AS totalrecords,
				recipe.id, 
				recipe.title,
				recipe.description, 
				recipe.pic_path,
				recipe.ingredients,
				recipe.methods,
				recipe."createdAt" AS created_at
			FROM public."recipe" AS recipe
			WHERE 
			( UPPER(recipe.title) LIKE '%'||UPPER(in_str)||'%'
			OR in_str IS null )
			AND (recipe.id = in_recipe_id OR in_recipe_id IS null)
			ORDER BY recipe."createdAt" 
		) inn
		ORDER BY inn.created_at DESC
		OFFSET (in_page * in_limit) LIMIT in_limit
	) inn2
		;
END;
$$;