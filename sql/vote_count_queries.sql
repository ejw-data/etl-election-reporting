--////////////////////////////////////////////////////
-- This set of queries uses the vote_counts table


-- Total Votes
select sum(v.votes) from vote_counts as v;

-- Biden Total Votes
select sum(v.votes) from vote_counts as v
where v.candidate = 'Biden';

-- Trump Total Votes
select sum(v.votes) from vote_counts as v
where v.candidate = 'Trump';

-- Trump Total Votes (same as above)
select sum(votes) from vote_counts
where candidate = 'Trump';

-- Biden Votes in Alabama
select sum(v.votes) from vote_counts as v
where v.candidate = 'Trump'
AND v.state = 'Alabama';

-- Final Vote Margin (scaler substraction)
select
	(select sum(v.votes) from vote_counts as v where v.candidate = 'Trump' AND v.state = 'Alabama')
   -  (select sum(v.votes) from vote_counts as v where v.candidate = 'Biden' AND v.state = 'Alabama')	
	as "Vote Margin";

-- Batch votes by time
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

-- -- Store value
-- select sum(vote_counts.votes) as "AllVotes" into totalVotes3 from vote_counts;

-- select * from totalVotes3


select sum(v.votes)/cast(av.sum as decimal)*100
as "Percent "
from vote_counts as v, allvotes as av
group by v.state, av.sum;



-- Get rows between two dates (midnight)
select *
from vote_counts
where 
	state = 'Alaska' 
	and 
	candidate = 'Biden'
	and
	datetime between '2020-11-11' and '2020-11-12'
	
	
-- Add amount to integer from latest row data
with data as (
	select 
		datetime, 
		votes 
	from vote_counts 
	order by datetime DESC
	LIMIT 1
)
update vote_counts set votes = votes + 10
