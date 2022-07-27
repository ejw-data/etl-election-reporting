-- Vote Margin (vector subtraction)
-- Added to a view to simplify next task
CREATE VIEW margins AS
select tab_1.*, tab_2.trump_votes from
	(select
	 	batch_id,
	 	datetime,
	 	state,
	 	votes as biden_votes
	 from vote_counts
	 where candidate='Biden') as tab_1,
	 (select
	  	batch_id,
	 	votes as trump_votes
	 from vote_counts
	 where candidate='Trump') as tab_2
	 where tab_1.batch_id = tab_2.batch_id;


-- View margins view
Select * from public.margins;


-- //////////////////////////////////////////////////////////
-- Modify the margins view

-- Calculate batch change in margin
select *, (biden_votes - trump_votes) 
as batch_margin from public.margins;


-- The first set of queries uses the view called 'margins'
-- Drop column of table
ALTER TABLE vote_counts
DROP COLUMN batch_margin;


-- Add new column to table
ALTER TABLE vote_counts 
ADD COLUMN batch_margin integer NOT NULL
DEFAULT 10;

-- Insert data
UPDATE vote_counts
SET batch_margin = subquery.batch_margin
FROM (
		select mg.batch_id, (mg.biden_votes - mg.trump_votes) as batch_margin
		from public.margins as mg) as subquery
WHERE vote_counts.batch_id = subquery.batch_id;


-- Check if data was updated
-- should probably make a summarized table
select * from vote_counts;