# Operations perfomed by associate
from flask import Flask, render_template, request, redirect, session, url_for, jsonify, make_response
import psycopg2,random,datetime,json
from Services.database_manager import DataBaseManager
import pdfkit
from flask_wkhtmltopdf import Wkhtmltopdf

class Associate:

    #loads the home page of the associate
    @classmethod
    def getHome(cls):
        user = session.get ( 'userdatalist', None )
        return render_template ( 'associate.html', name = user[1] )

    # retrieves entire profile details from the database for the users
    @classmethod
    def getProfile (cls, eid):
        conn = DataBaseManager.database_connection()
        cur = conn.cursor()
        try:
            query = "select u.eid, u.name, u.email, \
            u.phno, r.rolename from users u, roles r \
            where r.roleid = u.roleid and u.eid = %s"
            cur.execute ( query, ( eid, ) )
            personaldetails = cur.fetchone()
            query = "select s.skillname,p.plevel,a.result from skills s,associate_skills a,\
            proficiency p where a.skillid=s.skillid and p.pid=a.pid and a.eid=%s"
            cur.execute ( query, ( eid, ) )
            skills = cur.fetchall()
            newlist = []
            for touple in skills:
                newlist.append(touple[0])
            query = "select t.teamname,c.cname \
            from teams t,competency c, user_teams ut where \
            ut.teamid=t.teamid \
            and ut.cid=c.cid and ut.eid=%s"
            cur.execute ( query, ( eid, ) )
            teamdetails = cur.fetchone()
            query = "select at.eid,s.skillname,td.testname,td.testdate,at.score,\
            p.plevel,at.result from test_details td, associate_test_details at,\
            proficiency p, skills s where at.skillid=s.skillid and at.pid=p.pid \
            and td.testid=at.testid and at.eid=%s and at.status='taken'"
            cur.execute ( query, (eid, ) )
            testdetails = cur.fetchall()
            testdetails.reverse()
            profiledetails = []
            if personaldetails:
                profiledetails.append ( personaldetails )
            else :
                return None
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
            return render_template ( 'profilepage.html', details = profiledetails )
        finally:
            conn.close()

    # inserts skill details in the database
    @classmethod
    def addSkill ( cls ):
        if request.method == "POST":
            conn = DataBaseManager.database_connection()
            cur = conn.cursor()
            try:
                user = session.get ( 'userdatalist', None )
                eid = user[0]
                if request.get_json() is None:
                    cid = request.form['competency']
                    if cid == "please select an option":
                        return render_template('addskillpage.html',message="Please select Competency")
                    skillname = request.form['skillsdrop']
                    if skillname == "Please select a skill":
                        return render_template('addskillpage.html',message="Please select Skills")
                    if skillname == 'other':
                        skillname = request.form [ 'otherskill' ]
                        skillname = skillname.upper()
                        query = 'insert into skills (skillname,cid) values(%s,%s)'
                        cur.execute(query,(skillname,cid))
                else:
                    details = request.get_json()
                    if details['status'] == 'skills' :
                        if details['cid'] == "please select an option":
                            return render_template('addskillpage.html',message="Please select Competency")
                        query = "select skillname from skills where cid=%s"
                        cur.execute(query,(details['cid']))
                        skills = cur.fetchall()
                        newlist = []
                        for touple in skills:
                            newlist.append(touple[0])
                        skills = jsonify({"skills":newlist})
                        return skills
                query = "select skillid from skills where skillname=%s"
                cur.execute(query,(skillname,))
                skillid = cur.fetchone()
                query = "insert into associate_skills (eid,skillid,reviewed,pid) values (%s,%s,%s,%s)"
                cur.execute ( query, [ eid, skillid, 'no',0 ] )
                conn.commit()
                return render_template ( 'addskillpage.html', message = "Skill added" )
            except Exception:
                return render_template ( 'addskillpage.html', message = "Skill already exists")
            finally:
                conn.close()
        return render_template ( 'addskillpage.html' )

    # retrieves past test details of the associate from database
    @classmethod
    def testHistory ( cls ):
        conn = DataBaseManager.database_connection()
        cur = conn.cursor()
        try:
            if request.method == 'POST' :
                eid = request.form['testhistory']
            else :
                user = session.get ( 'userdatalist', None )
                eid = user[0]
            query = "select at.eid,s.skillname,td.testname,td.testdate,\
            at.score,p.plevel,at.result from test_details td,\
            associate_test_details at,proficiency p,skills s where at.eid=%s \
            and at.status='taken' and at.skillid=s.skillid and td.testid=at.testid and p.pid=at.pid"
            cur.execute ( query,(eid,))
            result = cur.fetchall()
            if result:
                result.reverse()
                return render_template ( 'testhistorypage.html', testdetails = result )
            return render_template ( 'testhistorypage.html', message = "No tests taken so far" )
        finally:
            conn.close()

    # retrieves skill details of the associate from database
    @classmethod
    def getSkills ( cls ):
        conn = DataBaseManager.database_connection()
        cur = conn.cursor()
        try:
            if request.method == 'POST' :
                eid = request.form['getskills']
            # else :
            #     user = session.get ( 'userdatalist', None )
            #     eid = user[0]
            query = "select s.skillname,p.plevel,a.result from skills s,associate_skills a,\
            proficiency p where a.skillid=s.skillid and p.pid=a.pid and a.eid=%s"
            cur.execute ( query, ( eid, ) )
            skills = cur.fetchall()
            if skills:
                skills.reverse()
                return render_template ( 'viewskills.html', skills = skills )
            return render_template ( 'viewskills.html', message = "No Skills Added Yet" )
        finally:
            conn.close()

    # retrives test details of associated skill from database
    @classmethod
    def takeTest ( cls,eid ):
        conn = DataBaseManager.database_connection()
        cur = conn.cursor()
        try:
            query = "select s.skillname,td.testname,td.testdate from test_details td,\
            skills s,associate_test_details at where at.eid=%s and at.status='pending' \
            and at.testid=td.testid and at.skillid=s.skillid"
            cur.execute ( query, ( eid,))
            result = cur.fetchall()
            if result:
                result.reverse()
                return result
            return None
        finally:
            conn.close()

    @classmethod
    def getCertificate(cls,app):
        try:
            conn = DataBaseManager.database_connection()
            cur = conn.cursor()
            certificate = request.form['certificate']
            certificate = certificate.split()
            query = "select testid,testdate from test_details where testname=%s"
            cur.execute(query,(certificate[1],))
            test_details = cur.fetchone()
            query = "select u.name,s.skillname,a.pid,a.score,a.result from users u \
            ,associate_test_details a,skills s where u.eid=a.eid and s.skillid=a.skillid\
            and a.eid=%s and a.testid=%s"
            cur.execute(query,(certificate[0],test_details[0]))
            test_results = cur.fetchone()
            rendered = render_template('certificate.html',name=test_results[0],\
            skill=test_results[1],score=test_results[3],date=test_details[1])
            pdf = pdfkit.from_string(rendered, False)
            response = make_response(pdf)
            response.headers['Content-Type'] = 'application/pdf'
            response.headers['Content-Disposition'] = 'download; filename = certificate.pdf'
            return response
            print(certificate)
        finally:
            conn.close()
    # retrieves question paper details from database
    @classmethod
    def getQuestions ( cls ):
        user = session.get ( 'userdatalist', None)
        if request.method == "POST":
            conn = DataBaseManager.database_connection()
            cur = conn.cursor()
            questions = []
            answers = []
            try:
                testname = request.form [ 'testname' ]
                query = "select testid from test_details where testname = %s"
                cur.execute(query,(testname,))
                testid = cur.fetchone()
                query = "update associate_test_details set \
                status=%s where testid=%s"
                cur.execute ( query, ('taken',testid) )
                query = "select skillid from associate_test_details where testid = %s"
                cur.execute(query,(testid,))
                skillid = cur.fetchone()
                query = "select count(skillid) from question_bank where skillid = %s"
                cur.execute(query,(skillid,))
                count = cur.fetchone()
                if( count[0] == 0):
                    return "No questions found for current skill"
                questionslist = random.sample ( range(1, count[0]+1), 20)
                query = "select testid from test_details where testname=%s"
                cur.execute ( query, ( testname,))
                testid = cur.fetchone()
                query = "select skillid from associate_test_details where testid=%s"
                cur.execute ( query, ( testid,))
                skillid = cur.fetchone()
                for l in questionslist:
                    query = "select * from question_bank where qno=%s and skillid=%s"
                    cur.execute ( query, ( l, skillid ))
                    question = cur.fetchone()
                    if question:
                        question = list ( question )
                    else :
                        return "No questions found for current skill"
                    question [1] = question [1].replace("\n","<br/>")
                    question [2] = question [2].replace("\n","<br/>")
                    question [3] = question [3].replace("\n","<br/>")
                    question [4] = question [4].replace("\n","<br/>")
                    question [5] = question [5].replace("\n","<br/>")
                    question [6] = question [6].replace("\n","<br/>")
                    questions.append ( question )
                    answers.append ( question [6] )
                paper = [ questions,answers ]
                conn.commit()
                if paper:
                    session [ 'answers' ] = paper[1]
                    return render_template ( \
                    'questionpaper.html', \
                    questions = paper[0],\
                    testname = json.dumps ( testname ),\
                    )

            finally:
                conn.close()
        testdetails = Associate.takeTest (user[0])
        if testdetails:
            return render_template ( "taketest.html", testdetails = testdetails )
        else:
            return render_template ( "taketest.html", message = "No tests added" )

    # updates score and result of the conducted test in database
    @classmethod
    def gettestresults ( cls ):
        user = session.get ( 'userdatalist', None )
        test_details = request.get_json()
        useranswers = test_details['useranswers']
        answers = session.get ( 'answers', None )
        session.pop('answers', None)
        testname = test_details['testname']
        score = 0
        i = 0
        conn = DataBaseManager.database_connection()
        cur = conn.cursor()
        try:
            for ans in useranswers:
                if( ans == answers[i] ):
                    score = score + 1
                i = i + 1
            dateobj = datetime.datetime.now()
            date = str ( dateobj.year) + "-" + str ( dateobj. month) + "-" + str ( dateobj.day )
            query = "select testid from test_details where testname=%s"
            cur.execute ( query, ( testname,))
            test_id = cur.fetchone()
            query = "update test_details set testdate=%s where testid=%s"
            cur.execute(query,(date,test_id))
            if(score >= 10) : result = "Certified"
            else : result = "Not Certified"
            if(score >= 18 ): pid = 5
            if(score < 18 and score >=15) : pid = 4
            if(score < 15 and score >=12) : pid = 3
            if(score < 12 and score >=10) : pid = 2
            if(score < 10) : pid = 1
            status = 'taken'
            query = "update associate_test_details set score=%s,result=%s\
            ,pid=%s,status=%s where testid=%s returning skillid"
            cur.execute ( query, ( score, result, pid, status, test_id[0] ) )
            skillid = cur.fetchone()
            query = 'select pid,result from associate_skills where skillid=%s and eid=%s'
            cur.execute(query,(skillid,user[0]))
            pre_pid = cur.fetchone()
            if pre_pid[0] == 0:
                query = 'update associate_skills set pid=%s where skillid=%s and eid=%s'
                cur.execute(query,(pid,skillid[0],user[0]))
            elif pre_pid[0] < pid :
                query = 'update associate_skills set pid=%s where skillid=%s and eid=%s'
                cur.execute(query,(pid,skillid[0],user[0]))
            if pre_pid[1] == None:
                query = "update associate_skills set result=%s where skillid=%s and eid=%s"
                cur.execute(query,(result,skillid[0],user[0]))
            elif result == 'Certified' :
                query = "update associate_skills set result=%s where skillid=%s and eid=%s"
                cur.execute(query,(result,skillid[0],user[0]))
            conn.commit()
            return "Test submitted succesfully"
        finally:
            conn.close()
