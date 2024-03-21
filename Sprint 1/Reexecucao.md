
# Passo a passo para a reexecução do desafio 

1.Passo:  
> Primeiramente, vamos criar a pasta ecommerce e, em seguida mover o arquivo **dados_de_vendas.csv** para a pasta **ecommerce**.
```
        mkdir ecommerce
        mv dados_de_vendas.csv ecommerce/
```

2. Passo:
> Após isso, vamos criar o script **processamendo_de_vendas.sh** 
> Para realizar todas as tarefas desejadas, utiliza-se este script:

   ```
        #Entra na pasta ecommerce, cria o diretório vendas e copia o arquivo dados_de_vendas.csv para dentro dele
        cd ~/ecommerce
        mkdir -p vendas
        cp dados_de_vendas.csv vendas/

        #Cria o subdiretório backup dentro da pasta vendas e faz uma cópia do arquivo dados_de_vendas.csv renomendo ele com a data de execução (ano-mes-dia-horas-minutos-segundos)
        mkdir -p vendas/backup
        data_atual=$(date +%Y%m%d-%H%M%S) 
        cp vendas/dados_de_vendas.csv vendas/backup/dados-"$data_atual".csv

        #Renomeia o arquivo para backup-dados-data atual de execução
        mv vendas/backup/dados-"$data_atual".csv vendas/backup/backup-dados-"$data_atual".csv

        #Cria o relátorio de vendas com as informações solicitadas
        arquivo_relatorio="vendas/backup/relatorio-"$data_atual".txt"
        data_sistema=$(date +"%Y/%m/%d %H:%M")
        primeira_data_venda=$(head -n 2 "vendas/backup/backup-dados-$data_atual.csv" | tail -n 1 | cut -d',' -f1)
        ultima_data_venda=$(tail -n 1 "vendas/backup/backup-dados-$data_atual.csv" | cut -d',' -f1)
        total_itens_unicos=$(tail -n +2 "vendas/backup/backup-dados-$data_atual.csv" | cut -d',' -f2 | sort -u | wc -l)
        echo "Data do sistema operacional: $data_sistema" > "$arquivo_relatorio"
        echo "Data do 1 registro de venda: $primeira_data_venda" >> "$arquivo_relatorio"
        echo "Data do último registro de venda: $ultima_data_venda" >> "$arquivo_relatorio"
        echo "Quantidade total de itens diferentes vendidos: $total_itens_unicos" >> "$arquivo_relatorio"

        #Mostra as primeiras 10 linhas do arquivo backup-dados-yyyymmddhms.csv e as inclui no arquivo relatorio.txt
        head vendas/backup/backup-dados-"$data_atual".csv | tail -n +2 >> "$arquivo_relatorio"

        #Comprime o arquivo para backup-dados-yyyymmddhms.zip
        zip vendas/backup/backup-dados-"$data_atual".zip vendas/backup/backup-dados-"$data_atual".csv

        #Apaga os arquivos originais do diretório vendas e backup
        rm vendas/dados_de_vendas.csv
        rm vendas/backup/backup-dados-"$data_atual".csv

```
    
3. Passo:
> Após criar o script, conceda permissões de execução com 
```    
    chmod +x processamento_de_vendas.sh`

```
    
4. Passo:
> Em seguida, para agendar a execução do script, você pode editar as tarefas cron usando o comando `crontab -e` e adicionar a seguinte linha para executar o script todos os dias de segunda a quinta às 15:27:
```   
    27 15 * * 1-4 /caminho/para/o/processamento_de_vendas.sh

```
>Substitua /caminho/para/o/processamento_de_vendas.sh pelo caminho onde o script **processamento_de_vendas.sh** está localizado.

5. Passo: 
> Quando houver pelo menos **três** relatórios gerados, você pode criar o script **consolidador_de_processamento_de_vendas.sh** para unir todos os relatórios gerados e gerar outro arquivo chamado **relatorio_final.txt**
```   

# Define o nome do arquivo final
arquivo_final="ecommerce/vendas/backup/relatorio_final.txt"

# Limpa o arquivo final se ele já existir
> "$arquivo_final"

# Loop para percorrer todos os relatórios gerados
for relatorio in ecommerce/vendas/backup/relatorio*.txt; do
    # Concatena o conteúdo do relatório ao arquivo final
    cat "$relatorio" >> "$arquivo_final"
    
    # Adiciona uma quebra de linha entre os relatórios
    echo -e "\n" >> "$arquivo_final"
done

```

6. Passo:
> Agora conceda permissões de execução: 

```

chmod +x consolidador_de_processamento_de_vendas.sh

```

7. Passo:
   Por fim, quando você tiver pelo menos três relatórios gerados pelo script **processamento_de_vendas.sh**, execute **manualmente** o script **consolidador_de_processamento_de_vendas.sh**.
