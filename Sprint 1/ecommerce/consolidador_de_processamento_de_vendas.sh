#!/bin/bash
diretorioRelatorios="/vendas/backup"

arquivoFinal="relatorio_final.txt"

cat "$diretorioRelatorios"/relatorio-*.txt >> "$arquivoFinal"

