

***Richard Davies
***Bristol University
***Groceries Scraper
***February 2021

***Description:  Scraping price data


***************************************************************************
*************************PYTHON********************************************
***************************************************************************

python
# /// Import tools that we will need:
# // Packages for data manipulation
import numpy as np
import pandas as pd
# // Web scraping: 
import requests
from bs4 import BeautifulSoup
# // OS. Sometimes need this for finding working directory:
import os


# // https://www.sainsburys.co.uk/shop/gb/groceries/drinks/cider#langId=44&storeId=10151&catalogId=10241&categoryId=12269&parent_category_rn=12192&top_category=12192&pageSize=120&orderBy=FAVOURITES_ONLY%7CSEQUENCING%7CTOP_SELLERS&searchTerm=&beginIndex=0&hideFilters=true

# // https://www.sainsburys.co.uk/shop/gb/groceries/drinks/cider#langId=44&storeId=10151&catalogId=10241&categoryId=12269&parent_category_rn=12192&top_category=12192&pageSize=120&orderBy=FAVOURITES_ONLY%7CSEQUENCING%7CTOP_SELLERS&searchTerm=&beginIndex=0&hideFilters=true

# // https://www.sainsburys.co.uk/shop/gb/groceries/drinks/CategoryDisplay?langId=44&storeId=10151&catalogId=10241&categoryId=12269&orderBy=FAVOURITES_ONLY%7CSEQUENCING%7CTOP_SELLERS&beginIndex=0&promotionId=&listId=&searchTerm=&hasPreviousOrder=&previousOrderId=&categoryFacetId1=&categoryFacetId2=&ImportedProductsCount=&ImportedStoreName=&ImportedSupermarket=&bundleId=&parent_category_rn=12192&top_category=12192&pageSize=120#langId=44&storeId=10151&catalogId=10241&categoryId=12269&parent_category_rn=12192&top_category=12192&pageSize=120&orderBy=FAVOURITES_ONLY%7CSEQUENCING%7CTOP_SELLERS&searchTerm=&beginIndex=0&hideFilters=true


# /// Pick the URLs that we want to scrape:
URLs = [
"https://www.sainsburys.co.uk/shop/gb/groceries/bakery/white-bread",
"https://www.sainsburys.co.uk/shop/gb/groceries/drinks/cider#langId=44&storeId=10151&catalogId=10241&categoryId=12269&parent_category_rn=12192&top_category=12192&pageSize=120&orderBy=FAVOURITES_ONLY%7CSEQUENCING%7CTOP_SELLERS&searchTerm=&beginIndex=0&hideFilters=true"
]


for t in URLs:
   s = URLs.index(t)
   html = requests.get(t)
   soup = BeautifulSoup(html.content, 'html.parser')
   results = soup.find_all("p", class_="pricePerUnit")
   results2 = soup.find_all("div", class_="productNameAndPromotions")
   
# // Now look at what we have:

# // A mess of HTML:
soup   

# // From within this, our results:
results

# // To get the length of our results:
x = len(results)



# // Set up some empty vectors to fill:
strArr = np.empty(x, dtype='S7')
strArr2 = np.empty(x, dtype='S50')

# // Now some code that will not work
# strArr = np.empty(length, dtype='S7')
# for i in range(0,length):
#   strArr[i] = results[i].text
# // This is becuase of encoding. Bytes verses Unicode. 
  
# // To investigate and improve one element:
results[1]
results[1].text
results[1].text.encode('utf-8')
results[1].text.encode('utf-8').strip()
results2[1].text.encode('utf-8').strip()
# // Progressively improving the output.


# // Now the loop should work:
for i in range(0,x):
   strArr[i] = results[i].text.encode('utf-8').strip()

for j in range(0,x):
   strArr2[j] = results2[j].text.encode('utf-8').strip()   

   
# // Examine what we have:   
strArr
strArr2


# //// Turn into dataframe and clean up:

df = pd.DataFrame(strArr)
df.columns = ['Price']
df['Desc'] = strArr2
# // df.columns = ['Data', 'Desc']

# // Clean up price
df['Price'] = df['Price'].str.decode("utf-8")
df['Price'] = df['Price'].str.rstrip('/unit')

# // Clean up description
df['Desc'] = df['Desc'].str.decode("utf-8")
df

end




