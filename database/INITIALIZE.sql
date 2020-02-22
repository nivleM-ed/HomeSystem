CREATE TABLE "session" (
  "sid" varchar NOT NULL COLLATE "default",
	"sess" json NOT NULL,
	"expire" timestamp(6) NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "session" ADD CONSTRAINT "session_pkey" PRIMARY KEY ("sid") NOT DEFERRABLE INITIALLY IMMEDIATE;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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

---------------------------


INSERT INTO public.recipe VALUES ('a4c15a98-16e4-4c97-a72c-533a35cfd444', '2020-02-20 23:48:38.399987+08', '2020-02-20 23:48:38.399987+08', 'NASI LEMAK', 'Nasi lemak - Malaysian coconut milk rice, served with sambal, fried crispy anchovies, toasted peanuts and cucumber. This is the best and most authentic nasi lemak recipe.  Servings: 4 people. Prep Time: 30 minutes. Cook Time: 30 minutes. Total Time: 1 hour', '1582213718143-nasiLemak.png', '[{"ingredient":"Coconut milk (santan)","quantity":"3","quantity_type":"Cup/s"},{"ingredient":"Rice","quantity":"2","quantity_type":"Cup/s"},{"ingredient":"Pandan leaves","quantity":"2","quantity_type":"-"},{"ingredient":"Water","quantity":"2","quantity_type":"Cup/s"},{"ingredient":"Tamarind Juice","quantity":"1","quantity_type":"Cup/s"},{"ingredient":"Red Onion","quantity":"1","quantity_type":"-"},{"ingredient":"Dried anchovies","quantity":"1","quantity_type":"Cup/s"},{"ingredient":"Garlic clove","quantity":"1","quantity_type":"-"},{"ingredient":"Dried chillies","quantity":"10","quantity_type":"-"},{"ingredient":"Belacan","quantity":"1","quantity_type":"Teaspoon/s"},{"ingredient":"Salt","quantity":"1","quantity_type":"Tablespoon/s"},{"ingredient":"Sugar","quantity":"1","quantity_type":"Tablespoon/s"},{"ingredient":"Hard boiled egg","quantity":"2","quantity_type":"-"},{"ingredient":"Cucumber","quantity":"1","quantity_type":"-"}]', '[{"step":1,"description":"Just like making steamed rice, rinse your rice and drain. Add the coconut milk, a pinch of salt, and some water. Add the pandan leaves into the rice and cook your rice."},{"step":2,"description":"Rinse the dried anchovies and drain the water. Fry the anchovies until they turn light brown and put aside."},{"step":3,"description":"Pound the prawn paste together with shallots, garlic, and deseeded dried chilies with a mortar and pestle. You can also grind them with a food processor. Slice the red onion into rings. Soak the tamarind pulp in water for 15 minutes. Squeeze the tamarind constantly to extract the flavor into the water. Drain the pulp and save the tamarind juice."},{"step":4,"description":"Heat some oil in a pan and fry the spice paste until fragrant. Add in the onion rings. Add in the ikan bilis and stir well. Add tamarind juice, salt, and sugar. Simmer on low heat until the gravy thickens. Set aside."},{"step":5,"description":"Clean the small fish, cut them into half and season with salt. Deep fry. Cut the cucumber into slices and then quartered into four small pieces. Dish up the steamed coconut milk rice and pour some sambal ikan bilis on top of the rice. Serve with fried fish, cucumber slices, and hard-boiled eggs."}]');
INSERT INTO public.recipe VALUES ('5efdb8c7-7cff-4bb7-aa2b-6f12bbd6009d', '2020-02-21 00:05:56.919649+08', '2020-02-21 00:05:56.919649+08', 'HAINANESE CHICKEN RICE', 'This is a chicken rice dish found in Malaysia and Singapore, called Hainanese chicken rice. Easy and delicious chicken rice recipe.', '1582214756771-hainanese-chicken-rice.png', '[{"ingredient":"Rice","quantity":"3","quantity_type":"Cup/s"},{"ingredient":"Vegetable Oil","quantity":"5","quantity_type":"Tablespoon/s"},{"ingredient":"Garlic cloves ","quantity":"4","quantity_type":"-"},{"ingredient":"Shallots","quantity":"4","quantity_type":"-"},{"ingredient":"Chicken broth","quantity":"3","quantity_type":"Cup/s"},{"ingredient":"Pandan leaves","quantity":"5","quantity_type":"-"},{"ingredient":"Ginger","quantity":"1","quantity_type":"-"},{"ingredient":"Garlic and Shallot oil","quantity":"1","quantity_type":"Tablespoon/s"},{"ingredient":"Salt ","quantity":"2","quantity_type":"Tablespoon/s"},{"ingredient":"Whole chicken","quantity":"1","quantity_type":"-"},{"ingredient":"Scallioin","quantity":"6","quantity_type":"-"},{"ingredient":"Carrot","quantity":"1","quantity_type":"-"},{"ingredient":"Cucumber","quantity":"1","quantity_type":"-"},{"ingredient":"Light soy sauce","quantity":"2","quantity_type":"Tablespoon/s"},{"ingredient":"Sesame oil","quantity":"3","quantity_type":"Tablespoon/s"},{"ingredient":"Red chilies","quantity":"100","quantity_type":"Grams"},{"ingredient":"Lime juice","quantity":"60","quantity_type":"mL"},{"ingredient":"Cilantro","quantity":"1","quantity_type":"-"}]', '[{"step":1,"description":"Wash chicken, drain well, stuff ginger and scallion into the chicken''s cavity. Using 2 tsp of salt as scrub, rub the salt all over the chicken for smooth looking skin."},{"step":2,"description":"In a not too large stockpot which fits the chicken perfectly, boil the chicken stock (enough to cover the whole chicken) together with pandan leaves, carrot and salt."},{"step":3,"description":"Submerge the whole chicken, breast side down in the boiling water for 35-45 minutes depending on the size of the chicken. Lower the heat to gentle simmer immediately."},{"step":4,"description":"When chicken is cooked, remove chicken and plunge it into prepared cold water at once for 10 minutes. Keep the chicken broth** for later use."},{"step":5,"description":"Drain the chicken, discard ginger and scallion from the cavity and set it aside to cool before chopping it neatly into desired serving size.\n"},{"step":6,"description":"For the rice, heat oil in wok, fry chopped shallots and garlic till fragrant and golden in colour. Add rice and stir well. Transfer the rice mixture to rice cooker."},{"step":7,"description":"Once transferred, add chicken broth, pandan leaves, ginger, garlic and shallot oil, chicken fats and salt into rice mixture. Cook according to rice cooker''s manual instruction."},{"step":8,"description":"Prepare the chicken rice by lining a serving plate with cucumber slices."},{"step":9,"description":"Arrange chicken pieces on top, pour in the prepared sauce before garnishing with cilantro."},{"step":10,"description":"Serve with chicken rice, side soup and chicken rice chili sauce."},{"step":11,"description":"Any left over chicken broth can be served as side soup, garnish with cilantro or chopped scallions."}]');

---------------------------------------

INSERT INTO public.users VALUES ('96a79aca-fc93-4dc5-911d-db71655d231c', '2020-02-21 19:21:58.152387+08', '2020-02-21 19:21:58.152387+08', 'user', '$2b$08$XrJRsxRvTgxklZr9ov23leh0GkEIg5XJ08RFD/PIIEtqLKGQdQxQ2');