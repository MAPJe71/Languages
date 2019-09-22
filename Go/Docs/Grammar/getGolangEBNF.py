from bs4 import BeautifulSoup
import requests


r = requests.get('http://golang.org/ref/spec')
soup = BeautifulSoup(r.text)
bnf = soup.find_all('pre', class_='ebnf')
bnftxt = [x.get_text() for x in bnf]

bnftxt = ''.join(bnftxt)
with open('go-out.txt', 'w') as f:
	f.write(bnftxt.encode('utf-8'))