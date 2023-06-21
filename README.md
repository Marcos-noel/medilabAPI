# Medilab API
This is an API buit in python Flask framework and MySQL databse

## The API has 3 parts

1. the API allows the client to register a member , sign in , profile ,add dependants, make bookings, make payments e.t.c. 

2. Other APIs include sign in, sign up, add laboratory, add lab tests, add nurses, allocate Nurses 

3. Nurse APIs allows nurss to login and access their allocated Tasks, change password.

### How to install
Step 1: Download Xampp from https://www.apachefriends.org/

step 2: create and import medilab.sql
step 3: Create a flask app and install these packages
```
pip install flask
pip install pymysql
pip install bcrypt
pip install africastalking
pip install fpdf

```
step 4: Create a folder named views.py and place the views_nurses.py, views.py nad views_dashboard.py inside

In the root folder cretae a functions.py
In the root folder again create app.py and configure  your Endpoints.

Run your App.

Useful links
https://github.com/africastalking/AfricasTalking-SDK
https://pypi.python.org/pypi/Flask
https://flask.palletsprojects.com/en/1.0.x/quickstart


