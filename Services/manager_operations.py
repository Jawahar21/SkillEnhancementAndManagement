# to perform Manager operations
from flask import Flask, render_template, request, redirect, session, url_for
import psycopg2,datetime
from Services.database_manager import DataBaseManager
from Services.associate_services import Associate
import time,json

class Manager:

    # loads the home page of the manager
    @classmethod
    def getHome(cls):
        user = session.get ( 'userdatalist', None )
        return render_template ( 'manager.html', name = user[1] )

    # retrieves newly added skill by the associate from the database
    @classmethod
    def getNotifications ( cls ):
        conn = DataBaseManager.database_connection()
        cur = conn.cursor()
        try:
            user = session.get ( 'userdatalist', None )
            query = "select teamid from teams where team_manager=%s"
            cur.execute(query,(user[1],))
            teamid = cur.fetchone()
            query = "select u.eid,u.name,s.skillname from skills s,users u,\
            associate_skills a,user_teams t where a.skillid=s.skillid and a.eid=u.eid \
            and a.reviewed='no' and u.eid = t.eid and t.teamid=%s "
            cur.execute ( query,(teamid,) )
            notifications = cur.fetchall()
            notifications.reverse()
            if notifications:
                return render_template ( 'notifications.html', notifications = notifications )
            else :
                return render_template ( 'notifications.html', message = "No notifications" )
        finally:
            conn.close()

    # retrieves user detials from database by giving name as input
    @classmethod
    def getUserByName ( cls ):
        if request.method == "POST":
            conn = DataBaseManager.database_connection()
            cur = conn.cursor()
            try:
                param = request.form [ 'param' ]
                detailsbyid = Associate.getProfile ( param )
                if detailsbyid:
                    return detailsbyid
                else:
                    name = param
                    query = "select u.eid,u.name,u.email,u.phno,\
                    r.rolename from users u,roles r where r.roleid=u.roleid and u.name=%s"
                    cur.execute ( query, ( name,))
                    personaldetails = cur.fetchone()
                    if personaldetails:
                        eid = personaldetails [0]
                    else:
                        return render_template ( 'employeedetailspage.html',\
                        message = "Employee not found" )
                    query = "select s.skillname,p.plevel,a.result from skills s,associate_skills a,\
                    proficiency p where a.skillid=s.skillid and p.pid=a.pid and a.eid=%s"
                    cur.execute ( query, ( eid, ))
                    skills=cur.fetchall()
                    newlist = []
                    for touple in skills:
                        newlist.append ( touple [0] )
                    query = "select t.teamname,c.cname from teams t,\
                    competency c, user_teams ut where ut.teamid=t.teamid and \
                    ut.cid=c.cid and ut.eid=%s"
                    cur.execute ( query, ( eid, ))
                    teamdetails = cur.fetchone()
                    query = "select at.eid,s.skillname,td.testname,td.testdate,at.score,\
                    p.plevel,at.result from test_details td, associate_test_details at,\
                    proficiency p, skills s where at.skillid=s.skillid and at.pid=p.pid \
                    and td.testid=at.testid and at.eid=%s and at.status='taken'"
                    cur.execute ( query, ( eid, ) )
                    testdetails = cur.fetchall()
                    testdetails.reverse()
                    profiledetails = []
                    if personaldetails:
                        profiledetails.append ( personaldetails )
                    else :
                        return render_template ( 'employeedetailspage.html',\
                        message = "Employee not found" )
                    if skills:
                        profiledetails.append ( newlist )
                    else :
                        profiledetails.append ( None )
                    if teamdetails:
                        profiledetails.append ( teamdetails )
                    else :
                        profiledetails.append ( None )
                    if testdetails:
                        profiledetails.append ( testdetails )
                    else :
                        profiledetails.append ( None )
                    return render_template ( 'profilepage.html', details =profiledetails )
            finally:
                conn.close()
        return render_template ( 'employeedetailspage.html' )

    #loads all the associates details at a glance
    @classmethod
    def allAssociatesList(cls):
        conn = DataBaseManager.database_connection()
        cur = conn.cursor()
        details = []
        try:
            user = session.get ( 'userdatalist', None )
            if user[5] == '003':
                query = "select u.eid,u.name,r.rolename from users u ,roles r where \
                r.roleid=u.roleid and r.roleid!='003'"
                cur.execute(query)
                user_details = cur.fetchall()
                for user in user_details:
                    query = "select s.skillname,p.plevel,a.result from skills s,associate_skills a,\
                    proficiency p where a.skillid=s.skillid and p.pid=a.pid and a.eid=%s"
                    cur.execute(query,(user[0],))
                    skills = cur.fetchall()
                    details.append([user,skills])
                return render_template('allassociates.html',details=details)
            else :
                query = "select teamid from teams where team_manager=%s"
                cur.execute(query,(user[1],))
                teamid = cur.fetchone()
                query = "select u.eid,u.name,r.rolename from users u ,roles r,user_teams t where \
                r.roleid=u.roleid and r.roleid='002' and t.eid=u.eid and t.teamid=%s"
                cur.execute(query,(teamid,))
                user_details = cur.fetchall()
                for user in user_details:
                    query = "select s.skillname,p.plevel,a.result from skills s,associate_skills a,\
                    proficiency p where a.skillid=s.skillid and p.pid=a.pid and a.eid=%s"
                    cur.execute(query,(user[0],))
                    skills = cur.fetchall()
                    details.append([user,skills])
                return render_template('allassociates.html',details=details)
        finally:
            conn.close()

    # inserts and updates test details in database
    @classmethod
    def createTest ( cls ):
        if request.method == "POST":
            conn = DataBaseManager.database_connection()
            cur = conn.cursor()
            try:
                if request.get_json() is None :
                    user_details = request.form['skillid']
                    user_details = user_details.split()
                    eid = user_details[0]
                    skillname = user_details[1]
                    params ={ "status": "Notification" }
                else :
                    params = request.get_json()
                    eid = params['eid']
                    if(eid == ''):
                        return "Employee ID Required"
                    skillname = params['skillname']
                    if(skillname == "please select an option"):
                        return "Input Skill required"
                testname = skillname+str(time.time())
                dateobj = datetime.datetime.now()
                date = str ( dateobj.year ) + "-" + str ( dateobj.month ) + "-" + str ( dateobj.day )
                details = []
                testdetails = []
                details.append ( testname )
                details.append ( date )
                query = "select a.eid from associate_test_details a,skills s \
                where a.eid=%s and s.skillname=%s and s.skillid=a.skillid and a.status='pending'"
                cur.execute(query,[eid,skillname])
                exists = cur.fetchone()
                if exists :
                    return "Test already generated for this skill"
                query = "insert into test_details (testname,testdate) \
                values(%s,%s) RETURNING testid"
                cur.execute ( query, details )
                testid = cur.fetchone()
                query = "select skillid from skills where skillname=%s"
                cur.execute(query,(skillname,))
                skillid = cur.fetchone()
                testdetails.append ( eid )
                testdetails.append ( testid )
                testdetails.append ( skillid )
                testdetails.append ( 'pending' )
                testdetails.append (0)
                query = "insert into associate_test_details \
                (eid,testid,skillid,status,pid) values(%s,%s,%s,%s,%s)"
                cur.execute ( query, testdetails )
                query = "update associate_skills set reviewed='yes' where skillid=%s"
                cur.execute ( query, ( skillid,))
                query = "select u.eid,u.name,s.skillname from skills s,users u,\
                associate_skills a where a.skillid=s.skillid and a.eid=u.eid \
                and a.reviewed='no' "
                cur.execute ( query )
                notifications = cur.fetchall()
                notifications.reverse()
                conn.commit()
                if params['status'] == 'conducttest':
                    return "Test reference Created"
                else :
                    message = "Test reference Created"
                    return render_template('notifications.html',notifications=notifications,message =json.dumps(message))
            except Exception:
                return "Error: Please check Employee ID and skill Name again."
            finally:
                conn.close()
        conn = DataBaseManager.database_connection()
        cur = conn.cursor()
        query = "select skillname from skills"
        cur.execute(query)
        skills = cur.fetchall()
        conn.close()
        return render_template ( 'conducttest.html',skills=skills )
