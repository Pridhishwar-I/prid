/*
# Restrict curated content writes

1. Purpose
- Keep government scheme and food guidance content readable in the app.
- Prevent normal signed-in users from creating, changing, or deleting curated content.

2. Security changes
- Replace broad authenticated write policies with explicit deny policies.
- Content remains visible to authenticated users through the existing SELECT policies.
- Future admin workflows must use a separately protected server-side role or function.
*/

DROP POLICY IF EXISTS "insert_government_schemes" ON government_schemes;
CREATE POLICY "insert_government_schemes" ON government_schemes FOR INSERT
  TO authenticated WITH CHECK (false);

DROP POLICY IF EXISTS "update_government_schemes" ON government_schemes;
CREATE POLICY "update_government_schemes" ON government_schemes FOR UPDATE
  TO authenticated USING (false) WITH CHECK (false);

DROP POLICY IF EXISTS "delete_government_schemes" ON government_schemes;
CREATE POLICY "delete_government_schemes" ON government_schemes FOR DELETE
  TO authenticated USING (false);

DROP POLICY IF EXISTS "insert_food_guidance" ON food_guidance;
CREATE POLICY "insert_food_guidance" ON food_guidance FOR INSERT
  TO authenticated WITH CHECK (false);

DROP POLICY IF EXISTS "update_food_guidance" ON food_guidance;
CREATE POLICY "update_food_guidance" ON food_guidance FOR UPDATE
  TO authenticated USING (false) WITH CHECK (false);

DROP POLICY IF EXISTS "delete_food_guidance" ON food_guidance;
CREATE POLICY "delete_food_guidance" ON food_guidance FOR DELETE
  TO authenticated USING (false);
