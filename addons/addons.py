# sudo apt install python3-pip -y
# sudo apt install unzip -y
# pip3 install bs4
# pip3 install lxml
# python3 addons.py

import os
import requests
from bs4 import BeautifulSoup, SoupStrainer

main_url = "http://sirpleaseny.site.nfoservers.com/map/"
page = requests.get(main_url)
soup = BeautifulSoup(page.text, features="lxml")

all_files = []

for link in soup.find_all('a'):
    string = link.get('href')
    if string.endswith(".zip"):
        all_files.append(string)

for file in all_files:
    link = main_url + file
    # get the file
    print("Downloading", file + "...")
    r = requests.get(link, allow_redirects=True)
    # store the file in disk
    open(file, "wb").write(r.content)
    # extract file
    print("Extracting", file + "...")
    os.system("unzip -o " + file)
    # delete zip
    os.remove(file)