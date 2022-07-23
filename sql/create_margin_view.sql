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


-- //////////////////////////////////////////////////////////
-- View tests

-- View margins view
Select * from public.margins;

-- Calculate batch change in margin
select *, (biden_votes - trump_votes) 
as batch_margin from public.margins;

