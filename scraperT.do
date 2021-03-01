

***Richard Davies
***Bristol University
***Alcohol Scraper
***February 2021

***Description:  Scraping price data

/// Opening Python and importing tools we need:
python
# // Packages for data manipulation
import numpy as np
import pandas as pd
# // Web scraping: 
import requests
from bs4 import BeautifulSoup
# // OS. Sometimes need this for finding working directory:
import os
import datetime as dt

# /// Note that some URLs limit the length of the page:
# /// Need to try to set this to capture the most products, setting it to 120.

# /// Set the URL
# /// This could be a list of URLs

python
URLs = ["https://www.tesco.com/groceries/en-GB/shop/drinks/beer-and-cider/cider"
]

Products = [
'Cider']

df_m = pd.DataFrame()

numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9']

for t in URLs:
   s = URLs.index(t)
   Products[s]  
   html = requests.get(t)
   soup = BeautifulSoup(html.content, 'html.parser')
   r = soup.find_all("div", class_="tile-content")
   x = len(r)

end 