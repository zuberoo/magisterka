import mysql.connector
import json
from flask import Flask
from time import time
from datetime import datetime

app = Flask(__name__)


@app.route('/widgets')
def get_widgets():
  try:
    mydb = mysql.connector.connect(
      host="mysql",
      user="mysql_bart",
      password="passwd",
      database="magisterka"
    )
  except:
    print("Next")
  cursor = mydb.cursor()


  cursor.execute("SELECT * FROM magisterka")

  row_headers=[x[0] for x in cursor.description] #this will extract row headers

  results = cursor.fetchall()
  json_data=[]
  for result in results:
    json_data.append(dict(zip(row_headers,result)))

  cursor.close()

  return json.dumps(json_data)

@app.route('/initdb')
def db_init():

  try:
    mydb = mysql.connector.connect(
      
      host="mysql",
      user="mgr",
      password="passwd",
      database="magisterka"
    )
  except:
    print("Next")
  cursor = mydb.cursor()

  

  cursor.execute("DROP TABLE IF EXISTS magisterka")

  cursor.execute("CREATE TABLE magisterka (id int NOT NULL AUTO_INCREMENT PRIMARY KEY ,name VARCHAR(255), description VARCHAR(255),z int)")
   
  d =0
  while d <= 25000:
    
    sql = "INSERT INTO magisterka ( name, description, z) VALUES ( %s, %s, %s)"
    val = ("Anna", "Gold",((c+1)*2)-1)
    cursor.execute(sql, val)
    d=d+1
  

  mydb.commit()
  cursor.close()

  return 'init database'

@app.route('/selectdb')
def db_select():
  try:
    mydb = mysql.connector.connect(
      
      host="mysql",
      user="mysql_bart",
      password="passwd",
      database="magisterka"
    )
  except:
    print("Next")
  cursor = mydb.cursor(buffered=True)

  c =1
  while c <= 25000:
    sql = """SELECT * FROM magisterka WHERE id >  %s AND id <(%s +1)*10 LIMIT 0, 1"""
    tuple1 = (c,c)
    cursor.execute(sql,tuple1)
    c=c+1
  
  cursor.close()

if __name__ == "__main__":
  app.run(host ='0.0.0.0')