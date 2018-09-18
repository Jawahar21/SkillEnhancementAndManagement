# Controller API of the ManagerAssist Project
from flask import Flask, render_template, request, redirect, session, url_for
from Models.user import User
from Services.loginsignup import LoginSignup
from Services.associate_services import Associate
from Services.manager_operations import Manager
from Services.admin import Admin
from passlib.hash import sha256_crypt
from flask_wkhtmltopdf import Wkhtmltopdf
import json

app = Flask(__name__)
wkhtmltopdf = Wkhtmltopdf(app)
app.config['MAIL_SERVER']='smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USERNAME'] = 'manager.assist.sg@gmail.com'
app.config['MAIL_PASSWORD'] = 'managerassist123$'
app.config['MAIL_USE_TLS'] = False
app.config['MAIL_USE_SSL'] = True

#prevents illegal load of url
# @app.before_request
# def request_authorisation():
#     if session.get ( 'userdatalist', None ) == None and \
#     request.endpoint not in ['loadLandingPage','loadLoginPage','loadSignupPage']:
#         return redirect(url_for('loadLoginPage'))

# loads the home page of the project
# if user is already logged in, the same session is continued
@app.route ( '/' )
def loadLandingPage():
    return LoginSignup.loadHome()

# loads the login page for users
@app.route ( '/login', methods = ['GET','POST'] )
def loadLoginPage():
    return LoginSignup.checkUser()

# loads the signup page for users
@app.route ( '/recruitment', methods = ['GET','POST'] )
def loadRecruitment():
    return Admin.registerUser(app)

# loads the home page of the associate
@app.route ( '/associatehome' )
def loadAssociateHome():
    return Associate.getHome()

# loads the home page of the manager
@app.route ( '/managerhome' )
def loadManagerHome():
    return Manager.getHome()

# loads the home page of the admin
@app.route ( '/adminhome' )
def loadAdminHome():
    return Admin.getHome()

# displays the profile details of the user
@app.route ( '/profilepage' )
def loadProfile():
    user = session.get ( 'userdatalist', None )
    return Associate.getProfile(user[0])

# displays the skill details of the user
@app.route ( '/viewskillspage', methods = ['GET','POST'] )
def loadSkills():
    return Associate.getSkills()

# provides option to add a new skill for associates
@app.route ( '/skillspage', methods = ['GET','POST'] )
def loadSkillspage():
    return Associate.addSkill ()

# displays all the tests taken by the associate
@app.route ( '/testhistorypage', methods =['GET','POST'] )
def loadTestHistory():
    return Associate.testHistory ()

@app.route('/generatecertificate',methods =['POST'])
def loadCertificatePage():
    return Associate.getCertificate(app)

# displays the recently added skills to the manager
@app.route ( '/notificationspage' )
def loadNotifications():
    return Manager.getNotifications()

# displays the associate profile to the manager
# either by referencing associate_name or associate_id
@app.route ( '/employeedetailspage', methods = ['GET','POST'] )
def loadEmployeeDetails():
    return Manager.getUserByName()

#loads a page which shows all the associate details overview
@app.route('/allassociates')
def loadAllAssociatesPage():
    return Manager.allAssociatesList()

# provides option to the manager to conduct test
# for the new skills added by the associates
@app.route ( '/conducttestpage' , methods = ['GET','POST'] )
def loadConductTestPage():
    return Manager.createTest ()

# allows associate to take test generated by the manager
@app.route ( '/taketestpage' , methods = ['GET','POST'] )
def loadTakeTestPage ():
    return Associate.getQuestions ()

# stores the test result into the database
@app.route ( '/gettestresults', methods = ['POST'] )
def loadTestScore():
    return Associate.gettestresults ()

#allows the admin to add questions to the database
@app.route ('/addquestionbank', methods = ['GET','POST'])
def loadAddQuestionBank():
    return Admin.addQuestionBank()

#loads the team management home page
@app.route('/teams')
def loadTeamsPage():
    return render_template('teams.html')

# loads the page to create team
@app.route('/createteam', methods=['GET','POST'])
def loadCreateTeam():
    return Admin.createTeam()

#loads the page to add member to a team
@app.route ('/addmember', methods = ['GET','POST'])
def loadAddMember():
    return Admin.addMember()

#loads the page to remove member from a team
@app.route ('/removemember', methods = ['GET','POST'])
def loadRemoveMember():
    return Admin.removeMember()

#loads the page which displays all team details overview
@app.route('/showteamdetails')
def loadTeamDetailsPage():
    return Admin.teamDetails()

#loads a page to remove team
@app.route('/removeteam',methods=['GET','POST'])
def loadRemoveTeamPage():
    return Admin.removeTeam()


# provides option to logout
@app.route ( '/logout' )
def logout():
    return LoginSignup.logout()

# checks whether the controller is run from the main module
if __name__ == '__main__':
    app.secret_key = 'this_secret_key_is_unique'
    app.run( threaded = True, port = 5001  )
    # app.run ( port = 5001 )
