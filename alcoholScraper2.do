

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
URLs = ["https://www.sainsburys.co.uk/shop/gb/groceries/drinks/cider#langId=44&storeId=10151&catalogId=10241&categoryId=12269&parent_category_rn=12192&top_category=12192&pageSize=120&orderBy=FAVOURITES_ONLY%7CSEQUENCING%7CTOP_SELLERS&searchTerm=&beginIndex=0&hideFilters=true",

"https://www.sainsburys.co.uk/shop/gb/groceries/drinks/all-lager#langId=44&storeId=10151&catalogId=10241&categoryId=278253&parent_category_rn=12192&top_category=12192&pageSize=60&orderBy=FAVOURITES_ONLY%7CSEQUENCING%7CTOP_SELLERS&searchTerm=&beginIndex=0",

"https://www.sainsburys.co.uk/shop/gb/groceries/drinks/all-champagne-and-sparkling-wine",

"https://www.sainsburys.co.uk/shop/gb/groceries/drinks/all-white-wine",

"https://www.sainsburys.co.uk/shop/gb/groceries/drinks/all-red-wine",

"https://www.sainsburys.co.uk/shop/gb/groceries/drinks/rose--wine",

"https://www.sainsburys.co.uk/shop/gb/groceries/drinks/vegan-wines",

"https://www.sainsburys.co.uk/shop/gb/groceries/drinks/sherry-port-and-fortified-wine",

"https://www.sainsburys.co.uk/shop/gb/groceries/bakery/white-bread",

"https://www.sainsburys.co.uk/shop/gb/groceries/meat-fish/CategoryDisplay?langId=44&storeId=10151&catalogId=10241&categoryId=310864&pageSize=60&beginIndex=0&promotionId=&listId=&searchTerm=&hasPreviousOrder=&previousOrderId=&categoryFacetId1=&categoryFacetId2=&bundleId=&parent_category_rn=13343&top_category=13343&orderBy=TOP_SELLERS#langId=44&storeId=10151&catalogId=10241&categoryId=310864&parent_category_rn=13343&top_category=13343&pageSize=60&orderBy=TOP_SELLERS&searchTerm=&beginIndex=0&hideFilters=true",

"https://www.sainsburys.co.uk/shop/gb/groceries/fruit-veg/bananas-grapes?fromMegaNav=1#langId=44&storeId=10151&catalogId=10241&categoryId=12551&parent_category_rn=12518&top_category=12518&pageSize=60&orderBy=FAVOURITES_ONLY%7CTOP_SELLERS&searchTerm=&beginIndex=0",

"https://www.sainsburys.co.uk/shop/gb/groceries/fruit-veg/citrus-fruit#langId=44&storeId=10151&catalogId=10241&categoryId=12648&parent_category_rn=12518&top_category=12518&pageSize=60&orderBy=FAVOURITES_ONLY%7CTOP_SELLERS&searchTerm=&beginIndex=0"

]

Products = [
'Cider', 
'Lager', 
'Champagne', 
'White wine', 
'Red wine', 
'Rose wine', 
'Vegan wine',
'Sherry & Port'
'Bread', 
'Chicken', 
'Banana-Grape', 
'Citrus']

df_m = pd.DataFrame()

numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9']

for t in URLs:
   s = URLs.index(t)
   Products[s]  
   html = requests.get(t)
   soup = BeautifulSoup(html.content, 'html.parser')
   results3 = soup.find_all("li", class_="gridItem")
   x = len(results3)

   # // Create empty vector: 
   allArr = np.empty(x, dtype='S100')
   pricesArr = np.empty(x, dtype='S7')
   pricesLArr = np.empty(x, dtype='S7')
   millsArr = np.empty(x, dtype='S7')
   descArr = np.empty(x, dtype='S50')
   gramsArr = np.empty(x, dtype='S7')
   
   # // arrays = [pricesArr, descArr, millsArr, gramsArr, pricesLArr, allArr]
   arrays = [pricesArr, descArr, allArr]

   # // Fill it:
   for i in range(0,x):
      all = results3[i].text.strip()
      all = " ".join(all.split())
      all = all.rsplit(' - ', -1)[0]
      allArr[i] = all.encode("utf-8")  
	  
      price = results3[i].text.strip()
      price = " ".join(price.split())
      price = price.rsplit('/unit',1)[0]
      price = price.rsplit(' ',1)[1]
      pricesArr[i] = price.encode("utf-8")
	  
	  # // Use 'sent' for 'desc' here:
      sent = results3[i].text.strip()
      sent = " ".join(sent.split())
      sent = sent.rsplit(' - ', 1)[0]
      for j in numbers:
         sent = sent.rsplit(j, -1)[0]
      sent = sent.strip()
      descArr[i] = sent.encode("utf-8")
	  
	  # // These don't work as they vary across goods.
      #priceL = results3[i].text.strip()
      #priceL = " ".join(priceL.split())
      #priceL = priceL.rsplit('/ltr',1)[0]
      #priceL = priceL.rsplit('£',1)[1]
      #pricesLArr[i] = priceL

      #millsL = results3[i].text.strip()
      #millsL = " ".join(millsL.split())
      #millsL = millsL.rsplit('ml ',-1)[0]
      #millsL = millsL.rsplit(' ',1)[1]
      #millsArr[i] = millsL

      #grams = results3[i].text.strip()
      #grams = " ".join(grams.split())
      #grams = grams.rsplit('g ',-1)[0]
      #grams = grams.rsplit(' ',1)[1]
      #gramsArr[i] = grams
	  	  
   df = pd.DataFrame(arrays)
   df = df.T
   df.columns = ['Price', 'Desc', 'All']
   df['Type'] = Products[s]
   df['Date'] = dt.datetime.today().strftime("%Y-%m-%d")
   df_m = df_m.append(df)

df_m['Price'] = df_m['Price'].str.decode("utf-8")
df_m['Desc'] = df_m['Desc'].str.decode("utf-8")

#df_m['All'] = df_m['All'].str.decode("utf-8")
# df_m

# // save the dataframe as a csv file 
df_m.to_csv("prices.csv")

# // to find working directory
# os.getcwd()

end


//////////STATA////////////////////////////

// cd to laptop desktop:
capture cd "C:\Users\hi19329\Documents"
capture cd "C:\\Users\\hi19329\\OneDrive - University of Bristol\\Documents"
// import data:
clear
import delimited "prices.csv", varnames(1) encoding(UTF-8) 


//Getting some weights and measures using Stata string functions:

// Millilitrs measure:
split all, p("ml ")
gen ml = reverse(all1)
split ml
gen mills = reverse(ml1)
drop ml* all1 all2

// Mend, to deal with litres:
split all, p(" - ")
split all1, p("L ")
replace all11="" if all12==""
replace all11 = reverse(all11)
split all11, p(" ")
rename all111 litres
destring litres, replace
replace litres = litres*1000
tostring litres, replace
replace mills = litres if litres!="."

rename mills volume
drop all1* litres


///////////TO DO - DEAL WITH CL HERE //////////////////////////////

// Grams measure:
split all, p("g ")
gen gr = reverse(all1)
split gr
gen weight = reverse(gr1)
drop gr* all1 all2 all3 all4

//Tidy up:
replace weight="" if length(weight)>7
rename v1 obs
order obs desc price volume weight type date all

br


