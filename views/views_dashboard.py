import pymysql
from flask_restful import*
from flask import *
from functions import *
import pymysql.cursors

# import JWT Packages
from flask_jwt_extended import create_access_token, jwt_required, create_refresh_token

#Signup

class LabSignup(Resource):
    def post(self):
        json = request.json
        lab_name = json['lab_name']
        permit_id=json['permit_id']
        email = json['email']
        phone = json['phone']
        password = json['password']
        # Validate password
        response = passwordValidity(password)
        if response == True:
            if check_phone(phone):
                connection = pymysql.connect(host='localhost',
                                             user='root',
                                             password='',
                                             database='medilab')
                cursor = connection.cursor()
                # Insert data
                sql = '''Insert into laboratories(lab_name,permit_id,email,phone,password)values(%s, %s, %s, %s,%s)'''
                #provide data
                
                data = (lab_name,permit_id,email,encrypt(phone),hash_password(password))

                try:
                    cursor.execute(sql,data)
                    connection.commit()
                    #Send Sms/Email
                    code = gen_random(4)
                    send_sms(phone,'''Thank you for joining Medilab. Your secret NO: {}. Do not share.'''.format(code))
                    return jsonify({'message': 'Registered successfully'})
                except:
                    connection.rollback()
                    return jsonify({'message':'Registration failed'})
                
            else:
                return jsonify({'message': 'Invalid Phone +254'})

        else:
            return jsonify( response)
     
            

                
      
class LabSignin(Resource):
    def post(self):
        json = request.json
        email = json['email']
        password = json['password']

        sql = "select * from laboratories where email=%s"
        connection = pymysql.connect(host='localhost',
                                             user='root',
                                             password='',
                                             database='medilab')
        cursor = connection.cursor(pymysql.cursors.DictCursor)
        cursor.execute(sql, email)
        count = cursor.rowcount
        if count == 0:
            return jsonify({'message': 'Email does not exist'})
        else:
            lab = cursor.fetchone()
            hashed_password = lab['password']
            if hash_verify(password,hashed_password):

                access_token = create_access_token(identity=email, fresh=True)
                refresh_token = create_refresh_token(email)
                return jsonify({'message': lab,
                                        'access_token': access_token,
                                        'refresh__token': refresh_token})
            else:
                return jsonify({'message': 'Login Failed'})


class LabProfile(Resource):
    @jwt_required(refresh=True)
    def post(self):
        json = request.json
        lab_id = json['lab_id']
        sql = "select * from laboratories where lab_id = %s"
            

        connection = pymysql.connect(host='localhost',
                                             user='root',
                                             password='',
                                             database='medilab')
        cursor = connection.cursor(pymysql.cursors.DictCursor)
        cursor.execute(sql,lab_id)
        count = cursor.rowcount
        if count == 0:
            return jsonify({'message': 'Lab does not exist'})
        else:
            lab = cursor.fetchone()
            return jsonify(lab)
               
class AddLabtest(Resource):
    @jwt_required(refresh=True)
    def post(self):
        json = request.json
        lab_id = json['lab_id']
        test_name = json['test_name']
        test_description =json['test_description']
        test_cost = json['test_cost']        
        test_discount = json['test_discount']
        availability = json['availability']
        more_info = json['more_info']

        connection = pymysql.connect(host='localhost',
                                     user='root',
                                     password='',
                                     database='medilab')
        cursor = connection.cursor()

        sql = '''insert into lab_tests(lab_id,test_name,test_description,test_cost ,test_discount,availability, more_info)values(%s,%s,%s,%s,%s,%s,%s)'''
        data = (lab_id,test_name,test_description,test_cost ,test_discount,availability, more_info)

        
        try:
            cursor.execute(sql, data)
            connection.commit()
            return jsonify({'message': 'Test Added'})
        except:
            connection.rollback()
            return jsonify({'message': 'Failed. Try Again'})
        
class ViewLabtest(Resource):
    @jwt_required(refresh=True) #Refresh Token
    def post(self):
          json = request.json
          lab_id = json['lab_id']
          sql = "select * from lab_tests where lab_id = %s"
            

          connection = pymysql.connect(host='localhost',
                                             user='root',
                                             password='',
                                             database='medilab')
          cursor = connection.cursor(pymysql.cursors.DictCursor)
          cursor.execute(sql,lab_id)
          count = cursor.rowcount
          if count == 0:
               return jsonify({'message': 'Test does not exist'})
          else:
               tests = cursor.fetchall()
               return jsonify(tests)
                    
