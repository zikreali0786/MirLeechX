#!/usr/bin/env python3
import sys, os, requests as rq, re, json as js
from bs4 import BeautifulSoup as bt

class gdtot:
      def init(self):
          self.url = ''
          self.list = gdtot.error(self)
          self.r = ''
          self.c = gdtot.check(self)
          self.h = {
                   'upgrade-insecure-requests': '1',
                   'save-data': 'on',
                   'user-agent': 'Mozilla/5.0 (Linux; Android 10; Redmi 8A Dual) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.101 Mobile Safari/537.36',
                   'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
                   'sec-fetch-site': 'same-origin',
                   'sec-fetch-mode': 'navigate',
                   'sec-fetch-dest': 'document',
                   'referer': self.r,
                   'prefetchAd_3621940': 'true',
                   'accept-language': 'en-IN,en-GB;q=0.9,en-US;q=0.8,en;q=0.7'
                   }

      def error(self):
          try:
             self.url = sys.argv[1]
          except:
             pass
          if len(self.url) == 0:
             return "yes"
          else:
             url = re.findall(r'\bhttps?://.*gdtot\S+', self.url)
             return url

      def check(self):
          p = os.getcwd()
          if os.path.isfile('%s/cookies.txt' %p) == False:
             return False
          else:
             with open('cookies.txt', 'r') as r:
                  f = r.read()
             j = js.loads(f)['cookie'].replace('=',': ').replace(';',',')
             f = re.sub(r'([a-zA-Z_0-9.%]+)', r'"\1"', "{%s}" %j)
             c = js.loads(f)
             return c

      def parse(self):
          if len(self.list) == 0:
             return "regex not match"
          elif self.list == "yes":
             return "Empty Task"
          elif self.c == False:
             return "cookies.txt file not found"
          else:
             print("Gdtot Parser\n")
             for i in self.list:
                 r1 = rq.get(self.url, headers=self.h, cookies=self.c).content
                 p = bt(r1, 'html.parser').find('button', id="down").get('onclick').split("'")[1]
                 self.r = self.url
                 r2 = bt(rq.get(p, headers=self.h, cookies=self.c).content, 'html.parser').find('meta').get('content').split('=',1)[1]
                 self.r = p
                 r3 = bt(rq.get(r2, headers=self.h, cookies=self.c).content, 'html.parser').find('div', align="center")
                 if r3 == None:
                    r3 = bt(rq.get(r2, headers=self.h, cookies=self.c).content, 'html.parser')
                    f = r3.find('h4').text
                    return f
                 else:
                    s = r3.find('h6').text
                    i = r3.find('a', class_="btn btn-outline-light btn-user font-weight-bold").get('href')
                    f = "File: {}\n\nLink: {}\n".format(s,i)
                    return f

print(gdtot().parse())
