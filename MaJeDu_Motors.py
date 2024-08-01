from errno import errorcode
import mysql.connector
from mysql.connector import Error

def connect_to_db():
    try:
        cnx = mysql.connector.connect(
            user='root',
            password='admin',
            host='127.0.0.1',
            database='majedu_motors'
        )
        return cnx
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Usuário ou senha inválidos")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Banco de dados não encontrado")
        else:
            print(err)
        return None

def execute_query(query, params=None):
    cnx = connect_to_db()
    if cnx is None:
        return
    cursor = cnx.cursor()
    try:
        cursor.execute(query, params)
        cnx.commit()
        return cursor
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()
        cnx.close()

#Criação de um carro no banco de dados
def add_car(placa_carro, modelo, cor, ano, marca, valor_diaria):
    query = ("INSERT INTO Carro (Placa_carro, Modelo, Cor, Ano, Marca, Valor_diaria) "
             "VALUES (%s, %s, %s, %s, %s, %s)")
    params = (placa_carro, modelo, cor, ano, marca, valor_diaria)
    execute_query(query, params)

def execute_select(query, params=None):
    cnx = connect_to_db()
    if cnx is None:
        return
    cursor = cnx.cursor()
    try:
        cursor.execute(query, params)
        results = cursor.fetchall()
        return results
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()
        cnx.close()

# Listar todos os carros
def list_all_cars():
    query = "SELECT * FROM Carro"
    cars = execute_select(query)
    if cars:
        for car in cars:
            placa_carro, modelo, cor, ano, marca, valor_diaria = car
            print(f"Placa: {placa_carro}, Modelo: {modelo}, Cor: {cor}, Ano: {ano}, Marca: {marca}, Valor Diária: {valor_diaria}")
def main():
    while True:
        print("1. Adicionar Carro")
        print("2. Adicionar Cliente")
        print("3. Adicionar Oficina")
        print("4. Adicionar Vistoria")
        print("5. Novo Emprestimo")
        print("6. Nova Devolução")
        print("7. Listar Carros Disponíveis")
        print("8. Listar Todos os Carros")
        print("9. Listar Usuários")
        print("10. Listar Empréstimos, seus valores totais, e os valores das multas associadas a eles")
        # Adicionar mais opções aqui...
        print("0. Sair")
        choice = input("Selecione uma opção: ")

        if choice == '1': #Criar carro
            placa_carro = input("Digite a placa do carro: ")
            modelo = input("Digite o modelo: ")
            cor = input("Digite a cor: ")
            ano = input("Digite o ano: ")
            marca = input("Digite a marca: ")
            valor_diaria = input("Digite o valor da diária: ")
            add_car(placa_carro, modelo, cor, ano, marca, valor_diaria)
        elif choice == '2': #Criar cliente
            pass
        elif choice == '3': #Criar oficina
            pass
        elif choice == '4': #Criar vistoria
            pass
        elif choice == '5': #Novo empréstimo
            pass
        elif choice == '6': #Nova Devolução
            pass
        elif choice == '7': #Listar Carros Disponíveis
            pass
        elif choice == '8': #Listar Todos os Carros
            list_all_cars()
        elif choice == '9': #Listar Usuários
            pass
        elif choice == '10': #Listar Empréstimos, seus valores totais, e os valores das multas associadas a eles
            pass
        elif choice == '0': #Sair
            break
        else:
            print("Escolha inválida!")

if __name__ == "__main__":
    main()