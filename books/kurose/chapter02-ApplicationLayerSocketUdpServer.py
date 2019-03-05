#!/usr/bin/python

from socket import *
serverPort = 12000
serverSocket = socket(AF_INET, SOCK_DGRAM)
serverSocket.bind((’’, serverPort))                             #vincula o número da porta(1200) ao socket servidor
print ”The server is ready to receive”
while 1:
	message, clientAddress = serverSocket.recvfrom(2048)    #os dados dos pacotes que chegam da Internet no socket do cliente e o endereço de origem;
	modifiedMessage = message.upper()                       #núcleo da aplicação, pega a linha enviada pelo cliente e a passa para letras maiúsculas;
	serverSocket.sendto(modifiedMessage, clientAddress)     #anexa a msg em letras maiúsculas ao endereço do cliente, e envia ao socket do servidor;
