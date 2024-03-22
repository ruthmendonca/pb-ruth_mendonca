cd ~/ecommerce


mkdir -p vendas
cp dados_de_vendas.csv vendas/


mkdir -p vendas/backup
data_atual=$(date +%Y%m%d-%H%M%S) 
cp vendas/dados_de_vendas.csv vendas/backup/dados-"$data_atual".csv


mv vendas/backup/dados-"$data_atual".csv vendas/backup/backup-dados-"$data_atual".csv

arquivo_relatorio="vendas/backup/relatorio-"$data_atual".txt"
data_sistema=$(date +"%Y/%m/%d %H:%M")
primeira_data_venda=$(head -n 2 "vendas/backup/backup-dados-$data_atual.csv" | tail -n 1 | cut -d',' -f1)
ultima_data_venda=$(tail -n 1 "vendas/backup/backup-dados-$data_atual.csv" | cut -d',' -f1)
total_itens_unicos=$(tail -n +2 "vendas/backup/backup-dados-$data_atual.csv" | cut -d',' -f2 | sort -u | wc -l)
echo "Data do sistema operacional: $data_sistema" > "$arquivo_relatorio"
echo "Data do 1 registro de venda: $primeira_data_venda" >> "$arquivo_relatorio"
echo "Data do último registro de venda: $ultima_data_venda" >> "$arquivo_relatorio"
echo "Quantidade total de itens diferentes vendidos: $total_itens_unicos" >> "$arquivo_relatorio"


head vendas/backup/backup-dados-"$data_atual".csv | tail -n +2 >> "$arquivo_relatorio"


zip vendas/backup/backup-dados-"$data_atual".zip vendas/backup/backup-dados-"$data_atual".csv

rm vendas/dados_de_vendas.csv
rm vendas/backup/backup-dados-"$data_atual".csv

echo "Processamento de vendas concluído!"



