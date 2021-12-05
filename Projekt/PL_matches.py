#!/usr/bin/env python
# coding: utf-8

# __Dataset for creating a ranking which will be used for classification 
#  of matches (win, draw, loss)__

# In[1]:


import PL_matches_scrape
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
plt.style.use('seaborn-whitegrid')

pl = pd.read_csv('PL_AllMatches_Scores_Links.csv')
pl.head(15)


# In[2]:


# Was there a score that had more than 9 goals on either side? NO!
len_score = [len(x) for x in pl.score.values]
count = 0
for score in len_score:
    if score >= 4:
        count += 1
print(count)


# In[3]:


pl.columns


# In[4]:


# Just changing the columns so they're more comprehensible
pl.columns = ['gameweek', 'dayofweek', 'date', 'time', 'h_Team', 'score', 'a_Team',
       'att', 'stadium', 'ref', 'report_link', 'notes']


# __Create columns for goals scored by home/away side__

# In[5]:


# Add scored goals for home and away side columns
pl['h_scored'] = pl['score'].apply(lambda x: int(x[0]))
pl['a_scored'] = pl['score'].apply(lambda x: int(x[-1]))


# In[6]:


# Convert date col to datetime format
pl['date'] = pd.to_datetime(pl['date'])


# In[7]:


# Sort dataset by the oldest matches
pl.sort_values('date', ascending=True, inplace=True)
pl.head()


# In[8]:


# Drop time and notes columns
pl.drop(['time', 'notes'], axis=1, inplace=True)


# # Taking upcoming fixtures aside

# In[9]:


pl.sort_values('date', ascending=False).head()


# __Number of not played YET matches__

# In[10]:


pl_full_no = pl.shape[0]
pl_played_no = pl.loc[pl.date < '2021-08-13'].sort_values('date', ascending=False).shape[0]
pl_notplayed_no = pl_full_no - pl_played_no

print(f"There is {pl_notplayed_no} not played games in dataset in total!")


# __Subset of not played YET matches__

# In[11]:


# pl_notplayed = pl.loc[pl.date >= '2021-08-13']
# pl_notplayed = pl.loc[pl.score == "0"]

# # Ranking program
# > __will create ELO ranking based on ELO scoring:__
# - https://digitalhub.fifa.com/m/f99da4f73212220/original/edbm045h0udbwkqew35a-pdf.pdf
# - https://www.goal.com/en-my/news/new-fifa-world-ranking-how-it-is-calculated/1xspsoo3o9j691wwm5i0mtpdbz
# - https://theconversation.com/what-are-the-world-football-elo-ratings-27851

# ***
# $$ Rn = Ro + K × (W - W_e)$$
# ***
# __WHERE:__
# - $R_n$ is the new rating;
# - $R_o$ is the old (pre-match) rating;
# - $K$ is the weight constant for the tournament played (60 for World Cup finals);
# $K$ is then adjusted for the goal difference in the game. It is increased by half if a game is won by two goals, by ¾ if a game is won by three goals, and by $¾ + \frac{(N-3)}{8}$ if the game is won by four or more goals, where N is the goal difference;
# - $W$ is the result of the game (__1__ for a win, __0.5__ for a draw, and __0__ for a loss);
# - $W_e$ is the expected result from this formula:
# > &emsp; $We = \frac{1}{(10^{(\frac{-dr}{600})})+ 1)}$ in which $dr = R_{{0}_{Home Team}} - R_{{0}_{Away Team}} $ equals the difference in ratings plus 100 points for a team playing at home

#  

# ## Create a dataset of all teams with needed columns

# In[12]:


pl.columns


# In[13]:


# Each team must have played home...
team_set = set(h for h in pl.h_Team)
team_set2 = set(a for a in pl.a_Team)
team_set == team_set2


# In[14]:


# Team column
# ELO = pd.DataFrame()

# ELO['Team'] = [x for x in team_set]
# ELO


# # In[15]:


# # Initial Rank for all teams will be 1
# ELO['Rank'] = 1
# # Initial Score
# ELO['ELO'] = 0

# ELO


# ### ELO class

# In[16]:


# def R_n(h_r_bef, a_r_bef, h_result, a_result):
#     """Calculates new ratings for home and away side"""
#     # Difference between rating for each side
#     h_dr = (h_r_bef + 100) - a_r_bef
#     a_dr = a_r_bef - h_r_bef
#     # Expected result for each side
#     h_W_e = 1 / (10 ** (-h_dr/600) + 1)
#     a_W_e = 1 / (10 ** (-a_dr/600) + 1)
#     # New rankings
#     h_R_n = h_r_bef + 1*(h_result - h_W_e)
#     a_R_n = a_r_bef + 1*(a_result - a_W_e)
#     return (h_R_n, a_R_n)


# In[18]:


# Creating an ID for each game
pl.reset_index(drop=True, inplace=True)
pl.reset_index(inplace=True)
pl


# In[17]:


pl['id_game'] = pl['index']


# In[18]:


pl['h_r_before'] = 1
pl['a_r_before'] = 1
pl['h_r_after'] = 0
pl['a_r_after'] = 0

# Result columns
h_result = []
a_result = []
# Score diff. columns
h_score_diff = []
a_score_diff = []
for x, y in zip(pl.h_scored.values, pl.a_scored.values):
    h_sc = x - y
    a_sc = y - x
    h_score_diff.append(h_sc)
    a_score_diff.append(a_sc)
    if x > y:
        h_result.append(1)
        a_result.append(0)
    if x == y:
        h_result.append(0.5)
        a_result.append(0.5)
    if x < y:
        h_result.append(0)
        a_result.append(1)
    
