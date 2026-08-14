import csv
import os

def obter_caminho_dados(nome_arquivo="dados.txt") -> str:
    diretorio_atual = os.path.dirname(os.path.abspath(__file__))
    return os.path.join(diretorio_atual, nome_arquivo)


def full_table_scan(caminho_arquivo: str):
    try:
        with open(caminho_arquivo, mode='r', encoding='utf-8') as arquivo:
            leitor = csv.reader(arquivo, delimiter=';')
            cabecalho = next(leitor, None)
            if cabecalho:
                print(f"{cabecalho[0]:<4} | {cabecalho[1]:<10} | {cabecalho[2]:<15} | {cabecalho[3]:<6} | {cabecalho[4]:<8} | {cabecalho[5]:<12}")
                print("-" * 70)
            
            for linha in leitor:
                if len(linha) == 6:
                    id_voo, num_voo, destino, portao, horario, status = linha
                    print(f"{id_voo:<4} | {num_voo:<10} | {destino:<15} | {portao:<6} | {horario:<8} | {status:<12}")
                    
            print("\n" + "=" * 70)

    except FileNotFoundError:
        print(f"O arquivo nao foi encontrado.")
    except Exception as e:
        print(f"Ocorreu um erro durante a leitura: {e}")


def busca_por_id(caminho_arquivo: str, id_procurado: str):
    encontrado = False
    
    try:
        with open(caminho_arquivo, mode='r', encoding='utf-8') as arquivo:
            leitor = csv.reader(arquivo, delimiter=';')
            cabecalho = next(leitor, None)
            
            for linha in leitor:
                if len(linha) == 6:
                    id_voo = linha[0].strip()
                    
                    if id_voo == str(id_procurado).strip():
                        encontrado = True
                        print(f"\n=== REGISTRO ENCONTRADO (ID = {id_procurado}) ===")
                        
                        if cabecalho:
                            print(f"{cabecalho[0]:<4} | {cabecalho[1]:<10} | {cabecalho[2]:<15} | {cabecalho[3]:<6} | {cabecalho[4]:<8} | {cabecalho[5]:<12}")
                            print("-" * 70)
                        
                        id_v, num_v, destino, portao, horario, status = linha
                        print(f"{id_v:<4} | {num_v:<10} | {destino:<15} | {portao:<6} | {horario:<8} | {status:<12}")
                        print("=" * 70)
                        break

            if not encontrado:
                print(f"\nID nao encontrado.")

    except FileNotFoundError:
        print(f"Erro: O arquivo nao foi encontrado.")
    except Exception as e:
        print(f"Ocorreu um erro durante a busca: {e}")


def filtro_e_projecao(caminho_arquivo: str, destino_filtro: str):
    contador_encontrados = 0

    try:
        with open(caminho_arquivo, mode='r', encoding='utf-8') as arquivo:
            leitor = csv.reader(arquivo, delimiter=';')
            next(leitor, None)  # Pula o cabeçalho
            print(f"{'NUMERO_VOO':<12} | {'DESTINO':<15} | {'HORARIO':<8} | {'STATUS':<12}")
            print("-" * 55)
            
            for linha in leitor:
                if len(linha) == 6:
                    id_voo, num_voo, destino, portao, horario, status = linha

                    if destino.strip().lower() == destino_filtro.strip().lower():
                        print(f"{num_voo:<12} | {destino:<15} | {horario:<8} | {status:<12}")
                        contador_encontrados += 1

            print("-" * 55)
            print(f"Total de registros encontrados: {contador_encontrados}\n" + "=" * 55)

    except FileNotFoundError:
        print(f"O arquivo nao foi encontrado.")
    except Exception as e:
        print(f"Ocorreu um erro durante a consulta: {e}")


if __name__ == "__main__":
    caminho_dados = obter_caminho_dados("dados.txt")

    print("\n")
    full_table_scan(caminho_dados)

    print("\n")
    id_usuario = input("Informe o ID do voo que deseja buscar: ")
    busca_por_id(caminho_dados, id_usuario)

    print("\n")
    destino_busca = input("Informe o destino para filtrar os voos (ex: Brasilia): ")
    filtro_e_projecao(caminho_dados, destino_busca)