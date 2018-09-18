#Operations perfomed by admin
from flask import Flask, render_template, request, redirect, session, url_for,jsonify
from Services.database_manager import DataBaseManager
from werkzeug import secure_filename
import psycopg2, csv, datetime, json
from passlib.hash import sha256_crypt
from Models.user import User
from flask_mail import Mail, Message

class Admin:

    # to check if the user is already registered
    @classmethod
    def checkUserRegister ( cls, email ):
        conn = DataBaseManager.database_connection()
        cur = conn.cursor()
        try:
            email = email.upper()
            query = "SELECT * FROM users WHERE email=%s"
            cur.execute ( query, (email,) )
            row = cur.fetchone()
            if row:
                return User ( *row )
            else:
                return None
        finally:
            conn.close()

    # to register the new user and update database
    @classmethod
    def registerUser(cls,app):
        if request.method == "POST":
            userlis = []
            emailid = []
            userlis.append ( request.form [ 'emp_id' ].upper() )
            userlis.append ( request.form [ 'name' ].upper() )
            emailid.append(request.form [ 'emailaddress' ].upper())
            userlis.append (emailid[0])
            password = request.form['password']
            userlis.append ( sha256_crypt.hash ( password ) )
            userlis.append (request.form ['phno' ] )
            role = request.form['role']
            open = request.form['open']
            micro = request.form['micro']
            web = request.form['web']
            open = open.split(',')
            micro = micro.split(',')
            web = web.split(',')
            competency = { "1" : open, "2" : micro, "3" : web}
            if role == 'Please select one' :
                return render_template('register.html',message='Please select role')
            userlis.append (request.form ['role' ] )
            conn = DataBaseManager.database_connection()
            cur = conn.cursor()
            try:
                exists = cls.checkUserRegister ( userlis[2] )
                if exists:
                    return render_template ( 'register.html', message = "User Already Exists")
                else:
                    query = "insert into users (eid,name,email,password,\
                    phno,roleid) values(%s,%s,%s,%s,%s,%s)"
                    cur.execute ( query, userlis )
                    for key,value in competency.items():
                        if len(value) == 1 and value[0] == '' :
                            continue
                        for skill in value:
                            skill = skill.upper()
                            query = 'select skillid from skills where skillname=%s'
                            cur.execute(query,(skill,))
                            skillid = cur.fetchone()
                            if skillid == None:
                                query = "insert into skills (skillname,cid) values (%s,%s) returning skillid"
                                cur.execute(query,(skill,int(key)))
                                skillid = cur.fetchone()
                            query = "insert into associate_skills (eid,skillid,reviewed,pid,result) \
                            values (%s,%s,%s,%s,%s)"
                            cur.execute(query,(userlis[0],skillid,'yes',4,'Certified'))
                    conn.commit()
                    try:
                        mail = Mail(app)
                        msg = Message('Hello', sender = 'manager.assist.sg@gmail.com',
                        recipients = emailid)
                        msg.body = "Welcome to Manager Assist, You are successfully registered!!!\
                        \nYour login credentials\
                        \nEmail : {0}\n Password : {1}".format(userlis[2],password)
                        mail.send(msg)
                    except Exception:
                        return render_template('register.html',message="Registered Successfully. Failed sending confirmation mail. Check your internet connection!!")
                    return render_template ( 'register.html', message="Registered Successfully")
            except Exception:
                return render_template('register.html',message="User already exists")
            finally:
                conn.close()
        else:
            return render_template ( 'register.html' )


    # loads the home page of the admin
    @classmethod
    def getHome(cls):
        user = session.get ( 'userdatalist', None )
        return render_template ( 'admin.html', name = user[1])

    #Adds questions to the databse from a CSV file uploaded
    @classmethod
    def addQuestionBank(cls):
        if request.method == 'POST':
            conn = DataBaseManager.database_connection()
            cur = conn.cursor()
            try:
                f = request.files['file']
                skillname = request.form['skill']
                query = "select skillid from skills where skillname=%s"
                cur.execute(query,(skillname,))
                skillid = cur.fetchone()
                if skillid == None:
                    return render_template('addquestionspage',message='Please select skill')
                f.save(secure_filename(f.filename))
                with open(f.filename) as csvfile:
                    readCSV = csv.reader(csvfile, delimiter=',')
                    for row in readCSV:
                        query = "insert into question_bank \
                        (qno,question,option1,option2,option3,option4,answer,skillid)\
                         values (%s,%s,%s,%s,%s,%s,%s,%s)"
                        row.append(skillid[0])
                        cur.execute(query,row)
                conn.commit()
            except Exception:
                return render_template('addquestionspage.html',message = "Upload a valid file")
            finally:
                conn.close()
        details = Admin.getQuestionsCount()
        conn = DataBaseManager.database_connection()
        cur = conn.cursor()
        query = "select skillname from skills"
        cur.execute(query)
        skills = cur.fetchall()
        conn.close()
        return render_template('addquestionspage.html',details = details,skills=skills)

    #retrieves the count of the questions of each skill from the database
    @classmethod
    def getQuestionsCount(cls):
        conn = DataBaseManager.database_connection()
        cur = conn.cursor()
        details = []
        try:
            query = "select skillid,skillname from skills"
            cur.execute(query)
            skills = cur.fetchall()
            for skillid,skillname in skills:
                query = "select count(skillid) from question_bank where skillid=%s"
                cur.execute(query,(skillid,))
                count = cur.fetchone()
                details.append([skillname,count[0]])
            return details
        finally:
            conn.close()

    #creates a team with certain selected associates and stores them in database
    @classmethod
    def createTeam(cls):
        if request.method == 'POST':
            conn = DataBaseManager.database_connection()
            cur = conn.cursor()
            try:
                details = request.get_json()
                if details['status'] == 'skills' :
                    query = "select skillname from skills where cid=%s"
                    cur.execute(query,(details['cid']))
                    skills = cur.fetchall()
                    newlist = []
                    for touple in skills:
                        newlist.append(touple[0])
                    skills = jsonify({"skills":newlist})
                    return skills
                if details['status'] == 'users' :
                    query = "select skillid from skills where skillname=%s"
                    cur.execute(query,(details['skill'],))
                    skillid = cur.fetchone()
                    query = "select u.eid,u.name,r.rolename,p.plevel,a.result from users u, roles r\
                    ,associate_skills a,proficiency p where a.eid = u.eid and u.roleid=r.roleid \
                    and p.pid=a.pid and a.skillid=%s and u.eid not in (select ut.eid from user_teams ut)"
                    cur.execute(query,(skillid,))
                    users = cur.fetchall()
                    if users:
                        query = "select u.eid,u.name,r.rolename from users u, roles r \
                        where u.roleid='001' and r.roleid=u.roleid and u.eid \
                        not in(select eid from user_teams)"
                        cur.execute(query)
                        managers = cur.fetchall()
                        for manager in managers:
                            users.append(manager)
                    return jsonify({"users":users})
                if details['status'] == 'submit':
                    try:
                        for user in details['users']:
                            if(user[5] == 'M'):
                                manager = user
                                break
                        query = 'select name from users where eid=%s'
                        cur.execute(query,(manager,))
                        managername = cur.fetchone()
                        dateobj = datetime.datetime.now()
                        date = str ( dateobj.year ) + "-" + str ( dateobj.month ) + "-" + str ( dateobj.day )
                        query = "insert into teams (teamname,teamsize,team_manager,team_created) \
                        values(%s,%s,%s,%s) returning teamid"
                        cur.execute(query,(details['teamname'].upper(),len(details['users']),managername,date))
                        teamid = cur.fetchone()
                        for user in details['users']:
                            query = "insert into user_teams (eid,teamid,cid) \
                            values (%s,%s,%s)"
                            cur.execute(query,(user,teamid,details['cid']))
                        conn.commit()
                        return " Team Created "
                    except Exception:
                        return "Enter valid details"
                    finally:
                        conn.close()
            finally:
                conn.close()
        return render_template('createteam.html')

    #adds a required member into the team and stores in database
    @classmethod
    def addMember(cls):
        if request.method == 'POST':
            teamname = request.form['teamname'].upper()
            userid = request.form['eid']
            conn = DataBaseManager.database_connection()
            cur = conn.cursor()
            try:
                query = "select teamid,teamsize from teams where teamname = %s"
                cur.execute(query,(teamname,))
                team_details = cur.fetchone()
                if team_details == None:
                    return render_template('addmember.html',message = "Team not found")
                query = "select eid from user_teams where teamid=%s and eid=%s"
                cur.execute(query,(team_details[0],userid))
                eid = cur.fetchone()
                if eid:
                    return render_template('addmember.html',message = "Member already exists")
                query = "select cid from user_teams where teamid = %s"
                cur.execute(query,(team_details[0],))
                team_project = cur.fetchone()
                query = "insert into user_teams (eid,teamid,cid) \
                values (%s,%s,%s)"
                cur.execute(query,(userid,team_details[0],team_project[0]))
                teamsize = team_details[1]+1
                query = "update teams set teamsize=%s where teamid =%s"
                cur.execute(query,(teamsize,team_details[0]))
                conn.commit()
                return render_template('addmember.html',message = "Team Member Added")
            except Exception :
                return render_template('addmember.html',message = "User not found")
            finally:
                conn.close()
        return render_template('addmember.html')

    # removes a required member from the team and stores in database
    @classmethod
    def removeMember(cls):
        if request.method == 'POST':
            teamname = request.form['teamname'].upper()
            userid = request.form['eid']
            conn = DataBaseManager.database_connection()
            cur = conn.cursor()
            try:
                query = "select teamid,teamsize from teams where teamname = %s"
                cur.execute(query,(teamname,))
                team_details = cur.fetchone()
                if team_details == None:
                    return render_template('removemember.html',message = " Team not found")
                query = "delete from user_teams where eid=%s and teamid = %s returning eid"
                cur.execute(query,(userid,team_details[0]))
                eid = cur.fetchone()
                if(eid):
                    teamsize = team_details[1]-1
                    query = "update teams set teamsize=%s where teamid =%s"
                    cur.execute(query,(teamsize,team_details[0]))
                    conn.commit()
                    return render_template('removemember.html',message = "Team Member Removed")
                else :
                    return render_template('removemember.html',message =  "Member not found")
            finally:
                conn.close()
        return render_template('removemember.html')

    #retrieves the entire team details from the database
    @classmethod
    def teamDetails(cls):
        conn = DataBaseManager.database_connection()
        cur = conn.cursor()
        details = []
        try:
            query = "select * from teams"
            cur.execute(query)
            teamdetails = cur.fetchall()
            for team in teamdetails:
                names = []
                query = "select u.name from users u, user_teams ut where u.eid=ut.eid \
                and u.roleid='002' and ut.teamid=%s"
                cur.execute(query,(team[0],))
                results = cur.fetchall()
                # query = "select p.projectn from project p,user_teams u \
                # where u.projectid=p.projectid and u.teamid=%s"
                # cur.execute(query,(team[0],))
                # projectname = cur.fetchone()
                for var in results:
                    names.append(var[0])
                details.append([team,names])
            return render_template('teamdetails.html',details = details)
        finally:
            conn.close()

    #removes the required team from the database
    @classmethod
    def removeTeam(cls):
        if request.method == 'POST':
            conn = DataBaseManager.database_connection()
            cur = conn.cursor()
            try:
                teamname = request.form['teamname'].upper()
                query = "select teamid from teams where teamname = %s"
                cur.execute(query,(teamname,))
                teamid = cur.fetchone()
                if teamid == None:
                    return render_template('removeteam.html',message = "Team not found")
                query = "delete from user_teams where teamid=%s"
                cur.execute(query,(teamid,))
                query = "delete from teams where teamid=%s"
                cur.execute(query,(teamid,))
                conn.commit()
                return render_template('removeteam.html',message = "Team removed")
            finally:
                conn.close()
        return render_template('removeteam.html')
