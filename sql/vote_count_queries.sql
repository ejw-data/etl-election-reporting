--////////////////////////////////////////////////////
-- This set of queries uses the vote_counts table

-- Show complete table
select * from vote_counts;

-- Total Votes
select sum(v.votes) from vote_counts as v;
-- Query Result:  155,505,907
-- Official Result:  155,485,078

-- Biden Total Votes
select sum(v.votes) from vote_counts as v
where v.candidate = 'Biden';
-- Query Result:  81,243,830
-- Official Result:  81,268,924

-- Trump Total Votes
select sum(v.votes) from vote_counts as v
where v.candidate = 'Trump';
-- Query Result:  74,262,077
-- Official Result:  74,216,154

-- Trump Total Votes (same as above)
select sum(votes) from vote_counts
where candidate = 'Trump';

-- Trump Votes in Alabama
select sum(v.votes) from vote_counts as v
where v.candidate = 'Trump'
AND v.state = 'Alabama';
-- Query Result:  1,441,170
-- Official Result:  1,441,170

-- Biden Votes in Alabama
select sum(v.votes) from vote_counts as v
where v.candidate = 'Biden'
AND v.state = 'Alabama';
-- Query Result:  849,624
-- Official Result:  849,624

-- Biden votes by state
select v.state, sum(v.votes) as Biden 
from vote_counts as v
where v.candidate = 'Biden'
group by v.state
order by v.state asc;


-- Final Vote Margin for Alabama(scaler substraction)
select
	(select sum(v.votes) from vote_counts as v where v.candidate = 'Trump' AND v.state = 'Alabama')
   -  (select sum(v.votes) from vote_counts as v where v.candidate = 'Biden' AND v.state = 'Alabama')	
	as "Vote Margin";
-- Query Result:  591,546
-- Official Result:  591,546

-- Batch votes by time for Alabama
select v.datetime, v.votes from  vote_counts as v
where v.candidate = 'Trump'
AND v.state = 'Alabama';

-- Vote summary Biden
select v.state, sum(v.votes) as "Biden Votes" from vote_counts as v
where v.candidate = 'Biden'
group by v.state;

-- Vote summary Both
select v.state, sum(v.votes) as "All Votes" from vote_counts as v
group by v.state;

-- Calculation with a stored value
-- Drop single value stored (if it exists)
Drop Table totalVotes;

-- Store value - total votes
select sum(vote_counts.votes) as AllVotes into totalVotes from vote_counts;
select AllVotes from totalVotes;
-- Query Result:  155,505,907

-- Calculate the percent of votes cast per state
select v.state, round(sum(v.votes)/cast(av.AllVotes as decimal)*100,1) as "Percent"
from vote_counts as v, totalVotes as av
group by v.state, av.AllVotes;
--Note:  CA ~= 11%, District of Columbia and Alaska ~= 0.2%


-- Get records between two dates (midnight)
select *
from vote_counts
where 
	state = 'Alaska' 
	and 
	candidate = 'Biden'
	and
	datetime between '2020-11-11' and '2020-11-12';
-- Results:  3 AK records
	

-- Add amount to integer from latest row data
-- Just showing the data can be manipulated
-- Dangerous operation since if wrong could change every vote column value
with update_data as (
	select 
		record_id,
		batch_id,
		datetime, 
		votes 
	from vote_counts 
	order by datetime DESC
	LIMIT 1
)
update vote_counts set votes = update_data.votes + 10
from update_data
where vote_counts.record_id = update_data.record_id
	AND
	vote_counts.batch_id = update_data.batch_id;


-- Check results
select * from vote_counts
order by datetime DESC 
limit 2;
--Result:  Shows an increase by 10 on only the last record
