SELECT
	period
	,first_value(cohort_retained) over (order by period) as cohort_size
	,cohort_retained
	,CAST(cohort_retained AS float) / first_value(cohort_retained) over (order by period) as pct_retained
FROM
	(-- This creates a time series by identifying each annual period and how many legislators survived their next election.
	SELECT
		datediff(year, first_term, term_start) as period
		,count(distinct a.id_bioguide) as cohort_retained
	FROM
		(-- This identifies each legislator and the first day of their first term.
		SELECT id_bioguide,min(term_start) AS first_term
		FROM legislators_terms
		GROUP BY id_bioguide) AS a
	
		JOIN legislators_terms as b
			on a.id_bioguide = b.id_bioguide
	GROUP BY datediff(year, first_term, term_start)) AS aa