class ViewBooking(Resource):
        @jwt_required(refresh=True)
        def post(self):
            json = request.json
            lab_id = json['lab_id']
            sql = "select * from bookings where lab_id = %s"
            

            connection = pymysql.connect(host='localhost',
                                             user='root',
                                             password='',
                                             database='medilab')
            cursor = connection.cursor(pymysql.cursors.DictCursor)
            cursor.execute(sql,lab_id)
            count = cursor.rowcount
            if count == 0:
               return jsonify({'message': 'Booking does not exist'})
            else:
               bookings = cursor.fetchall()
               for booking in bookings:
                   member_id = ['member_id']
                   sql = '''select * from members where member_id =%s'''
                   cursor = connection.cursor(pymysql.cursors.DictCursor)
                   cursor.execute(sql, member_id)
                   member = cursor.fetchone()
                   booking['key'] = member
                   print(member)




            import json
            jsonStr = json.dumps(bookings, indent=1, sort_keys=True, default=str)
          # then convert json string to json oject
            return json.loads(jsonStr)
          
                    

class AddNurses(Resource):
    @jwt_required(refresh=True)
    def post(self):
        json = request.json
        surname = json['surname']
        others = json['others']
        lab_id =json['lab_id']
        gender = json['gender'] 
        email= json['email']
        phone = json['phone']       
        password = gen_random(5)

    
        connection = pymysql.connect(host='localhost',
                                        user='root',
                                        password='',
                                        database='medilab')
        cursor = connection.cursor()
        # Insert Data
        sql = '''insert into Nurses(surname, others,lab_id, gender, email, phone, 
            password)values(%s, %s, %s, %s, %s, %s, %s) '''
        # Provide Data
        
        data = (surname, others,lab_id, gender,email, encrypt(phone), 
                hash_password(password))
        try:
            cursor.execute(sql, data)
            connection.commit()
            #Send Sms/Email
            code = gen_random(4)
            send_sms(phone,'''Thank you for joining Medilab. Your OTP is: {}. Username.{}.'''.format(password, surname))
            return jsonify({'message': 'Succesfully registered'})
        except:
            connection.rollback()
            return jsonify({'message': 'Failed.Try Again'})
    
class ViewNurses(Resource):
    @jwt_required(refresh=True)
    def post(self):
            json = request.json
            lab_id = json['lab_id']
            sql = "select * from Nurses where lab_id = %s"
            

            connection = pymysql.connect(host='localhost',
                                             user='root',
                                             password='',
                                             database='medilab')
            cursor = connection.cursor(pymysql.cursors.DictCursor)
            cursor.execute(sql,lab_id)
            count = cursor.rowcount
            if count == 0:
               return jsonify({'message': 'Nurse does not exist'})
            else:
               nurse = cursor.fetchall()
            import json
            jsonStr = json.dumps(nurse, indent=1, sort_keys=True, default=str)
          # then convert json string to json oject
            return json.loads(jsonStr)
                    
class TaskAllocation(Resource):
    def post(self):
        json = request.json
        nurse_id = json['nurse_id']
        invoice_no = json['invoice_no']
        
        #Check if above invoice is active

        sql = '''select * from lab_test_allocations where invoice_no=%s'''
        connection = pymysql.connect(host='localhost',user='root'
                                     ,password='',database='medilab')
        cursor = connection.cursor(pymysql.cursors.DictCursor)
        cursor.execute(sql,(invoice_no))
        count = cursor.rowcount
        # if it's found active, find the nurse allocated
        if count == 0:
            # Inoice does not exist in that table
            sql3 = '''insert into lab_test_allocation(nurse_id,invoice_no)values(%s,%s)'''
            cursor3 = connection.cursor()
            data = (nurse_id, invoice_no)
            cursor3.execute(sql3, data)
            connection.commit()

            #Could we send an sms to the nurse?
            #Yes, query using nurse id to get the phone and decrypt it
            #send text
            #se android push notificatioins - Firebase

            return jsonify({'message':'Allocation successful'})
        else:
            # it's found, what is the flag holding
            task = cursor.fetchone()
            flag = task['flag']

            if flag == 'active':
                # task = cursor.fetchone()
                #Below id belongs to the nurse allocated
                current_nurse_id = task['nurse_id']
                # Query nurse table and get the nurse's details.
                sql2 = '''select * from Nurses where nurse_id=%s'''
                cursor2 = connection.cursor(pymysql.cursors.DictCursor)
                cursor2.execute(sql2, (current_nurse_id))
                # get nurse details
                nurse = cursor2.fetchone()
                surname = nurse['surname']
                others = nurse['others']
                message = '''Failed. Invoice No:{} Already Allocated
                to {} {}'''. format(invoice_no, surname, others)
                return jsonify({'message': message})
            elif flag == 'completed':
                return jsonify({'message': 'This task is marked as complete'})
            
            elif flag == 'inactive':
                #can we activate it
                return jsonify({'message':'This is marked as inactive'})
            

               


       