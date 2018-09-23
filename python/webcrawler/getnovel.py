#!/usr/bin/env python
import requests
from bs4 import BeautifulSoup

def get_html(url):
    try:
        html =  requests.get(url)
        html.raise_for_status()
        r.encoding = 'utf-8'
        return html.text
    except:
        return "get html error"


def get_content(html):

    soup = BeautifulSoup(html, 'lxml')
    for link in soup.find_all('br'):
        print(link.string)


#def out_file():


book_number = 8778
start_page = 'https://www.piaotian.com/html/8/' + str(book_number) + '/index.html'
html = get_html(start_page)
get_content(html)


