# performs login and signup funtions
from flask import Flask, render_template, request, redirect, session, url_for
import psycopg2
from Models.user import User
from Services.database_manager import DataBaseManager
from passlib.hash import sha256_crypt

class LoginSignup():

    # loads the home page of the project
    # if user is already logged in, the same session is continued
    @classmethod
    def loadHome(cls):
        user = session.get ( 'userdatalist', None )
        if user:
            if user[5] == '002':
                return redirect ( url_for ( 'loadAssociateHome' ) )
            if user[5] == '001':
                return redirect ( url_for ( 'loadManagerHome' ) )
            if user[5] == '003':
                return redirect ( url_for ('loadAdminHome'))
        return render_template ( 'landing.html' )

    # for checking the existing user using entered inputs
    @classmethod
    def checkUser (cls):
        if request.method == "POST":
            email = request.form [ 'emailaddress' ].upper()
            password = request.form [ 'password' ]
            conn = DataBaseManager.database_connection()
            cur = conn.cursor()
            try:
                query = "SELECT * FROM users WHERE email=%s"
                cur.execute ( query, ( email, ))
                row = cur.fetchone()
                if row:
                    if(sha256_crypt.verify(password, row[3])):
                        user =  User(*row)
                        if user.roleid == "002":
                            session ['userdatalist'] = user.getData()
                            return redirect(url_for ( 'loadAssociateHome' ) )
                        if user.roleid == "003":
                            session ['userdatalist'] = user.getData()
                            return redirect(url_for ( 'loadAdminHome' ) )
                        if user.roleid == "001":
                            session [ 'userdatalist' ] = user.getData()
                            return redirect(url_for ( 'loadManagerHome' ) )
                    else:
                        return  render_template ( 'login.html', message = "Wrong email or password")
                else:
                    return  render_template ( 'login.html', message = "Wrong email or password")
            finally:
                conn.close()
        else:
            return render_template ( 'login.html' )

    # to check if the user is already registered
    # @classmethod
    # def checkUserRegister ( cls, email ):
    #     conn = DataBaseManager.database_connection()
    #     cur = conn.cursor()
    #     try:
    #         query = "SELECT * FROM users WHERE email=%s"
    #         cur.execute ( query, (email,) )
    #         row = cur.fetchone()
    #         if row:
    #             return User ( *row )
    #         else:
    #             return None
    #     finally:
    #         conn.close()

    # to register the new user and update database
    # @classmethod
    # def registerUser(cls,app):
    #     if request.method == "POST":
    #         userlis = []
    #         emailid = []
    #         userlis.append ( request.form [ 'emp_id' ] )
    #         userlis.append ( request.form [ 'name' ] )
    #         emailid.append(request.form [ 'emailaddress' ])
    #         userlis.append (emailid[0])
    #         password = request.form['password']
    #         userlis.append ( sha256_crypt.hash ( password ) )
    #         userlis.append (request.form ['phno' ] )
    #         role = request.form['role']
    #         if role == 'Please select one' :
    #             return render_template('signup.html',message='Please select role')
    #         userlis.append (request.form ['role' ] )
    #         print(userlis)
    #         conn = DataBaseManager.database_connection()
    #         cur = conn.cursor()
    #         try:
    #             exists = cls.checkUserRegister ( userlis[2] )
    #             if exists:
    #                 return render_template ( 'login.html', message = "User Already Exists")
    #             else:
    #                 query = "insert into users (eid,name,email,password,\
    #                 phno,roleid) values(%s,%s,%s,%s,%s,%s)"
    #                 cur.execute ( query, userlis )
    #                 conn.commit()
    #                 mail = Mail(app)
    #                 msg = Message('Hello', sender = 'manager.assist.sg@gmail.com',
    #                 recipients = emailid)
    #                 msg.body = "Welcome to Manager Assist, You are successfully registered!!!"
    #                 mail.send(msg)
    #                 return render_template ( 'login.html', message="Registered Successfully")
    #         except Exception:
    #             return render_template('login.html',message="User already exists")
    #         finally:
    #             conn.close()
    #     else:
    #         return render_template ( 'signup.html' )

    @classmethod
    def logout(cls):
        session.pop ( 'userdatalist', None )
        return redirect ( url_for ( 'loadLandingPage' ) )
