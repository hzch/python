#!/usr/bin/python
#-*- coding: utf-8 -*-
#encoding=utf-8
import re  
import sys
import urllib
import time
import os

base = "https://shop106728719.taobao.com/category.htm?spm=a1z10.1-c.w4010-4063085059.2.5qVQAh&search=y"  
path = '/Users/Jiang/Downloads/pic/'

def download():  
	file = open("urls")
	index = 0
	while 1:
		index = index + 1
		line = file.readline()
		print 'dowmload :' + line
		if not line:
			break
		content = urllib.urlopen(line).read()  
		filename = path + ('%04d' % index) + '.jpg'
	   	print 'download :' + filename
		f = open(filename,'w+')  
		f.write(content)  
		f.close() 

download()      






def get_url(html):  
    request = urllib2.Request(html)  
    response = urllib2.urlopen(request)  
    resp = response.read()  
    parser.feed(resp)  

def getAllItemIds():
	home = 'https://shop106728719.taobao.com/category.htm?search=y&pageNo='  
	i = 0
	while True:
		i = i + 1
		con = urllib.urlopen(home + str(i)).read()
		filename = path+'/aa.html'  
		f = open(filename,'w+')
		f.write(con)
		f.close()
		print con.find('itemIds=')
		print con.find('&amp;source=shop')
		# con = 'itemIds=1234&amp;source=shop'
		match = re.compile(r'itemIds=(.*)source=shop').match(con)
		if not match:
			# i = i - 1
			break
		print match.group(1)

def getAllPics():
	home = 'https://item.taobao.com/item.htm?id=44536923702'  
	i = 0
	while True:
		i = i + 1
		con = urllib.urlopen(home).read()
		filename = path+'/aa.html'  
		f = open(filename,'w+')
		f.write(con)
		f.close()

		match = re.compile(r'<img src=\"(.*)\" class=').match(con)
		if not match:
			# i = i - 1
			break
		print match.group(1)
		break
