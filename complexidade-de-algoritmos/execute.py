#!/usr/bin/python3

##########################################################
#                       DEPENDÊNCIAS                     #
#Usando Matplot:					 #
# Matplot: sudo apt-get install python3-matplotlib 	 # 			
#							 #
# Tkinter: sudo apt-get install python3-tk		 #
#							 #
#							 #
#Usando Plot:						 #
# Pip: wget https://bootstrap.pypa.io/get-pip.py	 #
#      sudo python3 get-pip.py				 #
#							 #
# Plotly: sudo pip install plotly			 #
#	  sudo pip install plotly --upgrade		 #
#	  print(plotly.__version__)  # version >1.9.4    #
##########################################################


import sys
import re
import plotly as py
import plotly.graph_objs as go
from subprocess import call

print("Executando o algoritmo "+sys.argv[1].upper()+" com entrada até "+sys.argv[2]+" num intervalo de "+sys.argv[3]+" ...")
for i in range(0, int(sys.argv[2])+1, int(sys.argv[3])):
	call(["./"+sys.argv[1], str(i)])
print("Execução terminada com sucesso!")

