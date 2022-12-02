/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
SELECT name
FROM Facilities
WHERE membercost != 0;

/* Q2: How many facilities do not charge a fee to members? */
SELECT COUNT(*) AS num_facil_with_mem_fee
FROM Facilities
WHERE membercost != 0;

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost != 0 AND membercost < 0.20 * monthlymaintenance;

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
SELECT *
FROM Facilities
WHERE facid IN (1, 5);

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */
SELECT name, monthlymaintenance,
	CASE WHEN monthlymaintenance > 100 THEN 'expensive'
	ELSE 'cheap' END AS cheap_or_expensive
FROM Facilities;

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
SELECT firstname, surname
FROM Members
WHERE joindate = (SELECT MAX(joindate) FROM Members);

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
/* Main query. If the member has ever used only one type of tennis court, the name of that court shows up
   next to the member's name. If the member has used both, the phrase "Both tennis courts" shows up instead. */
SELECT CASE 
	WHEN num_tennis_types = 1 THEN CONCAT_WS('', surname, ', ', firstname, ' - ', tennis_court)
	WHEN num_tennis_types = 2 THEN CONCAT_WS('', surname, ', ', firstname, ' - ', 'Both tennis courts')
	ELSE 'Something went wrong.'
	END AS tennis_courts_used
FROM (
/*     Subquery 3: The purpose of this subquery if to do a GROUP BY (yet again) by memid. Becasue in the results of the
       previous subquery each member appears only once or twice, this GROUP BY is able to count wheter each
       each member ever used only one tennis court of if they used both tennis courts. */
	SELECT *, COUNT(*) AS num_tennis_types
	FROM (
/*         Subquery 2: The purpose of this subquery is to group the table "all_tennis_bookings" by memid and tennis_court.
           Therefore, each member that has ever used a tennis court will appear either once or twice, depending on
           whether they have ever used a single tennis court of both courts */
		SELECT *
		FROM (
/*             Subquery 1: This subquery outputs a table called tennis_bookings containing every booking where either
               Tennis Court 1 or Tennis Court 2 was used. It is created by inner joining all three tables in the database. */
    		SELECT b.bookid, m.memid, m.surname, m.firstname, f.name AS tennis_court
			FROM Members AS m
			INNER JOIN Bookings AS b
			USING (memid)
			INNER JOIN Facilities AS f
			USING (facid)
			WHERE f.name LIKE 'Tennis Court%' AND m.memid != 0
        ) AS all_tennis_bookings
		GROUP BY memid, tennis_court
    ) AS tennis_courts_used
	GROUP BY memid
) AS final
ORDER BY surname, firstname;

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
SELECT f.name AS facility, CONCAT_WS('', m.surname, ', ', m.firstname) AS name,
	CASE  WHEN memid = 0 THEN guestcost * slots
		  ELSE membercost * slots
	END AS cost
FROM Bookings AS b
INNER JOIN Members AS m
USING (memid)
INNER JOIN Facilities AS f
USING (facid)
WHERE starttime LIKE '2012-09-14%'AND ((memid = 0 AND guestcost * slots > 30) OR (memid != 0 AND membercost * slots > 30))
ORDER BY cost DESC;

/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT facility, name, cost
FROM (
    SELECT f.name AS facility, CONCAT_WS('', m.surname, ', ', m.firstname) AS name,
    	b.starttime,
		CASE WHEN b.memid = 0 THEN f.guestcost * b.slots
		 	 ELSE f.membercost * b.slots
		END AS cost
	FROM Bookings AS b
	INNER JOIN Facilities AS f USING (facid)
    INNER JOIN Members AS m USING (memid)
) AS sub
WHERE cost > 30 AND starttime LIKE '2012-09-14%'
ORDER BY cost DESC;

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


/* Q12: Find the facilities with their usage by member, but not guests */


/* Q13: Find the facilities usage by month, but not guests */

