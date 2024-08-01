from errno import errorcode
import mysql.connector
from mysql.connector import Error

def connect_to_db():
    try:
        cnx = mysql.connector.connect(
            user='root',
            password='admin',
            host='localhost',
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

#Criação de um carro no banco de dados 1
def add_car(placa_carro, modelo, cor, ano, marca, valor_diaria):
    query = ("INSERT INTO Carro (Placa_carro, Modelo, Cor, Ano, Marca, Valor_diaria) "
             "VALUES (%s, %s, %s, %s, %s, %s)")
    params = (placa_carro, modelo, cor, ano, marca, valor_diaria)
    execute_query(query, params)

#Criação de um cliente no banco de dados 2
def add_cliente(cpf, Nome, Cnh, Rua, Numero_casa, Complemento, Cep, Telefone, Email):
    query = ("INSERT INTO Clientes(Cpf, Nome, Cnh, Rua, Numero_casa, Complemento, Cep, Telefone, Email)"
             "VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s)")
    params = (cpf, Nome, Cnh, Rua, Numero_casa, Complemento, Cep, Telefone, Email)
    execute_query(query,params)

#Criação de uma oficina no banco de dados 3
def add_ofi(nome_oficina, Rua, Numero_casa, Complemento, Cep, Telefone):
    query = ("INSERT INTO Oficina (nome_oficina, Rua, Numero_casa, Complemento, Cep, Telefone)"
            "VALUES (%s, %s, %s, %s, %s, %s)")
    params =  (nome_oficina, Rua, Numero_casa, Complemento, Cep, Telefone)
    execute_query(query, params)      

#Criação de uma vistoria no banco de dados 4
def add_vistoria(Placa_carro, Data_Vistoria, Sinistro, Oficina_id, Nome_responsavel, Valor_vistoria):
    query = ("INSERT INTO Vistoria (Placa_carro, Data_Vistoria, Sinistro, Oficina_id, Nome_responsavel, Valor_vistoria)" 
             "VALUES(%s, %s, %s, %s, %s, %s)")
    params =(Placa_carro, Data_Vistoria, Sinistro, Oficina_id, Nome_responsavel, Valor_vistoria) 
    execute_query(query,params)
    
#Criação de um emprestimo no banco de dados 5 
def add_emp(Cpf, Placa_carro, Data_emprestimo, Data_progamada_devolucao):
    query = ("INSERT INTO Oficina (Emprestimo_id, Cpf, Placa_carro, Data_emprestimo, Data_progamada_devolucao)"
            "VALUES (%s, %s, %s, %s)")
    params = (Cpf, Placa_carro, Data_emprestimo, Data_progamada_devolucao)
    execute_query(query, params)   
        
# adicionar data de devoluçao do carro 6
def up_emp(data_devolucao,emprestimo_id):
    query = ("UPDATE Emprestimo SET data_devolucao = %s WHERE emprestimo_id = %s")
    params = (data_devolucao, emprestimo_id)
    execute_query(query,params)
     
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

# Listar carros disponiveis 7
def list_carros_disponiveis():
    query = "SELECT * FROM Carros_disponiveis"
    cars = execute_select(query)
    if cars:
        for car in cars:
            placa_carro, modelo, cor, ano, marca, valor_diaria = car
            print(f"Placa: {placa_carro}, Modelo: {modelo}, Cor: {cor}, Ano: {ano}, Marca: {marca}, Valor Diária: {valor_diaria}")
 
 # Listar todos os carros 8
def list_all_cars():
    query = "SELECT * FROM Carro"
    cars = execute_select(query)
    if cars:
        for car in cars:
            placa_carro, modelo, cor, ano, marca, valor_diaria = car
            print(f"Placa: {placa_carro}, Modelo: {modelo}, Cor: {cor}, Ano: {ano}, Marca: {marca}, Valor Diária: {valor_diaria}")
            
# Listar todos os clientes 9
def list_all_cliente():
    query = "SELECT * FROM Clientes"
    clientes = execute_select(query)
    if clientes:
        for cliente in clientes:
            Cpf, Nome, Cnh, Rua, Numero_casa, Complemento, Cep, Telefone, Email = cliente
            print(f"Cliente: {Cpf}, Nome: {Nome}, Cnh: {Cnh}, Rua: {Rua}, Numero da casa: {Numero_casa}, Complemento: {Complemento}, Cep: {Cep}, Telefone: {Telefone}, email: {Email}")
           
# Listar Empréstimos, seus valores totais, e os valores das multas associadas a eles 10
def list_all_emp_val_mul():
    query = "SELECT Emprestimos.Emprestimo_id, Clientes.Nome AS Nome_Cliente, Emprestimos.Placa_carro, Carro.Modelo, Emprestimos.Data_emprestimo,"
    "Emprestimos.Data_programada_devolucao, Emprestimos.Data_devolucao, Valor_total_do_emprestimo.Valor_total, IFNULL(Multas_carros.valor_multa, 0) AS Valor_multa"
    "FROM Emprestimos LEFT JOIN Valor_total_do_emprestimo ON Emprestimos.Emprestimo_id = Valor_total_do_emprestimo.Emprestimo_id LEFT JOIN "
    "Multas_carros ON Emprestimos.Cpf = Multas_carros.Cpf LEFT JOIN Clientes ON Emprestimos.Cpf = Clientes.Cpf LEFT JOIN Carro ON Emprestimos.Placa_carro = Carro.Placa_carro;"
    emp_val_mul = execute_select(query)
    if emp_val_mul:
        for emp_val_muls in emp_val_mul:
            emprestimo_id, Nome_cliente, placa_carro, Modelo, Data_emprestimo, Data_programada_devolucao, Data_devolucao, valor_total, valor_multa  = emp_val_muls
            print(f"N° Emprestimo: {emprestimo_id}, Nome cliente: {Nome_cliente}, Placa do carro: {placa_carro}, Modelo do carro: {Modelo}, Data do emprestimo: {Data_emprestimo}, Data programada devolucao: {Data_programada_devolucao}, Data devolucao: {Data_devolucao}, Valor total: {valor_total}, valor multa: {valor_multa}")
           
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
        
        print("0. Sair")
        choice = int(input("Selecione uma opção: "))

        if choice == 1: #Criar carro
            placa_carro = input("Digite a placa do carro: ")
            modelo = input("Digite o modelo: ")
            cor = input("Digite a cor: ")
            ano = input("Digite o ano: ")
            marca = input("Digite a marca: ")
            valor_diaria = input("Digite o valor da diária: ")
            add_car(placa_carro, modelo, cor, ano, marca, valor_diaria)
            
        elif choice == 2: #Criar cliente
            cpf = input("Digite o cpf do cliente: ")
            Nome = input("Digite o nome do cliente: ")
            Cnh = input("Digite a Cnh: ")
            Rua = input("Digite a Rua: ")
            Numero_casa = input("Digite o numero da casa: ")
            Complemento = input("Digete complemento: ")
            Cep = input("Digite o CEP: ")
            Telefone = input("Digite um numero de telefone: ")
            Email = input("Digite um e-mail: ")
            add_cliente(cpf, Nome, Cnh, Rua, Numero_casa, Complemento, Cep, Telefone, Email)
            
        elif choice == 3: #Criar oficina
            nome_oficina = input("Digite o nome da oficina: ")
            Rua = input("Digite o nome da Rua: ")
            Numero_casa = input("Digite o numero da casa: ")
            Complemento = input("Digite o Complemento: ")
            Cep = input("Digite o cep: ")
            Telefone = input("Digite o telefone: ")
            add_ofi(nome_oficina, Rua, Numero_casa, Complemento, Cep, Telefone)
            
        elif choice == 4: #Criar vistoria
            Placa_carro = input("Digite placa do carro: ") 
            Data_Vistoria = input("Digite data de vistoria: ") 
            Sinistro = input("Digite 1 se passou ou 0 se não passou pela vistoria: ") 
            Oficina_id = input("Digite o id da oficina: ") 
            Nome_responsavel = input("Digite o nome do responsável pela vistoria: ") 
            Valor_vistoria = input("Digite o valor da vistoria: ") 
            add_vistoria(Placa_carro, Data_Vistoria, Sinistro, Oficina_id, Nome_responsavel, Valor_vistoria)
            
        elif choice == 5: #Novo empréstimo
            Cpf = input("Digite o Cpf: ")
            Placa_carro = input("Digite a placa do carro: ")
            Data_emprestimo = input("Digite a data do emprestimo: ")
            Data_progamada_devolucao = input("Digite a data progamada da devolucao: ")
            add_emp(Cpf, Placa_carro, Data_emprestimo, Data_progamada_devolucao)
            
        elif choice == 6: #Nova Devolução
            emprestimo_id = input("Digite o numero do emprestimo: ")
            data_devolucao = input("Diget data devolução: ")
            up_emp(emprestimo_id, data_devolucao)
            
        elif choice == 7: #Listar Carros Disponíveis
            list_carros_disponiveis()
            
        elif choice == 8: #Listar Todos os Carros
            list_all_cars()
            
        elif choice == 9: #Listar Usuários
            list_all_cliente()
            
        elif choice == 10: #Listar Empréstimos, seus valores totais, e os valores das multas associadas a eles
            list_all_emp_val_mul()
            
        elif choice == 0: #Sair
            break
        else:
            print("Escolha inválida!")

if __name__ == "__main__":
    main()