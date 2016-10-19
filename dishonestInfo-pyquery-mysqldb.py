#!/usr/bin/python
#-*- coding: utf-8 -*-
#encoding=utf-8
from pyquery import PyQuery as pyq
import re
import urllib
import MySQLdb

try:
	# Prepare mysql connection
	print 'Preparing mysql connection...'
	conn=MySQLdb.connect(host='localhost',user='root',passwd='root',port=3306,charset="utf8")
	cur = conn.cursor()
	cur.execute('CREATE DATABASE IF NOT EXISTS info')
	conn.select_db('info')
	cur.execute('CREATE TABLE IF NOT EXISTS dishonest(name VARCHAR(32), idNum CHAR(18), telNum CHAR(11), money FLOAT, day INTEGER)')

	i = 0
	while True:
		i = i + 1
		
		# Download html
		print 'Downloading page ' + str(i) + '...'
		html = urllib.urlopen('http://mobp2p.com/boot/blacklist/index.php?p=' + str(i)).read()
		html = html.decode('GB2312','ignore')
		jq	 = pyq(html)

		# Parse data
		print 'Parsing data...'
		table = jq('tbody')
		trs = table('tr')
		if not trs:
			break

		values = []
		for tr in trs:
			# ID numbers
			idNum = table(tr)('p').eq(1).text()[5:]
			match = re.compile(r'\A[0-9]{18}\Z').match(idNum)
			if not match:
				continue
			# TEL numbers
			telNum = table(tr)('p').eq(2).text()[4:]
			match = re.compile(r'\A1[0-9]{10}\Z').match(telNum)
			if not match:
				continue
			# name
			name = table(tr)('span').eq(0).text() 		
			# money
			money = table(tr)('span').eq(1).text()[:-1]	
			money = float(money.replace(',',''))
			# day
			day = table(tr)('p').eq(4).text()[7:-1] 
			day = int(day)	

			print '(%s,%s,%s,%.2f,%d)'%(name,idNum,telNum,money,day)
			values.append((name,idNum,telNum,money,day));

		print 'Storing data...'
		cur.executemany('INSERT INTO dishonest VALUES (%s,%s,%s,%s,%s)',values)
		conn.commit()

	print 'Finish'
	cur.close()
	conn.close()

except MySQLdb.Error,e:
     print "Mysql Error %d: %s" % (e.args[0], e.args[1])


