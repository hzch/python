#!/usr/bin/python
#-*- coding: utf-8 -*-

# 2.x 3.x pip easy_install


# import sys
# print sys.argv


# //  ** _ 复数j abs 引号' " """ 原始字符串r [-1] [1:-1] and or
# print (1+2j)*1j


# letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g']
# letters[2:5] = ['p']
# print  letters
# print letters[:]
# print  letters
# del letters[0]
# print letters
# del letters[2:4]
# print letters
# del letters[:]
# print letters
# del letters
# print letters



# a, b = 0, 1
# while b < 10:
#     print a
#     a, b = b, a+b
# a, b = b, a+b


# x = int(raw_input("Please enter an integer: "))
# if x < 0:
#     print 'Negative'
# elif x == 0:
#     print 'Zero'
# elif x == 1:
#     print 'Single'
# else:
#     print 'More'
# while True:
# print input('Input: ')


# words = ['cat', 'window', 'defenestrate']
# for w in words:
#     print w
#
# knights = {'gallahad': 'the pure', 'robin': 'the brave'}
# for k, v in knights.iteritems():
#     print k, v
#
# for n in range(2, 10):
#     for x in range(2, n):
#         if n % x == 0:
#             print n, 'equals', x, '*', n/x
#             break
#     else:
#         print n, 'is a prime number'
#
# while True:
#     pass

# def foo(x):
#     """ foo
#
#     docstring...
#     """
#     pass
# print foo(1)
# print foo.__doc__
#
# i = 4
# def foo(x,y=2,z=i):
#     print x,y,z
# i=5
# foo(1,y=1)
# foo(1,y=1,z=3)

# def f(a, L=[]):
#     L.append(a)
#     print L
# f(1)
# f(2,[])
# f(3)
# f(4)

# def cheeseshop(kind, *arguments, **keywords):
#     pass
#     # print  type(arguments)
# cheeseshop("Limburger",
#            "It's very runny, sir.",
#            "It's really very, VERY runny, sir.",
#            shopkeeper='Michael Palin',
#            client="John Cleese",
#            sketch="Cheese Shop Sketch")

# print range(3, 6)
# print range(*[3, 6])
#
# def foo(a,b,c):
#     print a,b,c
# foo(**{'b':1,'a':2,'c':3})

# a = 1
# if a in [1,2,3]:
#     print 'is in'
# else:
#     print 'not in'


# global cnt
# cnt=0
# def fun():
#     global cnt
#     cnt +=1
#     pass
# for i in range(0,10):
#     fun()
# print cnt

# if True:
#     a = 1
# else:
#     b = 0
#
# print a

# fun = lambda a,b: a + b
# print fun(1,2)

# def make_incrementor(n):
#     return lambda x: x + n
# f = make_incrementor(42)
# print f
# print f(1)
# print f(2)


# def f(x):
#     return x % 3 == 0 or x % 5 == 0
# print filter(f, range(2, 25))
# print map(f,[1,2,3,4])
#

# def aabb(a,b):
#     return a, b
# print map(aabb,range(1,2),range(3,5))

# def add(x,y):
#     return x+y
# print reduce(add, range(1, 11), 0)

# print reduce(lambda a,b:a+b,[x**2 for x in range(10)])

# print map(lambda x: x**2, range(10))
# print [x**2 for x in range(10)]
# print {x: x**2 for x in (2, 4, 6)}
#
# print [(x, y) for x in [1,2,3] for y in [3,1,2] if x != y]

# matrix = [(1, 2, 3, 4),
#           (5, 6, 7, 8),
#           (9, 10, 11, 12)
# ]
# print  matrix
# print zip(*matrix)

# in, a < b == c, and , or, not
# print '' or 'aa' or 'aaa'
# print 'aa' and 0 and 'aaa'
# print  1 == 1.0

## 模块
#
# if __name__ == "__main__":
#     print 'in main module'
# else:
#     print 'in module', __name__


# from bar import foo1
# import bar
# from bar import *
# from bar import _foo2
# print _foo2
# print _foo2


# import bar
# print locals()
# print dir(bar)
#
# import math
# print dir(math)

# import dir.foobar
# print dir.foobar.foobar

# from dir import *
# print foobar.foobar

# print '0:{}, 1:{}, 2:{a}.'.format(1, 2, a=3)
# for x in range(1, 11):
    # print str(x).rjust(2), str(x*x).rjust(3), str(x**3).rjust(4)
    # print '{0:2d} {1:3d} {2:4d}'.format(x, x*x, x**3)

# table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 8637678}
# print 'Jack: {0[Jack]}; Sjoerd: {0[Sjoerd]}; Dcab: {0[Dcab]}'.format(table)
# print 'Jack: {Jack}; Sjoerd: {Sjoerd}; Dcab: {Dcab}'.format(**table)
#
# print 'The value of PI is approximately %5.3f. %d' % (123.45 ,1)

# f = open('bar.py')
# print f.read()
# print f.readline()
# print f.readlines()
# f.close()
#
# with open('bar.py') as f:
#     print f.read()
#     print f.readline()
#     print f.readlines()


# while True:
#     try:
#         x = int(raw_input("Please enter a number: "))
#         break
#     except ValueError:
#         print "Oops!  That was no valid number.  Try again..."



# class FooClass:
#     def fooFunc(self):
#         return 1

# a = FooClass()
# a.fooFunc = lambda : 2
# a.fooFunc = lambda self : 2
# print a.fooFunc()
# del a.fooFunc
# del a.fooFunc
# print a.fooFunc()
# del a.fooFunc


# class A:
#     def a(self):
#         print 'A.a'
#
#     def b(self):
#         self.__a()
#
#     __a = a
#
# class B(A):
#     def a(self):
#         self._A__a()
#         print 'B.a'
#
# A()._A__a()

# class A(object):
#     def a(self):
#         print 'A.a'

# class B(A):
#     def a(self):
#         super(B,self).a()
#         print 'B.a'

# B().a()
