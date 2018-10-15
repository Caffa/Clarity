import sys
import praw
import pandas as pd
import datetime as dt
import pprint
from textblob import TextBlob

positiveStandard = 0

def SentimentIsPositive(textToCheck):
    """Checks if Sentiment is positive"""
    #check text
    sentiment = TextBlob(textToCheck).sentiment.polarity # 1 is positive, -1 is negative (can be inbetween )
    #return positive (true) or negative (false) based on score
    if(sentiment > positiveStandard):
        return True
    else:
        return False

def CheckRedditPost(submission, queryList):
    positiveCount = 0
    negativeCount = 0
    holyGrailCount = 0
    # print(submission.title)
    #then check comments of that post and post text
    postText = submission.selftext
    if(SentimentIsPositive(postText)):
        positiveCount += submission.score
    else:
        negativeCount += submission.score
    submission.comments.replace_more(limit=None)
    for comment in submission.comments.list():
        commentText = comment.body
        ThisCommentIsOk = False
        for possibleQuery in queryList:
            if (possibleQuery.lower() in commentText.lower()):
                ThisCommentIsOk = True
        if(ThisCommentIsOk):
            if(SentimentIsPositive(commentText)):
                positiveCount += comment.score
            else:
                negativeCount += comment.score

            if("holy grail".lower() in commentText.lower() or "HG".lower() in commentText.lower()):
                holyGrailCount += 1


    # print(positiveCount/positiveCount + negativeCount)
    # print("Positive Comments: " + str(positiveCount))
    # print("Negative Comments: " + str(negativeCount))

    if (positiveCount == negativeCount):
        overall = "Mixed opinions"
    elif (positiveCount > negativeCount):
        overall = "Positive opinions"
    else:
        overall = "Negative opinions"

    print('\n')

    thisdict =	{
        "title": submission.title,
        "postText": submission.selftext,
        "holyGrailCount": holyGrailCount,
        "positiveCommentCount": positiveCount,
        "negativeCommentCount": negativeCount,
        "overall": overall
    }
    return thisdict

# query = sys.argv[1]


def searchPerQueryList(qList):
    listOfQueriesNResults = []
    for querySet in qList:
        # query = "My Beauty Diary Black Pearl"
        query = querySet[0]

        overallDictionary = {
            "holyGrailCount": 0,
            "positiveCommentCount": 0,
            "negativeCommentCount": 0,
        }

        listOfResults = []

        print("# For query: " + query)

        for submission in reddit.subreddit('all').search(query, limit = 10): #search top 8 posts
            results = CheckRedditPost(submission, querySet)
            # pprint.pprint(results)
            listOfResults.append(results)

            for k,v in results.items():
                for key, value in overallDictionary.items():
                    if(key == k):
                        overallDictionary.update({key : value + v})

        if (overallDictionary.get("positiveCount") == overallDictionary.get("negativeCount")):
            overall = "Mixed opinions"
        elif (overallDictionary.get("positiveCount") > overallDictionary.get("negativeCount")):
            overall = "Positive opinions"
        else:
            overall = "Negative opinions"

        overallDictionary.update({"overallDictionary": overall})
        #
        # print("\n ## Overall View")
        # pprint.pprint(overallDictionary)
        #
        # print("////////////////////////////////////////////")

        thisQueryDictionary = {
            "query": query,
            "querySet": querySet,
            "overallDictionary": overallDictionary,
            "listOfResults": listOfResults
        }
        listOfQueriesNResults.append(thisQueryDictionary)
    return listOfQueriesNResults


reddit = praw.Reddit(client_id='lKdTVi0WuO_QgA', \
                     client_secret='Nv-HTXa9oklW-H0B_D5982JFWxM', \
                     user_agent='EntrepreneurshipAlfred')
ProductsList = [
    ["Benton Snail Bee High Content Essence", "Benton Snail", "Benton"],
    ["Cosrx Advanced Snail Mucin 96 Power Essence", "cosrx snail"],
    ["Scinic Honey AIO Ampoule", "Scinic Honey", "Honey Ampoule" ],
    ["Scinic Snail AIO Ampoule", "Scinic Snail", "Snail Ampoule"],
    ["Rosehip Oil"],
    ["Laneige Eye Sleeping Mask", "Sleeping Mask", "Sleeping Pack", "Laneige"],
    ["Acne Patches", "Patches"],
    ["Biore UV Aqua Rich Watery Essence", "Watery Essence"],
    ["Klairs Midnight Blue Calming Cream", "Blue Cream", "Midnight Cream"],
    ["Banila Co Clean It Zero Purity", "Purity", "Pure"],
    ["Banila Co Clean It Zero Cleansing Balm Original", "Original"],
    ["Banila Co Clean It Zero Cleansing Balm Purifying", "Purifying"],
    ["Cosrx AHA 7 Whitehead Power Liquid", "Cosrx AHA"],
    ["Cosrx AHA/BHA Clarifying Treatment Toner", "AHA/BHA"],
    ["Cosrx Honey Ceramide Eye Cream"],
    ["Cosrx Honey Ceramide Full Moisture Cream"],
    ["Cosrx Ultimate Moisturizing Honey Overnight Mask", "Honey Mask"],
    ["Cosrx Ultimate Nourishing Rice Overnight Mask", "Rice Mask"],
    ["Hada Labo Premium Hyaluronic Acid Lotion", "Hada Labo", "HA Lotion"],
    ["Hada Labo Hyaluronic Acid Lotion Light"],
    ["Hada Labo Hyaluronic Acid Lotion Moist"],
    ["Hada Labo Hyaluronic Acid Milk (Milky Lotion)"],
    ["Hada Labo Premium Hyaluronic Acid Lotion"],
    ["Hada Labo Premium Hyaluronic Acid Milk (Milky Lotion)"],
    ["Hada Labo Whitening Lotion"],
    ["Klairs Rich Moist Soothing Cream", "Klairs RMS Cream", "Klairs Cream"],
    ["Missha The First Treatment Essence Intensive", "Missha FTE Intensive"],
    ["Missha The First Treatment Essence Intensive Moist", "Intensive Moist"],
    ["Secret Key Starting Treatment Essence", "Secret Key FTE"],
    ["Secret Key Starting Treatment Essence Rose Edition", "Secret Key Rose", "Secret Key FTE Rose"],
    ["SK-II Facial Treatment Essence", "SkII FTE", "Sk-II FTE"],
    ["Mizon AHA & BHA Daily Clean Toner"],
    ["Mizon Snail Recovery Gel Cream", "Mizon Snail Cream"],
    ["Sulwhasoo Gentle Cleansing Foam EX"],
    ["Sulwhasoo Gentle Cleansing Oil EX"],
    ["The Ordinary 100% Plant-Derived Squalane", "Squalane"],
    ["The Ordinary Glycolic Acid 7% Toning Solution", "Glycolic Acid"],
    ["The Ordinary Matrixyl 10% + HA", "Matrixyl"],
    ["The Ordinary Buffet", "Buffet"]
]
listOfQueriesNResults = searchPerQueryList(ProductsList)

print(len(ProductsList))
# import csv
# with open('entrepreneurshipRedditData.csv', 'wb') as myfile:
#     wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
#     wr.writerow(listOfQueriesNResults)
import pandas as pd
from collections import OrderedDict
from datetime import date
df = pd.DataFrame(listOfQueriesNResults)
df.to_csv('entrepreneurshipRedditData.csv')
