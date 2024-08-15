
select * from assembly;
select * from duration;
select * from payment;
select * from trip_details;
select * from trips;


-- Q-1: Total trips?

select count(tripid) as Total_trips
from trip_details;


-- Q-2: Total earning

select sum(fare) as total_earning 
from trips;

-- Q-3: Total completed trips

select count(tripid) as completed_trips
from trip_details 
where end_ride = 1;


-- Q-4: Total searches

select count(searches) as total_search
from trip_details;

-- Q-5: Tootal searches which got estimate

select count(searches_got_estimate) as total_search_got_estimate
from trip_details
where searches_got_estimate = 1;

-- Q-6: Total searches for quotes

select count(searches_for_quotes) as total_search_got_quotes
from trip_details
where searches_for_quotes = 1;

-- Q-7: Total driver canceled

select count(driver_not_cancelled) as total_driver_cancelled
from trip_details
where driver_not_cancelled = 0;

-- Q-8: Total OTP entered?

select count(otp_entered) as total_otp_entered
from trip_details
where otp_entered = 1;

-- Q-9: Total ennd rides?

select count(end_ride) as total_end_ride
from trip_details
where end_ride = 1;


-- Q-10: Average distance per trips

select avg(distance) as average_distance
from trips;

-- Q-11: Average fare per trips

select avg(fare) as average_fare
from trips;


-- Q-12: Which is the most used payment method 

select b.faremethod ,pay.method from payment pay 
inner join
(select faremethod , count(faremethod) as most_used_payment_method 
from trips
group by  faremethod 
order by count(faremethod) desc limit 1) b
	on pay.id = b.faremethod
;


-- Q-13: The highest payment through which instrument

		-- Highest a particular trip--  
select b.faremethod, pay.method , b.fare from payment pay 
inner join 
(select * 
from trips
order by fare desc limit 1) b
	on pay.id = b.faremethod
;



-- Q-14: Which two location has the most trips

select loc_from , loc_to ,count(loc_from) , count(loc_to)
from trips
group by loc_from , loc_to
order by count(loc_from) desc , count(loc_to) desc limit 2;


-- Q-15: Top 5 earning drivers
select *
from
(select *,
dense_rank() over(order by Earning desc) as rnk
from
(select driverid , sum(fare) as Earning
from trips
group by driverid
)b)c
where rnk < 6;



;


-- Q-16: Which duration has more trips

select * from
(select * , rank () over(order by duration asc) as rnk
from
(select duration , count(duration) as highest_trip
from trips
group by duration)b)c
where rnk = 1;

-- Q-17: Which driver , customer pair had more order
select *
from
(select * , dense_rank () over( order by driver desc , customer desc) as rnk
from
(select driverid , custid , count(driverid) as driver  , count(custid) as customer
from trips
group by driverid , custid) a ) b
where rnk = 1;
;

-- Q-18: Search to estimate rate

select (sum(searches_got_estimate) * 100)/sum(searches) as Total_estimated
from trip_details
;

select * from trips;


-- Q-19: Which area got highest trips in which duration

select *
from
(select * , dense_rank() over( order by locFrom desc , dis desc ) as rnk
from
(select distance , loc_from ,  count(loc_from) as locFrom , count(distance) as dis
from trips
group by  distance ,loc_from ) a ) b
where rnk = 1
;


-- Q-20: Which area got highest fare, cancellation , trips
select *
from
(select * , rank () over (order by total_fare desc) as rnk
from
(select loc_from , sum(fare) as total_fare
from trips
group by loc_from) a) b
where rnk = 1 ;


select loc_from , count(*) - sum(driver_not_cancelled) as cancel
from trip_details
group by loc_from
;


-- Q-20: Whichh duration got the highest trps and fares

select duration , count(distinct tripid) as highest_trip
from trips
group by duration
order by highest_trip desc limit 1;
