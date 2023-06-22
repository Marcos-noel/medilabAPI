import pymysql
from flask_restful import*
from flask import *
from functions import *
import pymysql.cursors

# import JWT Packages
from flask_jwt_extended import create_access_token, jwt_required, create_refresh_token

class NurseLogin(Resource):
    def post(self):
        json = request.json
        surname = json['surname']
        password = json['password']

        sql = '''select * from Nurses where surname=%s'''
        connection = pymysql.connect(host='localhost',
                                             user='root',
                                             password='',
                                             database='medilab')
        cursor = connection.cursor(pymysql.cursors.DictCursor)
        cursor.execute(sql, surname)
        count = cursor.rowcount
        if count == 0:
            return jsonify({'message': 'surname does not exist'})
        else:
            nurse = cursor.fetchone()
            hashed_password = nurse['password']
            if hash_verify(password,hashed_password):

                access_token = create_access_token(identity=surname, fresh=True)
                refresh_token = create_refresh_token(surname)
                return jsonify({'message': nurse,
                                        'access_token': access_token,
                                        'refresh__token': refresh_token})
            else:
                return jsonify({'message': 'Login Failed'})

class NurseAllocation(Resource):
    @jwt_required(refresh=True)
    def post(self):
        json = request.json
        nurse_id = json['nurse_id']
        flag = json['flag']
        sql = "select * from lab_test_allocations where nurse_id = %s and flag = %s"
            

        connection = pymysql.connect(host='localhost',
                                             user='root',
                                             password='',
                                             database='medilab')
        cursor = connection.cursor(pymysql.cursors.DictCursor)
        cursor.execute(sql,(nurse_id, flag))
        count = cursor.rowcount
        if count == 0:
            message = "No {} Assignments".format(flag)
            return jsonify({'message': message})
        else:
            data = cursor.fetchall()
            return jsonify(data)

class ViewInvoiceDetails(Resource):
    @jwt_required(refresh=True)
    def post(self):
        json = request.json
        invoice_no = json['invoice_no']
     
        sql = "select * from bookings where invoice_no = %s"
            

        connection = pymysql.connect(host='localhost',
                                             user='root',
                                             password='',
                                             database='medilab')
        cursor = connection.cursor(pymysql.cursors.DictCursor)
        cursor.execute(sql,invoice_no)
        count = cursor.rowcount
        if count == 0:
            message = "Invoice No {} Assignments".format(invoice_no)
            return jsonify({'message': message})
        else:
            bookings = cursor.fetchall()
        import json
        jsonStr = json.dumps(bookings, indent=1, sort_keys=True, default=str)
          # then convert json string to json oject
        return json.loads(jsonStr)
                    
class ChangePass(Resource):
    def put(self):
        json = request.json
        nurse_id = json['nurse_id']
        current_password = json['current_password']
        new_password = json['new_password']
        confirm_password = json['confirm_password']

 # select using the nurse_id, if nurse does not exist, give a jsonify message
        sql = '''select * from Nurses where nurse_id =%s'''

        connection = pymysql.connect(host='localhost',
                                      user='root',
                                      password='',
                                      database='medilab')
        
     
        cursor = connection.cursor(pymysql.cursors.DictCursor)
        cursor.execute(sql,nurse_id)
        count = cursor.rowcount
        if count == 0:
                return jsonify({'message': 'User does not exist'})
        else:
                #user exists
                member = cursor.fetchone()
                hashed_password = member['password'] # this password is hashed
                # if nurse exists get the hashed password
                # verify if current password and hashed password are ok
                # Jane proided a plain password
                if hash_verify(current_password,hashed_password):
                    if new_password != confirm_password:
                        return jsonify({'message': 'Password Do Not Match'})
                    else:
                        sql = '''update Nurses Set password =%s where nurse_id=%s'''
                        cursor = connection.cursor()
                        data = (hash_password(new_password),nurse_id)
                        try:
                            cursor.execute(sql,data)
                            connection.commit()
                            return jsonify({'message':'Password Changed'})
                        except:connection.rollback()
                        connection.commit()
                        return jsonify({'message':'Error in changing the password'})
                else:
                    return jsonify({'message':'current password is wrong'})

            
                

              
                    
                

       
        
        
        # Verify if current password is ok for the nurse_id.
        # if current password is verified false , give message - current is wrong
        # if verified True , then confirm  that new password and confirm_password are same
        # if they are not same, send a message
        # if they are same then, hash new_password and update query under the nurse_id, update password using the nurse_id
        # give a message password updated
        # Go login with the new password

