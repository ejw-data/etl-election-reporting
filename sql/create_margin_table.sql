
-- Instead of making view make  a table
-- Makes adding columns easier since this will ahve new format
-- A view does not have an ADD COLUMN method
CREATE TABLE margin_info AS
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

-- Check table results
select * from margin_info;

-- Add new column to table
ALTER TABLE margin_info 
ADD COLUMN batch_margin integer NOT NULL
DEFAULT 10;

-- Insert data
UPDATE margin_info
SET batch_margin = subquery.batch_margin
FROM (
		select mg.batch_id, (mg.biden_votes - mg.trump_votes) as batch_margin
		from margin_info as mg) as subquery
WHERE margin_info.batch_id = subquery.batch_id;

-- Check results
select * from margin_info;


-- Cumulative/Running total
with data as (
	select 
		datetime as date,
		count(1)
	from margin_info
	group by 1
	order by date DESC
)
select
	date,
	sum(count) over (order by date asc rows between unbounded preceding and current row)
	from data;

-- show vote_counts table
select * from margin_info
where state = 'Alabama';