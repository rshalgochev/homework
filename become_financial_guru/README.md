#
mean_price.sh
Please, ensure, that you already have file quotes.json in script directory or do
curl -s https://yandex.ru/news/quotes/graph_2000.json > ./quotes.json command
before use the script.
##
This script calculate arithmetic mean of price for EUR/RUB pair at last N days.
###
Scrept needs one parameter - count of days. It must be numeric and integer. Default 
value is 14. 

