# Model for user-details
class User:

    def __init__ ( self, eid, name, email, password, phno, roleid ):
        self.eid = eid
        self.name = name
        self.email = email
        self.password = password
        self.phno = phno
        self.roleid = roleid

    def getData(self):
        return [ self.eid, self.name, self.email, self.password, self.phno, self.roleid ]
