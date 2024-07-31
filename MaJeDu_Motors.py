import mysql.connector
from mysql.connector import Error

try:
    
    connection = mysql.connector.connect(
        host ='localhost',
        database = 'majedu_motors',
        user = 'root',
        password = 'admin'
    )
    
    if connection.is_connected():
        db_info = connection.get_server_info()
        print(f"Connectado ao Servidor MySQL versão {db_info}")
        cursor = connection.cursor()
        cursor.execute("SELECT DATABASE();")
        record = cursor.fetchone()
        print(f"Você está conectado ao banco de dados: {record}")
        
except Error as e:
    print(f"Erro ao conectar ao MySQL: {e}")
    
finally:
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("Conexão ao MySQL foi encerrada")