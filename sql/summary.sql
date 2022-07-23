
-- Add Biden votes
with data as (
	select 
		datetime as date,
		biden_votes,
		trump_votes,
		batch_margin,
		(biden_votes + trump_votes) as total_votes
	from margin_info
	where state = 'Alabama'
	order by date DESC
),
data2 as (
	select
		date,
		biden_votes,
		trump_votes,
		sum(biden_votes) over (order by date asc rows between unbounded preceding and current row) as BidenVotes,
		sum(trump_votes) over (order by date asc rows between unbounded preceding and current row) as TrumpVotes,
		sum(total_votes) over (order by date asc rows between unbounded preceding and current row) as TotalVotes,
		batch_margin,
		avg( biden_votes::decimal/(trump_votes + biden_votes)*100 ) over (order by date asc rows between unbounded preceding and current row) as batch_trend_percent,
		sum(batch_margin) over (order by date asc rows between unbounded preceding and current row) as AccumBatchMargin		
	from data
)
select
	date,
	BidenVotes,
	TrumpVotes,
	TotalVotes,
	batch_margin as BatchMargin,
	round( biden_votes::decimal/(trump_votes + biden_votes)*100,1 ) as BatchPercent,
	round( batch_trend_percent,1 ) as batchTrendPercent,
	AccumBatchMargin,
	round( (BidenVotes::decimal / TotalVotes::decimal * 100),1) as VotePercent
	from data2