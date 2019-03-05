#!/usr/bin/python3

#Paramêtros: ./plot <resultado1> [resultado2 ... resultado5]

 
##########################################################
#                       DEPENDÊNCIAS                     #
#Usando Matplot:                                         #
# Matplot: sudo apt-get install python3-matplotlib       #                  
#                                                        #
# Tkinter: sudo apt-get install python3-tk               #
#                                                        #
#                                                        #
#Usando Plot:                                            #
# Pip: wget https://bootstrap.pypa.io/get-pip.py         #
#      sudo python3 get-pip.py                           #
#                                                        #
# Plotly: sudo pip install plotly                        #
#         sudo pip install plotly --upgrade              #
#         print(plotly.__version__)  # version >1.9.4    #
##########################################################


import sys
import plotly as py
import plotly.graph_objs as go

def main():
	qtdResults = len(sys.argv)-1	
	trace(qtdResults)

def trace(qtdTrace=0):
	if qtdTrace != 0:
		rawData = []
		for traces in range(1,qtdTrace+1):
			print(traces)
			arq = open(sys.argv[traces],"r")

			entry = []
			executionTime = []
			
			for line in arq:
				entry.append(line.split()[1])
				executionTime.append(line.split()[5])	

			data = go.Scatter(
 				x=entry,
 				y=executionTime,
 				name=sys.argv[traces][:-11]
		 	)
			rawData.append(data)
		plot(rawData)
	else:
		print("Sem resultados informados! :"+qtdTrace)

def plot(data=None):
	layout = go.Layout(
		title='Comparativo algoritmos de ordenação',
		font=dict(family='Courier New, monospace', size=14, color='#7f7f7f'),
    		xaxis=dict(
        		title='Entrada(n)',
        		titlefont=dict(
            			family='Courier New, monospace',
            			size=12,
            			color='#7f7f7f'
        		)
    		),
    		yaxis=dict(
        		title='Tempo de execução(s)',
        		titlefont=dict(
         			family='Courier New, monospace',
            			size=12,
            			color='#7f7f7f'
        		)
    		)
	)

	fig = go.Figure(data=data, layout=layout)
	py.offline.plot(fig)

if __name__ == '__main__':
	main()