pl['h_result'] = h_result
pl['a_result'] = a_result
pl['h_score_diff'] = h_score_diff
pl['a_score_diff'] = a_score_diff


# # In[19]:


# pl.head(40)


# # In[20]:


# pl.loc[pl.id_game.max()][0]


# # In[23]:


# pl.loc[(pl.id_game < 39) & (pl.a_Team == "Arsenal"), 'id_game'].max()


# # In[24]:


# pl.loc[1, 'a_r_after'] = 1000
# pl.loc[1, 'a_r_after']


# ## Create a dataset of played games and calculate ELO ratings

# In[21]:


# pl_played = pl.loc[pl.date < '2021-08-13']
pl_played = pl.loc[pl.score != "0"]

# In[22]:


pl_played.head(10)

pl_not_played = pl.loc[pl.score == '0']

pl_played
pl_not_played

pl_played.to_csv('pl_played.csv', index=False )
pl_not_played.to_csv('pl_not_played.csv', index=False)


# In[27]:


# # Create a default dictionary with all teams
# dict_count_teams = {x: 0 for x in ELO.Team}
# for i, h, a, h_res, a_res in zip(pl_played.id_game.values, pl_played.h_Team.values, pl_played.a_Team.values, pl_played.h_result.values, pl_played.a_result.values):
# #     print(i, h, a, h_res, a_res)
#     # If team appears on either side - count
#     dict_count_teams[h] += 1
#     dict_count_teams[a] += 1
    
#     # If-else loop for getting the right ELO before the match - h_Team
#     if dict_count_teams[h] == 1:
#         h_r_bef = 1
#     else:
#         # Look for the latest match where the h_Team appeared and take its
#         #  after-match ELO
#         h_comp_idx = pl_played.loc[(pl_played.id_game < i) & (pl_played.h_Team == h), 'id_game'].max()
#         if str(h_comp_idx) == 'nan':
#             h_comp_idx = 0
#         else:
#             h_comp_idx = h_comp_idx 
#         a_comp_idx = pl_played.loc[(pl_played.id_game < i) & (pl_played.a_Team == h), 'id_game'].max()
#         if str(a_comp_idx) == 'nan':
#             a_comp_idx = 0
#         else:
#             a_comp_idx = a_comp_idx
# #         print(h_comp_idx, a_comp_idx)
#         if h_comp_idx > a_comp_idx:
#             h_r_bef = pl_played.iloc[h_comp_idx]['h_r_after']
#         elif h_comp_idx < a_comp_idx:
#             h_r_bef = pl_played.iloc[a_comp_idx]['a_r_after']
#     # Update home-side before the match rating
#     pl_played.loc[i, 'h_r_before'] = h_r_bef

        
#     # If-else loop for getting the right ELO before the match - a_Team       
#     if dict_count_teams[a] == 1:
#         a_r_bef = 1
#     else:
#         h_comp_idx = pl_played.loc[(pl_played.id_game < i) & (pl_played.h_Team == a), 'id_game'].max()
#         if str(h_comp_idx) == 'nan':
#             h_comp_idx = 0
#         else:
#             h_comp_idx = h_comp_idx 
#         a_comp_idx = pl_played.loc[(pl_played.id_game < i) & (pl_played.a_Team == a), 'id_game'].max()
#         if str(a_comp_idx) == 'nan':
#             a_comp_idx = 0
#         else:
#             a_comp_idx = a_comp_idx
            
#         if h_comp_idx > a_comp_idx:
#             a_r_bef = pl_played.iloc[h_comp_idx]['h_r_after']
#         elif h_comp_idx < a_comp_idx:
#             a_r_bef = pl_played.iloc[a_comp_idx]['a_r_after']
#     # Update away-side before the match rating
#     pl_played.loc[i, 'a_r_before'] = a_r_bef
#     # Home-side after the match rating
#     h_r_aft = R_n(h_r_bef, a_r_bef, h_res, a_res)[0]
#     # Update home-side after the match rating
#     if h_r_aft < 1:
#         pl_played.loc[i, 'h_r_after'] = 1
#     else:
#         pl_played.loc[i, 'h_r_after'] = h_r_aft
#     # Away-side after the match rating
#     a_r_aft = R_n(h_r_bef, a_r_bef, h_res, a_res)[1]
#     # Update away-side after the match rating
#     if a_r_aft < 1:
#         pl_played.loc[i , 'a_r_after'] = 1
#     else:
#         pl_played.loc[i, 'a_r_after'] = a_r_aft
    
#     print(pl_played.loc[i, ['h_Team', 'a_Team', 'h_r_before', 'a_r_before', 'h_r_after', 'a_r_after']])

# # Check
# pl_played.sort_values('date', ascending=False).head(30)

# ELO.drop(columns=['Rank', 'ELO'], inplace=True)


# In[30]:


# ratings = []
# for team in ELO.Team.values:
#     h_t_idx = pl_played.loc[pl_played.h_Team==team, ['id_game', 'date']].nlargest(1, 'date').id_game.iloc[0]
#     a_t_idx = pl_played.loc[pl_played.a_Team==team, ['id_game', 'date']].nlargest(1, 'date').id_game.iloc[0]
#     print(h_t_idx, a_t_idx)
#     if h_t_idx > a_t_idx:
#         rating = pl_played.loc[h_t_idx, 'h_r_after']
#     elif h_t_idx < a_t_idx:
#         rating = pl_played.loc[a_t_idx, 'a_r_after']
#     print(rating)
#     ratings.append(rating)

# ELO['rating'] = ratings



