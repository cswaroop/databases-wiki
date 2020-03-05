
-- Row pattern recognition captures groups of rows that follow a pattern. Rows in matched groups can be filtered, grouped, and aggregated. The pattern itself is described with a simple regular expression syntax.

-- http://modern-sql.com/blog/2017-06/whats-new-in-sql-2016

SELECT COUNT (grp_start) AS groups
