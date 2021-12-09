#!/usr/bin/env python
# coding: utf-8

# ##### IMPORTANT!!!!! DO NOT SCRAPE IT AGAIN UNLESS THE DATA ARE WRONG

##############################################################################
## Web scrapping of Premier League match statistics from LAST 6 Seasons
##  inlucing the current season.
# Note: Can be changed to scrape all seasons.
##############################################################################

from bs4 import BeautifulSoup as soup
from urllib.request import urlopen as uReq 
import re

# Page to scrap from
my_url = 'https://fbref.com/en/comps/9/history/Premier-League-Seasons'

# Opening up connection, grabbing the page
html = uReq(my_url)
bs = soup(html.read(), 'html.parser')


# Get an url for each PL season details
seasons_links = []
for x in bs.find_all('a', href=re.compile('^\/en/comps/9/[0-9|P]+')):
    pl = bs.find_all('a', text="Premier League")
    fa_pl = bs.find_all('a', text="FA Premier League")
    if x not in pl and x not in fa_pl:
        #print(x.attrs['href'])
        link = 'https://fbref.com' + x.attrs['href']
        print(link)
        seasons_links.append(link)



# In[3]:


# For each season url, get an url to fixtures of that season
#  Do that only for last 2 seasons!
fixtures_links = []
for link in seasons_links[:2]:
    season = uReq(link)
    bs_season = soup(season.read(), 'html.parser')
    fixture = bs_season.find('a', href=re.compile('Premier-League-Scores-and-Fixtures+'))
    fixture_link = 'https://fbref.com' + fixture.attrs['href']
    fixtures_links.append(fixture_link)


# In[4]:


# Get the header from table in fixtures
link = fixtures_links[0]
fix = uReq(link)
bs_fix = soup(fix.read(), 'html.parser')
div = bs_fix.find('div', {'id':'all_sched'})
header_row = div.find_all('th', {'class': [' ', 'poptip','sort_default_asc', 'center']})[0:14]


# In[5]:


# (continued) Get the header from table in fixtures
header = []
for h in header_row:
    print(h.attrs['data-stat'])
    header.append(h.attrs['data-stat'])


# In[55]:


# Just removing useless cols
header.remove('xg_a')
header.remove('xg_b')


# In[12]:


# Get a table of fixtures for each season
tables = []
for link in fixtures_links:
    fix = uReq(link)
    print(link)
    bs_fix = soup(fix.read(), 'html.parser')
    div = bs_fix.find('div', {'id':'all_sched'})
    tables.append(div)


# In[106]:


# Create a dictionary with data for each statistic (column) by using for loop
data = dict()
for h in header:
    data[h] = []
    if h == 'gameweek':
        for table in tables:
            key = table.find_all('th', {'data-stat': h})
            for k in key:
                if k.get_text() == 'Wk':
                    continue
                elif len(k)==0:
                    data[h].append(0)
                else:
                    data[h].append(k.get_text())
    elif h == 'match_report':
        for table in tables:
            key = table.find_all('td', {'data-stat': h})
            for k in key:
                try:
                    a = k.find('a')
                    link = 'https://fbref.com' + a.attrs['href']
                    data[h].append(link)
                except AttributeError:
                    data[h].append(0)
    else: 
        for table in tables:
            key = table.find_all('td', {'data-stat': h})         
            for k in key:
                if len(k)==0:
                    data[h].append(0)
                else:
                    data[h].append(k.get_text())

for k, v in data.items():
    print(f"{k}: {len(v)}")


# In[102]:


import pandas as pd
 
pl = pd.DataFrame(data=data)
pl.head(50)



x = -1
indexes = []
for val in pl['squad_a'].values:
    x += 1
    if val == 0:
        indexes.append(x)
# Check
pl.iloc[indexes].sum()



pl.drop(indexes, axis=0, inplace=True)


pl.info()


pl.to_csv('PL_AllMatches_Scores_Links.csv', index=False)




# In[ ]:





# In[ ]:





# In[ ]:




