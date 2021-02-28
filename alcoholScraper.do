

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


# /// Note that some URLs limit the length of the page:
# /// Need to try to set this to capture the most products, setting it to 120.

# /// Set the URL
# /// This could be a list of URLs


# // URL = "https://www.sainsburys.co.uk/shop/gb/groceries/drinks/cider#langId=44&storeId=10151&catalogId=10241&categoryId=12269&parent_category_rn=12192&top_category=12192&pageSize=120&orderBy=FAVOURITES_ONLY%7CSEQUENCING%7CTOP_SELLERS&searchTerm=&beginIndex=0&hideFilters=true"

# // URL = "https://www.sainsburys.co.uk/shop/gb/groceries/drinks/all-lager"

URL = "https://www.sainsburys.co.uk/shop/gb/groceries/drinks/all-lager#langId=44&storeId=10151&catalogId=10241&categoryId=278253&parent_category_rn=12192&top_category=12192&pageSize=60&orderBy=FAVOURITES_ONLY%7CSEQUENCING%7CTOP_SELLERS&searchTerm=&beginIndex=0"

# /// Do the html request:
html = requests.get(URL)
soup = BeautifulSoup(html.content, 'html.parser')

# /// Generate some results based on differnet parts of the URL:
results1 = soup.find_all("p", class_="pricePerUnit")
results2 = soup.find_all("div", class_="productNameAndPromotions")
results3 = soup.find_all("li", class_="gridItem")

# /// Make a list of these, we can loop through this:
results_all = [results1, results2, results3]

# /// Check the lengths of our results:
for r in results_all:
   x = len(r)
   x
# /// If they are the same, may simpler to use 1 and 2. If they are differnt may need to use 3.
   

###### /////////////////////////////
   
### /// USING THE RESULTS ABOVE TO FILL VECTORS OF PRICES AND DESRIPTIONS:
## // The idea: we just create an empty vector of the right size, and then fill it up, element by element.


# // Things that we want to collect, in order:
# // All details
# // Prices
# // Descriptions
# // Sizes/weights


# // All details ////////////////
# // Create empty vector: 
allArr = np.empty(x, dtype='S100')


# // Fill it:
for i in range(0,x):
   all = results3[i].text.strip()
   all = " ".join(all.split())
   all = all.rsplit(' - ', 1)[0]
   allArr[i] = all.encode("utf-8")   
# /////////////////////////////// 



# // Prices /////////////////////////
# // Create the empty vector
pricesArr = np.empty(x, dtype='S7')

# // Now fill it up:
for i in range(0,x):
   price = results3[i].text.strip()
   price = " ".join(price.split())
   price = price.rsplit('/unit',1)[0]
   price = price.rsplit('£',1)[1]
   pricesArr[i] = price
# // This should give a vector of the prices:   
# // Prices /////////////////////////


# // Prices per litre ///////////////////////
# // Create the empty vector
pricesLArr = np.empty(x, dtype='S7')

# // Now fill it up:
for i in range(0,x):
   priceL = results3[i].text.strip()
   priceL = " ".join(priceL.split())
   priceL = priceL.rsplit('/ltr',1)[0]
   priceL = priceL.rsplit('£',1)[1]
   pricesLArr[i] = priceL

pricesLArr
# // Prices per litre //////////////////////


# // mls ///////////////////////
# // Create the empty vector
millsArr = np.empty(x, dtype='S7')

# // Now fill it up:
for i in range(0,x):
   millsL = results3[i].text.strip()
   millsL = " ".join(millsL.split())
   millsL = millsL.rsplit('ml',-1)[0]
   millsL = millsL.rsplit(' ',1)[1]
   millsArr[i] = millsL
millsArr

   
# // mls ///////////////////////


# // Descriptions ////////////////   
# // Create empty vector: 
descArr = np.empty(x, dtype='S50')

# // List of numbers that we are going to split on
numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9']

# // Fill it:
for i in range(0,x):
   sent = results3[i].text.strip()
   sent = " ".join(sent.split())
   sent = sent.rsplit(' - ', 1)[0]
   for j in numbers:
      sent = sent.rsplit(j, -1)[0]
   sent = sent.strip()
   # // Print out what we are loading in to our vector:
   sent
   # // Now load this element i, into place i in the vector:
   descArr[i] = sent.encode("utf-8")   
# // Descriptions ////////////////   

 
  
# // Print out what we have so far:
descArr
pricesArr
pricesLArr
allArr
millsArr


# /// Turning this into DataFrames:

arrays = [descArr, pricesArr, pricesLArr, millsArr]
df = pd.DataFrame(arrays)

# /// Transpose this:
df
df = df.T

# /// Name columns:
df.columns = ['Description', 'Prices', 'Price_PL', 'Volume']

# /// Decode the string:
# /// ? How to do all this in one line ?
df['Description'] = df['Description'].str.decode("utf-8")
df['Volume'] = df['Volume'].str.decode("utf-8")
df['Prices'] = df['Prices'].str.decode("utf-8")
df['Price_PL'] = df['Price_PL'].str.decode("utf-8")

# /// Sort and view:
df = df.sort_values('Description')
df   

# /// Add date and time, and type of item:

df['Type'] = 'Lager'

import datetime as dt
df['Date'] = dt.datetime.today().strftime("%Y-%m-%d")






end









