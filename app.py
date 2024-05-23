# Citation for the following function:
# Date: 5/21/24
# Adapted from CS 340 Flask App Starter 
# Adapted from class material provided and changed to accomodate our project and its needs.
# Source URL: https://github.com/osu-cs340-ecampus/flask-starter-app/blob/master/database/db_connector.py


from flask import Flask, render_template, json, redirect
from flask_mysqldb import MySQL
from flask import request
from dotenv import load_dotenv
import os
import database.db_connector as db

load_dotenv()

app = Flask(__name__)

app.config['MYSQL_HOST'] = os.getenv("MYSQL_HOST")
app.config['MYSQL_USER'] = os.getenv("MYSQL_USER")
app.config['MYSQL_PASSWORD'] = os.getenv("MYSQL_PASSWORD")
app.config['MYSQL_DB'] = os.getenv("MYSQL_DB")
app.config['MYSQL_CURSORCLASS'] = "DictCursor"


mysql = MySQL(app)

db_connection = db.connect_to_database()

# Routes
@app.route('/')
def root():
    return render_template("main.j2")

# Route for specialties page
@app.route('/specialties')
def specialties():
    return render_template("specialties.j2")

# Route for providers page
@app.route('/providers')
def providers():
    return render_template("providers.j2")

# Route for treatments page
@app.route('/treatments')
def treatments():
    return render_template("treatments.j2")

# Route for treatment orders and ordered treatments
@app.route('/treatmentordersandorderedtreatments')
def treatmentordersandorderedtreatments():
    return render_template("treatmentordersandorderedtreatments.j2")


# route for patients page
@app.route("/patients", methods=["POST", "GET"])
def patients():

    # for a POST
    # insert a Patient into the Patients entity
    if request.method == "POST":
        # fire off if user presses the Add Patient button
        if request.form.get("Add_Patient"):
            # grab user form inputs
            name = request.form["name"]
            birthdate = request.form["birthdate"]
            email = request.form["email"]
            ptproviderID = request.form["ptproviderID"]

            # account for null provider
            if ptproviderID == "0":
                # mySQL query to insert a new Patient into Patients with our form inputs
                query = "INSERT INTO Patients (patientName, birthDate, email) VALUES (%s, %s, %s)"
                cur = mysql.connection.cursor()
                cur.execute(query, (name, birthdate, email))
                mysql.connection.commit()

            # no null inputs
            else:
                query = "INSERT INTO Patients (patientName, birthDate, email, ptproviderID) VALUES (%s, %s, %s, %s)"
                cur = mysql.connection.cursor()
                cur.execute(query, (name, birthdate, email, ptproviderID))
                mysql.connection.commit()

            # back to Patients page
            return redirect("/patients")
        
    # Get Patients data to send to template to display
    if request.method == "GET":
        # mySQL query to get all the Patients in Patients
        query = "SELECT Patients.patientID, patientName, birthDate, email, Providers.name AS ptproviderID FROM Patients LEFT JOIN Providers ON ptproviderID = Providers.providerID"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # mySQL query to grab provider id/name data for our dropdown
        query2 = "SELECT providerID, name FROM Providers"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        provider_data = cur.fetchall()

        # render edit_patients page passing our query data and provider data to the edit_people template
        return render_template("patients.j2", data=data, ptproviderIDs=provider_data)

 # Get Patients data to send to template to display
    if request.method == "GET":
        # mySQL query to get all the Patients in Patients
        query = "SELECT Patients.patientID, patientName, birthDate, email, Providers.name AS ptproviderID FROM Patients LEFT JOIN Providers ON ptproviderID = Providers.providerID"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # mySQL query to grab provider id/name data for our dropdown
        query2 = "SELECT providerID, name FROM Providers"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        provider_data = cur.fetchall()

        # render edit_patients page passing our query data and provider data to the edit_people template
        return render_template("patients.j2", data=data, ptproviderIDs=provider_data)


# route for delete ability - deleting a Patient from Patients,
# we want to pass the 'patientID' value of that Patient on button click (see HTML) via the route
@app.route("/delete_patients/<int:patientID>")
def delete_people(patientID):
    # mySQL query to delete the Patient with patientID
    query = "DELETE FROM Patients WHERE patientID = '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (patientID))
    mysql.connection.commit()

    # redirect back to Patients page
    return redirect("/patients")


# route for edit ability - updating Patient attributes in Patients
# we want to the pass the 'patientID' value of that Patient on button click (see HTML) via the route
@app.route("/edit_patients/<int:patientID>", methods=["POST", "GET"])
def edit_people(patientID):
    if request.method == "GET":
        # mySQL query to grab the Patient info with passed patientID
        query = "SELECT * FROM Patients WHERE patientID = %s" % (patientID)
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # mySQL query to grab provider id/name data for our dropdown
        query2 = "SELECT providerID, name FROM Providers"
        cur = mysql.connection.cursor()
        cur.execute(query2)
        provider_data = cur.fetchall()

        # render edit_patients page passing our query data and provider data to the edit_patients template
        return render_template("edit_patients.j2", data=data, ptproviderIDs=provider_data)

    # main part of our update ability
    if request.method == "POST":
        # if user clicks the 'Update Patient' button
        if request.form.get("Update_Patient"):
            # grab user form inputs
            patientID = request.form["patientID"]
            name = request.form["name"]
            birthdate = request.form["birthdate"]
            email = request.form["email"]
            ptproviderID = request.form["ptproviderID"]

            # account for null provider
            if ptproviderID == "0":
                # mySQL query to update the Patient attributes with our passed patientID value
                query = "UPDATE Patients SET Patients.patientName = %s, Patients.birthDate = %s, Patients.email = %s, Patients.ptproviderID = NULL WHERE Patients.patientID = %s"
                cur = mysql.connection.cursor()
                cur.execute(query, (name, birthdate, email, patientID))
                mysql.connection.commit()

            # no null inputs
            else:
                query = "UPDATE Patients SET Patients.patientName = %s, Patients.birthDate = %s, Patients.email = %s, Patients.ptproviderID = %s WHERE Patients.patientID = %s"
                cur = mysql.connection.cursor()
                cur.execute(query, (name, birthdate, email, ptproviderID, patientID))
                mysql.connection.commit()

            # redirect back to Patients page after we execute the update query
            return redirect("/patients")



# Listener
if __name__ == "__main__":

    #Start the app on port 3000, it will be different once hosted
    app.run(port=58402, debug=True)
#   app.run(host='localhost', port=5000, debug=True)