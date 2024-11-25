use Kpi;

select * from success;

select distinct Count(Phone_Number) as Total_Success from success;

select count(distinct Batch) as Unique_Batch from success;

select distinct Department from success;

-- 1. Batch Wise Departmental Success;

with CTE_1 as 
(select Batch, Department, count(*) as Success_Count
from success
group by 1,2
order by 3 desc)

select c.Batch,
	sum(distinct case when c.Department = 'Graphic Design' then c.Success_Count else null end) as GD,
    sum(distinct case when c.Department = 'Digial Marketing' then c.Success_Count else null end) as DM,
	sum(distinct case when c.Department = 'Web & Software' then c.Success_Count else null end) as WD,
	sum(distinct case when c.Department = '3D Animation & Visualization' then c.Success_Count else null end) as TD,
	sum(distinct case when c.Department = 'Flim & Media' then c.Success_Count else null end) as FM
 from CTE_1 c
 group by 1;
 
-- 2. Top 5 Batch Success Count.

with cte_2 as (
select Batch, count(*) as Success_Count,
dense_rank() over (order by count(*) desc) as Rnk
from success 
group by 1
order by 2 desc)

select * from cte_2 c
where c.Rnk < 6;

-- 3. Top 3 Department Success Count.

with cte_3 as (
select Department, count(*) as Success_Count,
dense_rank() over (order by count(*) desc) as Rnk
from success 
group by 1
order by 2 desc)

select * from cte_3 c
where c.Rnk < 4;

-- 4. Average Success Batch Wise.


select
(select count(*) from success)/
(select count(distinct Batch) as Unique_Batch_Count from success) as Avg_Success from success;

select Batch, avg((select
(select count(*) from success)/
(select count(distinct Batch) as Unique_Batch_Count from success) as Avg_Success from success)) from success
group by Batch;

-- 5. Top 5 Mentor Status.

with cte_4 as (
select Mentor_Name, count(*) as Success_Count,
dense_rank() over (order by count(*) desc) as Rnk
from success 
group by 1
order by 2 desc)

select * from cte_4 c
where c.Rnk < 6;

-- 6. Overall Career Status.

select Market_Place_Name,Career, count(*) as Success_Count
from success 
group by 1,2
order by 3 desc;

select * from success;

-- 7. Overall Career Status Marketplace Wise.

with cte_5 as (
select Market_Place_Name,Career, count(*) as Success_Count
from success 
group by 1,2
order by 3 desc)

select c.Market_Place_Name,
	sum(distinct case when c.Career = 'Job' then c.Success_Count else null end) as Job,
	sum(distinct case when c.Career = 'Business' then c.Success_Count else null end) as Business,
    sum(distinct case when c.Career = 'Freelancing' then c.Success_Count else null end) as Freelancing,
    sum(distinct case when c.Career = 'Job + Freelancing' then c.Success_Count else null end) as Job_Freelancing,
	sum(distinct case when c.Career = 'Job + Business' then c.Success_Count else null end) as Job_Business,
    sum(distinct case when c.Career = 'Business + Freelancing' then c.Success_Count else null end) as Business_Freelancing
from cte_5 c
group by 1 ;

-- 8. Mentor Wise Career Status.
with cte_6 as (
select Mentor_Name,Career, count(*) as Success_Count
from success 
group by 1,2
order by 3 desc)

select c.Mentor_Name,
	sum(distinct case when c.Career = 'Job' then c.Success_Count else null end) as Job,
	sum(distinct case when c.Career = 'Business' then c.Success_Count else null end) as Business,
    sum(distinct case when c.Career = 'Freelancing' then c.Success_Count else null end) as Freelancing,
    sum(distinct case when c.Career = 'Job + Freelancing' then c.Success_Count else null end) as Job_Freelancing,
	sum(distinct case when c.Career = 'Job + Business' then c.Success_Count else null end) as Job_Business,
    sum(distinct case when c.Career = 'Business + Freelancing' then c.Success_Count else null end) as Business_Freelancing
    
from cte_6 c
group by 1;

-- 9. Depratment Wise Career Status.
select * from
(select  x.*, 
dense_rank() over(partition by x.Department order by x.Success_Count desc) as Rnk
from
(select Department,Career, count(*) as Success_Count
from success 
group by 1,2
order by 3 desc) as x) as x
where x.Rnk < 3;

-- 10 . Mentor Wise Marketplace Status..
select * from
(select x.*,
dense_rank() over(partition by x.Market_Place_Name order by x.Success_Count desc) as Rnk
from
(select Market_Place_Name,Mentor_Name, count(*) as Success_Count
from success 
group by 1,2
order by 3 desc) as x) as x
where x.Rnk < 4;