-- Add zip_code to geo_location table
ALTER TABLE geo_location
ADD COLUMN zip_code INT;

-- Creating four roles
CREATE ROLE admin;
CREATE ROLE employee;
CREATE ROLE trainee;
CREATE ROLE views_only; 

-- Giving all administrative rights for admin
GRANT SUPERUSER TO admin;

-- Giving read only rights for employee
GRANT SELECT ON ALL TABLES IN SCHEMA public TO employee;

-- Giving trainee to read only rights to selected tables
GRANT SELECT ON (project, customer, geo_location, project_role) TO trainee; 

-- Giving trainee read only rights for specific columns of employee table
GRANT SELECT (e_id, emp_name, email) ON employee TO trainee; 

-- Giving views_only read access to all created views
GRANT SELECT ON ALL VIEWS IN SCHEMA public TO views_only;
